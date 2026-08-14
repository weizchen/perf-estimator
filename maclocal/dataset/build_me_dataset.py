"""Join the ME corpus to its Fujitsu gem5 labels and emit a trainable dataset.

`PLAN.md` was written before labels existed ("the pipeline is built to accept
them when they arrive"). They have arrived, as `results-<date>.csv`. This script
is the join: for every ME row in that CSV it reads the matching
`<corpus>/<benchmark>/model.mlir`, parses the matmul shape with the existing
`features.parse_matmul`, and pairs it with the measured `sim_ticks`.

Outputs (into `dataset/processed/`):
    me_dataset.npz    X (v2 features), y (ticks), plus shape/mode columns
    me_dataset.csv    same, human-readable, for eyeballing and error analysis
    me_failures.csv   the rows gem5 could not label -- not training data, but
                      they document the censoring described below

Two data-quality rules are enforced here rather than left to the trainer:

1. `sim_ticks == 2**64` is a counter wraparound, not a measurement. Exactly one
   ME row hits it (`me_matmul_00325`, host_seconds=39 against ~1000+ for
   genuinely long runs, i.e. it exited immediately). Dropped.

2. `sim_seconds` is `sim_ticks * 1e-12` exactly on every row -- a unit
   conversion, not an independent signal. It never enters the feature matrix.
   `_assert_no_leakage` makes that failure loud rather than silent.

Censoring caveat: gem5 fails on 22% of ME configs, and the failures are heavily
size-biased (0% in the smallest MNK quartile, 73% in the largest). The labelled
set is therefore a survivor-biased sample of the large-shape regime. Anything
trained on it inherits that bias; `me_failures.csv` exists so the write-up can
quantify it instead of ignoring it.
"""

from __future__ import annotations

import argparse
import csv
import math
import re
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from dataset.scripts.features import feature_vector_me, parse_matmul  # noqa: E402
from maclocal.dataset.features_me import (  # noqa: E402
    ME_V2_FEATURE_NAMES, feature_vector_me_v2,
)

REPO = Path(__file__).resolve().parents[2]
DEFAULT_CORPUS = REPO / "dataset" / "fujitsu_dataset_July24" / "me_ready"
DEFAULT_OUT = REPO / "maclocal" / "processed"

# gem5 reports picosecond ticks: sim_seconds == sim_ticks * TICKS_TO_SECONDS.
TICKS_TO_SECONDS = 1e-12

# 2**64. Any tick count at or above this is an unsigned wraparound.
TICK_OVERFLOW = 2 ** 64


class MERow(dict):
    """One joined sample. A dict so csv.DictWriter can take it directly."""


_RESULTS_DATE = re.compile(r"results-(\d+)-(\d+)-(\d+)\.csv$")


def _results_date(path: Path) -> tuple[int, int, int]:
    """(year, month, day) parsed from a `results-M-D-YYYY.csv` filename."""
    m = _RESULTS_DATE.search(path.name)
    if not m:
        return (0, 0, 0)
    month, day, year = (int(g) for g in m.groups())
    return (year, month, day)


def _find_results_csv(explicit: Path | None) -> Path:
    if explicit is not None:
        return explicit
    # The labels live either beside the repo (ME_REGRESS/) or in dataset/results/.
    candidates = sorted(REPO.parent.glob("results-*.csv")) + \
        sorted((REPO / "dataset" / "results").glob("results-*.csv"))
    if not candidates:
        raise SystemExit("no results-*.csv found; pass --results explicitly")
    # Select by the date *in the filename*, not mtime: the older CSV is checked
    # into git, so a fresh clone gives it the newer mtime and mtime would pick
    # the stale label set.
    dated = [p for p in candidates if _results_date(p) != (0, 0, 0)]
    if not dated:
        raise SystemExit(
            "no results-M-D-YYYY.csv matched; pass --results explicitly")
    return max(dated, key=_results_date)


