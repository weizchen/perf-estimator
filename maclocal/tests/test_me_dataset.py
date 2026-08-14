"""Verification for the ME dataset join, featurizer and baselines.

These encode the facts the modelling depends on. If one fails, a number in
`results/me/me_results.md` is wrong -- they are not style checks.

Requires `dataset/scripts/build_me_dataset.py` to have been run.
"""

from __future__ import annotations

import math
import sys
from pathlib import Path

import numpy as np
import pytest

REPO = Path(__file__).resolve().parents[2]          # perf-estimator/
LOCAL = REPO / "maclocal"                            # this workstream's own tree
sys.path.insert(0, str(REPO))

from dataset.scripts.features import (  # noqa: E402  (upstream, unmodified)
    FEATURE_DIM, ME_FEATURE_DIM, feature_vector_me, parse_matmul,
)
from dataset.scripts.policy import align_dim  # noqa: E402
from maclocal.dataset.features_me import (  # noqa: E402  (this workstream)
    ME_V2_FEATURE_DIM, ME_V2_FEATURE_NAMES, feature_vector_me_v2,
)
from maclocal.eval.metrics_me import summary, within_pct  # noqa: E402

CORPUS = REPO / "dataset" / "fujitsu_dataset_July24" / "me_ready"   # upstream corpus
DATASET = LOCAL / "processed" / "me_dataset.npz"

pytestmark = pytest.mark.skipif(
    not DATASET.exists(),
    reason="run maclocal/dataset/build_me_dataset.py first")


@pytest.fixture(scope="module")
def ds() -> dict:
    z = np.load(DATASET, allow_pickle=False)
    return {k: z[k] for k in z.files}


# ----- the join --------------------------------------------------------------

def test_sample_count(ds):
    """612 = 613 PASS rows minus the one 2**64 tick overflow."""
    assert len(ds["y"]) == 612


def test_mode_balance(ds):
    """The corpus is balanced 262/mode; these are the per-mode survivors."""
    modes = dict(zip(*np.unique(ds["mode"].astype(str), return_counts=True)))
    assert modes == {"f16->f16": 215, "f16->f32": 202, "f8E5M2->f32": 195}


def test_no_tick_overflow(ds):
    """2**64 ticks is a counter wraparound, not a measurement."""
    assert ds["y"].max() < 2 ** 64
    assert ds["y"].max() < 1e17
    assert (ds["y"] > 0).all()


def test_no_duplicate_configs(ds):
    """Duplicate shapes would leak between train and test under random CV."""
    configs = list(zip(ds["M"], ds["K"], ds["N"], ds["mode"].astype(str)))
    assert len(set(configs)) == len(configs)


def test_target_range(ds):
    """~157x dynamic range is why everything is fit in log space."""
    assert ds["y"].max() / ds["y"].min() == pytest.approx(157, abs=5)


# ----- leakage ---------------------------------------------------------------

def test_no_feature_proportional_to_target(ds):
    """`sim_seconds` is `ticks * 1e-12`; admitting it would be silent leakage."""
    X, y = ds["X"], ds["y"]
    for j in range(X.shape[1]):
        col = X[:, j]
        if np.allclose(col, 0):
            continue
        ratio = col / y
        mean = abs(ratio.mean())
        assert not (mean > 0 and ratio.std() / mean < 1e-6), \
            f"feature {ME_V2_FEATURE_NAMES[j]} is proportional to the target"


def test_feature_matrix_is_finite(ds):
    assert np.isfinite(ds["X"]).all()


# ----- featurizer ------------------------------------------------------------

def test_parse_matmul_roundtrip():
    """A known corpus sample parses to its exact declared shape."""
    text = (CORPUS / "me_matmul_00000_bef03e2f" / "model.mlir").read_text()
    s = parse_matmul(text)
    assert (s.M, s.K, s.N, s.dtype, s.acc) == (2432, 1792, 512, "f8E5M2", "f32")


def test_v2_dimension_and_names(ds):
    s = parse_matmul((CORPUS / "me_matmul_00000_bef03e2f" / "model.mlir").read_text())
    v = feature_vector_me_v2(s)
    assert len(v) == ME_V2_FEATURE_DIM == len(ME_V2_FEATURE_NAMES)
    assert ds["X"].shape[1] == ME_V2_FEATURE_DIM


def test_v2_known_values():
    """Spot-check the derived terms against hand-computed values."""
    s = parse_matmul((CORPUS / "me_matmul_00000_bef03e2f" / "model.mlir").read_text())
    v = dict(zip(ME_V2_FEATURE_NAMES, feature_vector_me_v2(s)))
    assert v["M"] == 2432 and v["N"] == 512 and v["K"] == 1792
    # f8E5M2 runs on the 128x128 array.
    assert v["array_dim"] == 128
    assert v["tiles_m"] == 2432 / 128 and v["tiles_n"] == 512 / 128
    assert v["out_tiles"] == (2432 / 128) * (512 / 128)
    assert v["narrow_acc"] == 0.0          # f8E5M2 -> f32 widens
    assert v["dt_f8E5M2"] == 1.0
    assert v["log2_MNK"] == pytest.approx(math.log2(2432 * 512 * 1792))


