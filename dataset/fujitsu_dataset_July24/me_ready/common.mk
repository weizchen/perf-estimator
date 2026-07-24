# Self-contained build for a shipped single-op benchmark:
#
#     model.mlir + benchmark_runner.c  ->  static RISC-V ELF for gem5
#
# No generate_runner.py and no normalize step are needed on the build host: the
# C runner is pre-generated and shipped, and the single-op @kernel module
# compiles directly. The only external dependencies are the OFA compiler binary
# + its runtime .c sources (via OFA_ROOT) and a RISC-V toolchain.
#
# The compiler args / link flags mirror the OFA repo's
# Benchmarks/common/benchmark_common.mk; if that build flow changes upstream,
# re-sync the OARGS/GARGS/CFLAGS/LDFLAGS below.
#
# A per-benchmark Makefile sets NAME + SUPPORT_FLAGS + BENCH_DIR, then includes
# this file. Override OFA_ROOT / RISCV_CC / OBJCOPY on the make command line.

ifndef NAME
$(error set NAME before including common.mk)
endif
ifndef BENCH_DIR
$(error set BENCH_DIR before including common.mk)
endif
BENCH_DIR := $(patsubst %/,%,$(BENCH_DIR))

OFA_ROOT      ?= /home/weizchen/code/perf-estimator/OFA-compiler-master
OFA_COMPILER  ?= $(OFA_ROOT)/build/bin/ofa-compiler
TARGET_SPEC   ?= $(OFA_ROOT)/targets/Fuji-NPU.json
RISCV_CC      ?= /opt/riscv/bin/riscv64-unknown-linux-gnu-gcc
OBJCOPY       ?= /opt/riscv/bin/riscv64-unknown-linux-gnu-objcopy
SUPPORT_FLAGS ?=

MEMREF_SRC   := $(OFA_ROOT)/Benchmarks/common/memref_runtime.c
ENGCONT_SRC  := $(OFA_ROOT)/runtime/EngContOps/engcont_runtime.c
MEMALLOC_SRC := $(OFA_ROOT)/runtime/MemoryAlloc/memory_alloc.c

CFLAGS  ?= -O2 -g -std=c11 -march=rv64gc -mabi=lp64d
LDFLAGS ?= -march=rv64gc -mabi=lp64d -pthread -static
LDLIBS  ?= -lm

OARGS = --target-spec=$(TARGET_SPEC) --scheduling --schedule=0 --resource-alloc=1 \
        --dispatch-resource-alloc=1 --partition=0 --placement=0 $(SUPPORT_FLAGS)
GARGS = --target-spec=$(TARGET_SPEC) --scheduling=false $(SUPPORT_FLAGS)

MODEL  := $(BENCH_DIR)/model.mlir
RUNNER := $(BENCH_DIR)/benchmark_runner.c
OUT    := $(BENCH_DIR)/out
NAIL   := $(OUT)/model.nail.mlir
OBJ    := $(OUT)/model.o
RUNOBJ := $(OUT)/benchmark_runner.o
RTOBJS := $(OUT)/memref_runtime.o $(OUT)/engcont_runtime.o $(OUT)/memory_alloc.o
ELF    := $(OUT)/$(NAME).elf
BIN    := $(OUT)/$(NAME).bin

.PHONY: all elf object bin clean check-ofa check-cc
all: elf
object: $(OBJ)
elf: $(ELF)
bin: $(BIN)

# check-ofa gates the kernel-object path (toolchain-free; works on the dev box).
check-ofa:
	@test -f $(MODEL)        || { echo "Missing $(MODEL)"; exit 1; }
	@test -x $(OFA_COMPILER) || { echo "Missing $(OFA_COMPILER) — set OFA_ROOT"; exit 1; }

# check-cc additionally gates the RISC-V compile/link (needs the cross toolchain).
check-cc: check-ofa
	@test -f $(RUNNER)       || { echo "Missing $(RUNNER) — ship the pre-generated runner.c"; exit 1; }
	@command -v $(RISCV_CC) >/dev/null 2>&1 || { echo "Missing $(RISCV_CC) — set RISCV_CC"; exit 1; }

$(OUT):
	mkdir -p $(OUT)

# kernel: single-op @kernel module -> scheduled NAIL -> relocatable RISC-V object
$(NAIL): $(MODEL) | $(OUT) check-ofa
	$(OFA_COMPILER) $(MODEL) $(OARGS) --emit-stage=nail -o $@

$(OBJ): $(NAIL) | $(OUT) check-ofa
	$(OFA_COMPILER) $(NAIL) $(GARGS) --emit-stage=object -o $@

# shipped runner + OFA runtime support objects
$(RUNOBJ): $(RUNNER) | $(OUT) check-cc
	$(RISCV_CC) $(CFLAGS) -c $(RUNNER) -o $@

$(OUT)/memref_runtime.o: $(MEMREF_SRC) | $(OUT) check-cc
	$(RISCV_CC) $(CFLAGS) -c $(MEMREF_SRC) -o $@
$(OUT)/engcont_runtime.o: $(ENGCONT_SRC) | $(OUT) check-cc
	$(RISCV_CC) $(CFLAGS) -c $(ENGCONT_SRC) -o $@
$(OUT)/memory_alloc.o: $(MEMALLOC_SRC) | $(OUT) check-cc
	$(RISCV_CC) $(CFLAGS) -c $(MEMALLOC_SRC) -o $@

$(ELF): $(OBJ) $(RUNOBJ) $(RTOBJS) | $(OUT) check-cc
	$(RISCV_CC) $(CFLAGS) $(LDFLAGS) $(OBJ) $(RUNOBJ) $(RTOBJS) -o $@ $(LDLIBS)

$(BIN): $(ELF) | $(OUT) check-tools
	$(OBJCOPY) -O binary $< $@

clean:
	rm -rf $(OUT)
