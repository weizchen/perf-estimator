"""Synthetic Tier-2 structured-op corpus builder (VE + Scalar).

Five named ops that lower on VE/Scalar (verified) and add real coverage beyond
the generic/matmul/conv families:

  * reduce      — named reduction (LayerNorm / softmax reductions)
  * broadcast   — bias / mask expansion
  * copy        — pure memory move
  * elementwise — newer structured elementwise (kind attr)
  * select      — conditional / attention masking (cond, true, false)

Dtypes come from `policy.GENERIC_DTYPES[engine]` (VE: i8/i16/bf16/f16/f32;
Scalar: i8/i16/f16/f32); div / unary transcendental elementwise kinds are
float-only (`policy.FLOAT_DTYPES`). `reduce` is the named-Reduction op, whose
VE lowering is broken, so VE is built with `emit_reduce=False` and named
reductions live on the scalar core only. (map, pack, unpack were dropped: map
is redundant with generic + elementwise; pack/unpack fail bufferization.)
"""

from __future__ import annotations

import math
import random
from pathlib import Path

from dataset.scripts.canonicalize import region_hash
from dataset.scripts.features import feature_vector_structured
from dataset.scripts.policy import FLOAT_DTYPES, GENERIC_DTYPES
from dataset.scripts.schema import PROC_OF_ENGINE, LinalgOpSample

_KINDS = ["reduce", "broadcast", "copy", "elementwise", "select"]

# elementwise kinds (verified to lower). Binary work for any dtype; div + the
# unary transcendentals are float-only.
_EW_BINARY = ["add", "sub", "mul", "max_signed", "min_signed"]
_EW_BINARY_F = ["div"]
_EW_UNARY_F = ["exp", "tanh", "negf"]
# reduce combiner ops by (float, int).
_RED = {"sum": ("arith.addf", "arith.addi"),
        "max": ("arith.maximumf", "arith.maxsi"),
        "mul": ("arith.mulf", "arith.muli")}


def _is_int(dt: str) -> bool:
    return dt.startswith("i") and dt[1:].isdigit()


def _dim(rng: random.Random, lo: int = 4, hi: int = 512) -> int:
    return max(lo, min(hi, int(2 ** rng.uniform(math.log2(lo), math.log2(hi)))))


def _t(shape, dt):
    return "tensor<" + "x".join(str(d) for d in shape) + f"x{dt}>"


def _elems(shape):
    n = 1
    for d in shape:
        n *= d
    return n


def _wrap(args, ret_t, body, yld, proc):
    return (
        "module {\n"
        f"  func.func @kernel({args}) -> {ret_t} {{\n"
        f"    %r = NAIL.unit {{schedule = 0 : i64}} : "
        f"!NAIL.target<i : 0, j : 0, proc : {proc}> -> {ret_t} {{\n"
        f"    {body}\n"
        f"      NAIL.yield {yld} : {ret_t}\n"
        f"    }}\n"
        f"    return %r : {ret_t}\n"
        "  }\n}\n"
    )


