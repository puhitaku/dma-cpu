/* kconsstub.c: the no-console-DMA twin of kcons.c, kfsstub-style.
 * Lean kernels (and boards without the three spare channels) link
 * this; kproc.c then keeps its classic polling paths and every fire
 * is a timer tick. */
#include "kernel/types.h"

int
kcons_on(void)
{
  return 0;
}

int
kcons_tx(uint b)
{
  (void)b;
  return 0;
}

int
kcons_rx(void)
{
  return -2;
}

void
kcons_kick(void)
{
}

void
kcons_aim(uint addr)
{
  (void)addr;
}
