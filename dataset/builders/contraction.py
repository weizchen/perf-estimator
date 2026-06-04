"""Synthetic contraction corpus builder: batch_matmul, matvec, vecmat.

These are the matmul-family ops that show up in transformer inference but that
the ME kernel can't run (it only handles 2-D `linalg.matmul`). They lower on
VE and Scalar, so this builder targets those engines:

  * batch_matmul [B,M,K]x[B,K,N] -> [B,M,N]   (batched attention: Q·Kᵀ, attn·V)
  * matvec       [M,K]·[K]       -> [M]        (decode-phase GEMV)
  * vecmat       [K]·[K,N]       -> [N]        (decode-phase GEMV)

Dtypes {i8 (→i32 acc), bf16, f32} — all verified to lower on VE/Scalar.
"""

from __future__ import annotations

import math
import random
from pathlib import Path

from dataset.canonicalize import region_hash
from dataset.features import feature_vector_contraction
from dataset.schema import PROC_OF_ENGINE, LinalgOpSample

_DTYPES = ["i8", "bf16", "f32"]
_BATCH = [1, 2, 4, 8, 16, 32]
_KINDS = ["batch_matmul", "matvec", "vecmat"]


def _acc(dt: str) -> str:
    return "i32" if dt == "i8" else "f32"


def _dim(rng: random.Random, lo: int = 8, hi: int = 2048) -> int:
    return max(lo, min(hi, int(2 ** rng.uniform(math.log2(lo), math.log2(hi)))))


def _wrap(args: str, ret_t: str, body: str, yld: str, proc: int) -> str:
    return (
        "module {\n"
        f"  func.func @main({args}) -> {ret_t} {{\n"
        f"    %r = NAIL.unit {{schedule = 0 : i64}} : "
        f"!NAIL.target<i : 0, j : 0, proc : {proc}> -> {ret_t} {{\n"
        f"    {body}\n"
        f"      NAIL.yield {yld} : {ret_t}\n"
        f"    }}\n"
        f"    return %r : {ret_t}\n"
        "  }\n}\n"
    )


def _make(kind: str, rng: random.Random, dtype: str, proc: int):
    """Return (module_text, body_text, (B,M,K,N))."""
    a = _acc(dtype)
    if kind == "batch_matmul":
        B, M, K, N = rng.choice(_BATCH), _dim(rng), _dim(rng), _dim(rng)
        at, bt, ct = (f"tensor<{B}x{M}x{K}x{dtype}>", f"tensor<{B}x{K}x{N}x{dtype}>",
                      f"tensor<{B}x{M}x{N}x{a}>")
        body = (f"%z = linalg.batch_matmul ins(%arg0, %arg1 : {at}, {bt}) "
                f"outs(%arg2 : {ct}) -> {ct}")
        return _wrap(f"%arg0: {at}, %arg1: {bt}, %arg2: {ct}", ct, body, "%z", proc), body, (B, M, K, N)
    if kind == "matvec":
        M, K = _dim(rng), _dim(rng)
        at, xt, yt = f"tensor<{M}x{K}x{dtype}>", f"tensor<{K}x{dtype}>", f"tensor<{M}x{a}>"
        body = (f"%z = linalg.matvec ins(%arg0, %arg1 : {at}, {xt}) "
                f"outs(%arg2 : {yt}) -> {yt}")
        return _wrap(f"%arg0: {at}, %arg1: {xt}, %arg2: {yt}", yt, body, "%z", proc), body, (1, M, K, 1)
    # vecmat
    K, N = _dim(rng), _dim(rng)
    xt, at, yt = f"tensor<{K}x{dtype}>", f"tensor<{K}x{N}x{dtype}>", f"tensor<{N}x{a}>"
    body = (f"%z = linalg.vecmat ins(%arg0, %arg1 : {xt}, {at}) "
            f"outs(%arg2 : {yt}) -> {yt}")
    return _wrap(f"%arg0: {xt}, %arg1: {at}, %arg2: {yt}", yt, body, "%z", proc), body, (1, 1, K, N)


def build_contraction_corpus(out_dir: Path, n_samples: int, seed: int = 0,
                             engine: str = "ve") -> int:
    rng = random.Random(seed)
    proc = PROC_OF_ENGINE[engine]
    out_dir.mkdir(parents=True, exist_ok=True)
    seen: set[str] = set()
    written = attempts = 0
    while written < n_samples and attempts < n_samples * 5:
        attempts += 1
        kind = rng.choice(_KINDS)
        dtype = rng.choice(_DTYPES)
        module_text, body_text, (B, M, K, N) = _make(kind, rng, dtype, proc)
        rhash = region_hash(body_text)
        if rhash in seen:
            continue
        seen.add(rhash)
        uid = f"{engine}_{kind}_{written:05d}_{rhash[:8]}"
        (out_dir / f"{uid}.mlir").write_text(module_text)
        LinalgOpSample(
            uid=uid, engine=engine, op_name=f"linalg.{kind}",
            region_mlir=body_text, region_hash=rhash,
            features=feature_vector_contraction(kind, B, M, K, N, dtype),
            label_cycles=None,
            meta={"kind": kind, "B": B, "M": M, "K": K, "N": N,
                  "dtype": dtype, "acc": _acc(dtype), "source": "synthetic"},
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
    n = build_contraction_corpus(out, args.n, args.seed, args.engine)
    print(f"wrote {n} contraction ({args.engine}) samples to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
