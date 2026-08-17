/* DMA-machine adaptation of kernel/proc.c + syscall.c + sysproc.c (see
 * xv6/PORT.md: those files are REPLACED by this one — upstream's are
 * built around per-process kernel stacks, swtch, paging and multi-hart
 * spinlocks, none of which exist here). The xv6 shapes survive:
 * struct proc with the upstream state enum, sleep/wakeup on a channel,
 * exit/wait with ZOMBIE reaping, a round-robin scheduler(), and the
 * syscall numbering from the upstream kernel/syscall.h.
 *
 * The one deep difference: this kernel has NO per-process kernel
 * context, so it runs to completion on every entry (and is compiled
 * without safepoints — not preemptible). A syscall that must block
 * cannot sleep inside C and later resume mid-function; instead it
 * records what it waits for and returns-with-switch, and the EVENT
 * deposits the return value into the sleeper's mailbox before waking
 * it (exit() deposits the child pid + status into the parent waiting
 * in wait()). The woken process resumes at its syscall return address
 * with the answer already in its mailbox.
 *
 * Entry/exit protocol with kernel.dasm:
 *  - dma_ktick(): a tick detour. The dasm stub already EOI'd curr's
 *    dispatch and saved its resume into curResume.
 *  - dma_ksyscall(): a voluntary call; curr's return address is in
 *    curr's lr word.
 *  - Both end in kexit(): pick next, publish the cur* words and
 *    nextResume to the dasm side, retarget the tick injector at next's
 *    dispatch, re-arm if a fire was consumed.
 *
 * Tick accounting is airtight under the single-fire discipline (the
 * injector is one-shot and only re-armed here): on entry the injector
 * is retargeted at the kernel-owned `tickpending` word so fires during
 * kernel execution land harmlessly; fires that landed on curr's
 * dispatch just before entry are detected by comparing the dispatch
 * word against the thunk. Every fire is therefore consumed exactly
 * once: by the dasm detour, by the dispatch-word check, or by the
 * tickpending check at entry and exit.
 *
 * Loader-patched: the kw_* pointers (kernel.dasm words) and the proc
 * table (addresses inside each process image; see struct proc). A fire
 * always writes the address of kernel.dasm's vecSched (nonzero), which
 * is all the tickpending check relies on.
 */
#include "kernel/types.h"
#include "kernel/syscall.h"

extern volatile unsigned int __dma_uart_dr; /* mapped to UART0 DR by dmacc */
extern volatile unsigned int __dma_uart_fr; /* mapped to UART0 FR */

#define NPROC 8

struct dma_sysmail {
  uint num, a0, a1, a2, ret, done;
};

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

/* All-uint layout: the loader pokes fields by word offset (0..11).
 * The address-valued fields point into the process image: its
 * dispatch/irqresume/lr register-bank words, its crt0 resume thunk,
 * and its usys mailbox (0 for processes that never syscall). */
struct proc {
  uint state;      /* 0: enum procstate */
  uint pid;        /* 1 */
  uint ppid;       /* 2 */
  uint chan;       /* 3: sleep channel (an address token, 0 = none) */
  uint wake_tick;  /* 4: for sleeps on &ticks */
  uint xstate;     /* 5: exit status (int) */
  uint pdispatch;  /* 6 */
  uint pirqresume; /* 7 */
  uint plr;        /* 8 */
  uint thunk;      /* 9 */
  uint resume;     /* 10: where this proc continues when scheduled */
  uint pmail;      /* 11 */
};

struct proc proc[NPROC];
uint curr;
uint ticks;

/* kernel.dasm interface words (loader-patched pointers). */
uint *volatile kw_pcurdisp;
uint *volatile kw_curthunk;
uint *volatile kw_pcurresume;
uint *volatile kw_curresume;
uint *volatile kw_nextresume;
uint *volatile kw_khalt; /* &kernel.dasm khalt: park when nothing runnable */

/* Absorbs injector fires that land while the kernel is running. */
uint tickpending;

