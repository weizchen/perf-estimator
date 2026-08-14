# ME cycle prediction -- results

612 labelled `linalg.matmul` benchmarks on the Matrix Engine, 25 features, target `sim_ticks`.

## Accuracy

| model | CV MAPE | CV sd | CV within 10% | extrap MAPE | extrap within 10% | extrap log-R2 |
|---|---|---|---|---|---|---|
| mlp_residual | 2.49% | 0.16 | 97% | 4.59% | 90% | 0.987 |
| mlp | 2.74% | 0.20 | 97% | 6.42% | 81% | 0.974 |
| svr_rbf | 3.42% | 0.58 | 95% | 16.28% | 50% | 0.706 |
| hist_gbm | 9.52% | 1.05 | 61% | 30.38% | 12% | 0.150 |
| ridge | 9.83% | 0.61 | 61% | 11.14% | 64% | 0.927 |
| random_forest | 12.41% | 0.53 | 47% | 33.93% | 16% | -0.173 |
| knn | 15.02% | 0.25 | 41% | 41.72% | 6% | -0.782 |
| *powerlaw* | 15.71% | 0.86 | 36% | 15.26% | 39% | 0.879 |
| *roofline* | 47.70% | 4.03 | 13% | 53.12% | 11% | 0.060 |
| *geomean* | 142.22% | 13.85 | 6% | 71.24% | 1% | -7.297 |

*Italic = analytical baseline, not a learned model.*

- Best under random CV: **mlp_residual** (2.49% MAPE).
- Best under extrapolation: **mlp_residual** (4.59% MAPE).
- The `powerlaw` baseline is 4 fitted parameters per dtype mode and reaches 15.71% / 15.26%. Any learned model has to be read against that, not against the roofline.

## Fitted scaling exponents

`ticks = c * M^a * N^b * K^d`, fit per mode:

| mode | M | N | K |
|---|---|---|---|
| f16->f16 | 0.817 | 0.838 | 0.353 |
| f16->f32 | 0.852 | 0.894 | 0.272 |
| f8E5M2->f32 | 0.885 | 0.903 | 0.197 |

Cost is near-linear in the output dims but strongly sublinear in K, so the textbook output-stationary roofline (`tiles_m * tiles_n * K`, i.e. K^1) mismodels this corpus -- per-output-tile fixed cost dominates over K-streaming at these shapes.

## Caveats

- **Censoring.** gem5 fails on 22% of ME configs, and the failure rate rises from ~1% in the smallest MNK quartile to 73% in the largest. The extrapolation test set is therefore a survivor-biased sample of exactly the regime it is meant to probe. See `dataset/processed/me_failures.csv`.
- **Scope.** `linalg.matmul` on ME only, at dims already aligned to the systolic edge (128 for FP8, 64 for FP16). Unaligned shapes and `conv_2d` do not appear in this corpus, so nothing here speaks to them.
- **N = 612.** Small. The CV sd column is there to be read.