def test_v1_still_importable():
    """v2 is additive; existing importers of the v1 names must keep working."""
    s = parse_matmul((CORPUS / "me_matmul_00000_bef03e2f" / "model.mlir").read_text())
    assert len(feature_vector_me(s)) == ME_FEATURE_DIM == FEATURE_DIM == 18


def test_corpus_is_fully_aligned():
    """Every corpus dim is a multiple of its mode's systolic edge.

    This is why v2 drops v1's two padding-waste features: with no ragged shape
    anywhere in the corpus they are identically zero and carry no signal.
    """
    unaligned = 0
    for d in sorted(CORPUS.glob("me_matmul_*")):
        s = parse_matmul((d / "model.mlir").read_text())
        dim = align_dim(s.dtype)
        if s.M % dim or s.N % dim or s.K % dim:
            unaligned += 1
    assert unaligned == 0


def test_v1_padding_features_are_dead():
    """The two v1 pad slots are zero on every sample.

    Layout of `feature_vector_me`: M,N,K (0-2), logs (3-5), log MNK (6),
    dtype one-hot (7-12), tiles_m/tiles_n (13-14), pad_rows (15), pad_cols (16),
    acc_is_f32 (17).
    """
    pad_rows, pad_cols = 15, 16
    for d in sorted(CORPUS.glob("me_matmul_*")):
        v = feature_vector_me(parse_matmul((d / "model.mlir").read_text()))
        assert v[pad_rows] == 0.0 and v[pad_cols] == 0.0


# ----- baselines -------------------------------------------------------------

def _as_model_input(ds: dict) -> dict:
    mode = ds["mode"].astype(str)
    return {"X": ds["X"], "y": ds["y"], "M": ds["M"], "N": ds["N"], "K": ds["K"],
            "mnk": ds["mnk"], "mode": mode,
            "benchmark": ds["benchmark"].astype(str),
            "dtype": np.array([m.split("->")[0] for m in mode])}


def test_powerlaw_reproduces_baseline(ds):
    """End-to-end check: if the join or target transform broke, this moves.

    ~15.7% MAPE / 0.967 log-R2 under random 5-fold is the documented baseline.
    """
    from maclocal.models.baselines.roofline_me import PowerLawME
    from maclocal.training.train_me import random_folds, subset

    d = _as_model_input(ds)
    pred = np.zeros(len(d["y"]))
    for test_idx in random_folds(len(d["y"]), 5, 0):
        train_idx = np.setdiff1d(np.arange(len(d["y"])), test_idx)
        pred[test_idx] = PowerLawME().fit(subset(d, train_idx)).predict(
            subset(d, test_idx))
    m = summary(d["y"], pred)
    assert m["MAPE_%"] == pytest.approx(15.7, abs=1.5)
    assert m["log_R2"] == pytest.approx(0.967, abs=0.02)


def test_powerlaw_exponents_are_physical(ds):
    """M,N near-linear; K strongly sublinear.

    A K exponent near 1.0 would mean the per-mode grouping was lost and the fit
    collapsed back onto the (wrong) roofline assumption.
    """
    from maclocal.models.baselines.roofline_me import PowerLawME

    exps = PowerLawME().fit(_as_model_input(ds)).exponents()
    assert set(exps) == {"f16->f16", "f16->f32", "f8E5M2->f32"}
    for mode, e in exps.items():
        assert 0.75 <= e["M"] <= 0.95, f"{mode} M exponent {e['M']}"
        assert 0.75 <= e["N"] <= 0.95, f"{mode} N exponent {e['N']}"
        assert 0.15 <= e["K"] <= 0.45, f"{mode} K exponent {e['K']}"


def test_roofline_is_beaten_by_powerlaw(ds):
    """The K^1 roofline must lose to the fitted exponent -- that is the finding."""
    from maclocal.models.baselines.roofline_me import PowerLawME, RooflineME

    d = _as_model_input(ds)
    pl = summary(d["y"], PowerLawME().fit(d).predict(d))
    rf = summary(d["y"], RooflineME().fit(d).predict(d))
    assert pl["MAPE_%"] < rf["MAPE_%"] / 2


# ----- metrics ---------------------------------------------------------------

def test_within_pct():
    y = np.array([100.0, 100.0, 100.0, 100.0])
    p = np.array([105.0, 109.0, 115.0, 200.0])
    assert within_pct(y, p, 0.10) == 50.0
    assert within_pct(y, p, 0.20) == 75.0
