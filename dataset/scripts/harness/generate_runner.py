#!/usr/bin/env python3

# Generic C runner generator for static single-/multi-op benchmark MLIR models.
#
# Originally f32/i64 only (the repo's decomposed transformer suite is all-f32).
# Extended for the perf-estimator single-op corpus, which exercises the full
# per-engine precision range:
#
#   f32, f64          -> native C float/double (real fill + float checksum)
#   i8, i16, i32, i64 -> intN_t            (small signed fill + integer checksum)
#   i1                -> int8_t            (0/1 fill)
#   f16, bf16, f8E5M2 -> raw uintN_t bits  (filled with a small *positive* bit
#                        pattern ≈1.0 so the kernel never sees NaN/Inf; the
#                        checksum is over the raw output bits — deterministic)
#
# Also handles rank-0 (scalar) tensors, e.g. the 0-D result of a reduction.
# f32/i64 codegen is unchanged from the original, so the existing benchmark
# suite produces identical runners.

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from functools import reduce
from operator import mul
from pathlib import Path


FUNC_RE = re.compile(
    r"func\.func\s+@(?P<name>[^\(\s]+)\((?P<args>.*?)\)\s*->\s*(?P<returns>.*?)(?:\{|attributes)",
    re.S,
)
TENSOR_RE = re.compile(r"tensor<(?P<body>.+)>")


@dataclass(frozen=True)
class ElemInfo:
    c_type: str        # storage / descriptor element C type
    fill: str          # fill helper name
    checksum: str      # checksum helper name
    fmt: str           # printf conversion for the checksum
    label: str         # checksum label suffix in the printed line


# MLIR element type -> codegen info. Sized-int storage for everything that has
# no portable C scalar; the kernel reinterprets the bytes (a pointer is a
# pointer at the ABI level).
_ELEM: dict[str, ElemInfo] = {
    "f32":    ElemInfo("float",    "fill_f32",  "checksum_f32", "%.10e", "f32"),
    "f64":    ElemInfo("double",   "fill_f64",  "checksum_f64", "%.10e", "f64"),
    "i64":    ElemInfo("int64_t",  "fill_i64",  "checksum_i64", "%lld",  "i64"),
    "i32":    ElemInfo("int32_t",  "fill_i32",  "checksum_i32", "%lld",  "i32"),
    "i16":    ElemInfo("int16_t",  "fill_i16",  "checksum_i16", "%lld",  "i16"),
    "i8":     ElemInfo("int8_t",   "fill_i8",   "checksum_i8",  "%lld",  "i8"),
    "i1":     ElemInfo("int8_t",   "fill_i1",   "checksum_i8",  "%lld",  "i1"),
    "f16":    ElemInfo("uint16_t", "fill_f16",  "checksum_u16", "%lld",  "f16bits"),
    "bf16":   ElemInfo("uint16_t", "fill_bf16", "checksum_u16", "%lld",  "bf16bits"),
    "f8E5M2": ElemInfo("uint8_t",  "fill_f8",   "checksum_u8",  "%lld",  "f8bits"),
}

