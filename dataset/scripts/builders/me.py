"""Synthetic Matrix-Engine matmul corpus builder (+ optional cross-engine).

Emits single-op `linalg.matmul` modules. By default they target the Matrix
Engine (`proc: 2`), where the hand-tuned systolic kernel runs them.

Modes come from `dataset.scripts.policy.ME_MODES` -- the six (input, accumulator) pairs
the compiler declares in `targets/Processors/MatrixEngine.json`:

    FP8  -> FP32   128x128   runnable
    FP16 -> FP32    64x64    runnable
    FP16 -> FP16    64x64    runnable
    INT8 -> INT32  128x128   quarantined -- compiles, gem5 support "still missing"
    BF16 -> FP32    64x64    quarantined -- compiles, gem5 Run FAIL
    BF16 -> FP16    64x64    quarantined -- does not even compile (linalg.matmul
                             cannot cast bf16 accumulation into f16); kept as a
                             token set so the mode is on record

Runnable modes get 3x the sample budget -- they are the rows gem5 can label
today.

Shapes: M, K and N are always **multiples of the mode's systolic array edge**
(64 for FP16/BF16, 128 for INT8/FP8). The ME requires it, so an unaligned
matmul is not a valid benchmark. Multiples are drawn log-uniformly over the
tile count, so the corpus spans 1..64 tiles per dimension (64..4096 elements)
with mass on the small tile counts.

Cross-engine mode (`cross_engine=True`): each instance is also emitted for
every *other* engine whose precision matrix admits its dtype, giving aligned
per-op cross-engine cycle pairs. VE and the scalar core have no systolic array
(RVV with masking / an in-order scalar pipe), so alignment is not required
there -- those copies simply inherit the ME-aligned shape and use the engine's
normal accumulator. matmul on the scalar core is out of RISC-V's supported_ops
and is routed to `corpus/extras/scalar/` by the build driver.
"""

from __future__ import annotations

import math
import random
from pathlib import Path

from dataset.scripts.canonicalize import region_hash
from dataset.scripts.features import feature_vector_me, parse_matmul
from dataset.scripts.policy import (ME_MODES, MATMUL_DTYPES, MATMUL_MODES,
                            acc_dtype as _acc_dtype, align_dim)
from dataset.scripts.schema import LinalgOpSample

_PROC = {"me": 2, "ve": 1, "scalar": 0}
_MAX_DIM = 4096
# Per-mode share of the sample budget: modes gem5 can label today get the most,
# modes that compile but don't run get a reference set, and the one mode that
# does not even lower (bf16->f16) gets a token set kept for the record.
_WEIGHT_RUNS, _WEIGHT_LOWERS_ONLY, _WEIGHT_NO_LOWER = 3.0, 1.0, 0.5


def _aligned_dim(rng: random.Random, dim: int) -> int:
    """A dimension that is a multiple of `dim`, log-uniform in tile count."""
    max_tiles = _MAX_DIM // dim
    tiles = int(round(2 ** rng.uniform(0.0, math.log2(max_tiles))))
    return min(max_tiles, max(1, tiles)) * dim


def _mode_quotas(n_samples: int) -> list[tuple[tuple, int]]:
    """Split `n_samples` across the ME modes, favouring the runnable ones."""
    weights = [_WEIGHT_RUNS if runs else
               (_WEIGHT_LOWERS_ONLY if lowers else _WEIGHT_NO_LOWER)
               for *_, lowers, runs in ME_MODES]
    total = sum(weights)
    return [(mode, max(1, round(n_samples * w / total)))
            for mode, w in zip(ME_MODES, weights)]


def _matmul_module(M: int, K: int, N: int, dtype: str, acc: str,
                   proc: int) -> tuple[str, str]:
    at, bt = f"tensor<{M}x{K}x{dtype}>", f"tensor<{K}x{N}x{dtype}>"
    ct = f"tensor<{M}x{N}x{acc}>"
    body = (f"    %m = linalg.matmul ins(%arg0, %arg1 : {at}, {bt}) "
            f"outs(%arg2 : {ct}) -> {ct}\n")
    module = (
        "module {\n"
        f"  func.func @kernel(%arg0: {at}, %arg1: {bt}, %arg2: {ct}) -> {ct} {{\n"
        f"    %r = NAIL.unit {{schedule = 0 : i64}} : "
        f"!NAIL.target<i : 0, j : 0, proc : {proc}> -> {ct} {{\n"
        f"  {body}"
        f"      NAIL.yield %m : {ct}\n"
        f"    }}\n"
        f"    return %r : {ct}\n"
        "  }\n}\n"
    )
    return module, body.strip()


