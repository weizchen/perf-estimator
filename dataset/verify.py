"""Validity verifier for generated single-op benchmarks.

Why not the MLIR Python bindings? Our modules use the OFA-private `NAIL`
dialect (`NAIL.unit`, the custom `!NAIL.target<...>` type) and the linalg
pretty-printed assembly. Stock `mlir` bindings only know upstream dialects;
`allow_unregistered_dialects` rescues only the *generic* op form and cannot
parse custom *types* at all. The only parser that knows NAIL is the compiler's
own `ofa-opt`, so this module shells out to it.

Two levels of checking:
  * parse  — `ofa-opt <file> -o /dev/null` round-trips the module, which runs
             MLIR's verifier (catches the i8/float-arith mismatch, bad shapes,
             malformed regions). Fast; the default.
  * compile — `ofa-compiler <file> ... --emit-stage=llvm-ir` drives the full
             per-engine lowering to LLVM IR (catches dtype-combination edge
             cases that only surface during codegen). Opt-in via --compile.

Locating the tools: set $OFA_OPT / $OFA_COMPILER, else they're resolved
relative to this repo at ../OFA-compiler-master/build/bin/.

ofa-compiler ../perf-estimator/dataset/corpus/me/me_matmul_00091_d2ffc139.mlir --target-spec=targets/Fuji-NPU.json --scheduling --dispatch-resource-alloc=1 --resource-alloc=1 --emit-stage=llvm-ir
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

REPO = Path(__file__).resolve().parent.parent
_OFA_ROOT = REPO.parent / "OFA-compiler-master"
_DEFAULT_OPT = _OFA_ROOT / "build" / "bin" / "ofa-opt"
_DEFAULT_COMPILER = _OFA_ROOT / "build" / "bin" / "ofa-compiler"
_DEFAULT_TARGET_SPEC = _OFA_ROOT / "targets" / "Fuji-NPU.json"

# ofa-compiler refuses NAIL-input lowering without an explicit single-core
# resource-alloc algorithm (see ofa-compiler.cpp). These are the args the
# benchmark Makefiles use for a minimal single-unit lowering.
_COMPILE_ARGS = [
    "--scheduling",
    "--dispatch-resource-alloc=1",
    "--resource-alloc=1",
]


def ofa_opt_path() -> Path:
    return Path(os.environ.get("OFA_OPT", _DEFAULT_OPT))


def ofa_compiler_path() -> Path:
    return Path(os.environ.get("OFA_COMPILER", _DEFAULT_COMPILER))


def target_spec_path() -> Path:
    return Path(os.environ.get("OFA_TARGET_SPEC", _DEFAULT_TARGET_SPEC))


@dataclass
class Result:
    path: Path
    ok: bool
    stage: str            # "parse" or "compile"
    message: str = ""     # compiler stderr on failure


def verify_parse(mlir_file: Path, opt: Optional[Path] = None,
                 timeout: float = 60.0) -> Result:
    """Parse + verify a module with ofa-opt (no passes)."""
    opt = Path(opt) if opt else ofa_opt_path()
    if not opt.exists():
        return Result(mlir_file, False, "parse",
                      f"ofa-opt not found at {opt} (build OFA or set $OFA_OPT)")
    try:
        proc = subprocess.run(
            [str(opt), str(mlir_file), "-o", os.devnull],
            capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return Result(mlir_file, False, "parse", "timeout")
    ok = proc.returncode == 0
    return Result(mlir_file, ok, "parse", "" if ok else proc.stderr.strip())


def verify_compile(mlir_file: Path, compiler: Optional[Path] = None,
                   target_spec: Optional[Path] = None,
                   timeout: float = 180.0) -> Result:
    """Drive the full per-engine lowering to LLVM IR with ofa-compiler."""
    compiler = Path(compiler) if compiler else ofa_compiler_path()
    target_spec = Path(target_spec) if target_spec else target_spec_path()
    if not compiler.exists():
        return Result(mlir_file, False, "compile",
                      f"ofa-compiler not found at {compiler}")
    cmd = [str(compiler), str(mlir_file), f"--target-spec={target_spec}",
           *_COMPILE_ARGS, "--emit-stage=llvm-ir", "-o", os.devnull]
    try:
        proc = subprocess.run(cmd, capture_output=True, text=True,
                              timeout=timeout)
    except subprocess.TimeoutExpired:
        return Result(mlir_file, False, "compile", "timeout")
    ok = proc.returncode == 0
    return Result(mlir_file, ok, "compile", "" if ok else proc.stderr.strip())


def verify_dir(corpus_dir: Path, *, compile: bool = True) -> list[Result]:
    """Verify every `*.mlir` under a corpus directory."""
    results: list[Result] = []
    for f in sorted(corpus_dir.glob("*.mlir")):
        r = verify_parse(f)
        if r.ok and compile:
            r = verify_compile(f)
        results.append(r)
    return results


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", type=Path, nargs="+",
                    help="corpus directories and/or individual .mlir files")
    ap.add_argument("--parse-only", action="store_true",
                    help="only parse and verify MLIR without running the slower lowering/compilation passes")
    ap.add_argument("--show", type=int, default=10,
                    help="max failing-file diagnostics to print")
    args = ap.parse_args(argv)

    compile_check = not args.parse_only
    results: list[Result] = []
    for p in args.paths:
        if p.is_dir():
            results.extend(verify_dir(p, compile=compile_check))
        elif p.suffix == ".mlir":
            r = verify_parse(p)
            if r.ok and compile_check:
                r = verify_compile(p)
            results.append(r)
        else:
            print(f"  skip (not a dir or .mlir): {p}")

    failures = [r for r in results if not r.ok]
    for r in failures[: args.show]:
        first_line = r.message.splitlines()[0] if r.message else "(no message)"
        print(f"  FAIL [{r.stage}] {r.path.name}: {first_line}")
    if len(failures) > args.show:
        print(f"  ... and {len(failures) - args.show} more failures")

    n = len(results)
    print(f"\nverified {n} module(s): {n - len(failures)} OK, "
          f"{len(failures)} FAIL"
          f"{' (parse+compile)' if compile_check else ' (parse)'}")
    return 1 if failures else 0



if __name__ == "__main__":
    raise SystemExit(main())
