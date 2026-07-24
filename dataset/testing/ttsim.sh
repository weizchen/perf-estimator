./OFA-compiler-master/build/bin/ofa-compiler perf-estimator/dataset/corpus/me/me_matmul_00002_e9b965e9.mlir --target-spec=OFA-compiler-master/targets/Wormhole-NPU.json --emit-stage=tenstorrent-metal -o test.ttob


./OFA-compiler-master/build/bin/ofa-compiler /home/weizchen/code/perf-estimator/perf-estimator/dataset/corpus/me/me_matmul_00002_e9b965e9.mlir --target-spec=/home/weizchen/code/perf-estimator/OFA-compiler-master/targets/Wormhole-NPU.json --emit-stage=tenstorrent-metal -o matmul_fpu.ttob

./OFA-compiler-master/build/bin/ofa-compiler /home/weizchen/code/perf-estimator/me_matmul_sfpu.mlir --target-spec=/home/weizchen/code/perf-estimator/OFA-compiler-master/targets/Wormhole-NPU.json --emit-stage=tenstorrent-metal -o matmul_sfpu.ttob


unset TT_METAL_EMULE_MODE && export TT_METAL_SIMULATOR=/home/weizchen/code/perf-estimator/externals/sim/libttsim_wh.so && export TT_METAL_SLOW_DISPATCH_MODE=1 && export TT_METAL_DISABLE_SFPLOADMACRO=1 && export LD_LIBRARY_PATH=/home/weizchen/code/perf-estimator/externals/tt-metal/built/lib:$LD_LIBRARY_PATH && ./OFA-compiler-master/build/runtime/TenstorrentRuntime/lib/ttm_loader matmul_fpu.ttob --simulate