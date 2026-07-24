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

static void fill_i32(int32_t *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (int32_t)(((int)((i + (size_t)seed) % 7)) - 3);
}

static long long checksum_i32(const int32_t *b, size_t n) {
  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;
}

static int8_t input0_storage[1445] __attribute__((aligned(64)));
static int8_t input1_storage[630] __attribute__((aligned(64)));
static int32_t input2_storage[896] __attribute__((aligned(64)));
static int32_t output0_storage[896] __attribute__((aligned(64)));

extern void kernel(int8_t *arg0_allocated, int8_t *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_size2, int64_t arg0_size3, int64_t arg0_stride0, int64_t arg0_stride1, int64_t arg0_stride2, int64_t arg0_stride3, int8_t *arg1_allocated, int8_t *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_size1, int64_t arg1_size2, int64_t arg1_size3, int64_t arg1_stride0, int64_t arg1_stride1, int64_t arg1_stride2, int64_t arg1_stride3, int32_t *arg2_allocated, int32_t *arg2_aligned, int64_t arg2_offset, int64_t arg2_size0, int64_t arg2_size1, int64_t arg2_size2, int64_t arg2_size3, int64_t arg2_stride0, int64_t arg2_stride1, int64_t arg2_stride2, int64_t arg2_stride3, int32_t *result0_allocated, int32_t *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_size1, int64_t result0_size2, int64_t result0_size3, int64_t result0_stride0, int64_t result0_stride1, int64_t result0_stride2, int64_t result0_stride3);

int main(void) {
  fill_i8(input0_storage, 1445, 1);
  fill_i8(input1_storage, 630, 2);
  fill_i32(input2_storage, 896, 3);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 1, 17, 17, 5, 1445, 85, 5, 1, input1_storage, input1_storage, 0, 3, 3, 5, 14, 210, 70, 14, 1, input2_storage, input2_storage, 0, 1, 8, 8, 14, 896, 112, 14, 1, output0_storage, output0_storage, 0, 1, 8, 8, 14, 896, 112, 14, 1);
  ofa_dma_memory_fence();
  puts("scalar_conv_00033_d985087f: benchmark completed");
  printf("output0_i32_checksum=%lld\n", checksum_i32(output0_storage, 896));
  return 0;
}
