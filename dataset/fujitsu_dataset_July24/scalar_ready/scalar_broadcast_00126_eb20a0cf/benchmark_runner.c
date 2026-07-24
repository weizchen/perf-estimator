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

static void fill_i8(int8_t *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (int8_t)(((int)((i + (size_t)seed) % 7)) - 3);
}

static long long checksum_i8(const int8_t *b, size_t n) {
  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;
}

static int8_t input0_storage[333] __attribute__((aligned(64)));
static int8_t input1_storage[6327] __attribute__((aligned(64)));
static int8_t output0_storage[6327] __attribute__((aligned(64)));

extern void kernel(int8_t *arg0_allocated, int8_t *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_stride0, int64_t arg0_stride1, int8_t *arg1_allocated, int8_t *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_size1, int64_t arg1_size2, int64_t arg1_stride0, int64_t arg1_stride1, int64_t arg1_stride2, int8_t *result0_allocated, int8_t *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_size1, int64_t result0_size2, int64_t result0_stride0, int64_t result0_stride1, int64_t result0_stride2);

int main(void) {
  fill_i8(input0_storage, 333, 1);
  fill_i8(input1_storage, 6327, 2);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 37, 9, 9, 1, input1_storage, input1_storage, 0, 37, 19, 9, 171, 9, 1, output0_storage, output0_storage, 0, 37, 19, 9, 171, 9, 1);
  ofa_dma_memory_fence();
  puts("scalar_broadcast_00126_eb20a0cf: benchmark completed");
  printf("output0_i8_checksum=%lld\n", checksum_i8(output0_storage, 6327));
  return 0;
}
