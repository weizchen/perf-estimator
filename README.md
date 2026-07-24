# perf-estimator

Deep-learning cycle-count predictor for the **Fuji NPU**'s three execution engines: the Matrix Engine (ME), the Vector Engine (VE), and the RISC-V scalar core. Trained on Fujitsu gem5 labels, served as a sub-millisecond replacement for cycle-level simulation.

Three independent per-engine models. Each takes a single linalg-op MLIR module (wrapped in `nail.unit { proc: <engine> }`) and predicts execution cycles for that engine. No architecture descriptor as input — engine partition is the only architecture signal each model sees.

See [`PLAN.md`](PLAN.md) for the full design (technical decisions, corpus structure, repo diff, verification). For building benchmark ELFs and verifying a harness + testcase without gem5 (the label-generation side), see [`doc/verifying_benchmark_elfs_without_gem5.md`](doc/verifying_benchmark_elfs_without_gem5.md). The previous Gemini-drafted background docs are preserved under [`doc/archive/`](doc/archive/).
