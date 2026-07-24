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

static uint16_t input0_storage[11020] __attribute__((aligned(64)));
static uint16_t input1_storage[11020] __attribute__((aligned(64)));
static uint16_t output0_storage[11020] __attribute__((aligned(64)));

extern void kernel(uint16_t *arg0_allocated, uint16_t *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_size2, int64_t arg0_size3, int64_t arg0_stride0, int64_t arg0_stride1, int64_t arg0_stride2, int64_t arg0_stride3, uint16_t *arg1_allocated, uint16_t *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_size1, int64_t arg1_size2, int64_t arg1_size3, int64_t arg1_stride0, int64_t arg1_stride1, int64_t arg1_stride2, int64_t arg1_stride3, uint16_t *result0_allocated, uint16_t *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_size1, int64_t result0_size2, int64_t result0_size3, int64_t result0_stride0, int64_t result0_stride1, int64_t result0_stride2, int64_t result0_stride3);

int main(void) {
  fill_bf16(input0_storage, 11020, 1);
  fill_bf16(input1_storage, 11020, 2);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 29, 4, 19, 5, 380, 95, 5, 1, input1_storage, input1_storage, 0, 29, 4, 5, 19, 380, 95, 19, 1, output0_storage, output0_storage, 0, 29, 4, 5, 19, 380, 95, 19, 1);
  ofa_dma_memory_fence();
  puts("ve_transpose_00074_8ef0306b: benchmark completed");
  printf("output0_bf16bits_checksum=%lld\n", checksum_u16(output0_storage, 11020));
  return 0;
}
