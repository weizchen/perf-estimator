#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#if defined(__riscv)
static inline void ofa_dma_memory_fence(void) {
  __asm__ volatile("fence rw, rw" ::: "memory");
}
#else
static inline void ofa_dma_memory_fence(void) {}
#endif

static void fill_bf16(uint16_t *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (uint16_t)(0x3F80u + ((i + (size_t)seed) % 8));
}

static long long checksum_u16(const uint16_t *b, size_t n) {
  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;
}

static void fill_f16(uint16_t *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (uint16_t)(0x3C00u + ((i + (size_t)seed) % 8));
}

static uint16_t input0_storage[167936] __attribute__((aligned(64)));
static uint16_t input1_storage[1343488] __attribute__((aligned(64)));
static uint16_t input2_storage[32768] __attribute__((aligned(64)));
static uint16_t output0_storage[32768] __attribute__((aligned(64)));

extern void kernel(uint16_t *arg0_allocated, uint16_t *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_stride0, int64_t arg0_stride1, uint16_t *arg1_allocated, uint16_t *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_size1, int64_t arg1_stride0, int64_t arg1_stride1, uint16_t *arg2_allocated, uint16_t *arg2_aligned, int64_t arg2_offset, int64_t arg2_size0, int64_t arg2_size1, int64_t arg2_stride0, int64_t arg2_stride1, uint16_t *result0_allocated, uint16_t *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_size1, int64_t result0_stride0, int64_t result0_stride1);

int main(void) {
  fill_bf16(input0_storage, 167936, 1);
  fill_bf16(input1_storage, 1343488, 2);
  fill_f16(input2_storage, 32768, 3);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 64, 2624, 2624, 1, input1_storage, input1_storage, 0, 2624, 512, 512, 1, input2_storage, input2_storage, 0, 64, 512, 512, 1, output0_storage, output0_storage, 0, 64, 512, 512, 1);
  ofa_dma_memory_fence();
  puts("me_matmul_00993_63f5d2fe: benchmark completed");
  printf("output0_f16bits_checksum=%lld\n", checksum_u16(output0_storage, 32768));
  return 0;
}
