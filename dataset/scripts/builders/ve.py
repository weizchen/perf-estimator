"""Synthetic vector/elementwise corpus builder (shared by VE and Scalar).

Each sample is one `linalg.generic` (elementwise or reduction) wrapped in a
`nail.unit { proc: <engine> }`. VE (`proc:1`) auto-vectorizes via
`VectorizeVEBindsPass`; Scalar (`proc:0`) lowers through linalg-to-loops. The
two engines run the *same* op families, so they share this builder
(`build_ve_corpus` / `build_scalar_corpus` are thin wrappers).

Coverage:
  * elementwise kinds: add, mul, max, relu, sigmoid-approx
  * reduction kinds:   sum, max, mean
  * chain depth {1,2,4,8}: dependency chains of that many arith ops
Dtypes come from `dataset.scripts.policy.GENERIC_DTYPES` (VE: i8/i16/bf16/f16/f32;
Scalar: i8/i16/f16/f32 — no BF16). Float-only kinds use `FLOAT_DTYPES`.

Reduction handling: the upgraded compiler's VE reduction path does not lower
(named `linalg.reduce`, matvec/vecmat and reduction-form generics all fail),
so VE is built with `emit_reduction=False` and reduction coverage lives on the
scalar core only. argmax is omitted (needs a 2-result generic + linalg.index).
"""

from __future__ import annotations

import random
from pathlib import Path

from dataset.scripts.canonicalize import region_hash
from dataset.scripts.features import (
    feature_vector_scalar, feature_vector_ve, parse_generic)
from dataset.scripts.policy import FLOAT_DTYPES, GENERIC_DTYPES
from dataset.scripts.schema import PROC_OF_ENGINE, LinalgOpSample

_CHAIN_DEPTHS = [1, 2, 4, 8]
_ADD = ("arith.addf", "arith.addi")
_MUL = ("arith.mulf", "arith.muli")
_MAX = ("arith.maximumf", "arith.maxsi")
# Transcendental / activation ops (float-only; hit the VE special-function
# unit, far costlier than add/mul). erf is excluded — it has no lowering.
_ACTIVATIONS = {
    "exp": ("math.exp", "unary"),
    "tanh": ("math.tanh", "unary"),
    "rsqrt": ("math.rsqrt", "unary"),
    "sqrt": ("math.sqrt", "unary"),
    "div": ("arith.divf", "binary"),
    "reciprocal": ("arith.divf", "recip"),
}


def _is_int_dtype(dtype: str) -> bool:
    return dtype.startswith("i") and dtype[1:].isdigit()


def _op(pair: tuple[str, str], dtype: str) -> str:
    return pair[1] if _is_int_dtype(dtype) else pair[0]


def _chain_ops(kind: str, depth: int) -> list[tuple[str, str]]:
    if kind == "sigmoid":
        return [_MUL, _ADD, _MUL, _ADD, _MAX]   # multi-op proxy, depth 5
    base = {"add": _ADD, "mul": _MUL}.get(kind, _MAX)
    return [base] if depth == 1 else [_ADD if i % 2 == 0 else _MUL
                                      for i in range(depth)]


def _wrap(body: str, args: str, yield_val: str, ret_t: str, proc: int) -> str:
    return (
        "module {\n"
        f"  func.func @kernel({args}) -> {ret_t} {{\n"
        f"    %r = NAIL.unit {{schedule = 0 : i64}} : "
        f"!NAIL.target<i : 0, j : 0, proc : {proc}> -> {ret_t} {{\n"
        f"  {body}"
        f"      NAIL.yield {yield_val} : {ret_t}\n"
        f"    }}\n"
        f"    return %r : {ret_t}\n"
        "  }\n}\n"
    )


def _ew_module(n, kind, depth, dtype, proc):
    t = f"tensor<{n}x{dtype}>"
    lines = [f'    ^bb0(%in: {dtype}, %out: {dtype}):']
    prev = "%out"
    for i, pair in enumerate(_chain_ops(kind, depth)):
        lines.append(f'      %{i} = {_op(pair, dtype)} %in, {prev} : {dtype}')
        prev = f"%{i}"
    lines.append(f'      linalg.yield {prev} : {dtype}')
    body = (f'    %g = linalg.generic {{indexing_maps = [affine_map<(d0) -> (d0)>, '
            f'affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]}} '
            f'ins(%arg0 : {t}) outs(%arg1 : {t}) {{\n' + "\n".join(lines) +
            f'\n    }} -> {t}\n')
    return _wrap(body, f"%arg0: {t}, %arg1: {t}", "%g", t, proc), body.strip()


def _red_module(n, kind, dtype, proc):
    t_in, t_out = f"tensor<{n}x{dtype}>", f"tensor<{dtype}>"
    op = _op(_MAX if kind == "max" else _ADD, dtype)
    body = (f'    %g = linalg.generic {{indexing_maps = [affine_map<(d0) -> (d0)>, '
            f'affine_map<(d0) -> ()>], iterator_types = ["reduction"]}} '
            f'ins(%arg0 : {t_in}) outs(%arg1 : {t_out}) {{\n'
            f'    ^bb0(%in: {dtype}, %out: {dtype}):\n'
            f'      %0 = {op} %in, %out : {dtype}\n'
            f'      linalg.yield %0 : {dtype}\n'
            f'    }} -> {t_out}\n')
    return _wrap(body, f"%arg0: {t_in}, %arg1: {t_out}", "%g", t_out, proc), body.strip()


