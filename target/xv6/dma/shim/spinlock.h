/* DMA shim: single hart, non-preemptible kernel — locks are no-ops
 * with their API intact (xv6/PORT.md). */
#ifndef DMA_SHIM_SPINLOCK_H
#define DMA_SHIM_SPINLOCK_H
struct spinlock {
  char unused;
};
#endif
