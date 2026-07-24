"""ttsim matmul size-sweep: is `g_clock` a usable cycle label? (Spoiler: no.)

Runs one square matmul N×N×N (bf16, TILE_LAYOUT) through the Tenstorrent ttsim
simulator (`libttsim_wh.so`) per process and reads the simulated cycle counter
`g_clock` from libttsim's exit line. Sweeping N shows g_clock barely moves while
compute (MACs = N³) explodes -> g_clock tracks dispatch/control overhead, not
arithmetic. See doc/tt_label_source_assessment.md §3.4 for the results/analysis.

Usage (env must point at the simulator, NOT the EMULE functional emulator):

    cd /home/weizchen/code/perf-estimator
    source env.sh
    unset TT_METAL_EMULE_MODE
    export TT_METAL_SIMULATOR=$PWD/externals/sim/libttsim_wh.so   # soc_descriptor.yaml beside it
    export TT_METAL_SLOW_DISPATCH_MODE=1 TT_METAL_DISABLE_SFPLOADMACRO=1
    for N in 0 32 64 128 256 512 1024 2048; do
        python3 perf-estimator/dataset/testing/ttsim_size_sweep.py $N
    done

g_clock is the [NNNN] in libttsim's exit summary, e.g. "[7342] 11.0 seconds (0.7 KHz)".
N=0 = baseline (open/close only, no matmul).
"""

import sys

import torch
import ttnn


def main() -> int:
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    dev = ttnn.open_device(device_id=0)
    try:
        if n > 0:
            a = ttnn.from_torch(torch.rand(n, n, dtype=torch.float32),
                                dtype=ttnn.bfloat16, layout=ttnn.TILE_LAYOUT, device=dev)
            b = ttnn.from_torch(torch.rand(n, n, dtype=torch.float32),
                                dtype=ttnn.bfloat16, layout=ttnn.TILE_LAYOUT, device=dev)
            c = a @ b
            _ = ttnn.to_torch(c)          # force execution
            print(f"DONE matmul {n}x{n}x{n}  (MACs={n**3})")
        else:
            print("DONE baseline (no matmul)")
    finally:
        ttnn.close_device(dev)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
