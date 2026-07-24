"""Synthetic contraction corpus builder: batch_matmul, matvec, vecmat.

These are the matmul-family ops that show up in transformer inference but that
the ME kernel can't run (it only handles 2-D `linalg.matmul`). Under the
upgraded compiler they FAIL to lower on VE -- all three kinds fail with
"could not lower dispatch.bind processor VE", identically for both an f32 and
an f16 accumulator, so the gap is VE contraction support, not precision. This
builder is therefore Scalar-only, over `policy.MATMUL_MODES["scalar"]`
(i8->i32, f16->f32, f16->f16, f32->f32):

  * batch_matmul [B,M,K]x[B,K,N] -> [B,M,N]   (batched attention: Q·Kᵀ, attn·V)
  * matvec       [M,K]·[K]       -> [M]        (decode-phase GEMV)
  * vecmat       [K]·[K,N]       -> [N]        (decode-phase GEMV)

By `categoryOf`, batch_matmul is Matmul (∉ scalar supported_ops → routed to
`extras/scalar/`); matvec/vecmat are Reduction (∈ scalar supported_ops → kept in
the main scalar corpus).

Matrix dimensions (M, K, N — not the batch dim) are multiples of
`policy.align_dim(dtype)`: applications pad their matrices to the ME's systolic
geometry up front, so the scalar core only ever sees aligned operands too.
"""

from __future__ import annotations

import math
import random
from pathlib import Path

from dataset.scripts.canonicalize import region_hash
from dataset.scripts.features import feature_vector_contraction
from dataset.scripts.policy import MATMUL_MODES, acc_dtype as _acc, align_dim
from dataset.scripts.schema import PROC_OF_ENGINE, LinalgOpSample

_BATCH = [1, 2, 4, 8, 16, 32]
_KINDS = ["batch_matmul", "matvec", "vecmat"]
_MAX_DIM = 2048


def _dim(rng: random.Random, align: int) -> int:
    """A matrix dimension: a multiple of `align`, log-uniform in tile count."""
    max_tiles = max(1, _MAX_DIM // align)
    tiles = int(round(2 ** rng.uniform(0.0, math.log2(max_tiles))))
    return min(max_tiles, max(1, tiles)) * align


def _wrap(args: str, ret_t: str, body: str, yld: str, proc: int) -> str:
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


def _make(kind: str, rng: random.Random, dtype: str, acc: str, proc: int):
    """Return (module_text, body_text, (B,M,K,N))."""
    a = acc
    al = align_dim(dtype)
    if kind == "batch_matmul":
        B, M, K, N = rng.choice(_BATCH), _dim(rng, al), _dim(rng, al), _dim(rng, al)
        at, bt, ct = (f"tensor<{B}x{M}x{K}x{dtype}>", f"tensor<{B}x{K}x{N}x{dtype}>",
                      f"tensor<{B}x{M}x{N}x{a}>")
        body = (f"%z = linalg.batch_matmul ins(%arg0, %arg1 : {at}, {bt}) "
                f"outs(%arg2 : {ct}) -> {ct}")
        return _wrap(f"%arg0: {at}, %arg1: {bt}, %arg2: {ct}", ct, body, "%z", proc), body, (B, M, K, N)
    if kind == "matvec":
        M, K = _dim(rng, al), _dim(rng, al)
        at, xt, yt = f"tensor<{M}x{K}x{dtype}>", f"tensor<{K}x{dtype}>", f"tensor<{M}x{a}>"
        body = (f"%z = linalg.matvec ins(%arg0, %arg1 : {at}, {xt}) "
                f"outs(%arg2 : {yt}) -> {yt}")
        return _wrap(f"%arg0: {at}, %arg1: {xt}, %arg2: {yt}", yt, body, "%z", proc), body, (1, M, K, 1)
    # vecmat
    K, N = _dim(rng, al), _dim(rng, al)
    xt, at, yt = f"tensor<{K}x{dtype}>", f"tensor<{K}x{N}x{dtype}>", f"tensor<{N}x{a}>"
    body = (f"%z = linalg.vecmat ins(%arg0, %arg1 : {xt}, {at}) "
            f"outs(%arg2 : {yt}) -> {yt}")
    return _wrap(f"%arg0: {xt}, %arg1: {at}, %arg2: {yt}", yt, body, "%z", proc), body, (1, 1, K, N)


def build_contraction_corpus(out_dir: Path, n_samples: int, seed: int = 0,
                             engine: str = "scalar",
                             dtypes: list[str] | None = None) -> int:
    rng = random.Random(seed)
    proc = PROC_OF_ENGINE[engine]
    # (input, accumulator) modes, same table the 2-D matmul builder uses: the
    # widening accumulator per dtype plus the narrow f16->f16 variant.  An
    # explicit `dtypes` list falls back to the widening accumulator only.
    modes = ([(d, _acc(d)) for d in dtypes] if dtypes
             else list(MATMUL_MODES[engine]))
    cells = [(k, m) for k in _KINDS for m in modes]
    quota = max(1, round(n_samples / len(cells)))
    out_dir.mkdir(parents=True, exist_ok=True)
    seen: set[str] = set()
    written = 0
    for kind, (dtype, acc) in cells:
        made = attempts = 0
        while made < quota and attempts < quota * 20:
            attempts += 1
            module_text, body_text, (B, M, K, N) = _make(kind, rng, dtype, acc, proc)
            rhash = region_hash(body_text)
            if rhash in seen:
                continue
            seen.add(rhash)
            uid = f"{engine}_{kind}_{written:05d}_{rhash[:8]}"
            (out_dir / f"{uid}.mlir").write_text(module_text)
            LinalgOpSample(
                uid=uid, engine=engine, op_name=f"linalg.{kind}",
                region_mlir=body_text, region_hash=rhash,
                features=feature_vector_contraction(kind, B, M, K, N, dtype, acc),
                label_cycles=None,
                meta={"kind": kind, "B": B, "M": M, "K": K, "N": N,
                      "dtype": dtype, "acc": acc, "source": "synthetic"},
            ).write(out_dir / f"{uid}.json")
            written += 1
            made += 1
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
    n = build_contraction_corpus(out, args.n, args.seed, args.engine)
    print(f"wrote {n} contraction ({args.engine}) samples to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
