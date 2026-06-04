# perf-estimator: Plan

## Context

The project is a deep-learning cycle-count predictor for the **Fuji NPU** — a heterogeneous accelerator with three execution engines per core: a Matrix Engine (ME, a 128×128 output-stationary systolic array), a Vector Engine (VE, RVV-based SIMD), and a RISC-V scalar core. The compiler is `OFA-compiler-master/`. Per-op cycle measurements come from Fujitsu's gem5 simulation. We want sub-millisecond inference of cycles, replacing gem5 (weeks per simulation) on the perf-estimation side.

Framing:

- **Input**: a corpus of *single-op* linalg benchmarks. One `.mlir` file = one linalg op = one Fujitsu-gem5 cycle label per engine. Labels themselves are out of scope right now; the pipeline is built to accept them when they arrive.
- **Code representation**: hand-crafted feature vector → MLP for v1; raw `linalg.generic` text → `regress-lm` for v2.
- **Model**: three independent per-engine models (ME, VE, RISC-V). No architecture descriptor as input — engine partition is the only "arch info" the model sees.
- **Output**: predicted cycle count.

This document supersedes the previous PLAN (per-`nail.unit` extraction + remote per-unit gem5 labeling). The earlier `doc/problem.md` and `doc/simplified_problem.md` are preserved under `doc/archive/` as historical background.

## Technical decisions

Each is anchored in evidence from `OFA-compiler-master`.

### 1. Author input as `nail.unit { proc: <engine> }`; let OFA do per-engine codegen

We wrap every corpus sample in a `nail.unit` with a fixed `proc` value (ME=2, VE=1, RISC-V=0). The OFA pipeline already contains per-engine codegen behind the binding, so we don't rewrite ops to "trick" the auto-router:

- `tools/ofa_compiler/ofa-compiler.cpp:452-454` — `InsertNAILDialectPass` only runs when input has no NAIL. Hand-placed `nail.unit` ops bypass auto-partition/placement; no `supported_ops` check happens on our work.
- **ME**: `ConvertDispatchKernelsToCalls.cpp:202-243` pattern-matches `linalg::MatmulOp` on ME-bound work and lowers to a call into `dispatch_kernel_matmul_me(...)`, built from `runtime/MatmulKernel/matmul.c` (linked as `matmul_runtime.ll`). That function programs the Matrix Engine's control registers to run the systolic array — the hand-tuned ME matmul kernel. Non-matmul ops on ME fall through to `linalg-to-loops`.
- **VE**: `tools/ofa_compiler/ofa-compiler.cpp:469` adds `createVectorizeVEBindsPass()`. The pass calls `affine::vectorizeAffineLoops` (`VectorizeVEBinds.cpp:271`) on VE-bound work, producing RVV-vectorized code.
- **RISC-V**: no engine-specific pass; the generic `linalg-to-loops` → `scf` → `cf` → LLVM path produces scalar code, which is correct for the scalar pipeline.

Consequence: we don't need to rewrite a matmul as chained dot-products to put it on VE, and we don't need raw `scf.for + arith.*` templates to put work on RISC-V. Wrap the linalg op, set `proc`, the compiler handles the rest.

How the wrap happens: builders emit `.mlir` text directly via Python f-strings, the same shape as `unittests/four_matmul/matmul_2x2.nail.mlir`. No call to any pass for the wrap itself.

### 2. Per-engine corpora stay disjoint; named-op breadth comes from the real-world pull

The auto-router in `Support.cpp:36-53` collapses every linalg op into 5 categories — `matmul`, `conv2d`, `reduction`, `elementwise`, `scalar`. The hardware JSONs claim:

- ME `supported_ops = ["matmul", "conv2d"]`
- VE `supported_ops = ["elementwise", "reduction"]`
- RISC-V `supported_ops = ["all"]`

Under default routing, ME only ever sees matmul + conv2d, VE only ever sees elementwise + reduction. So:

- **ME corpus** = matmul + conv2d variants.
- **VE corpus** = elementwise + reduction `linalg.generic` variants.
- **Scalar corpus** = mixed bag of linalg ops wrapped `proc: 0`.

