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

static void fill_i16(int16_t *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (int16_t)(((int)((i + (size_t)seed) % 7)) - 3);
}

static long long checksum_i16(const int16_t *b, size_t n) {
  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;
}

static int16_t input0_storage[398] __attribute__((aligned(64)));
static int16_t input1_storage[398] __attribute__((aligned(64)));
static int16_t output0_storage[398] __attribute__((aligned(64)));

extern void kernel(int16_t *arg0_allocated, int16_t *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_stride0, int16_t *arg1_allocated, int16_t *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_stride0, int16_t *result0_allocated, int16_t *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_stride0);

int main(void) {
  fill_i16(input0_storage, 398, 1);
  fill_i16(input1_storage, 398, 2);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 398, 1, input1_storage, input1_storage, 0, 398, 1, output0_storage, output0_storage, 0, 398, 1);
  ofa_dma_memory_fence();
  puts("ve_generic_00657_40f849b0: benchmark completed");
  printf("output0_i16_checksum=%lld\n", checksum_i16(output0_storage, 398));
  return 0;
}
