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

static void fill_f32(float *buffer, size_t count, int seed) {
  for (size_t index = 0; index < count; ++index)
    buffer[index] = (float)(((int)((index + (size_t)seed) % 23)) - 11) / 7.0f;
}

static void fill_i64(int64_t *buffer, size_t count, int seed) {
  for (size_t index = 0; index < count; ++index)
    buffer[index] = (int64_t)((index + (size_t)seed) % 7);
}

static double checksum_f32(const float *buffer, size_t count) {
  double sum = 0.0;
  for (size_t index = 0; index < count; ++index)
    sum += (double)buffer[index];
  return sum;
}

static long long checksum_i64(const int64_t *buffer, size_t count) {
  long long sum = 0;
  for (size_t index = 0; index < count; ++index)
    sum += (long long)buffer[index];
  return sum;
}

static float input0_storage[131072] __attribute__((aligned(64)));
static float input1_storage[256] __attribute__((aligned(64)));
static float output0_storage[256] __attribute__((aligned(64)));

extern void kernel(float *arg0_allocated, float *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_stride0, int64_t arg0_stride1, float *arg1_allocated, float *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_stride0, float *result0_allocated, float *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_stride0);

int main(void) {
  fill_f32(input0_storage, 131072, 1);
  fill_f32(input1_storage, 256, 2);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 256, 512, 512, 1, input1_storage, input1_storage, 0, 256, 1, output0_storage, output0_storage, 0, 256, 1);
  ofa_dma_memory_fence();
  puts("ve_reduction_repro/scalar_named_reduce: benchmark completed");
  printf("output0_f32_checksum=%.10e\n", checksum_f32(output0_storage, 256));
  return 0;
}