# Source for every fill/checksum helper, keyed by name (only the ones a given
# benchmark uses are emitted).
_HELPERS: dict[str, str] = {
    "fill_f32": (
        "static void fill_f32(float *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (float)(((int)((i + (size_t)seed) % 23)) - 11) / 7.0f;\n}"),
    "fill_f64": (
        "static void fill_f64(double *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (double)(((int)((i + (size_t)seed) % 23)) - 11) / 7.0;\n}"),
    "fill_i64": (
        "static void fill_i64(int64_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (int64_t)((i + (size_t)seed) % 7);\n}"),
    "fill_i32": (
        "static void fill_i32(int32_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (int32_t)(((int)((i + (size_t)seed) % 7)) - 3);\n}"),
    "fill_i16": (
        "static void fill_i16(int16_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (int16_t)(((int)((i + (size_t)seed) % 7)) - 3);\n}"),
    "fill_i8": (
        "static void fill_i8(int8_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (int8_t)(((int)((i + (size_t)seed) % 7)) - 3);\n}"),
    "fill_i1": (
        "static void fill_i1(int8_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (int8_t)((i + (size_t)seed) % 2);\n}"),
    # raw-float bit patterns near 1.0 (positive, finite, never NaN/Inf):
    "fill_f16": (
        "static void fill_f16(uint16_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (uint16_t)(0x3C00u + ((i + (size_t)seed) % 8));\n}"),  # f16 1.0 = 0x3C00
    "fill_bf16": (
        "static void fill_bf16(uint16_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (uint16_t)(0x3F80u + ((i + (size_t)seed) % 8));\n}"),  # bf16 1.0 = 0x3F80
    "fill_f8": (
        "static void fill_f8(uint8_t *b, size_t n, int seed) {\n"
        "  for (size_t i = 0; i < n; ++i) b[i] = (uint8_t)(0x3Cu + ((i + (size_t)seed) % 2));\n}"),      # E5M2 1.0 = 0x3C
    "checksum_f32": (
        "static double checksum_f32(const float *b, size_t n) {\n"
        "  double s = 0.0; for (size_t i = 0; i < n; ++i) s += (double)b[i]; return s;\n}"),
    "checksum_f64": (
        "static double checksum_f64(const double *b, size_t n) {\n"
        "  double s = 0.0; for (size_t i = 0; i < n; ++i) s += b[i]; return s;\n}"),
    "checksum_i64": (
        "static long long checksum_i64(const int64_t *b, size_t n) {\n"
        "  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;\n}"),
    "checksum_i32": (
        "static long long checksum_i32(const int32_t *b, size_t n) {\n"
        "  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;\n}"),
    "checksum_i16": (
        "static long long checksum_i16(const int16_t *b, size_t n) {\n"
        "  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;\n}"),
    "checksum_i8": (
        "static long long checksum_i8(const int8_t *b, size_t n) {\n"
        "  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;\n}"),
    "checksum_u16": (
        "static long long checksum_u16(const uint16_t *b, size_t n) {\n"
        "  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;\n}"),
    "checksum_u8": (
        "static long long checksum_u8(const uint8_t *b, size_t n) {\n"
        "  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;\n}"),
}


@dataclass(frozen=True)
class TensorType:
    shape: tuple[int, ...]
    element_type: str

    @property
    def info(self) -> ElemInfo:
        info = _ELEM.get(self.element_type)
        if info is None:
            raise ValueError(f"unsupported element type: {self.element_type}")
        return info

    @property
    def c_type(self) -> str:
        return self.info.c_type

    @property
    def count(self) -> int:
        return reduce(mul, self.shape, 1)

    @property
    def strides(self) -> tuple[int, ...]:
        strides: list[int] = []
        running = 1
        for dim in reversed(self.shape):
            strides.append(running)
            running *= dim
        return tuple(reversed(strides))


@dataclass(frozen=True)
class BenchmarkSignature:
    function_name: str
    arguments: tuple[TensorType, ...]
    results: tuple[TensorType, ...]


def parse_tensor_type(text: str) -> TensorType:
    match = TENSOR_RE.fullmatch(text.strip())
    if not match:
        raise ValueError(f"unsupported tensor type syntax: {text}")
    parts = match.group("body").split("x")
    element = parts[-1]
    dims = parts[:-1]                       # empty for a rank-0 (scalar) tensor
    try:
        shape = tuple(int(dim) for dim in dims)
    except ValueError as error:
        raise ValueError(f"dynamic or invalid shape in tensor type: {text}") from error
    return TensorType(shape=shape, element_type=element)


def split_types(text: str) -> list[str]:
    text = text.strip()
    if not text:
        return []
    if not text.startswith("("):
        return [text]
    inner = text[1:-1].strip()
    if not inner:
        return []
    parts: list[str] = []
    depth = 0
    current: list[str] = []
    for char in inner:
        if char == ',' and depth == 0:
            parts.append("".join(current).strip())
            current = []
            continue
        if char == '<':
            depth += 1
        elif char == '>':
            depth -= 1
        current.append(char)
    if current:
        parts.append("".join(current).strip())
    return parts


def parse_signature(input_path: Path) -> BenchmarkSignature:
    text = input_path.read_text(encoding="utf-8")
    match = FUNC_RE.search(text)
    if not match:
        raise ValueError(f"could not find func.func signature in {input_path}")

    arg_text = match.group("args")
    args = [
        parse_tensor_type(type_text)
        for _, type_text in re.findall(r"(%[^:]+):\s*([^,\)]+(?:<[^>]+>)?)", arg_text)
    ]
    results = [parse_tensor_type(type_text) for type_text in split_types(match.group("returns"))]
    return BenchmarkSignature(
        function_name=match.group("name").strip(),
        arguments=tuple(args),
        results=tuple(results),
    )


