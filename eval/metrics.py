"""Evaluation metrics. No scipy — Spearman implemented via rank Pearson."""

from __future__ import annotations

import numpy as np


def mape(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    return float(np.mean(np.abs((y_pred - y_true) / np.maximum(y_true, 1e-6))) * 100.0)


def r2(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    ss_res = np.sum((y_true - y_pred) ** 2)
    ss_tot = np.sum((y_true - np.mean(y_true)) ** 2) + 1e-12
    return float(1.0 - ss_res / ss_tot)


def worst_rel_err(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    return float(np.max(np.abs((y_pred - y_true) / np.maximum(y_true, 1e-6))) * 100.0)


def spearman(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    def ranks(a: np.ndarray) -> np.ndarray:
        order = np.argsort(a)
        r = np.empty_like(order, dtype=float)
        r[order] = np.arange(len(a))
        return r
    rt, rp = ranks(y_true), ranks(y_pred)
    rt -= rt.mean()
    rp -= rp.mean()
    denom = np.sqrt(np.sum(rt ** 2) * np.sum(rp ** 2)) + 1e-12
    return float(np.sum(rt * rp) / denom)


def summary(y_true: np.ndarray, y_pred: np.ndarray) -> dict[str, float]:
    return {
        "MAPE_%": round(mape(y_true, y_pred), 3),
        "R2": round(r2(y_true, y_pred), 4),
        "worst_rel_%": round(worst_rel_err(y_true, y_pred), 2),
        "spearman": round(spearman(y_true, y_pred), 4),
    }
