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

static void fill_f32(float *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (float)(((int)((i + (size_t)seed) % 23)) - 11) / 7.0f;
}

static double checksum_f32(const float *b, size_t n) {
  double s = 0.0; for (size_t i = 0; i < n; ++i) s += (double)b[i]; return s;
}

static float input0_storage[1400832] __attribute__((aligned(64)));
static float input1_storage[417792] __attribute__((aligned(64)));
static float input2_storage[3969024] __attribute__((aligned(64)));
static float output0_storage[3969024] __attribute__((aligned(64)));

extern void kernel(float *arg0_allocated, float *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_stride0, int64_t arg0_stride1, float *arg1_allocated, float *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_size1, int64_t arg1_stride0, int64_t arg1_stride1, float *arg2_allocated, float *arg2_aligned, int64_t arg2_offset, int64_t arg2_size0, int64_t arg2_size1, int64_t arg2_stride0, int64_t arg2_stride1, float *result0_allocated, float *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_size1, int64_t result0_stride0, int64_t result0_stride1);

int main(void) {
  fill_f32(input0_storage, 1400832, 1);
  fill_f32(input1_storage, 417792, 2);
  fill_f32(input2_storage, 3969024, 3);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 3648, 384, 384, 1, input1_storage, input1_storage, 0, 384, 1088, 1088, 1, input2_storage, input2_storage, 0, 3648, 1088, 1088, 1, output0_storage, output0_storage, 0, 3648, 1088, 1088, 1);
  ofa_dma_memory_fence();
  puts("scalar_matmul_00390_e43b0a9c: benchmark completed");
  printf("output0_f32_checksum=%.10e\n", checksum_f32(output0_storage, 3969024));
  return 0;
}
