"""Extra regression metrics -- an additive extension of `eval/metrics.py`.

Kept here rather than edited into the shared module so `maclocal/` stays a
purely additive subtree with no upstream modifications to conflict on.

The shared `eval.metrics` already provides `mape`, `r2`, `worst_rel_err` and
`spearman`; those are imported and reused rather than reimplemented. This module
adds two metrics and a wider `summary()` that supersedes the shared one:

* `within_pct` -- the hit-rate metric. For design-space exploration this matters
  more than mean error: a sweep is usable when most points land close, even if a
  few are badly off.
* `log_r2` -- R^2 on log(ticks). The ME targets span ~157x, so linear-space R^2
  is dominated by the largest shapes and reads high even for a poor model;
  log-space R^2 weights every sample by relative error instead. It is also the
  metric that exposes genuinely bad extrapolation, where it goes negative
  (= worse than predicting a constant).

To fold upstream, move `within_pct`/`log_r2` into `eval/metrics.py` and replace
its `summary()` with the one below.
"""

from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from eval.metrics import mape, r2, spearman, worst_rel_err  # noqa: E402


def within_pct(y_true: np.ndarray, y_pred: np.ndarray, tol: float) -> float:
    """Percentage of predictions within `tol` relative error (tol=0.10 -> +-10%)."""
    rel = np.abs((y_pred - y_true) / np.maximum(y_true, 1e-6))
    return float(np.mean(rel < tol) * 100.0)


def log_r2(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    """R^2 computed on log(ticks) rather than raw ticks."""
    return r2(np.log(np.maximum(y_true, 1e-12)), np.log(np.maximum(y_pred, 1e-12)))


def summary(y_true: np.ndarray, y_pred: np.ndarray) -> dict[str, float]:
    """Wider than `eval.metrics.summary` -- adds median, hit-rates and log-R^2."""
    return {
        "MAPE_%": round(mape(y_true, y_pred), 3),
        "median_rel_%": round(float(np.median(
            np.abs((y_pred - y_true) / np.maximum(y_true, 1e-6))) * 100.0), 3),
        "within_10%": round(within_pct(y_true, y_pred, 0.10), 1),
        "within_20%": round(within_pct(y_true, y_pred, 0.20), 1),
        "log_R2": round(log_r2(y_true, y_pred), 4),
        "R2": round(r2(y_true, y_pred), 4),
        "worst_rel_%": round(worst_rel_err(y_true, y_pred), 2),
        "spearman": round(spearman(y_true, y_pred), 4),
    }
