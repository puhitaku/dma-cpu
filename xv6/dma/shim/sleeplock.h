/* DMA shim: the kernel runs to completion; sleep-locks are no-ops. */
#ifndef DMA_SHIM_SLEEPLOCK_H
#define DMA_SHIM_SLEEPLOCK_H
struct sleeplock {
  char unused;
};
#endif