def emit_descriptor_arguments(prefix: str, tensor_type: TensorType) -> list[str]:
    args = [f"{tensor_type.c_type} *{prefix}_allocated", f"{tensor_type.c_type} *{prefix}_aligned", f"int64_t {prefix}_offset"]
    args.extend(f"int64_t {prefix}_size{index}" for index in range(len(tensor_type.shape)))
    args.extend(f"int64_t {prefix}_stride{index}" for index in range(len(tensor_type.shape)))
    return args


def emit_call_arguments(prefix: str, tensor_type: TensorType) -> list[str]:
    args = [f"{prefix}_storage", f"{prefix}_storage", "0"]
    args.extend(str(dim) for dim in tensor_type.shape)
    args.extend(str(stride) for stride in tensor_type.strides)
    return args


def render_source(signature: BenchmarkSignature, benchmark_name: str) -> str:
    tensors = list(signature.arguments) + list(signature.results)
    # Emit only the fill/checksum helpers this benchmark actually uses.
    needed: list[str] = []
    for t in tensors:
        for fn in (t.info.fill, t.info.checksum):
            if fn not in needed:
                needed.append(fn)

    lines: list[str] = [
        "#include <inttypes.h>",
        "#include <stdint.h>",
        "#include <stdio.h>",
        "#include <string.h>",
        "",
        "#if defined(__riscv)",
        "static inline void ofa_dma_memory_fence(void) {",
        "  __asm__ volatile(\"fence rw, rw\" ::: \"memory\");",
        "}",
        "#else",
        "static inline void ofa_dma_memory_fence(void) {}",
        "#endif",
        "",
    ]
    for fn in needed:
        lines.append(_HELPERS[fn])
        lines.append("")

    for index, t in enumerate(signature.arguments):
        lines.append(f"static {t.c_type} input{index}_storage[{t.count}] __attribute__((aligned(64)));")
    for index, t in enumerate(signature.results):
        lines.append(f"static {t.c_type} output{index}_storage[{t.count}] __attribute__((aligned(64)));")
    lines.append("")

    proto_args: list[str] = []
    for index, t in enumerate(signature.arguments):
        proto_args.extend(emit_descriptor_arguments(f"arg{index}", t))
    for index, t in enumerate(signature.results):
        proto_args.extend(emit_descriptor_arguments(f"result{index}", t))
    lines.append(f"extern void {signature.function_name}({', '.join(proto_args)});")
    lines.append("")
    lines.append("int main(void) {")

    for index, t in enumerate(signature.arguments):
        lines.append(f"  {t.info.fill}(input{index}_storage, {t.count}, {index + 1});")
    for index, t in enumerate(signature.results):
        lines.append(f"  memset(output{index}_storage, 0, sizeof(output{index}_storage));")

    call_args: list[str] = []
    for index, t in enumerate(signature.arguments):
        call_args.extend(emit_call_arguments(f"input{index}", t))
    for index, t in enumerate(signature.results):
        call_args.extend(emit_call_arguments(f"output{index}", t))

    lines.extend([
        "  ofa_dma_memory_fence();",
        f"  {signature.function_name}({', '.join(call_args)});",
        "  ofa_dma_memory_fence();",
        f'  puts("{benchmark_name}: benchmark completed");',
    ])

    for index, t in enumerate(signature.results):
        lines.append(
            f'  printf("output{index}_{t.info.label}_checksum={t.info.fmt}\\n", '
            f'{t.info.checksum}(output{index}_storage, {t.count}));'
        )
    lines.extend(["  return 0;", "}", ""])
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate a generic C runner for a static benchmark MLIR model.")
    parser.add_argument("--input", type=Path, required=True, help="Input model.mlir path")
    parser.add_argument("--output", type=Path, required=True, help="Output C source path")
    parser.add_argument("--benchmark-name", required=True, help="Benchmark name used in printed status lines")
    args = parser.parse_args()

    signature = parse_signature(args.input)
    args.output.write_text(render_source(signature, args.benchmark_name), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
