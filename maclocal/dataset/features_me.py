"""ME v2 featurizer -- an additive extension of `dataset/scripts/features.py`.

This lives here rather than inside the shared featurizer so that `maclocal/`
stays a purely additive subtree: nothing upstream is modified, so nothing can
conflict when this branch is merged or compared against someone else's work on
the same corpus.

To fold it upstream later, paste `feature_vector_me_v2` + the two constants into
`dataset/scripts/features.py` next to `feature_vector_me` and delete this file.
It deliberately reuses the shared parse helpers (`MatmulShape`, `parse_matmul`,
`_DTYPES`) rather than copying them, so there is exactly one matmul parser.

What changed from v1, measured against the labelled corpus (786 ME benchmarks,
`results-7-30-2026.csv`):

1. Every M, K and N in the corpus is already a multiple of the mode's systolic
   edge -- 786/786 on all three dims. Application-level padding (see
   `policy.align_dim`) means the ME never sees a ragged operand, so v1's two
   padding-waste slots are identically zero on every sample. Dropped here.

2. Cost is close to linear in the output dims but strongly *sublinear* in K.
   Fitting log(ticks) ~ a.logM + b.logN + c.logK per mode gives M^0.82..0.89,
   N^0.84..0.90 but K^0.20..0.35 (median 0.29 with M,N held fixed). So the
   textbook output-stationary roofline `tiles_m * tiles_n * K`, which assumes
   K^1, mismodels the corpus -- per-output-tile fixed cost dominates over
   K-streaming. v2 therefore exposes tiles_m*tiles_n and K as *separate* log
   terms rather than pre-multiplying them, letting a model fit its own K
   exponent instead of having 1.0 baked in.

The dtype one-hot is kept: array edge (128 vs 64) and accumulator width both
shift the intercept, and f16->f16 has a visibly different K exponent from the
f32-accumulator modes.
"""

from __future__ import annotations

import math
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from dataset.scripts.features import _DTYPES, MatmulShape  # noqa: E402
from dataset.scripts.policy import align_dim  # noqa: E402


def feature_vector_me_v2(s: MatmulShape) -> list[float]:
    """25-d ME feature vector. See the module docstring for what changed."""
    M, N, K = s.M, s.N, s.K
    dim = align_dim(s.dtype)
    tiles_m = math.ceil(M / dim)
    tiles_n = math.ceil(N / dim)
    tiles_k = math.ceil(K / dim)
    out_tiles = tiles_m * tiles_n
    onehot = [1.0 if s.dtype == d else 0.0 for d in _DTYPES]
    return [
        # raw dims (trees split on these directly)
        float(M), float(N), float(K),
        # logs -- a linear model over these is exactly the power law
        math.log2(M), math.log2(N), math.log2(K),
        math.log2(M * N * K),
        # output-tile count: the term the labels say actually drives cost
        math.log2(out_tiles),
        float(out_tiles),
        float(tiles_m), float(tiles_n), float(tiles_k),
        # the naive roofline, kept as one feature so a model can use it if it helps
        math.log2(out_tiles * K),
        # operand/result traffic
        math.log2(M * K + K * N + M * N),
        # arithmetic intensity: MACs per element moved
        math.log2(M * N * K / (M * K + K * N + M * N)),
        # shape anisotropy -- separates tall-skinny from square at equal MNK
        math.log2(M / N),
        math.log2(M * N / K),
        # mode descriptors
        float(dim),
        1.0 if s.acc == s.dtype else 0.0,     # narrow accumulator (f16->f16)
        *onehot,                              # 6
    ]


ME_V2_FEATURE_DIM = 19 + len(_DTYPES)   # 25


ME_V2_FEATURE_NAMES = [
    "M", "N", "K",
    "log2_M", "log2_N", "log2_K", "log2_MNK",
    "log2_out_tiles", "out_tiles", "tiles_m", "tiles_n", "tiles_k",
    "log2_out_tiles_K", "log2_bytes", "log2_arith_intensity",
    "log2_M_over_N", "log2_MN_over_K",
    "array_dim", "narrow_acc",
] + [f"dt_{d}" for d in _DTYPES]

assert len(ME_V2_FEATURE_NAMES) == ME_V2_FEATURE_DIM
