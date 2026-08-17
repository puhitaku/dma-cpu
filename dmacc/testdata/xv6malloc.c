/* Exercises xv6's user/umalloc.c (K&R allocator) running on the DMA
   machine — the first upstream xv6 code through the pipeline. Fully
   self-checking: returns 0xC0FFEE on success, a small error code on
   the first failed invariant. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

volatile uint seed = 12345;

/* ulib.c owns sbrk() now (wrapping sys_sbrk); this test links
   umalloc + string.c without ulib, so provide the wrapper here. */
char *
sbrk(int n)
{
  return sys_sbrk(n, 0);
}

int
main(void)
{
  void *blk[12];
  uint sizes[12];
  uint s = seed;

  /* allocate twelve blocks of pseudo-random size, fill with patterns */
  for (int i = 0; i < 12; i++) {
    s = s * 1103515245 + 12345;
    sizes[i] = 8 + (s >> 16) % 200;
    blk[i] = malloc(sizes[i]);
    if (!blk[i])
      return 1;
    memset(blk[i], 0x40 + i, sizes[i]);
  }
  /* free the even ones, allocate again (exercises coalescing/reuse) */
  for (int i = 0; i < 12; i += 2)
    free(blk[i]);
  for (int i = 0; i < 12; i += 2) {
    blk[i] = malloc(sizes[i] / 2 + 4);
    if (!blk[i])
      return 2;
    memset(blk[i], 0x60 + i, sizes[i] / 2 + 4);
    sizes[i] = sizes[i] / 2 + 4;
  }
  /* verify every surviving pattern byte */
  for (int i = 0; i < 12; i++) {
    uchar want = (uchar)((i % 2) ? 0x40 + i : 0x60 + i);
    uchar *p = (uchar *)blk[i];
    for (uint j = 0; j < sizes[i]; j++)
      if (p[j] != want)
        return 3;
  }
  for (int i = 0; i < 12; i++)
    free(blk[i]);
  /* after freeing everything, one big block must fit again */
  if (!malloc(4000))
    return 4;
  return 0xC0FFEE;
}
