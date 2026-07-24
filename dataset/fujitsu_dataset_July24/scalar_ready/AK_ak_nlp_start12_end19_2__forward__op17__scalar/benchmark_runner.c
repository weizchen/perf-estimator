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

static void fill_i64(int64_t *b, size_t n, int seed) {
  for (size_t i = 0; i < n; ++i) b[i] = (int64_t)((i + (size_t)seed) % 7);
}

static long long checksum_i64(const int64_t *b, size_t n) {
  long long s = 0; for (size_t i = 0; i < n; ++i) s += (long long)b[i]; return s;
}

static int64_t input0_storage[64] __attribute__((aligned(64)));
static int64_t input1_storage[4096] __attribute__((aligned(64)));
static int64_t output0_storage[4096] __attribute__((aligned(64)));

extern void kernel(int64_t *arg0_allocated, int64_t *arg0_aligned, int64_t arg0_offset, int64_t arg0_size0, int64_t arg0_size1, int64_t arg0_size2, int64_t arg0_size3, int64_t arg0_stride0, int64_t arg0_stride1, int64_t arg0_stride2, int64_t arg0_stride3, int64_t *arg1_allocated, int64_t *arg1_aligned, int64_t arg1_offset, int64_t arg1_size0, int64_t arg1_size1, int64_t arg1_size2, int64_t arg1_size3, int64_t arg1_stride0, int64_t arg1_stride1, int64_t arg1_stride2, int64_t arg1_stride3, int64_t *result0_allocated, int64_t *result0_aligned, int64_t result0_offset, int64_t result0_size0, int64_t result0_size1, int64_t result0_size2, int64_t result0_size3, int64_t result0_stride0, int64_t result0_stride1, int64_t result0_stride2, int64_t result0_stride3);

int main(void) {
  fill_i64(input0_storage, 64, 1);
  fill_i64(input1_storage, 4096, 2);
  memset(output0_storage, 0, sizeof(output0_storage));
  ofa_dma_memory_fence();
  kernel(input0_storage, input0_storage, 0, 1, 1, 1, 64, 64, 64, 64, 1, input1_storage, input1_storage, 0, 1, 1, 64, 64, 4096, 4096, 64, 1, output0_storage, output0_storage, 0, 1, 1, 64, 64, 4096, 4096, 64, 1);
  ofa_dma_memory_fence();
  puts("AK_ak_nlp_start12_end19_2__forward__op17__scalar: benchmark completed");
  printf("output0_i64_checksum=%lld\n", checksum_i64(output0_storage, 4096));
  return 0;
}
