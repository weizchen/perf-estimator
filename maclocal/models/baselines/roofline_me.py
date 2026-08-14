"""Analytical cost models for the Matrix Engine -- the floor the ML must beat.

Two models, and the gap between them is itself a finding.

`RooflineME` is the textbook output-stationary systolic cost: the array holds a
128x128 (or 64x64) output tile stationary and streams K elements through it, so
cost ~ tiles_m * tiles_n * K. This is the physically-motivated prior and it is
what `PLAN.md` assumed.

`PowerLawME` drops the assumption that cost is linear in K and fits the exponent
instead: ticks = c * M^a * N^b * K^d, one fit per (input, accumulator) mode. On
the labelled corpus the fitted exponents come out at roughly M^0.85, N^0.87 but
**K^0.20..0.35** -- strongly sublinear. Holding M and N fixed and sweeping K
confirms it independently (median exponent 0.29).

So the roofline's K^1 assumption is wrong for this corpus, and that costs it:
it explains ~62% of log-variance where the power law explains ~97%. Physically,
per-output-tile fixed cost (tile setup, operand staging, drain) dominates over
K-streaming at these shapes -- the ME is not K-compute-bound here.

`PowerLawME` is therefore the honest baseline to score the ML models against,
not the roofline. It is a 4-parameter-per-mode model and it already reaches
~15% MAPE, so "we beat a roofline" would be a much weaker claim than it sounds.

Both are fit in log space (least squares on log ticks), which is the natural
space for a product of powers and matches how the models are evaluated.
"""

from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))

from dataset.scripts.policy import align_dim  # noqa: E402


def _design(M: np.ndarray, N: np.ndarray, K: np.ndarray) -> np.ndarray:
    """[log M, log N, log K, 1] -- linear here == power law in linear space."""
    return np.column_stack([
        np.log(M.astype(float)),
        np.log(N.astype(float)),
        np.log(K.astype(float)),
        np.ones(len(M)),
    ])


def _tiles(M: np.ndarray, N: np.ndarray, dtypes: np.ndarray) -> np.ndarray:
    """Output-tile count, using each sample's own systolic edge (128 or 64)."""
    dims = np.array([align_dim(dt) for dt in dtypes], dtype=float)
    return np.ceil(M / dims) * np.ceil(N / dims)


class _LogLinearBase:
    """Least-squares fit in log space, per mode, with a pooled fallback.

    Modes are few (3) and well populated (~200 each), but a fold could still
    leave a mode too thin to fit 4 parameters. Any such mode falls back to the
    pooled fit rather than producing a wild extrapolation.
    """

    MIN_PER_MODE = 8

    def __init__(self) -> None:
        self.coef_: dict[str, np.ndarray] = {}
        self.pooled_: np.ndarray | None = None

    def _features(self, d: dict) -> np.ndarray:
        raise NotImplementedError

    def fit(self, d: dict) -> "_LogLinearBase":
        y = np.log(d["y"])
        X = self._features(d)
        self.pooled_, *_ = np.linalg.lstsq(X, y, rcond=None)
        for mode in np.unique(d["mode"]):
            sel = d["mode"] == mode
            if sel.sum() < self.MIN_PER_MODE:
                continue
            self.coef_[str(mode)], *_ = np.linalg.lstsq(X[sel], y[sel], rcond=None)
        return self

    def predict(self, d: dict) -> np.ndarray:
        X = self._features(d)
        out = np.empty(len(X))
        for i, mode in enumerate(d["mode"]):
            co = self.coef_.get(str(mode), self.pooled_)
            out[i] = X[i] @ co
        return np.exp(out)


class PowerLawME(_LogLinearBase):
    """ticks = c * M^a * N^b * K^d, fit per mode. The real baseline."""

    name = "powerlaw"

    def _features(self, d: dict) -> np.ndarray:
        return _design(d["M"], d["N"], d["K"])

    def exponents(self) -> dict[str, dict[str, float]]:
        """Fitted exponents per mode -- the interpretable output of this model."""
        return {
            mode: {"M": float(c[0]), "N": float(c[1]), "K": float(c[2]),
                   "const": float(np.exp(c[3]))}
            for mode, c in self.coef_.items()
        }


class RooflineME(_LogLinearBase):
    """ticks = c * (tiles_m * tiles_n * K)^a -- the K^1 output-stationary prior.

    A scale factor is still fit (the tick cost of one MAC pass is not known a
    priori), so this is the fairest possible version of the roofline: it is
    handed the right functional form and only has to calibrate it.
    """

    name = "roofline"

    def _features(self, d: dict) -> np.ndarray:
        work = _tiles(d["M"], d["N"], d["dtype"]) * d["K"].astype(float)
        return np.column_stack([np.log(work), np.ones(len(work))])


class MeanPredictorME(_LogLinearBase):
    """Geometric mean of training ticks. The zero-information control.

    Included so the reported R^2 has a meaningful zero: any model that cannot
    beat this has learned nothing at all.
    """

    name = "geomean"

    def _features(self, d: dict) -> np.ndarray:
        return np.ones((len(d["M"]), 1))


BASELINES = [MeanPredictorME, RooflineME, PowerLawME]
