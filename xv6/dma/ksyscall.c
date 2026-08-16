/* DMA-machine addition (not from upstream xv6): the interim kernel-side
 * syscall core, called from kernel.dasm's sys_from_* stubs with the
 * caller id in r0. Compiled WITHOUT safepoints: the kernel is not
 * preemptible; ticks arriving during a syscall patch the (not-running)
 * process dispatches and deliver at the caller's next safepoint.
 *
 * Syscall numbers come from the upstream kernel/syscall.h. This file
 * is the seed of the syscall.c/sysproc.c adaptation (xv6/PORT.md): the
 * dispatch table shape will migrate to upstream's once struct proc
 * exists.
 *
 * Loader-patched globals: dma_mail[2] (each process's __dma_sysmail),
 * dma_wsw (kernel.dasm's want-switch word), dma_ticks (its tick
 * counter).
 */
#include "kernel/types.h"
#include "kernel/syscall.h"

extern volatile unsigned int __dma_uart_dr; /* mapped to UART0 DR by dmacc */
extern volatile unsigned int __dma_uart_fr; /* mapped to UART0 FR */

struct dma_sysmail {
  uint num, a0, a1, a2, ret, done;
};

struct dma_sysmail *volatile dma_mail[2];
uint *volatile dma_wsw;
uint *volatile dma_ticks;

int dma_exit_status[2];

int
dma_ksyscall(int caller) /* return value unused by the dasm stub */
{
  volatile struct dma_sysmail *m = dma_mail[caller];
  *dma_wsw = 0;
  uint ret = (uint)-1;
  switch (m->num) {
  case SYS_getpid:
    ret = (uint)caller + 1;
    break;
  case SYS_uptime:
    ret = *dma_ticks;
    break;
  case SYS_write: { /* fd ignored until the file layer exists */
    char *p = (char *)m->a1;
    for (uint i = 0; i < m->a2; i++) {
      while (__dma_uart_fr & (1u << 5)) /* TXFF */
        ;
      __dma_uart_dr = (uchar)p[i];
    }
    ret = m->a2;
    break;
  }
  case SYS_pause: /* interim: yield once (see usys.c) */
    m->ret = 0;
    m->done = 1;
    *dma_wsw = 1;
    return 0;
  case SYS_exit:
    dma_exit_status[caller] = (int)m->a0;
    m->ret = 0;
    m->done = 1;
    *dma_wsw = 1; /* switch away; interim parking, see usys.c */
    return 0;
  }
  m->ret = ret;
  m->done = 1;
  return 0;
}
