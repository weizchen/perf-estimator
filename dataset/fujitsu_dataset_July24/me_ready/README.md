# me_ready

All ME single-op benchmarks, harnessed for gem5 (fujitsu-624-test layout).

Matrix Engine matmuls, one per (input, accumulator) **mode** declared in `targets/Processors/MatrixEngine.json`. Every M/K/N is a **multiple of the mode's systolic array edge** (128 for INT8/FP8, 64 for FP16/BF16), as the ME requires.

Runnable (top-level dirs): `FP8->FP32` (128x128), `FP16->FP32` and `FP16->FP16` (64x64).

* `unsupported_bf16/` (87) — BF16->FP32: compiles, but gem5 reports Build OK / Run FAIL
* `unsupported_bf16_f16acc/` (44) — BF16->FP16: does NOT compile — linalg.matmul only inserts widening accumulator casts, so bf16 into an f16 accumulator fails with "'arith.addf' op requires the same type for all operands and results". Matches the planned table, where every FP16-accumulator column in the BF16 rows is "-". Shipped for the record; expected to fail at build.
* `unsupported_f32/` (10) — FP32 is not an ME input mode at all (real-world batch_matmul; dims are also not array-aligned)
* `unsupported_i8/` (87) — INT8->INT32: compiles, but ME INT8 support is still missing (and INT8 is absent from the planned-datatype table)

Layout: {'unsupported_f32': 10, 'main': 786, 'unsupported_i8': 87, 'unsupported_bf16': 87, 'unsupported_bf16_f16acc': 44}

Build:  `./build_all.sh OFA_ROOT=/path/to/OFA-compiler-master`
        `INCLUDE_UNSUPPORTED=1 ./build_all.sh OFA_ROOT=...`  (also builds ['unsupported_bf16', 'unsupported_bf16_f16acc', 'unsupported_f32', 'unsupported_i8'])

Each `<uid>/` = model.mlir + pre-generated benchmark_runner.c + Makefile. ELFs land at `<uid>/out/<uid>.elf`. Report cycles back keyed by `<uid>` (uid, build, run, sim_ticks, sim_seconds).
