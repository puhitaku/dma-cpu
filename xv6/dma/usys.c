/* DMA-machine replacement for user/usys.pl's ecall stubs (not from
 * upstream xv6): the "syscall instruction" of this machine.
 *
 * A syscall writes the process's mailbox and TAIL-CALLS the kernel
 * vector: dmacc's tail-call optimization turns `return dma_trap()`
 * into a jump with the caller's lr intact, so these wrappers have NO
 * frames at all — the kernel returns straight to the wrapper's caller
 * with the result already in r0 and mail.ret. Framelessness is what
 * makes the whole syscall layer safe under vfork: a child sharing the
 * parent's image can make any syscall without clobbering a frame the
 * suspended parent resumes through (prompts/018).
 *
 * Loader-patched: __dma_syscall_entry (kernel.dasm sys_entry).
 */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/syscall.h"

struct dma_sysmail {
  uint num, a0, a1, a2, ret, done;
};

volatile struct dma_sysmail __dma_sysmail;
uint __dma_syscall_entry;

/* The trap itself: a tail call all the way into the kernel. */
static int
dma_trap(void)
{
  return ((int (*)(void))__dma_syscall_entry)();
}

static void
fill(uint num, uint a0, uint a1, uint a2)
{
  volatile struct dma_sysmail *m = &__dma_sysmail;
  m->num = num;
  m->a0 = a0;
  m->a1 = a1;
  m->a2 = a2;
}

int
write(int fd, const void *buf, int n)
{
  fill(SYS_write, (uint)fd, (uint)buf, (uint)n);
  return dma_trap();
}

int
getpid(void)
{
  fill(SYS_getpid, 0, 0, 0);
  return dma_trap();
}

int
uptime(void)
{
  fill(SYS_uptime, 0, 0, 0);
  return dma_trap();
}

/* Sleeps n ticks (upstream sys_sleep semantics; n=0 yields). */
int
pause(int n)
{
  fill(SYS_pause, (uint)n, 0, 0);
  return dma_trap();
}

/* Console read with blocking semantics: the kernel returns 0 while no
 * cooked line is available (its line discipline echoes and edits), so
 * poll once per tick. fd is ignored until the file layer exists. */
int
read(int fd, void *buf, int n)
{
  for (;;) {
    fill(SYS_read, (uint)fd, (uint)buf, (uint)n);
    int r = dma_trap();
    if (r != -2) /* -2: console has no cooked line yet; 0 is EOF */
      return r;
    fill(SYS_pause, 1, 0, 0);
    dma_trap();
  }
}

/* vfork semantics (xv6/PORT.md): the child shares the parent's image
 * and frames; the parent is suspended until the child calls exec() or
 * exit(). With frameless wrappers the child may use any syscall in
 * between; it must only avoid clobbering the parent's live locals. */
int
fork(void)
{
  fill(SYS_fork, 0, 0, 0);
  return dma_trap();
}

/* Blocks until a child exits; the exiting child deposits its pid (the
 * return value) and status into this process's mailbox and r0. */
int
wait(int *status)
{
  fill(SYS_wait, (uint)status, 0, 0);
  return dma_trap();
}

/* argv is copied by the kernel into the fresh image (kproc.c). Only
 * returns on failure. */
int
exec(const char *path, char **argv)
{
  fill(SYS_exec, (uint)path, (uint)argv, 0);
  return dma_trap();
}

/* Never returns: the kernel marks the process ZOMBIE (or reaps it
 * straight into a waiting parent) and never schedules it again. The
 * trailing loop is unreachable-by-construction safety. */
void
exit(int status)
{
  fill(SYS_exit, (uint)status, 0, 0);
  dma_trap();
  for (;;)
    ;
}

/* File-layer syscalls sh.c and ulib.c reference: the kernel answers
 * -1 until fs.c is ported (sh degrades gracefully — redirection and
 * pipes report failure, `cd` prints its error). */
int
open(const char *path, int mode)
{
  fill(SYS_open, (uint)path, (uint)mode, 0);
  return dma_trap();
}

int
close(int fd)
{
  fill(SYS_close, (uint)fd, 0, 0);
  return dma_trap();
}

int
dup(int fd)
{
  fill(SYS_dup, (uint)fd, 0, 0);
  return dma_trap();
}

int
pipe(int *p)
{
  fill(SYS_pipe, (uint)p, 0, 0);
  return dma_trap();
}

int
chdir(const char *path)
{
  fill(SYS_chdir, (uint)path, 0, 0);
  return dma_trap();
}

int
fstat(int fd, struct stat *st)
{
  fill(SYS_fstat, (uint)fd, (uint)st, 0);
  return dma_trap();
}

int
sync(void)
{
  fill(SYS_sync, 0, 0, 0);
  return dma_trap();
}

int
link(const char *old, const char *new)
{
  fill(SYS_link, (uint)old, (uint)new, 0);
  return dma_trap();
}

int
unlink(const char *path)
{
  fill(SYS_unlink, (uint)path, 0, 0);
  return dma_trap();
}

int
mkdir(const char *path)
{
  fill(SYS_mkdir, (uint)path, 0, 0);
  return dma_trap();
}

int
kill(int pid)
{
  fill(SYS_kill, (uint)pid, 0, 0);
  return dma_trap();
}

/* ulib.c's sbrk()/sbrklazy() wrap this. */
char *
sys_sbrk(int n, int flags)
{
  fill(SYS_sbrk, (uint)n, (uint)flags, 0);
  return (char *)dma_trap();
}

/* --- SIGINT with user-space handlers (prompts/026) ---
 * signal() deposits this context with the kernel; on delivery the
 * kernel diverts the process's next resume into __dma_sigentry after
 * saving r0/r1 and the original resume point here. The stub runs the
 * handler and SYS_sigreturn restores everything. Handlers run on the
 * interrupted context's static frames: keep them to leaf work (the
 * frameless syscall wrappers, flags) or exit. */
struct dma_sigctx {
  uint entry;  /* &__dma_sigentry */
  uint resume; /* kernel-saved: the interrupted resume point */
  uint save0, save1; /* kernel-saved r0/r1 */
};
static struct dma_sigctx __dma_sigctx;
static void (*__dma_sig_fn)(int);

static void
__dma_sigentry(void)
{
  (*__dma_sig_fn)(2 /* SIGINT (user.h) */);
  fill(SYS_sigreturn, 0, 0, 0);
  dma_trap(); /* does not return: the kernel resumes the interrupted
               * point with r0/r1 restored */
}

/* dmacc's bounded-recursion sink (depth-K clones exhausted): die as a
 * process instead of halting the whole machine — deeply nested sh
 * subshells overflow in the vfork child and the shell survives. Must
 * not return. */
void
__dmacc_recursion_overflow(void)
{
  write(2, "recursion too deep\n", 19);
  exit(-2);
}

int
signal(int sig, void (*fn)(int))
{
  (void)sig; /* SIGINT is the only signal */
  __dma_sig_fn = fn;
  __dma_sigctx.entry = (uint)__dma_sigentry;
  fill(SYS_signal, (uint)sig, 0, fn ? (uint)&__dma_sigctx : 0);
  return dma_trap();
}
