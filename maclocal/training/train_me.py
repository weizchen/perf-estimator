"""Train and evaluate every ME cycle model under both split regimes.

Run `dataset/scripts/build_me_dataset.py` first.

Two splits are reported side by side, and the gap between them is the point:

* **random 5-fold CV** -- interpolation. Every test shape has close neighbours
  in the training set. This is the optimistic number, and it is the one that
  gets quoted if you only run one split.

* **MNK extrapolation** -- train on the smallest 75% of problems by M*N*K, test
  on the largest 25%. This asks whether the model learned ME cost structure or
  just interpolated a sampled grid, and it is the regime that matters for
  design-space exploration, where the interesting configs are the big ones.

Read the extrapolation column with the censoring caveat in mind: gem5 fails on
73% of the largest-quartile configs, so the large-shape test set is a
survivor-biased sample of that regime (see `me_failures.csv`).

Everything is scored in linear tick space after exponentiating, so models that
fit in different spaces stay comparable.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from maclocal.eval.metrics_me import summary  # noqa: E402
from maclocal.models.baselines.roofline_me import BASELINES, PowerLawME  # noqa: E402
from maclocal.models.me_classical import all_classical  # noqa: E402

REPO = Path(__file__).resolve().parents[2]          # perf-estimator/
LOCAL = REPO / "maclocal"                            # this workstream's own tree
DEFAULT_DATA = LOCAL / "processed" / "me_dataset.npz"
DEFAULT_OUT = LOCAL / "results" / "me"

# Column keys carried through every split so models can pick what they need.
_KEYS = ("X", "y", "M", "N", "K", "mnk", "mode", "dtype", "benchmark")


def load_dataset(path: Path) -> dict:
    z = np.load(path, allow_pickle=False)
    mode = z["mode"].astype(str)
    return {
        "X": z["X"], "y": z["y"],
        "M": z["M"], "N": z["N"], "K": z["K"], "mnk": z["mnk"],
        "mode": mode,
        # `dtype` is the input element type, i.e. the mode before the arrow.
        "dtype": np.array([m.split("->")[0] for m in mode]),
        "benchmark": z["benchmark"].astype(str),
        "feature_names": z["feature_names"].astype(str),
    }


def subset(d: dict, idx: np.ndarray) -> dict:
    return {k: d[k][idx] for k in _KEYS}


def random_folds(n: int, k: int, seed: int) -> list[np.ndarray]:
    idx = np.random.RandomState(seed).permutation(n)
    return [idx[f::k] for f in range(k)]


def extrapolation_split(d: dict, train_frac: float = 0.75) -> tuple[np.ndarray, np.ndarray]:
    """Smallest `train_frac` of problems by MNK for training, largest for test."""
    return band_split(d, "mnk", train_frac)


def band_split(d: dict, key: str, train_frac: float = 0.75) -> tuple[np.ndarray, np.ndarray]:
    """Train on the smallest `train_frac` by `key`, test on the largest.

    `key="mnk"` is the headline split, but it is a weaker test than it looks:
    the corpus samples M, N and K independently, so holding out the largest
    products still leaves ~100% of test M and N values inside the training
    range -- only the *combination* is new. Holding out a single dimension
    ("K") is the stricter test, and the one that matters most here, since K is
    where the cost model is least constrained (exponent 0.28, and the roofline's
    K^1 assumption fails exactly there).
    """
    order = np.argsort(d[key])
    cut = int(len(order) * train_frac)
    return order[:cut], order[cut:]


# The held-out regimes reported alongside random CV. "mnk" is the headline.
EXTRAP_SPLITS = ("mnk", "K", "M", "N")


def _new_models(seed: int, with_mlp: bool, mlp_epochs: int) -> list:
    models = [cls() for cls in BASELINES] + all_classical(seed)
    if with_mlp:
        from maclocal.models.me_mlp import MLPME, ResidualMLPME
        models.append(MLPME(seed=seed, epochs=mlp_epochs))
        models.append(ResidualMLPME(seed=seed, epochs=mlp_epochs))
    return models


def run_cv(d: dict, k: int, seed: int, with_mlp: bool, mlp_epochs: int) -> dict:
    """k-fold CV. Returns per-model out-of-fold predictions and per-fold metrics."""
    folds = random_folds(len(d["y"]), k, seed)
    oof: dict[str, np.ndarray] = {}
    per_fold: dict[str, list[dict]] = {}

    for f, test_idx in enumerate(folds):
        train_idx = np.setdiff1d(np.arange(len(d["y"])), test_idx)
        tr, te = subset(d, train_idx), subset(d, test_idx)
        for model in _new_models(seed + f, with_mlp, mlp_epochs):
            pred = model.fit(tr).predict(te)
            oof.setdefault(model.name, np.zeros(len(d["y"])))[test_idx] = pred
            per_fold.setdefault(model.name, []).append(summary(te["y"], pred))
        print(f"  fold {f + 1}/{k} done", flush=True)

    return {
        "oof": oof,
        "per_fold": per_fold,
        "metrics": {name: summary(d["y"], p) for name, p in oof.items()},
        # Spread across folds -- a point estimate at N=612 is not trustworthy.
        "mape_std": {name: float(np.std([m["MAPE_%"] for m in folds_]))
                     for name, folds_ in per_fold.items()},
    }


def run_extrapolation(d: dict, seed: int, with_mlp: bool, mlp_epochs: int,
                      key: str = "mnk", n_seeds: int = 3) -> dict:
    """Held-out band evaluation, averaged over `n_seeds` independent fits.

    Unlike CV -- where averaging over folds already smooths the estimate -- a
    band split is a single train/test partition, so a single fit reports one
    draw of the seed noise. That noise is not small for the stochastic models:
    the plain MLP varies by +-4.6pp across seeds on the M band. Averaging is
    therefore required for the number to mean anything. Deterministic models
    (the baselines, ridge, kNN) simply report sd 0.
    """
    train_idx, test_idx = band_split(d, key)
    tr, te = subset(d, train_idx), subset(d, test_idx)
    per_seed: dict[str, list[dict]] = {}
    preds: dict[str, np.ndarray] = {}
    for s in range(n_seeds):
        for model in _new_models(seed + 10 * s, with_mlp, mlp_epochs):
            pred = model.fit(tr).predict(te)
            per_seed.setdefault(model.name, []).append(summary(te["y"], pred))
            if s == 0:
                preds[model.name] = pred        # first seed's curve, for plots
    metrics = {n: {k: round(float(np.mean([m[k] for m in runs])), 3) for k in runs[0]}
               for n, runs in per_seed.items()}
    return {
        "key": key, "preds": preds, "metrics": metrics, "n_seeds": n_seeds,
        "mape_std": {n: float(np.std([m["MAPE_%"] for m in runs]))
                     for n, runs in per_seed.items()},
        "train_idx": train_idx, "test_idx": test_idx,
        "n_train": len(train_idx), "n_test": len(test_idx),
        "mnk_boundary": float(d[key][train_idx].max()),
    }


def _table(metrics: dict[str, dict], order: list[str],
           extra: dict[str, float] | None = None) -> str:
    cols = ["MAPE_%", "median_rel_%", "within_10%", "within_20%", "log_R2",
            "worst_rel_%", "spearman"]
    head = f"  {'model':<16}" + "".join(f"{c:>14}" for c in cols)
    if extra is not None:
        head += f"{'MAPE sd':>10}"
    lines = [head, "  " + "-" * (len(head) - 2)]
    for name in order:
        if name not in metrics:
            continue
        row = f"  {name:<16}" + "".join(f"{metrics[name][c]:>14.3f}" for c in cols)
        if extra is not None:
            row += f"{extra.get(name, float('nan')):>10.2f}"
        lines.append(row)
    return "\n".join(lines)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--data", type=Path, default=DEFAULT_DATA)
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT)
    ap.add_argument("--folds", type=int, default=5)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--epochs", type=int, default=200,
                    help="MLP training budget (also the cosine schedule's T_max)")
    ap.add_argument("--no-mlp", action="store_true", help="skip the deep model")
    args = ap.parse_args()

    if not args.data.exists():
        raise SystemExit(f"{args.data} not found -- run dataset/scripts/build_me_dataset.py first")

    d = load_dataset(args.data)
    with_mlp = not args.no_mlp
    print(f"ME dataset: {len(d['y'])} samples x {d['X'].shape[1]} features\n")

    print(f"[1/2] random {args.folds}-fold CV (interpolation)")
    cv = run_cv(d, args.folds, args.seed, with_mlp, args.epochs)

    print(f"\n[2/2] held-out band splits (train small -> test large)")
    ex_all = {}
    for key in EXTRAP_SPLITS:
        ex_all[key] = run_extrapolation(d, args.seed, with_mlp, args.epochs, key)
        print(f"  {key} done", flush=True)
    ex = ex_all["mnk"]

    order = sorted(cv["metrics"], key=lambda n: cv["metrics"][n]["MAPE_%"])

    print("\n" + "=" * 108)
    print(f"RANDOM {args.folds}-FOLD CV  (out-of-fold, n={len(d['y'])})")
    print("=" * 108)
    print(_table(cv["metrics"], order, cv["mape_std"]))

    print("\n" + "=" * 108)
    print(f"MNK EXTRAPOLATION  (train {ex['n_train']} smallest -> test "
          f"{ex['n_test']} largest, MNK > {ex['mnk_boundary']:.3e}; "
          f"mean of {ex['n_seeds']} seeds)")
    print("=" * 108)
    print(_table(ex["metrics"], order, ex["mape_std"]))

    # The MNK split leaves ~100% of test M and N inside the training range, so
    # the single-dimension bands are the stricter tests. MAPE only, side by side.
    print("\n" + "=" * 108)
    print("ALL HELD-OUT BANDS  (MAPE %, train smallest 75% by each key)")
    print("=" * 108)
    hdr = f"  {'model':<17}" + "".join(f"{'hold ' + k:>16}" for k in EXTRAP_SPLITS)
    print(hdr + "\n  " + "-" * (len(hdr) - 2))
    for name in order:
        print(f"  {name:<17}" + "".join(
            f"{ex_all[k]['metrics'][name]['MAPE_%']:>10.2f}"
            f" ±{ex_all[k]['mape_std'][name]:<5.2f}" for k in EXTRAP_SPLITS))

    # The fitted exponents are the physical cross-check: M,N ~0.85, K ~0.3.
    pl = PowerLawME().fit(d)
    print("\nfitted power-law exponents (ticks = c * M^a * N^b * K^d):")
    for mode, e in sorted(pl.exponents().items()):
        print(f"  {mode:<14} M^{e['M']:.3f}  N^{e['N']:.3f}  K^{e['K']:.3f}")

    args.out.mkdir(parents=True, exist_ok=True)
    np.savez(args.out / "me_predictions.npz",
             y=d["y"], mnk=d["mnk"], mode=d["mode"], M=d["M"], N=d["N"], K=d["K"],
             feature_names=d["feature_names"],
             **{f"oof_{k}": v for k, v in cv["oof"].items()},
             **{f"ext_{k}": v for k, v in ex["preds"].items()},
             ext_test_idx=ex["test_idx"], ext_train_idx=ex["train_idx"])
    (args.out / "me_metrics.json").write_text(json.dumps({
        "n_samples": int(len(d["y"])),
        "n_features": int(d["X"].shape[1]),
        "cv": {"folds": args.folds, "metrics": cv["metrics"],
               "mape_std": cv["mape_std"], "per_fold": cv["per_fold"]},
        "extrapolation": {"metrics": ex["metrics"], "n_train": ex["n_train"],
                          "n_test": ex["n_test"],
                          "mnk_boundary": ex["mnk_boundary"]},
        "held_out_bands": {k: {"metrics": v["metrics"], "n_test": v["n_test"],
                               "boundary": v["mnk_boundary"],
                               "mape_std": v["mape_std"], "n_seeds": v["n_seeds"]}
                           for k, v in ex_all.items()},
        "powerlaw_exponents": pl.exponents(),
    }, indent=2))
    print(f"\nwrote {args.out}/me_metrics.json and me_predictions.npz")


if __name__ == "__main__":
    main()
