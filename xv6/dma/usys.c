/* DMA-machine replacement for user/usys.pl's ecall stubs (not from
 * upstream xv6): the "syscall instruction" of this machine.
 *
 * A syscall stores its number and arguments into the process's mailbox
 * and then CALLS the kernel's per-process syscall vector (sys_from_a/b
 * in kernel.dasm) as a plain indirect function call. Unlike a trap,
 * a syscall is voluntary, so nothing needs the dispatch word: the
 * kernel stub returns (or, for yield/exit, switches away and later
 * resumes) through this process's lr, and pending scheduler ticks are
 * untouched — they deliver at the next safepoint as usual. This keeps
 * the syscall path completely free of races against the tick injectors.
 *
 * Loader-patched: __dma_syscall_entry (this instance's kernel vector).
 */
#include "kernel/types.h"
#include "kernel/syscall.h"

struct dma_sysmail {
  uint num, a0, a1, a2, ret, done;
};

volatile struct dma_sysmail __dma_sysmail;
uint __dma_syscall_entry;

static int
dma_syscall(uint num, uint a0, uint a1, uint a2)
{
  volatile struct dma_sysmail *m = &__dma_sysmail;
  m->num = num;
  m->a0 = a0;
  m->a1 = a1;
  m->a2 = a2;
  m->done = 0;
  ((void (*)(void))__dma_syscall_entry)();
  return (int)m->ret;
}

int
write(int fd, const void *buf, int n)
{
  return dma_syscall(SYS_write, (uint)fd, (uint)buf, (uint)n);
}

int
getpid(void)
{
  return dma_syscall(SYS_getpid, 0, 0, 0);
}

int
uptime(void)
{
  return dma_syscall(SYS_uptime, 0, 0, 0);
}

/* Interim semantics (real proc states arrive with the proc.c port):
 * pause(n) yields the processor once regardless of n. */
int
pause(int n)
{
  return dma_syscall(SYS_pause, (uint)n, 0, 0);
}

/* Interim: an exited process is switched away from but stays in the
 * round-robin, parked in a safepointed spin. */
void
exit(int status)
{
  dma_syscall(SYS_exit, (uint)status, 0, 0);
  for (;;)
    ;
}