def load_me_rows(results_csv: Path, corpus: Path) -> tuple[list[MERow], list[dict]]:
    """Return (labelled samples, unlabelled/failed rows) for the ME engine."""
    labelled: list[MERow] = []
    failures: list[dict] = []

    with results_csv.open() as fh:
        for row in csv.DictReader(fh):
            if row["proc"] != "ME":
                continue

            mlir_path = corpus / Path(row["benchmark"]).name / "model.mlir"
            if not mlir_path.exists():
                raise SystemExit(f"corpus file missing for {row['benchmark']}: {mlir_path}")

            shape = parse_matmul(mlir_path.read_text())
            if shape is None:
                raise SystemExit(f"parse_matmul failed on {mlir_path}")

            base = {
                "benchmark": Path(row["benchmark"]).name,
                "M": shape.M, "K": shape.K, "N": shape.N,
                "dtype": shape.dtype, "acc": shape.acc,
                "mode": f"{shape.dtype}->{shape.acc}",
                "mnk": shape.M * shape.N * shape.K,
            }

            if row["run"] != "PASS":
                failures.append({**base, "run": row["run"], "note": row["note"],
                                 "host_seconds": row["host_seconds"]})
                continue

            ticks = float(row["sim_ticks"])
            if ticks >= TICK_OVERFLOW:
                failures.append({**base, "run": "OVERFLOW",
                                 "note": f"sim_ticks={row['sim_ticks']} >= 2**64 "
                                         f"(counter wraparound, not a measurement)",
                                 "host_seconds": row["host_seconds"]})
                continue

            # Cross-check the tick/second relationship; if it ever breaks, the
            # CSV semantics changed and the target needs re-deriving. abs_tol
            # carries the load here: sim_seconds is written to 6 decimals, so
            # sub-millisecond runs carry ~1e-4 relative rounding error.
            secs = float(row["sim_seconds"])
            if not math.isclose(secs, ticks * TICKS_TO_SECONDS,
                                rel_tol=1e-3, abs_tol=1e-6):
                raise SystemExit(
                    f"{base['benchmark']}: sim_seconds={secs} is not "
                    f"sim_ticks*{TICKS_TO_SECONDS} ({ticks * TICKS_TO_SECONDS}); "
                    "the CSV's tick units changed")

            labelled.append(MERow({
                **base,
                "ticks": ticks,
                "log_ticks": math.log(ticks),
                "host_seconds": float(row["host_seconds"]),
                "features_v1": feature_vector_me(shape),
                "features_v2": feature_vector_me_v2(shape),
            }))

    return labelled, failures


def _assert_no_leakage(rows: list[MERow]) -> None:
    """Fail loudly if the target leaked into the feature matrix.

    `sim_seconds` is `ticks * 1e-12`, so a feature proportional to the label
    would give a near-perfect model that means nothing. Check that no feature
    column is a fixed multiple of the target.
    """
    X = np.array([r["features_v2"] for r in rows], dtype=float)
    y = np.array([r["ticks"] for r in rows], dtype=float)
    for j in range(X.shape[1]):
        col = X[:, j]
        if np.allclose(col, 0):
            continue
        # Scale-free: a leaked feature has col/y constant, so the ratio's
        # relative spread collapses to zero. Comparing the ratios directly with
        # np.allclose would not work -- they are ~1e-9 here, far below its
        # default atol, so every feature would look constant.
        ratio = col / y
        mean = np.abs(ratio.mean())
        if mean > 0 and ratio.std() / mean < 1e-6:
            raise SystemExit(
                f"feature '{ME_V2_FEATURE_NAMES[j]}' is a constant multiple of "
                "the target -- label leaked into the features")


def _assert_dataset_sane(rows: list[MERow]) -> None:
    configs = {(r["M"], r["K"], r["N"], r["dtype"], r["acc"]) for r in rows}
    if len(configs) != len(rows):
        raise SystemExit(
            f"{len(rows) - len(configs)} duplicate (M,K,N,dtype,acc) configs; "
            "a random CV split would leak between train and test")
    if any(r["ticks"] <= 0 for r in rows):
        raise SystemExit("non-positive sim_ticks survived filtering")
    _assert_no_leakage(rows)


