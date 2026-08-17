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

/* Console read with blocking semantics: the kernel returns 0 while no
 * cooked line is available (its line discipline echoes and edits), so
 * poll once per tick. fd is ignored until the file layer exists. */
int
read(int fd, void *buf, int n)
{
  for (;;) {
    int r = dma_syscall(SYS_read, (uint)fd, (uint)buf, (uint)n);
    if (r != 0)
      return r;
    dma_syscall(SYS_pause, 1, 0, 0);
  }
}

/* Sleeps n ticks (upstream sys_sleep semantics; n=0 yields). */
int
pause(int n)
{
  return dma_syscall(SYS_pause, (uint)n, 0, 0);
}

/* Blocks until a child exits; the exiting child deposits its pid (the
 * return value) and status into this process's mailbox (kproc.c). */
int
wait(int *status)
{
  return dma_syscall(SYS_wait, (uint)status, 0, 0);
}

/* vfork semantics (xv6/PORT.md): the child shares the parent's image
 * and frames; the parent is suspended until the child calls exec() or
 * exit(). Between fork() and exec() the child must touch nothing else
 * — in particular it must not make other syscalls (see below). */
int
fork(void)
{
  return dma_syscall(SYS_fork, 0, 0, 0);
}

/* exec and exit do NOT go through dma_syscall: a vforked child shares
 * the parent's static frames, and re-entering dma_syscall would
 * overwrite the saved return address the suspended parent resumes
 * through. Each gets a private invocation with its own frame. */

/* argv is accepted for the upstream signature but not passed yet. */
int
exec(const char *path, char **argv)
{
  volatile struct dma_sysmail *m = &__dma_sysmail;
  m->num = SYS_exec;
  m->a0 = (uint)path;
  m->a1 = (uint)argv;
  m->a2 = 0;
  m->done = 0;
  ((void (*)(void))__dma_syscall_entry)();
  return (int)m->ret; /* reached only on failure */
}

/* Never returns: the kernel marks the process ZOMBIE (or reaps it
 * straight into a waiting parent) and never schedules it again. The
 * trailing loop is unreachable-by-construction safety. */
void
exit(int status)
{
  volatile struct dma_sysmail *m = &__dma_sysmail;
  m->num = SYS_exit;
  m->a0 = (uint)status;
  m->a1 = 0;
  m->a2 = 0;
  m->done = 0;
  ((void (*)(void))__dma_syscall_entry)();
  for (;;)
    ;
}
