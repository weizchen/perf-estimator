# ve_ready

All VE single-op benchmarks, harnessed for gem5 (fujitsu-624-test layout).

Layout: {'main': 2063}

Build:  `./build_all.sh OFA_ROOT=/path/to/OFA-compiler-master`

Each `<uid>/` = model.mlir + pre-generated benchmark_runner.c + Makefile. ELFs land at `<uid>/out/<uid>.elf`. Report cycles back keyed by `<uid>` (uid, build, run, sim_ticks, sim_seconds).