No cross-engine duplication of the same body is needed for "predict cycles per engine"; comparative ranking (which engine is faster for op X) is a v2+ concern.

Routing categories aren't perf categories, though — `linalg.depthwise_conv_2d_nhwc_hwc` and `linalg.conv_2d_nhwc_hwcf` both classify `"conv2d"` but have different cycle costs, and the model must see both to predict both. Coverage is split:

- **Synthetic sweeps** cover the high-volume families (matmul, conv_2d_nhwc_hwcf, elementwise generic, reduction generic) with dense shape grids — they dominate workload time.
- **Real-world pull** (next decision) covers everything else — depthwise convs, pooling families, softmax, transpose, batch_matmul, mmt4d, pack/unpack, fill, copy, broadcast, the long tail — at shapes deployed models actually use.

### 3. Real-world pull = a new ofa-opt pass that extracts single-op modules

The benchmark corpus under `OFA-compiler-master/Benchmarks/*/model.mlir` contains `func.func`s with many linalg ops each. Using a whole module as one corpus entry is the wrong granularity (one label for many ops). We need to extract each linalg op as a standalone single-op file.

**This is a new MLIR pass: `NAILExtractLinalgBenchmarks`**, living at `OFA-compiler-master/lib/Dialect/NAIL/Transforms/NAILExtractLinalgBenchmarks.cpp`. It walks each `linalg::LinalgOp` in each `func.func` and emits one standalone MLIR module per op:

```mlir
func.func @main(%arg0: tensor<...>, %arg1: tensor<...>) -> tensor<...> {
  %0 = NAIL.unit { schedule = 0 : i64 } : !NAIL.target<i:0, j:0, proc: <engine>> -> tensor<...> {
    %1 = linalg.<op> ins(%arg0, %arg1 : ...) outs(...) ...
    NAIL.yield %1 : tensor<...>
  }
  return %0 : tensor<...>
}
```

Operands of the linalg op become function args. The op is wrapped in `nail.unit { proc: <engine> }`. The engine is chosen by the pass's `--engine={me,ve,scalar}` option; the pass filters out ops whose category mismatches the requested engine (so VE runs against the same benchmark file emit only its elementwise + reduction ops, etc.). Output is one `.mlir` per op into `dataset/corpus/<engine>/<benchmark>__<op_idx>.mlir`.

Design notes:

- Modeled on the deleted `NAILExtractUnitMicrobench` but one level lower (walks `linalg::LinalgOp` instead of `NAIL::UnitOp`) and doesn't depend on placement having run.
- Uses `linalg::LinalgOp` interface and `mlir::OpBuilder` to construct the standalone module. Operand SSA values become block args; the op body is cloned in.
- Registers via `Passes.td` + factory in `Passes.cpp`, same convention as existing NAIL passes.
- Invoked: `ofa-opt --nail-extract-linalg-benchmarks=engine=ve <path>/model.mlir -o dataset/corpus/ve/`.

### 4. Loss = MAPE only

`models/me_mlp.py` currently uses `MAPE + λ·max(0, ŷ−y)/y`. The asymmetric term was a PRIME-style hedge for RL reward signals; under the new framing (predict cycles, no RL coupling) symmetric MAPE is correct. Drop the penalty in v1.

### 5. Use `regress-lm` for v2 — don't build a bespoke text model

`externals/regress-lm/` is exactly a text→scalar regressor with T5/Mamba encoder options. When labels arrive in sufficient volume, fine-tune one instance per engine on `(canonicalized linalg.generic text, cycles)` pairs. v1 MLPs become the floor v2 must beat. NeuSight is GPU-specific and not directly reusable; `t5x` and `Instruction-Tuning-Survey` stay as references.

## Repo diff

### Salvageable — keep