def _act_module(n, kind, dtype, proc):
    """Elementwise transcendental/activation generic (float dtype)."""
    t = f"tensor<{n}x{dtype}>"
    op, form = _ACTIVATIONS[kind]
    inner = [f'    ^bb0(%in: {dtype}, %out: {dtype}):']
    if form == "unary":
        inner.append(f'      %0 = {op} %in : {dtype}')
    elif form == "binary":
        inner.append(f'      %0 = {op} %in, %out : {dtype}')
    else:  # reciprocal: 1 / x
        inner.append(f'      %c1 = arith.constant 1.0 : {dtype}')
        inner.append(f'      %0 = {op} %c1, %in : {dtype}')
    inner.append(f'      linalg.yield %0 : {dtype}')
    body = (f'    %g = linalg.generic {{indexing_maps = [affine_map<(d0) -> (d0)>, '
            f'affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]}} '
            f'ins(%arg0 : {t}) outs(%arg1 : {t}) {{\n' + "\n".join(inner) +
            f'\n    }} -> {t}\n')
    return _wrap(body, f"%arg0: {t}, %arg1: {t}", "%g", t, proc), body.strip()


def build_generic_corpus(out_dir: Path, n_samples: int, seed: int, *,
                         engine: str, dtypes: list[str] | None = None,
                         float_dtypes: list[str] | None = None,
                         emit_reduction: bool = True,
                         len_log2=(4.0, 13.0)) -> int:
    """Generate `n_samples` generic elementwise/reduction ops for `engine`.

    `emit_reduction=False` (VE) suppresses the reduction-form generics, whose
    VE lowering is broken; that probability mass falls through to activations.
    """
    rng = random.Random(seed)
    proc = PROC_OF_ENGINE[engine]
    dtypes = dtypes or GENERIC_DTYPES[engine]
    float_dtypes = float_dtypes or FLOAT_DTYPES[engine]
    featurize = feature_vector_ve if engine == "ve" else feature_vector_scalar
    out_dir.mkdir(parents=True, exist_ok=True)
    seen: set[str] = set()
    written = attempts = 0
    while written < n_samples and attempts < n_samples * 5:
        attempts += 1
        n = max(4, min(8192, int(2 ** rng.uniform(*len_log2))))
        dtype = rng.choice(dtypes)
        roll = rng.random()
        if emit_reduction and roll < 0.25:
            kind = rng.choice(["sum", "max", "mean"])
            module_text, body_text = _red_module(n, kind, dtype, proc)
            form, depth = "reduction", 1
        elif roll < 0.45:                                  # activations (float)
            dtype = rng.choice(float_dtypes)
            kind = rng.choice(list(_ACTIVATIONS))
            module_text, body_text = _act_module(n, kind, dtype, proc)
            form, depth = "activation", 1
        elif roll < 0.58:
            kind, depth, form = "sigmoid", 5, "elementwise"
            module_text, body_text = _ew_module(n, kind, depth, dtype, proc)
        elif roll < 0.73:
            kind, depth, form = "chain", rng.choice(_CHAIN_DEPTHS), "elementwise"
            module_text, body_text = _ew_module(n, kind, depth, dtype, proc)
        else:
            kind = rng.choice(["add", "mul", "max", "relu"])
            module_text, body_text = _ew_module(n, kind, 1, dtype, proc)
            form, depth = "elementwise", 1

        rhash = region_hash(body_text)
        if rhash in seen:
            continue
        seen.add(rhash)
        shape = parse_generic(body_text)
        if shape is None:
            continue
        uid = f"{engine}_generic_{written:05d}_{rhash[:8]}"
        (out_dir / f"{uid}.mlir").write_text(module_text)
        LinalgOpSample(
            uid=uid, engine=engine, op_name="linalg.generic",
            region_mlir=body_text, region_hash=rhash,
            features=featurize(shape), label_cycles=None,
            meta={"n": n, "dtype": dtype, "kind": kind, "form": form,
                  "chain_depth": depth, "source": "synthetic"},
        ).write(out_dir / f"{uid}.json")
        written += 1
    return written


def build_ve_corpus(out_dir: Path, n_samples: int, seed: int = 0) -> int:
    # VE reduction lowering is broken under the upgraded compiler -> hold it.
    return build_generic_corpus(out_dir, n_samples, seed, engine="ve",
                                emit_reduction=False)


def main(argv: list[str] | None = None) -> int:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", type=Path, default=Path("dataset/corpus/ve"))
    ap.add_argument("--n", type=int, default=500)
    ap.add_argument("--seed", type=int, default=0)
    args = ap.parse_args(argv)
    print(f"wrote {build_ve_corpus(args.out, args.n, args.seed)} VE samples to {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
