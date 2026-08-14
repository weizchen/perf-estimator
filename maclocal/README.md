# maclocal — Matrix Engine regression workstream

Self-contained ME cycle-prediction work, kept in its own subtree so it can be
developed, compared and merged without colliding with anyone else working on the
same corpus.

**Nothing outside this directory is modified.** `git status` on a clean checkout
should show `maclocal/` as the only entry. That is deliberate — see
[Merging back](#merging-back).

## What this is

`PLAN.md` was written before the Fujitsu gem5 labels existed ("Labels themselves
are out of scope right now; the pipeline is built to accept them when they
arrive"). They have arrived, as `results-7-30-2026.csv`. This closes that loop
for the **Matrix Engine**: it joins the existing `me_ready` corpus to its labels
and builds the regression models `PLAN.md` specified but never implemented.

## Running it

From the repo root (`perf-estimator/`), with the venv active:

```bash
python maclocal/dataset/build_me_dataset.py   # join corpus -> labels (612 samples)
python maclocal/training/train_me.py          # baselines + classical + MLP, all splits
python maclocal/eval/report_me.py             # figures + markdown summary
python -m pytest maclocal/tests/ -q           # 17 verification checks
```

Extra dependencies beyond the repo's `requirements.txt`:

```bash
pip install -r maclocal/requirements.txt
```

Full run is ~6 min on CPU. `--no-mlp` on the trainer gives a ~20 s classical-only path.

## Results

| model | CV MAPE | sd | hold mnk | hold K | hold M | hold N |
|---|---|---|---|---|---|---|
| **mlp_residual** | **2.49%** | 0.16 | **4.59** | **5.02** | **9.17** | **9.80** |
| mlp (2×256) | 2.74% | 0.20 | 6.42 | 8.52 | 11.25 | 12.02 |
| svr_rbf | 3.42% | 0.58 | 16.28 | 32.26 | 34.65 | 44.33 |
| hist_gbm | 9.52% | 1.05 | 30.38 | 24.11 | 17.11 | 22.63 |
| ridge | 9.83% | 0.61 | 11.14 | 16.57 | 30.52 | 23.14 |
| *powerlaw (baseline)* | 15.71% | 0.86 | 15.26 | 24.90 | 21.57 | 19.28 |
| *roofline (baseline)* | 47.70% | 4.03 | 53.12 | 119.89 | 40.11 | 37.14 |

Full write-up with figures: [`results/me/me_results.md`](results/me/me_results.md).

### Findings worth carrying to VE and scalar

- **ME cost scales as ~`M^0.85 · N^0.87 · K^0.28`** — strongly sublinear in K. The
  textbook output-stationary roofline assumes K¹ and is off by 48 pp as a result;
  per-output-tile fixed cost dominates over K-streaming. VE, by contrast, measures
  `M^1.00 · N^1.06 · K^1.00` (R²=0.98) — exactly linear, as a SIMD engine should be.
- **gem5 failures are not random.** Failure rate rises from ~1% in the smallest
  problem-size quartile to 73% in the largest, so every large-shape accuracy
  number is measured on a survivor-biased sample. See `processed/me_failures.csv`.
- **Anchoring a network on a fitted analytic prior beats predicting cycles
  directly** — but only when the prior is good. The fitted power law works
  (15.3% MAPE); the hardcoded roofline would not (53%).
- **The MNK extrapolation split is weaker than it looks** — ~100% of its test M
  and N values still fall inside the training range, so only the *product* is
  new. The single-dimension bands (`hold K`, `hold M`, `hold N`) are the honest
  tests, and they are roughly 2× harder.

## Layout

Mirrors upstream paths, rooted here, so merging is mostly a move-up-one-level.

```
maclocal/
├── dataset/
│   ├── features_me.py        # v2 featurizer   -> extends dataset/scripts/features.py
│   └── build_me_dataset.py   # corpus + labels -> processed/
├── models/
│   ├── baselines/roofline_me.py   # roofline, per-mode power law, geomean control
│   ├── me_classical.py            # ridge / RF / HistGBM / SVR / kNN
│   └── me_mlp.py                  # MLPME (2×256) and ResidualMLPME
├── training/train_me.py      # random 5-fold CV + 4 held-out band splits
├── eval/
│   ├── metrics_me.py         # within_pct, log_r2, wider summary()
│   └── report_me.py          # figures + markdown
├── tests/test_me_dataset.py  # 17 checks
├── processed/                # generated: me_dataset.{npz,csv}, me_failures.csv
└── results/me/               # generated: metrics, predictions, 4 figures
```

Imports are fully qualified (`from maclocal.models... import`) and every entry
point puts the repo root on `sys.path`, so upstream modules resolve normally and
nothing shadows them.

## Merging back

The subtree is **purely additive**: no upstream file is touched, so a merge
cannot conflict. Two files exist only to keep it that way, and are the only
things needing manual attention when folding this upstream:

| file here | folds into | how |
|---|---|---|
| `dataset/features_me.py` | `dataset/scripts/features.py` | paste `feature_vector_me_v2` + `ME_V2_FEATURE_DIM` + `ME_V2_FEATURE_NAMES` beside `feature_vector_me`, drop the `sys.path`/import preamble |
| `eval/metrics_me.py` | `eval/metrics.py` | paste `within_pct` + `log_r2`, and replace the existing `summary()` with the wider one |
| `requirements.txt` | `requirements.txt` | add `scikit-learn`, `matplotlib`; note the numpy `<2` bound |

Everything else moves to the matching upstream path unchanged (`models/`,
`training/`, `eval/report_me.py`, `tests/`), after which the `maclocal.` import
prefixes and the `LOCAL` path constants come out.

`feature_vector_me` (v1) is left untouched and still exported — v2 is additive,
and `test_v1_still_importable` guards that.

## Comparing against another implementation

`processed/me_dataset.csv` is the join in plain text — 612 rows of
`benchmark, mode, M, K, N, mnk, ticks` — so another implementation can be diffed
against it directly without rerunning anything.

Two things to check first when numbers disagree:

1. **Label file.** Selecting `results-*.csv` by mtime picks the *stale*
   `dataset/results/results-7-20-2026.csv`, because it is checked into git and a
   fresh clone gives it the newer mtime. That file is a different corpus
   entirely — real-world model pulls, zero benchmark overlap with the synthetic
   `me_matmul_*` sweep, and only 91 of 519 ME rows usable. The builder here
   selects by the date parsed from the filename.
2. **The 2⁶⁴ row.** `me_matmul_00325_f7699c26` reports `sim_ticks = 2**64`, an
   unsigned wraparound (its `host_seconds` is 39 against ~1000+ for genuinely
   long runs). Keeping it inflates every error metric; this build drops it,
   leaving exactly 612.