def write_outputs(rows: list[MERow], failures: list[dict], out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)

    X = np.array([r["features_v2"] for r in rows], dtype=np.float64)
    X_v1 = np.array([r["features_v1"] for r in rows], dtype=np.float64)
    np.savez(
        out_dir / "me_dataset.npz",
        X=X,
        X_v1=X_v1,
        feature_names=np.array(ME_V2_FEATURE_NAMES),
        y=np.array([r["ticks"] for r in rows], dtype=np.float64),
        log_y=np.array([r["log_ticks"] for r in rows], dtype=np.float64),
        M=np.array([r["M"] for r in rows]),
        K=np.array([r["K"] for r in rows]),
        N=np.array([r["N"] for r in rows]),
        mnk=np.array([r["mnk"] for r in rows], dtype=np.float64),
        mode=np.array([r["mode"] for r in rows]),
        benchmark=np.array([r["benchmark"] for r in rows]),
    )

    cols = ["benchmark", "mode", "dtype", "acc", "M", "K", "N", "mnk",
            "ticks", "log_ticks", "host_seconds"]
    with (out_dir / "me_dataset.csv").open("w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore")
        w.writeheader()
        w.writerows(sorted(rows, key=lambda r: r["mnk"]))

    fcols = ["benchmark", "mode", "dtype", "acc", "M", "K", "N", "mnk",
             "run", "host_seconds", "note"]
    with (out_dir / "me_failures.csv").open("w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=fcols, extrasaction="ignore")
        w.writeheader()
        w.writerows(sorted(failures, key=lambda r: r["mnk"]))


def censoring_report(rows: list[MERow], failures: list[dict]) -> str:
    """Failure rate by MNK quartile over *all* attempted configs.

    This is the project's main caveat, so the builder prints it every run
    rather than leaving it to be rediscovered.
    """
    every = [(r["mnk"], False) for r in rows] + [(f["mnk"], True) for f in failures]
    every.sort()
    n = len(every)
    lines = ["  MNK quartile        range                 unlabelled"]
    for q in range(4):
        chunk = every[q * n // 4:(q + 1) * n // 4]
        failed = sum(1 for _, is_fail in chunk if is_fail)
        lines.append("  Q%d (%3d configs)   %.2e .. %.2e   %3d (%2.0f%%)" % (
            q + 1, len(chunk), chunk[0][0], chunk[-1][0],
            failed, 100.0 * failed / len(chunk)))
    return "\n".join(lines)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", type=Path, default=None,
                    help="labels CSV (default: newest results-*.csv found)")
    ap.add_argument("--corpus", type=Path, default=DEFAULT_CORPUS)
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = ap.parse_args()

    results_csv = _find_results_csv(args.results)
    rows, failures = load_me_rows(results_csv, args.corpus)
    _assert_dataset_sane(rows)
    write_outputs(rows, failures, args.out)

    from collections import Counter
    modes = Counter(r["mode"] for r in rows)
    ticks = np.array([r["ticks"] for r in rows])

    print(f"labels : {results_csv}")
    print(f"corpus : {args.corpus}")
    print(f"wrote  : {args.out}/me_dataset.{{npz,csv}} + me_failures.csv")
    print()
    print(f"labelled ME samples : {len(rows)}")
    print(f"unlabelled (gem5 failed / overflow) : {len(failures)}")
    for mode, c in sorted(modes.items()):
        print(f"  {mode:<14} {c}")
    print()
    print(f"ticks  : {ticks.min():.3e} .. {ticks.max():.3e} "
          f"(median {np.median(ticks):.3e}, {ticks.max() / ticks.min():.0f}x range)")
    print(f"feature matrix : {len(rows)} x {len(ME_V2_FEATURE_NAMES)}")
    print()
    print("censoring (gem5 failure rate rises steeply with problem size):")
    print(censoring_report(rows, failures))


if __name__ == "__main__":
    main()
