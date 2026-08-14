"""Classical regressors for ME cycle prediction.

All of these share one interface with the analytical baselines in
`baselines/roofline_me.py` -- `fit(d)` / `predict(d)` over a dict of arrays --
so `training/train_me.py` can run everything through the same split harness.

Two conventions apply to every model here, and both matter for the numbers:

* **Fit on log(ticks), report in linear space.** The targets span 157x. Fitting
  raw ticks with squared error would let a handful of 6e10 samples set the
  loss and would trade away all small-shape accuracy. Every model predicts
  log ticks and `predict` exponentiates.

* **Standardize inputs.** The v2 feature vector mixes raw dims (up to 4096)
  with logs (order 10) and one-hots. Ridge/SVR/kNN are all scale-sensitive;
  the trees are not, but standardizing them too costs nothing and keeps the
  harness uniform.

Expected outcome at N=612: gradient boosting wins. The power-law baseline
already captures the smooth leading-order trend, so the headroom is in the
tiling staircase and mode-specific kinks -- exactly what a tree ensemble picks
up and what a linear model structurally cannot.
"""

from __future__ import annotations

import numpy as np
from sklearn.ensemble import HistGradientBoostingRegressor, RandomForestRegressor
from sklearn.linear_model import RidgeCV
from sklearn.neighbors import KNeighborsRegressor
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVR


class SklearnME:
    """Adapter: sklearn estimator -> the trainer's dict-in/ticks-out interface."""

    def __init__(self, name: str, estimator, standardize: bool = True) -> None:
        self.name = name
        self.model = (Pipeline([("scale", StandardScaler()), ("est", estimator)])
                      if standardize else estimator)

    def fit(self, d: dict) -> "SklearnME":
        self.model.fit(d["X"], np.log(d["y"]))
        return self

    def predict(self, d: dict) -> np.ndarray:
        return np.exp(self.model.predict(d["X"]))

    def feature_importances(self) -> np.ndarray | None:
        est = self.model[-1] if isinstance(self.model, Pipeline) else self.model
        if hasattr(est, "feature_importances_"):
            return est.feature_importances_
        if hasattr(est, "coef_"):
            return np.abs(est.coef_)
        return None


def ridge() -> SklearnME:
    """Linear in log-features == a generalized power law.

    Its coefficients on log2_M / log2_N / log2_K are directly readable as
    scaling exponents, which is the cross-check that the fit is physical.
    RidgeCV picks alpha by internal CV, so no outer tuning is needed.
    """
    return SklearnME("ridge", RidgeCV(alphas=np.logspace(-3, 3, 25)))


def random_forest(seed: int = 0) -> SklearnME:
    return SklearnME("random_forest", RandomForestRegressor(
        n_estimators=400, min_samples_leaf=2, n_jobs=-1, random_state=seed))


def hist_gbm(seed: int = 0) -> SklearnME:
    """Gradient boosting. Depth and leaf size are held down deliberately:
    at N=612 an unconstrained booster memorizes the shape grid."""
    return SklearnME("hist_gbm", HistGradientBoostingRegressor(
        max_iter=500, learning_rate=0.06, max_depth=6, min_samples_leaf=8,
        l2_regularization=1.0, early_stopping=True, validation_fraction=0.15,
        n_iter_no_change=40, random_state=seed))


def svr() -> SklearnME:
    return SklearnME("svr_rbf", SVR(kernel="rbf", C=30.0, gamma="scale",
                                    epsilon=0.02))


def knn() -> SklearnME:
    """Distance-weighted kNN. Weak on its own, but a useful control: if it wins,
    the corpus is a dense grid and the task is interpolation, not modelling."""
    return SklearnME("knn", KNeighborsRegressor(n_neighbors=5, weights="distance"))


def all_classical(seed: int = 0) -> list[SklearnME]:
    return [ridge(), random_forest(seed), hist_gbm(seed), svr(), knn()]
