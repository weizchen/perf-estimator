"""Figures and a markdown summary for the ME regression results.

Run after `training/train_me.py`, which writes the predictions this reads.

Four figures, each answering one question:

  me_pred_vs_actual.png   Does the model track the label across the 157x range?
                          Log-log with a y=x reference and +-10% band.
  me_residual_vs_size.png Where does error live? Residual against MNK and K --
                          this is where the roofline's bad K exponent shows up
                          as visible tilt, and where extrapolation failure
                          appears as a fan at the right edge.
  me_model_comparison.png Both split regimes side by side. The gap between them
                          is the headline: trees look fine under random CV and
                          fall apart under extrapolation.
  me_feature_importance.png  What the tree ensemble actually keys on.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

REPO = Path(__file__).resolve().parents[2]          # perf-estimator/
LOCAL = REPO / "maclocal"                            # this workstream's own tree
DEFAULT_RESULTS = LOCAL / "results" / "me"

# Baselines are drawn in grey so the learned models stand out.
_BASELINE = {"geomean", "roofline", "powerlaw"}


def _load(results: Path) -> tuple[dict, dict]:
    z = np.load(results / "me_predictions.npz", allow_pickle=False)
    metrics = json.loads((results / "me_metrics.json").read_text())
    return z, metrics


def _models(z, prefix: str) -> list[str]:
    return sorted(k[len(prefix):] for k in z.files if k.startswith(prefix))


def plot_pred_vs_actual(z, metrics: dict, out: Path, top_n: int = 4) -> None:
    order = sorted(metrics["cv"]["metrics"],
                   key=lambda n: metrics["cv"]["metrics"][n]["MAPE_%"])[:top_n]
    y = z["y"]
    fig, axes = plt.subplots(1, len(order), figsize=(4.2 * len(order), 4.3),
                             sharex=True, sharey=True)
    lim = (y.min() * 0.7, y.max() * 1.4)
    for ax, name in zip(np.atleast_1d(axes), order):
        p = z[f"oof_{name}"]
        ax.plot(lim, lim, "k-", lw=1, zorder=3)
        ax.fill_between(lim, [v * 0.9 for v in lim], [v * 1.1 for v in lim],
                        color="k", alpha=0.10, zorder=0, label="+-10%")
        ax.scatter(y, p, s=9, alpha=0.5, edgecolors="none")
        ax.set(xscale="log", yscale="log", xlim=lim, ylim=lim,
               xlabel="measured ticks (gem5)")
        ax.set_title(f"{name}\nMAPE {metrics['cv']['metrics'][name]['MAPE_%']:.2f}%  "
                     f"within10 {metrics['cv']['metrics'][name]['within_10%']:.0f}%",
                     fontsize=10)
        ax.grid(alpha=0.25, which="both", lw=0.4)
    np.atleast_1d(axes)[0].set_ylabel("predicted ticks")
    np.atleast_1d(axes)[0].legend(loc="upper left", fontsize=8)
    fig.suptitle("ME: predicted vs measured, out-of-fold (random 5-fold CV)", y=1.0)
    fig.tight_layout()
    fig.savefig(out / "me_pred_vs_actual.png", dpi=150, bbox_inches="tight")
    plt.close(fig)


def plot_residual_vs_size(z, metrics: dict, out: Path) -> None:
    best = min(metrics["cv"]["metrics"],
               key=lambda n: metrics["cv"]["metrics"][n]["MAPE_%"])
    fig, axes = plt.subplots(1, 2, figsize=(11, 4.2))
    for ax, key, label in ((axes[0], "mnk", "M*N*K"), (axes[1], "K", "K")):
        for name, color in ((best, "tab:blue"), ("powerlaw", "tab:orange"),
                            ("roofline", "tab:grey")):
            if f"oof_{name}" not in z.files:
                continue
            rel = (z[f"oof_{name}"] - z["y"]) / z["y"] * 100
            ax.scatter(z[key], rel, s=8, alpha=0.45, edgecolors="none",
                       color=color, label=name)
        ax.axhline(0, color="k", lw=1)
        ax.set(xscale="log", xlabel=label, ylabel="relative error (%)")
        ax.set_ylim(-80, 80)
        ax.grid(alpha=0.25, which="both", lw=0.4)
        ax.legend(fontsize=8)
    axes[0].set_title("residual vs problem size")
    axes[1].set_title("residual vs K (roofline assumes K^1; measured ~K^0.3)")
    fig.tight_layout()
    fig.savefig(out / "me_residual_vs_size.png", dpi=150, bbox_inches="tight")
    plt.close(fig)


def plot_model_comparison(metrics: dict, out: Path) -> None:
    cv, ex = metrics["cv"]["metrics"], metrics["extrapolation"]["metrics"]
    sd = metrics["cv"]["mape_std"]
    names = sorted(cv, key=lambda n: cv[n]["MAPE_%"])
    x = np.arange(len(names))
    fig, ax = plt.subplots(figsize=(max(8, 1.1 * len(names)), 4.6))
    c1 = ["silver" if n in _BASELINE else "tab:blue" for n in names]
    c2 = ["darkgrey" if n in _BASELINE else "tab:red" for n in names]
    ax.bar(x - 0.2, [cv[n]["MAPE_%"] for n in names], 0.4, color=c1,
           yerr=[sd.get(n, 0) for n in names], capsize=3,
           label="random 5-fold CV (interpolation)")
    ax.bar(x + 0.2, [ex[n]["MAPE_%"] for n in names], 0.4, color=c2,
           label="MNK extrapolation (train small -> test large)")
    ax.set_xticks(x)
    ax.set_xticklabels(names, rotation=25, ha="right")
    ax.set_ylabel("MAPE (%)  -- lower is better")
    ax.set_title("ME cycle prediction: interpolation vs extrapolation\n"
                 "(grey = analytical baselines; error bars = sd across folds)")
    ax.grid(axis="y", alpha=0.3)
    ax.legend()
    # The largest bars are baselines and squash everything else.
    ax.set_ylim(0, min(80, max(ex[n]["MAPE_%"] for n in names) * 1.15))
    fig.tight_layout()
    fig.savefig(out / "me_model_comparison.png", dpi=150, bbox_inches="tight")
    plt.close(fig)


def plot_feature_importance(z, out: Path) -> None:
    """Refit the booster on all data purely to read its feature importances."""
    from maclocal.models.me_classical import hist_gbm
    from sklearn.inspection import permutation_importance

    names = z["feature_names"].astype(str)
    d = {"X": z["X"] if "X" in z.files else None, "y": z["y"]}
    if d["X"] is None:      # predictions file does not carry X; reload dataset
        ds = np.load(LOCAL / "processed" / "me_dataset.npz", allow_pickle=False)
        d = {"X": ds["X"], "y": ds["y"]}

    model = hist_gbm().fit(d)
    # HistGradientBoosting exposes no feature_importances_, so use permutation
    # importance on the log target -- the same space the model was fit in.
    r = permutation_importance(model.model, d["X"], np.log(d["y"]),
                               n_repeats=10, random_state=0, n_jobs=-1)
    order = np.argsort(r.importances_mean)[::-1][:15]

    fig, ax = plt.subplots(figsize=(7.5, 5))
    ax.barh(range(len(order)), r.importances_mean[order][::-1],
            xerr=r.importances_std[order][::-1], color="tab:blue", capsize=2)
    ax.set_yticks(range(len(order)))
    ax.set_yticklabels(names[order][::-1], fontsize=9)
    ax.set_xlabel("permutation importance (increase in log-space error)")
    ax.set_title("ME features by permutation importance (hist_gbm)")
    ax.grid(axis="x", alpha=0.3)
    fig.tight_layout()
    fig.savefig(out / "me_feature_importance.png", dpi=150, bbox_inches="tight")
    plt.close(fig)


def write_summary(metrics: dict, out: Path) -> None:
    cv, ex = metrics["cv"]["metrics"], metrics["extrapolation"]["metrics"]
    sd = metrics["cv"]["mape_std"]
    names = sorted(cv, key=lambda n: cv[n]["MAPE_%"])
    best_cv = names[0]
    best_ex = min(ex, key=lambda n: ex[n]["MAPE_%"])

    lines = [
        "# ME cycle prediction -- results",
        "",
        f"{metrics['n_samples']} labelled `linalg.matmul` benchmarks on the Matrix "
        f"Engine, {metrics['n_features']} features, target `sim_ticks`.",
        "",
        "## Accuracy",
        "",
        "| model | CV MAPE | CV sd | CV within 10% | extrap MAPE | extrap within 10% | extrap log-R2 |",
        "|---|---|---|---|---|---|---|",
    ]
    for n in names:
        lines.append(
            f"| {'*' if n in _BASELINE else ''}{n}{'*' if n in _BASELINE else ''} "
            f"| {cv[n]['MAPE_%']:.2f}% | {sd.get(n, 0):.2f} "
            f"| {cv[n]['within_10%']:.0f}% | {ex[n]['MAPE_%']:.2f}% "
            f"| {ex[n]['within_10%']:.0f}% | {ex[n]['log_R2']:.3f} |")

    lines += [
        "",
        "*Italic = analytical baseline, not a learned model.*",
        "",
        f"- Best under random CV: **{best_cv}** ({cv[best_cv]['MAPE_%']:.2f}% MAPE).",
        f"- Best under extrapolation: **{best_ex}** ({ex[best_ex]['MAPE_%']:.2f}% MAPE).",
        f"- The `powerlaw` baseline is 4 fitted parameters per dtype mode and "
        f"reaches {cv['powerlaw']['MAPE_%']:.2f}% / {ex['powerlaw']['MAPE_%']:.2f}%. "
        "Any learned model has to be read against that, not against the roofline.",
        "",
        "## Fitted scaling exponents",
        "",
        "`ticks = c * M^a * N^b * K^d`, fit per mode:",
        "",
        "| mode | M | N | K |",
        "|---|---|---|---|",
    ]
    for mode, e in sorted(metrics["powerlaw_exponents"].items()):
        lines.append(f"| {mode} | {e['M']:.3f} | {e['N']:.3f} | {e['K']:.3f} |")

    lines += [
        "",
        "Cost is near-linear in the output dims but strongly sublinear in K, so "
        "the textbook output-stationary roofline (`tiles_m * tiles_n * K`, i.e. "
        "K^1) mismodels this corpus -- per-output-tile fixed cost dominates over "
        "K-streaming at these shapes.",
        "",
        "## Caveats",
        "",
        f"- **Censoring.** gem5 fails on 22% of ME configs, and the failure rate "
        "rises from ~1% in the smallest MNK quartile to 73% in the largest. The "
        "extrapolation test set is therefore a survivor-biased sample of exactly "
        "the regime it is meant to probe. See `dataset/processed/me_failures.csv`.",
        f"- **Scope.** `linalg.matmul` on ME only, at dims already aligned to the "
        "systolic edge (128 for FP8, 64 for FP16). Unaligned shapes and `conv_2d` "
        "do not appear in this corpus, so nothing here speaks to them.",
        f"- **N = {metrics['n_samples']}.** Small. The CV sd column is there to be read.",
    ]
    (out / "me_results.md").write_text("\n".join(lines) + "\n")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", type=Path, default=DEFAULT_RESULTS)
    args = ap.parse_args()

    if not (args.results / "me_predictions.npz").exists():
        raise SystemExit(f"{args.results}/me_predictions.npz not found -- "
                         "run training/train_me.py first")

    z, metrics = _load(args.results)
    plot_pred_vs_actual(z, metrics, args.results)
    plot_residual_vs_size(z, metrics, args.results)
    plot_model_comparison(metrics, args.results)
    plot_feature_importance(z, args.results)
    write_summary(metrics, args.results)
    for f in sorted(args.results.glob("me_*")):
        print(f"  {f.relative_to(REPO)}")


if __name__ == "__main__":
    main()
