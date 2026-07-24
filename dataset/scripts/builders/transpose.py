"""Synthetic transpose corpus builder (linalg.transpose).

Memory-bound permutation — common in transformers (attention Q/K/V reshapes,
weight relayouts). No ME kernel; lowers on VE and Scalar (Elementwise category
→ in each engine's supported_ops). Dtypes come from
`policy.GENERIC_DTYPES[engine]` (transpose is dtype-agnostic data movement, so
it exercises the full integer+float range incl. i16). Covers rank-2/3/4
permutations; the cost knobs are the shape and the permutation, not arithmetic.
"""

from __future__ import annotations

import math
import random
from pathlib import Path

from dataset.scripts.canonicalize import region_hash
from dataset.scripts.features import feature_vector_transpose
from dataset.scripts.policy import GENERIC_DTYPES
from dataset.scripts.schema import PROC_OF_ENGINE, LinalgOpSample
# Non-identity permutations per rank (attention-style reshapes for rank 3/4).
_PERMS = {
    2: [[1, 0]],
    3: [[0, 2, 1], [1, 0, 2], [2, 1, 0]],
    4: [[0, 2, 1, 3], [0, 1, 3, 2], [0, 3, 2, 1]],
}


def _dim(rng: random.Random, lo: int, hi: int) -> int:
    return max(lo, min(hi, int(2 ** rng.uniform(math.log2(lo), math.log2(hi)))))


def _ttype(shape: list[int], dtype: str) -> str:
    return "tensor<" + "x".join(str(d) for d in shape) + f"x{dtype}>"


def _transpose_module(shape, perm, dtype, proc):
    out_shape = [shape[p] for p in perm]
    in_t, out_t = _ttype(shape, dtype), _ttype(out_shape, dtype)
    perm_str = ", ".join(str(p) for p in perm)
    body = (f"%z = linalg.transpose ins(%arg0 : {in_t}) "
            f"outs(%arg1 : {out_t}) permutation = [{perm_str}]")
    module = (
        "module {\n"
        f"  func.func @kernel(%arg0: {in_t}, %arg1: {out_t}) -> {out_t} {{\n"
        f"    %r = NAIL.unit {{schedule = 0 : i64}} : "
        f"!NAIL.target<i : 0, j : 0, proc : {proc}> -> {out_t} {{\n"
        f"    {body}\n"
        f"      NAIL.yield %z : {out_t}\n"
        f"    }}\n"
        f"    return %r : {out_t}\n"
        "  }\n}\n"
    )
    return module, body


def build_transpose_corpus(out_dir: Path, n_samples: int, seed: int = 0,
                           engine: str = "ve",
                           dtypes: list[str] | None = None) -> int:
    rng = random.Random(seed)
    proc = PROC_OF_ENGINE[engine]
    dtypes = dtypes or GENERIC_DTYPES[engine]
    out_dir.mkdir(parents=True, exist_ok=True)
    seen: set[str] = set()
    written = attempts = 0
    while written < n_samples and attempts < n_samples * 5:
        attempts += 1
        rank = rng.choice([2, 2, 3, 4])               # bias toward 2-D
        hi = {2: 512, 3: 128, 4: 48}[rank]            # cap to keep tensors small
        shape = [_dim(rng, 4, hi) for _ in range(rank)]
        perm = rng.choice(_PERMS[rank])
        dtype = rng.choice(dtypes)
        module_text, body_text = _transpose_module(shape, perm, dtype, proc)
        rhash = region_hash(body_text)
        if rhash in seen:
            continue
        seen.add(rhash)
        uid = f"{engine}_transpose_{written:05d}_{rhash[:8]}"
        (out_dir / f"{uid}.mlir").write_text(module_text)
        LinalgOpSample(
            uid=uid, engine=engine, op_name="linalg.transpose",
            region_mlir=body_text, region_hash=rhash,
            features=feature_vector_transpose(shape, perm, dtype),
            label_cycles=None,
            meta={"shape": shape, "perm": perm, "rank": rank,
                  "dtype": dtype, "source": "synthetic"},
        ).write(out_dir / f"{uid}.json")
        written += 1
    return written


def main(argv: list[str] | None = None) -> int:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", type=Path, default=None)
    ap.add_argument("--engine", choices=["ve", "scalar"], default="ve")
    ap.add_argument("--n", type=int, default=120)
    ap.add_argument("--seed", type=int, default=0)
    args = ap.parse_args(argv)
    out = args.out or Path("dataset/corpus") / args.engine
    n = build_transpose_corpus(out, args.n, args.seed, args.engine)
    print(f"wrote {n} transpose ({args.engine}) samples to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