/* --- Process creation (Phase 5e): image registry + region allocator.
 * The registry rows are pre-parsed DMX images (segments + a packed
 * relocation table + the symbol offsets the kernel needs), poked by
 * the loader/dmxgen at generation time; exec() places a fresh copy
 * with the bump allocator and applies the relocations — the loader
 * now lives in the kernel. Packed reloc word: bit31 = target segment
 * (0 text, 1 data), bit30 = referenced segment, low 30 bits = byte
 * offset within the target segment. */
#define NIMG 4

struct kimg {
  char name[12];
  uint text, textlen; /* blob source (flash or RAM) + byte length */
  uint data, datalen;
  uint textlink, datalink;
  uint relocs, nreloc;
  uint entryoff;  /* text-rel: crt0's warmstart (dispatch preset here) */
  uint thunkoff;  /* text-rel */
  uint dispoff, irqoff, lroff, mailoff, sysoff; /* data-rel */
};

struct kimg kimages[NIMG];
uint k_sysentry;        /* loader-patched: &kernel.dasm sys_entry */
uint nextpid;           /* loader-patched: first unused pid */
uint arena, arena_end;  /* loader-patched: exec placement region */

static uint
kalloc(uint n)
{
  n = (n + 0xFFu) & ~0xFFu;
  if (arena + n > arena_end)
    return 0;
  uint a = arena;
  arena += n;
  return a; /* bump only; exec'd images are never freed yet */
}

static struct kimg *
lookup(const char *name)
{
  for (int i = 0; i < NIMG; i++) {
    struct kimg *im = &kimages[i];
    if (!im->name[0])
      break;
    int ok = 1;
    for (int j = 0; j < 12; j++) {
      if (im->name[j] != name[j]) {
        ok = 0;
        break;
      }
      if (!im->name[j])
        break;
    }
    if (ok)
      return im;
  }
  return 0;
}

/* Releases a vfork parent (sleeping on the child's proc struct) when
 * the child execs or exits, depositing the child pid — the parent's
 * fork() return value — into its mailbox. */
static void
vfork_release(struct proc *p)
{
  for (int i = 0; i < NPROC; i++) {
    struct proc *q = &proc[i];
    if (q->state == SLEEPING && q->chan == (uint)p) {
      volatile struct dma_sysmail *qm = (volatile struct dma_sysmail *)q->pmail;
      qm->ret = p->pid;
      q->chan = 0;
      q->state = RUNNABLE;
    }
  }
}

/* Tick injector: ABI channel 3, family-common register addresses. */
#define INJ_WRITE_ADDR (*(volatile uint *)0x500000C4u)  /* CH3 WRITE_ADDR */
#define INJ_COUNT_TRIG (*(volatile uint *)0x500000DCu)  /* CH3 AL1_TRANS_COUNT_TRIG */

#define W(a) (*(volatile uint *)(a))

static uint rearm;

static void
tick_income(void)
{
  ticks++;
  rearm = 1;
  /* wakeup(&ticks): timer sleepers whose deadline passed. */
  for (int i = 0; i < NPROC; i++) {
    struct proc *p = &proc[i];
    if (p->state == SLEEPING && p->chan == (uint)&ticks &&
        (int)(ticks - p->wake_tick) >= 0) {
      p->chan = 0;
      p->state = RUNNABLE;
    }
  }
}

/* Consume any fire that landed on curr's dispatch word or in
 * tickpending, then aim in-kernel fires at tickpending. */
static void
kenter(void)
{
  rearm = 0;
  struct proc *p = &proc[curr];
  if (W(p->pdispatch) != p->thunk) { /* fire landed just before entry */
    W(p->pdispatch) = p->thunk;
    tick_income();
  }
  INJ_WRITE_ADDR = (uint)&tickpending;
  if (tickpending) {
    tickpending = 0;
    tick_income();
  }
}