def _make(kind, rng, proc, dtypes):
    """Return (module, body, dtype, in_elems, out_elems, rank, n_inputs, meta)."""
    if kind == "reduce":
        dt = rng.choice(dtypes)
        red = rng.choice(list(_RED))
        op = _RED[red][1 if _is_int(dt) else 0]
        shape = [_dim(rng) for _ in range(rng.choice([2, 3]))]
        rdim = rng.randrange(len(shape))
        out_shape = [d for i, d in enumerate(shape) if i != rdim]
        ti, to = _t(shape, dt), _t(out_shape, dt)
        body = (f"%z = linalg.reduce ins(%arg0 : {ti}) outs(%arg1 : {to}) "
                f"dimensions = [{rdim}]\n"
                f"      (%in: {dt}, %acc: {dt}) {{\n"
                f"        %s = {op} %in, %acc : {dt}\n"
                f"        linalg.yield %s : {dt}\n      }}")
        return (_wrap(f"%arg0: {ti}, %arg1: {to}", to, body, "%z", proc), body,
                dt, _elems(shape), _elems(out_shape), len(shape), 1,
                {"reduce_kind": red, "dim": rdim})
    if kind == "broadcast":
        dt = rng.choice(dtypes)
        rank = rng.choice([2, 3])
        out_shape = [_dim(rng) for _ in range(rank)]
        bdim = rng.randrange(rank)
        in_shape = [d for i, d in enumerate(out_shape) if i != bdim]
        ti, to = _t(in_shape, dt), _t(out_shape, dt)
        body = (f"%z = linalg.broadcast ins(%arg0 : {ti}) outs(%arg1 : {to}) "
                f"dimensions = [{bdim}]")
        return (_wrap(f"%arg0: {ti}, %arg1: {to}", to, body, "%z", proc), body,
                dt, _elems(in_shape), _elems(out_shape), rank, 1,
                {"bcast_dim": bdim})
    if kind == "copy":
        dt = rng.choice(dtypes)
        shape = [_dim(rng) for _ in range(rng.choice([1, 2, 3]))]
        t = _t(shape, dt)
        body = f"%z = linalg.copy ins(%arg0 : {t}) outs(%arg1 : {t}) -> {t}"
        return (_wrap(f"%arg0: {t}, %arg1: {t}", t, body, "%z", proc), body,
                dt, _elems(shape), _elems(shape), len(shape), 1, {})
    if kind == "elementwise":
        dt = rng.choice(dtypes)
        if _is_int(dt):
            ek = rng.choice(_EW_BINARY)
            unary = False
        else:
            ek = rng.choice(_EW_BINARY + _EW_BINARY_F + _EW_UNARY_F)
            unary = ek in _EW_UNARY_F
        shape = [_dim(rng) for _ in range(rng.choice([1, 2]))]
        t = _t(shape, dt)
        if unary:
            ins = f"ins(%arg0 : {t})"
            args = f"%arg0: {t}, %arg1: {t}"
            n_in = 1
        else:
            ins = f"ins(%arg0, %arg1 : {t}, {t})"
            args = f"%arg0: {t}, %arg1: {t}, %arg2: {t}"
            n_in = 2
        out = "%arg1" if unary else "%arg2"
        body = (f"%z = linalg.elementwise kind=#linalg.elementwise_kind<{ek}> "
                f"{ins} outs({out} : {t}) -> {t}")
        return (_wrap(args, t, body, "%z", proc), body,
                dt, _elems(shape), _elems(shape), len(shape), n_in,
                {"ew_kind": ek})
    # select
    dt = rng.choice(dtypes)
    shape = [_dim(rng) for _ in range(rng.choice([1, 2]))]
    t, tc = _t(shape, dt), _t(shape, "i1")
    body = (f"%z = linalg.select ins(%arg0, %arg1, %arg2 : {tc}, {t}, {t}) "
            f"outs(%arg3 : {t}) -> {t}")
    return (_wrap(f"%arg0: {tc}, %arg1: {t}, %arg2: {t}, %arg3: {t}", t, body, "%z", proc),
            body, dt, _elems(shape), _elems(shape), len(shape), 3, {})


def build_structured_corpus(out_dir: Path, n_samples: int, seed: int = 0,
                            engine: str = "ve", dtypes: list[str] | None = None,
                            emit_reduce: bool = True) -> int:
    rng = random.Random(seed)
    proc = PROC_OF_ENGINE[engine]
    dtypes = dtypes or GENERIC_DTYPES[engine]
    # `reduce` is the named-Reduction op; its VE lowering is broken -> hold it.
    kinds = _KINDS if emit_reduce else [k for k in _KINDS if k != "reduce"]
    out_dir.mkdir(parents=True, exist_ok=True)
    seen: set[str] = set()
    written = attempts = 0
    while written < n_samples and attempts < n_samples * 6:
        attempts += 1
        kind = rng.choice(kinds)
        module, body, dt, ine, oute, rank, n_in, extra = _make(kind, rng, proc, dtypes)
        rhash = region_hash(body)
        if rhash in seen:
            continue
        seen.add(rhash)
        uid = f"{engine}_{kind}_{written:05d}_{rhash[:8]}"
        (out_dir / f"{uid}.mlir").write_text(module)
        LinalgOpSample(
            uid=uid, engine=engine, op_name=f"linalg.{kind}",
            region_mlir=body, region_hash=rhash,
            features=feature_vector_structured(kind, ine, oute, rank, n_in, dt),
            label_cycles=None,
            meta={"kind": kind, "dtype": dt, "in_elems": ine, "out_elems": oute,
                  "rank": rank, "source": "synthetic", **extra},
        ).write(out_dir / f"{uid}.json")
        written += 1
    return written


def main(argv: list[str] | None = None) -> int:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", type=Path, default=None)
    ap.add_argument("--engine", choices=["ve", "scalar"], default="ve")
    ap.add_argument("--n", type=int, default=200)
    ap.add_argument("--seed", type=int, default=0)
    args = ap.parse_args(argv)
    out = args.out or Path("dataset/corpus") / args.engine
    n = build_structured_corpus(out, args.n, args.seed, args.engine)
    print(f"wrote {n} structured ({args.engine}) samples to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