| File | Role |
|---|---|
| `dataset/canonicalize.py` | SSA-renumbering hash. Used to dedup the real-world pull (the same matmul shape recurs in many model layers). |
| `dataset/features.py` | Matmul shape → 14-d feature vector. Becomes ME's featurizer; VE/scalar featurizers share its parse helpers. |
| `models/me_mlp.py` | Engine-agnostic MLP body. Loss simplification (decision #4) applies here. Clone for VE and scalar. |
| `models/baselines/roofline_me.py` | Analytical floor for ME. |
| `eval/metrics.py` | Generic regression metrics. |
| `tests/test_canonicalize.py` | Tests hash invariance — the property that makes real-world-pull dedup work. |

### Dead weight — delete

| File | Reason |
|---|---|
| `OFA-compiler-master/lib/Dialect/NAIL/Transforms/NAILDumpUnits.cpp` + registration + CMake entry | No longer sampling at `nail.unit` granularity. |
| `OFA-compiler-master/lib/Dialect/NAIL/Transforms/NAILExtractUnitMicrobench.cpp` + registration + CMake entry | Replaced by `NAILExtractLinalgBenchmarks` at the linalg level. |
| `perf-estimator/extractor/dump_units.py` (and the now-empty `extractor/` directory) | Wrapper around the deleted pass. |
| `row`, `col`, `placed` fields in the existing `dataset/schema.py` | Per-unit artifacts; gone in the new schema. |

### Rewrite

| File | New shape |
|---|---|
| `dataset/schema.py` | `LinalgOpSample { uid, engine ∈ {me,ve,scalar}, op_name, region_mlir, region_hash, features, label_cycles }`. |
| `dataset/builders/me.py` | Emits `nail.unit { proc: 2 } { linalg.matmul \| linalg.conv_2d_nhwc_hwcf ... }` modules into `dataset/corpus/me/`. |
| `models/me_mlp.py` | Drop conservative penalty (decision #4). |
| `training/train_me.py` → `training/train.py` | Generalized: `--engine={me,ve,scalar}`. Loads `dataset/corpus/<engine>/*.json`. |

### New

| File | Purpose |
|---|---|
| `OFA-compiler-master/lib/Dialect/NAIL/Transforms/NAILExtractLinalgBenchmarks.cpp` (+ Passes.td/cpp/CMake entries) | The extraction pass described in decision #3. |
| `dataset/builders/ve.py` | Synthetic VE sweep: `nail.unit { proc: 1 } { linalg.generic <elementwise \| reduction> }`. |
| `dataset/builders/scalar.py` | Synthetic scalar sweep: `nail.unit { proc: 0 } { <mixed linalg ops> }`. |
| `dataset/corpus/{me,ve,scalar}/` | On-disk samples: `<uid>.mlir` + `<uid>.json` per entry. |
| `models/ve_mlp.py`, `models/scalar_mlp.py` | Per-engine MLPs cloned from `me_mlp.py`. |
| `models/baselines/roofline_ve.py` | `ceil(n_elems/VLEN)·ops_per_lane + chain_latency·chain_depth`. |
| `models/baselines/roofline_scalar.py` | `trip_count_product·CPI_inner + branch_penalty + icache_miss_factor`. Sanity ceiling only. |
| `doc/archive/` | Holds the archived `problem.md` and `simplified_problem.md`. |

## Architecture v1 — features + MLP, per engine

Per engine, identical recipe; differences are the featurizer and the roofline.

1. **Input**: single linalg-op MLIR file from `dataset/corpus/<engine>/`.
2. **Featurizer** (`dataset/features.py`, engine-specific functions):
   - ME: `(M, N, K, log M, log N, log K, dtype one-hot, transpose flags, accum dtype, tile-padding fraction)` — ~16-d.
   - VE: `(vector_len, num_iters, chain_depth, reduction_kind, dtype one-hot, mask_density)` — ~12-d.
   - Scalar: `(loop_nest_depth, trip_count_logs, stride_kind, branch_density, body_size_bytes)` — ~10-d.
3. **Model**: 4-layer MLP, hidden 256, GELU, residual; predicts `log1p(cycles)`.
4. **Loss**: MAPE.
5. **Baseline floor**: `roofline_<engine>`. Trained model must beat it on held-out.

Scalar is the weakest case — RISC-V perf is loop-structure-dependent and the MLP-on-features ceiling is low. It's the first engine slated to flip to v2.

## Architecture v2 — regress-lm, one fine-tune per engine

Deferred until labels arrive:

- Canonicalize every sample with `mlir-opt -linalg-generalize-named-ops` so all forms are `linalg.generic`.
- Per engine, fine-tune `externals/regress-lm/` on `(canonicalized MLIR text, cycles)`.
- v1 MLPs remain the floor v2 must beat.
- Roll out scalar first (biggest expected lift), then VE, then ME.

## Corpus design

Each builder synthesizes samples over the sweep below. All samples are `nail.unit { proc: <engine> }`-wrapped.

**ME** (`dataset/builders/me.py`)

| Body | Knobs |
|---|---|
| `linalg.matmul` | `M, N, K` log-uniform [1, 4096], boundary points {64, 128, 129, 256, 1024}; dtypes {INT8, BF16, FP32-accum}; layouts {row-major, transpose-B, `matmul_transpose_b`}. |
| `linalg.conv_2d_nhwc_hwcf` | input HW log-uniform [8, 512]; filter HW {1, 3, 5, 7}; channels log-uniform [1, 1024]; stride {1, 2}; padding {0, 1, same}. |

**VE** (`dataset/builders/ve.py`)

| Body | Knobs |
|---|---|
| `linalg.generic` elementwise | vector length log-uniform [16, 8192]; kind {add, mul, max, relu, sigmoid-approx}; dtypes {BF16, FP32, INT8}. |
| `linalg.generic` reduction | length log-uniform [16, 8192]; kind {sum, max, mean, argmax}; chain depth {1, 2, 4, 8}. |

**Scalar** (`dataset/builders/scalar.py`)

Light versions of all of the above wrapped `proc: 0`. The OFA pipeline lowers them through `linalg-to-loops` → scalar code. No separate scf-arith template family in v1.

**Real-world pull** (via `NAILExtractLinalgBenchmarks`)

For each `Benchmarks/*/model.mlir`, run the extractor three times (once per engine) to populate `dataset/corpus/<engine>/`. The extractor filters by op category so each output engine only gets ops that engine naturally accepts. This is where named-op breadth (depthwise convs, pooling, softmax, transpose, etc.) enters the corpus.

**Held-out**: per engine, reserve (a) one shape-bucket band for extrapolation (e.g., M, N, K ≥ 2048 for ME) and (b) the full op-signature set of one held-out real benchmark for cross-benchmark generalization.

**Open question, not for v1**: whether Fujitsu's gem5 labels measure compute-only or end-to-end (including DRAM→SLM movement and writeback). We treat the cycle count as a black-box scalar; if labels later turn out to mix populations, we revisit.

## Verification

- **Dedup test** — `tests/test_canonicalize.py` continues to pass against the new corpus output.
- **Featurizer round-trip** — per engine, emit a known sample via the builder, parse it through the featurizer, assert feature dimensions and specific known values (e.g., `M=K=N=128` ME matmul → exact 16-d vector).
- **Extraction pass lit-test** — fixture: a small `model.mlir` with N linalg ops of mixed categories; assert `NAILExtractLinalgBenchmarks --engine=ve` produces exactly the elementwise+reduction ops as standalone modules. Reuses OFA's `unittests/` framework.
- **End-to-end compile test** — for each `(engine, sample)` in the corpus, `ofa-compiler` runs through to RISC-V ELF without error. Catches dtype-combination edge cases per engine.
- **Trainer smoke** — `python -m perf_estimator.training.train --engine={me,ve,scalar} --epochs=2` against synthetic roofline labels asserts loss decreases.
- **Baseline floor (post-labels)** — MAPE-vs-roofline gate per engine in CI once real labels arrive.
- **OFA regression** — `OFA-compiler-master/run_tests.sh` passes after the two deletions + the new pass land.

## Out of scope

- Generating the actual corpus on disk (builders + extractor land as code; running them is a follow-up task).
- Wiring real Fujitsu labels beyond a `label_cycles` slot.
- v2 (`regress-lm` fine-tuning).
- RL-reward integration, serving, active learning.
