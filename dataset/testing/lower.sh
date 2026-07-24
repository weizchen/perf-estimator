KERNEL_NAME=$1
OFA=/home/weizchen/code/perf-estimator/OFA-compiler-master

if [ -z "$KERNEL_NAME" ]; then
    echo "Error: No kernel name provided. Usage: ./lower.sh <kernel_name>"
    exit 1
fi

python3 $OFA/Benchmarks/common/generate_runner.py \
    --input ${KERNEL_NAME}.mlir --output ${KERNEL_NAME}_runner.c --benchmark-name ${KERNEL_NAME}

$OFA/build/bin/ofa-compiler ${KERNEL_NAME}.mlir \
    --target-spec=$OFA/targets/Fuji-NPU.json \
    --scheduling --dispatch-resource-alloc=1 --resource-alloc=1 \
    --emit-stage=llvm-ir -o ${KERNEL_NAME}.ll

$OFA/externals/llvm-project/build/bin/llc -mtriple=riscv64-unknown-linux-gnu \
    -target-abi=lp64d -mattr=+a,+m,+f,+d,+c ${KERNEL_NAME}.ll -o ${KERNEL_NAME}.s

# gcc -c ${KERNEL_NAME}_runner.c -o ${KERNEL_NAME}_runner.o