/* Round-robin: next RUNNABLE slot after curr (curr itself last). */
static int
pick(void)
{
  for (int off = 1; off <= NPROC; off++) {
    int i = (int)(curr + (uint)off) % NPROC;
    if (proc[i].state == RUNNABLE)
      return i;
  }
  return -1;
}

/* Publish `next` to the dasm side and leave the kernel. `resume` is
 * where next continues (its saved resume, or for the non-switch case
 * the caller's syscall return address). */
static void
kexit(uint next, uint resume)
{
  struct proc *p = &proc[next];
  curr = next;
  *kw_pcurdisp = p->pdispatch;
  *kw_curthunk = p->thunk;
  *kw_pcurresume = p->pirqresume;
  *kw_nextresume = resume;
  INJ_WRITE_ADDR = p->pdispatch;
  if (tickpending) { /* fired while the kernel ran */
    tickpending = 0;
    tick_income();
  }
  if (rearm)
    INJ_COUNT_TRIG = 1;
}

/* Switch away from curr (already saved / no longer runnable). */
static void
swtch(void)
{
  int next = pick();
  if (next < 0) {
    /* Nothing runnable: park at kernel.dasm's halt block. A live
     * system keeps an always-runnable process (idle/shell). */
    kexit(curr, (uint)kw_khalt);
    return;
  }
  kexit((uint)next, proc[next].resume);
}

/* sleep(chan) — xv6's, minus the lock and the kernel-stack blocking:
 * the caller's syscall return address becomes its resume point. */
static void
sleep(uint chan)
{
  struct proc *p = &proc[curr];
  p->resume = W(p->plr);
  p->chan = chan;
  p->state = SLEEPING;
}

static void
wakeup(uint chan)
{
  for (int i = 0; i < NPROC; i++) {
    if (proc[i].state == SLEEPING && proc[i].chan == chan) {
      proc[i].chan = 0;
      proc[i].state = RUNNABLE;
    }
  }
}

void
dma_ktick(void)
{
  kenter();
  tick_income(); /* the delivered detour that brought us here */
  struct proc *p = &proc[curr];
  p->resume = *kw_curresume; /* saved by the dasm stub */
  if (p->state == RUNNING)
    p->state = RUNNABLE;
  swtch();
}