def _emit(dst: Path, engine: str, index: int, rhash: str, module_text: str,
          body_text: str, feats: list[float], M: int, K: int, N: int,
          dtype: str, acc: str, dim: int, lowers: bool = True) -> None:
    dst.mkdir(parents=True, exist_ok=True)
    uid = f"{engine}_matmul_{index:05d}_{rhash[:8]}"
    (dst / f"{uid}.mlir").write_text(module_text)
    LinalgOpSample(
        uid=uid, engine=engine, op_name="linalg.matmul",
        region_mlir=body_text, region_hash=rhash, features=feats,
        label_cycles=None,
        meta={"M": M, "N": N, "K": K, "dtype": dtype, "acc": acc,
              "array_dim": dim, "lowers": lowers, "source": "synthetic",
              "cross_engine": engine != "me"},
    ).write(dst / f"{uid}.json")


def build_me_corpus(out_dir: Path, n_samples: int, seed: int = 0,
                    cross_engine: bool = False) -> int:
    """Generate ~`n_samples` ME matmuls across the six modes.

    `out_dir` is the ME corpus dir; cross-engine copies go to its siblings
    `../ve` and `../scalar`. Returns the ME sample count.
    """
    rng = random.Random(seed)
    root = out_dir.parent
    seen: dict[str, set[str]] = {"me": set(), "ve": set(), "scalar": set()}
    written = {"me": 0, "ve": 0, "scalar": 0}

    for (dtype, acc, dim, lowers, _runs), quota in _mode_quotas(n_samples):
        made = attempts = 0
        while made < quota and attempts < quota * 20:
            attempts += 1
            M, K, N = (_aligned_dim(rng, dim) for _ in range(3))
            module_text, body_text = _matmul_module(M, K, N, dtype, acc, _PROC["me"])
            rhash = region_hash(body_text)
            if rhash in seen["me"]:
                continue
            shape = parse_matmul(body_text)
            if shape is None:
                continue
            seen["me"].add(rhash)
            feats = feature_vector_me(shape)
            _emit(out_dir, "me", written["me"], rhash, module_text, body_text,
                  feats, M, K, N, dtype, acc, dim, lowers)
            written["me"] += 1
            made += 1

            if not cross_engine:
                continue
            for engine in ("ve", "scalar"):
                if dtype not in MATMUL_DTYPES[engine]:
                    continue
                e_acc = _acc_dtype(dtype)
                e_mod, e_body = _matmul_module(M, K, N, dtype, e_acc, _PROC[engine])
                e_hash = region_hash(e_body)
                if e_hash in seen[engine]:
                    continue
                seen[engine].add(e_hash)
                _emit(root / engine, engine, written[engine], e_hash, e_mod,
                      e_body, feats, M, K, N, dtype, e_acc, dim)
                written[engine] += 1
    return written["me"]


def build_matmul_corpus(out_dir: Path, n_samples: int, seed: int = 0, *,
                        engine: str) -> int:
    """Aligned 2-D matmuls for a non-ME engine (VE / scalar).

    Neither engine has a systolic array and both lower unaligned shapes fine,
    but applications pad their matrices to the ME's geometry before dispatch,
    so these use the same `align_dim` rule.

    Modes come from `policy.MATMUL_MODES[engine]`: the widening accumulator per
    input dtype, plus the narrow `f16->f16` variant the ME also runs. Samples
    are split evenly across the engine's modes.
    """
    rng = random.Random(seed)
    proc = _PROC[engine]
    modes = MATMUL_MODES[engine]
    quota = max(1, round(n_samples / len(modes)))
    seen: set[str] = set()
    written = 0
    for dtype, acc in modes:
        dim = align_dim(dtype)
        made = attempts = 0
        while made < quota and attempts < quota * 20:
            attempts += 1
            M, K, N = (_aligned_dim(rng, dim) for _ in range(3))
            module_text, body_text = _matmul_module(M, K, N, dtype, acc, proc)
            rhash = region_hash(body_text)
            if rhash in seen:
                continue
            shape = parse_matmul(body_text)
            if shape is None:
                continue
            seen.add(rhash)
            _emit(out_dir, engine, written, rhash, module_text, body_text,
                  feature_vector_me(shape), M, K, N, dtype, acc, dim)
            written += 1
            made += 1
    return written


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
