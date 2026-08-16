/* DMA-machine addition (not from upstream xv6): sbrk backing
 * user/umalloc.c before real process memory management exists. The
 * "process heap" is a static arena inside the image — consistent with
 * the no-MMU model where a process is a relocated image. */
#include "kernel/types.h"

#define DMA_HEAP_SIZE 36864 /* >= NALLOC(4096) * sizeof(Header)(8) */

static char dma_heap[DMA_HEAP_SIZE];
static uint dma_brk;

char *
sbrk(int n)
{
  if (n < 0 || dma_brk + (uint)n > DMA_HEAP_SIZE)
    return (char *)-1;
  char *p = dma_heap + dma_brk;
  dma_brk += (uint)n;
  return p;
}
