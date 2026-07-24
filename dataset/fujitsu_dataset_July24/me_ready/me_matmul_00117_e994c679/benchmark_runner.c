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

static void fill_f8(uint8_t *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (uint8_t)(0x3Cu + ((i + (size_t)seed) % 2));
}

static long long checksum_u8(const uint8_t *b, size_t n) {
  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;
}

static void fill_f32(float *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (float)(((int)((i + (size_t)seed) % 23)) - 11) / 7.0f;
}

static double checksum_f32(const float *b, size_t n) {
  double s = 0.0; for (size_t i = 0; i < n; ++i) s += (double)b[i]; return s;
}

static uint8_t input0_storage[983040] __attribute__((aligned(64)));
static uint8_t input1_storage[327680] __attribute__((aligned(64)));
static float input2_storage[196608] __attribute__((aligned(64)));
static float output0_storage[196608] __attribute__((aligned(64)));

extern void kernel(uint8_t *arg0_allocated, uint8_t *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_stride0, int64_t arg0_stride1, uint8_t *arg1_allocated, uint8_t *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_size1, int64_t arg1_stride0, int64_t arg1_stride1, float *arg2_allocated, float *arg2_aligned, int64_t arg2_offset, int64_t arg2_size0, int64_t arg2_size1, int64_t arg2_stride0, int64_t arg2_stride1, float *result0_allocated, float *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_size1, int64_t result0_stride0, int64_t result0_stride1);

int main(void) {
  fill_f8(input0_storage, 983040, 1);
  fill_f8(input1_storage, 327680, 2);
  fill_f32(input2_storage, 196608, 3);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 768, 1280, 1280, 1, input1_storage, input1_storage, 0, 1280, 256, 256, 1, input2_storage, input2_storage, 0, 768, 256, 256, 1, output0_storage, output0_storage, 0, 768, 256, 256, 1);
  ofa_dma_memory_fence();
  puts("me_matmul_00117_e994c679: benchmark completed");
  printf("output0_f32_checksum=%.10e\n", checksum_f32(output0_storage, 196608));
  return 0;
}
