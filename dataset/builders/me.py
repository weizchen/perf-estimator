"""Synthetic Matrix-Engine matmul corpus builder (+ optional cross-engine).

Emits single-op `linalg.matmul` modules. By default they target the Matrix
Engine (`proc: 2`), where the hand-tuned systolic kernel runs them.

Dtypes and where they lower (verified by flipping `proc` and compiling):
  * f32, f8E5M2  -> ME only (VE/Scalar hit unrealized_conversion_cast)
  * bf16, i8     -> ME, VE and Scalar all lower
i8 uses i32 accumulation (the standard quantized matmul); floats use f32.

Cross-engine mode (`cross_engine=True`): for the dtypes that lower elsewhere
(bf16, i8) the *same* matmul instance is also emitted for VE and Scalar, so you
get aligned per-op cross-engine cycle pairs ("which engine is fastest for this
matmul"). These land in the sibling `ve/` and `scalar/` corpus dirs with
`op_name=linalg.matmul` and the 16-d matmul feature vector.

Shapes: log-uniform [1,4096] with extra mass on the 128 systolic boundary.
"""

from __future__ import annotations

import random
from pathlib import Path

from dataset.canonicalize import region_hash
from dataset.features import feature_vector_me, parse_matmul
from dataset.schema import LinalgOpSample

_DTYPES = ["i8", "f8E5M2", "bf16", "f32"]
# Sizes that matter for the 128x128 systolic engine: powers of two, the
# 127/128/129 tile-edge triple, and a few non-power-of-two multiples.
_BOUNDARY = [32, 64, 127, 128, 129, 256, 384, 512, 1024, 2048, 4096]
# Matmul dtypes that actually lower on VE/Scalar (verified). f8E5M2 and f32
# do NOT (unrealized_conversion_cast); we still mirror them cross-engine and
# tag them `expected_lower=False` so they're available as bug-report cases.
_CROSS_LOWERS = {"i8", "bf16"}


def _acc_dtype(dtype: str) -> str:
    return "i32" if dtype == "i8" else "f32"


def _free(rng: random.Random) -> int:
    """A free dimension: log-uniform in [8, 4096]."""
    return max(8, min(4096, int(2 ** rng.uniform(3.0, 12.0))))


def _sample_shape(rng: random.Random) -> tuple[int, int, int]:
    """Sample (M, K, N) with mass concentrated on the boundary grid.

      35%  boundary           : M, K, N all from the boundary set (fully aligned)
      35%  boundary x boundary : M, N on the boundary grid, K free (aligned
                                 output tiles, arbitrary contraction depth)
      30%  free                : M, K, N all log-uniform in [8, 4096]
    """
    r = rng.random()
    if r < 0.35:
        return (rng.choice(_BOUNDARY), rng.choice(_BOUNDARY), rng.choice(_BOUNDARY))
    if r < 0.70:
        return (rng.choice(_BOUNDARY), _free(rng), rng.choice(_BOUNDARY))
    return (_free(rng), _free(rng), _free(rng))


def _matmul_module(M: int, K: int, N: int, dtype: str, proc: int) -> tuple[str, str]:
    acc = _acc_dtype(dtype)
    at, bt = f"tensor<{M}x{K}x{dtype}>", f"tensor<{K}x{N}x{dtype}>"
    ct = f"tensor<{M}x{N}x{acc}>"
    body = (f"    %m = linalg.matmul ins(%arg0, %arg1 : {at}, {bt}) "
            f"outs(%arg2 : {ct}) -> {ct}\n")
    module = (
        "module {\n"
        f"  func.func @main(%arg0: {at}, %arg1: {bt}, %arg2: {ct}) -> {ct} {{\n"
        f"    %r = NAIL.unit {{schedule = 0 : i64}} : "
        f"!NAIL.target<i : 0, j : 0, proc : {proc}> -> {ct} {{\n"
        f"  {body}"
        f"      NAIL.yield %m : {ct}\n"
        f"    }}\n"
        f"    return %r : {ct}\n"
        "  }\n}\n"
    )
    return module, body.strip()


def _engines_for(dtype: str, cross_engine: bool) -> list[tuple[str, int]]:
    engines = [("me", 2)]
    if cross_engine:                      # mirror ALL dtypes (keep failures)
        engines += [("ve", 1), ("scalar", 0)]
    return engines


def build_me_corpus(out_dir: Path, n_samples: int, seed: int = 0,
                    cross_engine: bool = False) -> int:
    """Generate `n_samples` ME matmuls (+ cross-engine copies if enabled).

    `out_dir` is the ME corpus dir; cross-engine copies go to its siblings
    `../ve` and `../scalar`. Returns the ME sample count.
    """
    rng = random.Random(seed)
    root = out_dir.parent
    seen = {"me": set(), "ve": set(), "scalar": set()}
    written = {"me": 0, "ve": 0, "scalar": 0}
    attempts = 0
    while written["me"] < n_samples and attempts < n_samples * 4:
        attempts += 1
        M, K, N = _sample_shape(rng)
        dtype = rng.choice(_DTYPES)
        body_text = _matmul_module(M, K, N, dtype, 2)[1]
        rhash = region_hash(body_text)
        shape = parse_matmul(body_text)
        if shape is None:
            continue
        feats = feature_vector_me(shape)
        for engine, proc in _engines_for(dtype, cross_engine):
            if rhash in seen[engine]:
                continue
            seen[engine].add(rhash)
            module_text, _ = _matmul_module(M, K, N, dtype, proc)
            # ME goes to the given dir; cross-engine copies to its siblings.
            dst = out_dir if engine == "me" else root / engine
            dst.mkdir(parents=True, exist_ok=True)
            uid = f"{engine}_matmul_{written[engine]:05d}_{rhash[:8]}"
            (dst / f"{uid}.mlir").write_text(module_text)
            LinalgOpSample(
                uid=uid, engine=engine, op_name="linalg.matmul",
                region_mlir=body_text, region_hash=rhash, features=feats,
                label_cycles=None,
                meta={"M": M, "N": N, "K": K, "dtype": dtype,
                      "acc": _acc_dtype(dtype), "source": "synthetic",
                      "cross_engine": engine != "me",
                      "expected_lower": engine == "me" or dtype in _CROSS_LOWERS},
            ).write(dst / f"{uid}.json")
            written[engine] += 1
    return written["me"]


def main(argv: list[str] | None = None) -> int:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", type=Path, default=Path("dataset/corpus/me"))
    ap.add_argument("--n", type=int, default=500)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--cross-engine", action="store_true",
                    help="also emit bf16/i8 matmuls for VE and Scalar")
    args = ap.parse_args(argv)
    n = build_me_corpus(args.out, args.n, args.seed, args.cross_engine)
    print(f"wrote {n} ME matmul samples to {args.out}"
          f"{' (+cross-engine VE/Scalar copies)' if args.cross_engine else ''}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