void
dma_ksyscall(void)
{
  kenter();
  struct proc *p = &proc[curr];
  volatile struct dma_sysmail *m = (volatile struct dma_sysmail *)p->pmail;
  uint ret = (uint)-1;
  int block = 0; /* handler slept/exited: switch instead of return */

  switch (m->num) {
  case SYS_getpid:
    ret = p->pid;
    break;
  case SYS_uptime:
    ret = ticks;
    break;
  case SYS_write: { /* fd ignored until the file layer exists */
    char *b = (char *)m->a1;
    for (uint i = 0; i < m->a2; i++) {
      while (__dma_uart_fr & (1u << 5)) /* TXFF */
        ;
      __dma_uart_dr = (uchar)b[i];
    }
    ret = m->a2;
    break;
  }
  case SYS_pause: /* sleep a0 ticks on &ticks (upstream sys_sleep) */
    p->wake_tick = ticks + m->a0;
    sleep((uint)&ticks);
    ret = 0;
    block = 1;
    break;
  case SYS_wait: { /* a0: int* status (0 = don't care) */
    int have = 0, zomb = -1;
    for (int i = 0; i < NPROC; i++) {
      if (proc[i].state != UNUSED && proc[i].ppid == p->pid) {
        have = 1;
        if (proc[i].state == ZOMBIE)
          zomb = i;
      }
    }
    if (zomb >= 0) { /* reap immediately */
      if (m->a0)
        W(m->a0) = proc[zomb].xstate;
      ret = proc[zomb].pid;
      proc[zomb].state = UNUSED;
    } else if (!have) {
      ret = (uint)-1;
    } else { /* block; the exiting child deposits ret and *status */
      sleep((uint)p);
      block = 1;
      ret = m->ret; /* keep whatever the depositor will write */
    }
    break;
  }
  case SYS_fork: { /* vfork semantics: shared image, parent suspended
                    * until the child execs or exits. The shared
                    * mailbox works because the child runs first and
                    * reads 0 before the release deposits the pid. */
    int ci = -1;
    for (int i = 0; i < NPROC; i++) {
      if (proc[i].state == UNUSED) {
        ci = i;
        break;
      }
    }
    if (ci < 0) {
      ret = (uint)-1;
      break;
    }
    struct proc *c = &proc[ci];
    *c = *p;
    c->pid = nextpid++;
    c->ppid = p->pid;
    c->chan = 0;
    c->state = RUNNABLE;
    c->resume = W(p->plr);
    p->resume = W(p->plr);
    p->chan = (uint)c;
    p->state = SLEEPING;
    ret = 0;
    block = 1;
    break;
  }
  case SYS_exec: { /* a0: image name (argv not passed yet) */
    struct kimg *im = lookup((const char *)m->a0);
    if (!im) {
      ret = (uint)-1;
      break;
    }
    uint tb = kalloc(im->textlen), db = kalloc(im->datalen);
    if (!tb || !db) {
      ret = (uint)-1;
      break;
    }
    uint *src = (uint *)im->text, *dst = (uint *)tb;
    for (uint n = 0; n < im->textlen; n += 4)
      *dst++ = *src++;
    src = (uint *)im->data, dst = (uint *)db;
    for (uint n = 0; n < im->datalen; n += 4)
      *dst++ = *src++;
    uint tD = tb - im->textlink, dD = db - im->datalink;
    uint *rl = (uint *)im->relocs;
    for (uint n = 0; n < im->nreloc; n++) {
      uint r = rl[n];
      uint tgt = ((r & 0x80000000u) ? db : tb) + (r & 0x3FFFFFFFu);
      W(tgt) += (r & 0x40000000u) ? dD : tD;
    }
    p->pdispatch = db + im->dispoff;
    p->pirqresume = db + im->irqoff;
    p->plr = db + im->lroff;
    p->thunk = tb + im->thunkoff;
    p->pmail = db + im->mailoff;
    W(db + im->sysoff) = k_sysentry;
    W(p->pdispatch) = p->thunk; /* preset; entryoff skips crt0's write */
    vfork_release(p);
    /* exec does not return: continue at the fresh image's crt0. */
    p->state = RUNNING;
    kexit(curr, tb + im->entryoff);
    return;
  }
  case SYS_exit: {
    p->xstate = m->a0;
    vfork_release(p); /* exit also ends a pre-exec vfork suspension */
    /* If the parent is blocked in wait() on us, deposit and wake:
     * this IS the reap (the parent cannot re-run its scan). */
    int reaped = 0;
    for (int i = 0; i < NPROC; i++) {
      struct proc *q = &proc[i];
      if (q->pid == p->ppid && q->state == SLEEPING && q->chan == (uint)q) {
        volatile struct dma_sysmail *qm = (volatile struct dma_sysmail *)q->pmail;
        if (qm->a0)
          W(qm->a0) = p->xstate;
        qm->ret = p->pid;
        q->chan = 0;
        q->state = RUNNABLE;
        reaped = 1;
        break;
      }
    }
    p->state = reaped ? UNUSED : ZOMBIE;
    block = 1;
    break;
  }
  }

  if (!block) {
    m->ret = ret;
    m->done = 1;
    p->state = RUNNING;
    kexit(curr, W(p->plr));
    return;
  }
  if (p->state == SLEEPING)
    m->ret = ret; /* pause/wait: value for when the sleeper resumes */
  m->done = 1;
  swtch();
}

/* GC anchor only: makes both kernel entries reachable from the dmacc
 * entry point. Never executed — the kernel is entered via the dasm
 * stubs, not via crt0. */
int
kmain(void)
{
  dma_ktick();
  dma_ksyscall();
  return 0;
}
