"""Synthetic RISC-V scalar corpus builder.

Same op families and sweep as the Vector Engine (see `ve.py`): elementwise +
reduction `linalg.generic` over kinds {add, mul, max, relu, sigmoid, sum, max,
mean} with chain depths {1,2,4,8}. Dtypes come from
`policy.GENERIC_DTYPES["scalar"]` = {i8, i16, f16, f32} (RISC-V has no BF16).
Unlike VE, the scalar core *keeps* the reduction-form generics (its reduction
lowering works). The engine binding is `proc: 0`; OFA lowers these through
linalg-to-loops to scalar code. v1 is a feature MLP and is genuinely weak on
this engine; v2 (regress-lm) is the planned upgrade.
"""

from __future__ import annotations

from pathlib import Path

from dataset.scripts.builders.ve import build_generic_corpus


def build_scalar_corpus(out_dir: Path, n_samples: int, seed: int = 0) -> int:
    return build_generic_corpus(out_dir, n_samples, seed, engine="scalar")


def main(argv: list[str] | None = None) -> int:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path, default=Path("dataset/corpus/scalar"))
    ap.add_argument("--n", type=int, default=500)
    ap.add_argument("--seed", type=int, default=0)
    args = ap.parse_args(argv)
    print(f"wrote {build_scalar_corpus(args.out, args.n, args.seed)} "
          f"scalar samples to {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
