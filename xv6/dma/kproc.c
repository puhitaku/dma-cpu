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

/* --- The file layer (Phase 7): verbatim fs.c/file.c + glue. The
 * kernel mounts the RAM disk lazily on the first entry after the
 * loader configured dma_disk (kbio.c). --- */
extern uint dma_disk;
extern uint fsready;
extern void kfs_start(void);
extern void kfs_forkcopy(int parent, int child);
extern void kfs_exit(int slot);
extern int kfs_read(int fd, uint addr, int n);
extern int kfs_write(int fd, uint addr, int n);
extern int kfs_open(uint pathaddr, int omode);
extern int kfs_close(int fd);
extern int kfs_dup(int fd);
extern int kfs_fstat(int fd, uint staddr);
extern int kfs_pipe(uint fdarray);
extern int kfs_chdir(uint pathaddr);
extern int kfs_mkdir(uint pathaddr);
extern int kfs_link(uint oldaddr, uint newaddr);
extern int kfs_unlink(uint pathaddr);
extern uint kfs_iopen(const char *path);
extern int kfs_iread(uint ipu, uint off, uint dst, uint n);
extern void kfs_iclose(uint ipu);

/* Tick injector registers (family-common DMA base). Classic machines
 * use ABI channel 3; the compact machine's injector is channel 9
 * (emu/compact.go), so the loader patches these when the system runs
 * in Tier-C encoding. */
uint inj_wreg = 0x500000C4u; /* CH3 WRITE_ADDR */
uint inj_treg = 0x500000DCu; /* CH3 AL1_TRANS_COUNT_TRIG */
#define INJ_WRITE_ADDR (*(volatile uint *)inj_wreg)
#define INJ_COUNT_TRIG (*(volatile uint *)inj_treg)

#define W(a) (*(volatile uint *)(a))


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

/* First-fit allocator with coalescing over [arena, arena_end): each
 * block carries a one-word size header. exec() frees its relocation
 * scratch immediately and exit() frees the process image, so spawn
 * sessions no longer exhaust the arena (prompts/019). */
struct khdr {
  uint size;         /* bytes including the header */
  struct khdr *next; /* free list, address-ordered */
};
static struct khdr *kfreelist;
static uint kheap_init;

static uint
kalloc(uint n)
{
  if (!kheap_init) {
    kheap_init = 1;
    kfreelist = (struct khdr *)arena;
    kfreelist->size = arena_end - arena;
    kfreelist->next = 0;
  }
  n = ((n + 0xFFu) & ~0xFFu) + 0x100u; /* header burns one 256B unit */
  struct khdr **pp = &kfreelist;
  for (struct khdr *h = kfreelist; h; pp = &h->next, h = h->next) {
    if (h->size >= n) {
      if (h->size - n >= 0x200u) { /* split */
        struct khdr *rest = (struct khdr *)((uint)h + n);
        rest->size = h->size - n;
        rest->next = h->next;
        h->size = n;
        *pp = rest;
      } else {
        *pp = h->next;
      }
      return (uint)h + 0x100u;
    }
  }
  return 0;
}

static void
kfree(uint a)
{
  if (!a)
    return;
  struct khdr *h = (struct khdr *)(a - 0x100u);
  struct khdr *prev = 0;
  struct khdr *cur = kfreelist;
  while (cur && (uint)cur < (uint)h) {
    prev = cur;
    cur = cur->next;
  }
  h->next = cur;
  if (prev)
    prev->next = h;
  else
    kfreelist = h;
  if (cur && (uint)h + h->size == (uint)cur) { /* merge up */
    h->size += cur->size;
    h->next = cur->next;
  }
  if (prev && (uint)prev + prev->size == (uint)h) { /* merge down */
    prev->size += h->size;
    prev->next = h->next;
  }
}

/* Arena allocations owned by each slot's exec'd image (freed at exit
 * or on re-exec): text, data, argv area. */
static uint execmem[NPROC][3];

static void
kfree_exec(int slot)
{
  for (int i = 0; i < 3; i++) {
    kfree(execmem[slot][i]);
    execmem[slot][i] = 0;
  }
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

/* Completes a syscall for proc p: the return value goes into the
 * mailbox AND the image's r0 word — frameless usys wrappers tail-jump
 * into the kernel, so the kernel's return lands directly at the
 * wrapper's caller, which reads r0 per the ABI. */
static void
setret(struct proc *p, uint v)
{
  volatile struct dma_sysmail *m = (volatile struct dma_sysmail *)p->pmail;
  m->ret = v;
  m->done = 1;
  W(p->pdispatch - 0x54) = v; /* r0: regs base is 0x54 below dispatch */
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
      setret(q, p->pid);
      q->chan = 0;
      q->state = RUNNABLE;
    }
  }
}

static uint rearm;

/* --- Cooked console input (the consoleintr slice of kernel/console.c,
 * see xv6/PORT.md): SYS_read drains the UART RX FIFO through a line
 * discipline — echo, backspace editing, CR->NL — and hands out only
 * committed lines. There is no RX interrupt: draining happens on each
 * SYS_read poll (the usys read() wrapper retries once per tick). */
#define INPUT_BUF 128
static char cons_buf[INPUT_BUF];
static uint cons_r, cons_w, cons_e; /* read, committed, edit (free-running) */

static void
cputc(int c)
{
  if (c == '\n') {
    while (__dma_uart_fr & (1u << 5))
      ;
    __dma_uart_dr = '\r';
  }
  while (__dma_uart_fr & (1u << 5))
    ;
  __dma_uart_dr = (uchar)c;
}

/* Exported console I/O (also the devsw[CONSOLE] backend once the fs
 * is up): kconswrite paces cputc; kconsread hands out cooked lines,
 * -2 (EAGAIN) when none is ready — the usys read() wrapper retries. */
void
kconswrite(const char *b, int n)
{
  for (int i = 0; i < n; i++)
    cputc(b[i]);
}

static void cons_poll(void);

int
kconsread(uint dst, int n)
{
  cons_poll();
  if (cons_r == cons_w)
    return -2;
  char *d = (char *)dst;
  int got = 0;
  while (got < n && cons_r != cons_w) {
    char c = cons_buf[cons_r % INPUT_BUF];
    cons_r++;
    d[got++] = c;
    if (c == '\n')
      break;
  }
  return got;
}

static void
cons_poll(void)
{
  while (!(__dma_uart_fr & (1u << 4))) { /* RXFE clear: a byte waits */
    uint c = __dma_uart_dr & 0xFFu;
    if (c == '\r')
      c = '\n';
    if (c == '\b' || c == 0x7F) {
      if (cons_e != cons_w) {
        cons_e--;
        cputc('\b');
        cputc(' ');
        cputc('\b');
      }
      continue;
    }
    if (cons_e - cons_r < INPUT_BUF) {
      cons_buf[cons_e % INPUT_BUF] = (char)c;
      cons_e++;
      cputc((int)c);
      if (c == '\n' || cons_e - cons_r == INPUT_BUF)
        cons_w = cons_e;
    }
  }
}

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

/* The dispatch word the injector was aimed at when the kernel was
 * entered: a fire can land there between kenter's check and the
 * retarget, so kexit MUST re-check this exact address (not
 * proc[curr].pdispatch — exec repoints that mid-call). A fire missed
 * here would never be consumed and the timer would never re-arm:
 * this closed a real silicon hang (prompts/017). */
static uint entry_disp, entry_thunk;

/* Consume any fire that landed on curr's dispatch word or in
 * tickpending, then aim in-kernel fires at tickpending. */
static void
kenter(void)
{
  rearm = 0;
  if (!fsready && dma_disk)
    kfs_start();
  struct proc *p = &proc[curr];
  entry_disp = p->pdispatch;
  entry_thunk = p->thunk;
  if (W(entry_disp) != entry_thunk) { /* fire landed just before entry */
    W(entry_disp) = entry_thunk;
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
  /* Close the kenter window: a fire that hit the entry-time dispatch
   * between its check and the retarget. */
  if (entry_disp && W(entry_disp) != entry_thunk) {
    W(entry_disp) = entry_thunk;
    tick_income();
  }
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

/* --- Scheduler fence for the fs layer (kpipe.c): sleeper lookup,
 * mailbox access, deposit-completion, and voluntary blocking, without
 * exposing the ABI proc table. Mail fields: 1 a0, 2 a1, 3 a2, 4 ret,
 * 5 done. --- */
int
kfind_sleeper(uint chan)
{
  for (int i = 0; i < NPROC; i++)
    if (proc[i].state == SLEEPING && proc[i].chan == chan)
      return i;
  return -1;
}

static volatile struct dma_sysmail *
mailof(int slot)
{
  return (volatile struct dma_sysmail *)proc[slot].pmail;
}

uint
kmail_get(int slot, int field)
{
  volatile struct dma_sysmail *m = mailof(slot);
  switch (field) {
  case 1:
    return m->a0;
  case 2:
    return m->a1;
  case 3:
    return m->a2;
  case 4:
    return m->ret;
  }
  return m->done;
}

void
kmail_set(int slot, int field, uint v)
{
  volatile struct dma_sysmail *m = mailof(slot);
  switch (field) {
  case 2:
    m->a1 = v;
    break;
  case 3:
    m->a2 = v;
    break;
  case 5:
    m->done = v;
    break;
  }
}

void
kcomplete(int slot, uint ret)
{
  struct proc *q = &proc[slot];
  setret(q, ret);
  q->chan = 0;
  q->state = RUNNABLE;
}

int
kblock_self_slot(void)
{
  return (int)curr;
}

void
kblock_current(uint chan)
{
  sleep(chan);
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
  case SYS_write: {
    int r;
    if (fsready)
      r = kfs_write((int)m->a0, m->a1, (int)m->a2);
    else {
      kconswrite((const char *)m->a1, (int)m->a2);
      r = (int)m->a2;
    }
    if (r == -3)
      block = 1; /* pipe full: sleeping; the reader pulls + deposits */
    ret = (uint)r;
    break;
  }
  case SYS_open:
    ret = fsready ? (uint)kfs_open(m->a0, (int)m->a1) : (uint)-1;
    break;
  case SYS_close:
    ret = fsready ? (uint)kfs_close((int)m->a0) : (uint)-1;
    break;
  case SYS_dup:
    ret = fsready ? (uint)kfs_dup((int)m->a0) : (uint)-1;
    break;
  case SYS_fstat:
    ret = fsready ? (uint)kfs_fstat((int)m->a0, m->a1) : (uint)-1;
    break;
  case SYS_pipe:
    ret = fsready ? (uint)kfs_pipe(m->a0) : (uint)-1;
    break;
  case SYS_chdir:
    ret = fsready ? (uint)kfs_chdir(m->a0) : (uint)-1;
    break;
  case SYS_mkdir:
    ret = fsready ? (uint)kfs_mkdir(m->a0) : (uint)-1;
    break;
  case SYS_link:
    ret = fsready ? (uint)kfs_link(m->a0, m->a1) : (uint)-1;
    break;
  case SYS_unlink:
    ret = fsready ? (uint)kfs_unlink(m->a0) : (uint)-1;
    break;
  case SYS_read: {
    int r;
    if (fsready)
      r = kfs_read((int)m->a0, m->a1, (int)m->a2);
    else
      r = kconsread(m->a1, (int)m->a2);
    if (r == -3)
      block = 1; /* pipe: already sleeping; the peer deposits */
    ret = (uint)r;
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
    if (fsready)
      kfs_forkcopy((int)curr, ci);
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
  case SYS_exec: { /* a0: path (fs) or registry name; a1: argv */
    struct kimg fsim; /* header-backed row for the fs path */
    struct kimg *im = 0;
    uint tb = 0, db = 0;
    uint ipu = fsready ? kfs_iopen((const char *)m->a0) : 0;
    if (ipu) {
      /* DMX-exec file: 13-word header, then text, data, packed relocs
       * (the registry row shape, serialized — see fsimg). */
      uint hdr[13];
      if (kfs_iread(ipu, 0, (uint)hdr, 52) != 52 || hdr[0] != 0x58414D44u) {
        kfs_iclose(ipu);
        ret = (uint)-1;
        break;
      }
      fsim.textlen = hdr[1];
      fsim.datalen = hdr[2];
      fsim.textlink = hdr[3];
      fsim.datalink = hdr[4];
      fsim.nreloc = hdr[5];
      fsim.entryoff = hdr[6];
      fsim.thunkoff = hdr[7];
      fsim.dispoff = hdr[8];
      fsim.irqoff = hdr[9];
      fsim.lroff = hdr[10];
      fsim.mailoff = hdr[11];
      fsim.sysoff = hdr[12];
      tb = kalloc(fsim.textlen);
      db = kalloc(fsim.datalen);
      uint toff = 52, doff = toff + fsim.textlen, roff = doff + fsim.datalen;
      if (!tb || !db ||
          kfs_iread(ipu, toff, tb, fsim.textlen) != (int)fsim.textlen ||
          kfs_iread(ipu, doff, db, fsim.datalen) != (int)fsim.datalen) {
        kfree(tb);
        kfree(db);
        kfs_iclose(ipu);
        ret = (uint)-1;
        break;
      }
      /* Relocations stream from the file in small chunks — no arena
       * scratch (the pipe demo's peak lives on this). */
      {
        uint tD2 = tb - fsim.textlink, dD2 = db - fsim.datalink;
        uint rw[64];
        uint left = fsim.nreloc, off = roff;
        while (left > 0) {
          uint take = left > 64 ? 64 : left;
          if (kfs_iread(ipu, off, (uint)rw, take * 4) != (int)(take * 4))
            break;
          for (uint n = 0; n < take; n++) {
            uint r = rw[n];
            uint tgt = ((r & 0x80000000u) ? db : tb) + (r & 0x3FFFFFFFu);
            W(tgt) += (r & 0x40000000u) ? dD2 : tD2;
          }
          left -= take;
          off += take * 4;
        }
      }
      kfs_iclose(ipu);
      fsim.nreloc = 0; /* already applied */
      fsim.relocs = 0;
      im = &fsim;
    } else {
      im = lookup((const char *)m->a0);
      if (!im) {
        ret = (uint)-1;
        break;
      }
      tb = kalloc(im->textlen);
      db = kalloc(im->datalen);
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
    }
    uint tD = tb - im->textlink, dD = db - im->datalink;
    uint *rl = (uint *)im->relocs;
    for (uint n = 0; n < im->nreloc; n++) {
      uint r = rl[n];
      uint tgt = ((r & 0x80000000u) ? db : tb) + (r & 0x3FFFFFFFu);
      W(tgt) += (r & 0x40000000u) ? dD : tD;
    }
    kfree_exec((int)curr); /* a re-exec'd image releases its old one */
    execmem[curr][0] = tb;
    execmem[curr][1] = db;
    /* argv: copy the caller's vector + strings into a fresh area and
     * pass argc/argv through the image's r0/r1 register words (crt0's
     * `call main` leaves them untouched; .regs zero-init means plain
     * loads see argc=0). The regs bank sits 0x54 below dispatch. */
    uint argc = 0, argvdst = 0;
    if (m->a1) {
      uint area = kalloc(256);
      if (area) {
        uint *av = (uint *)m->a1;
        uint *slots = (uint *)area;
        char *sp = (char *)(area + 16 * 4);
        char *lim = (char *)(area + 256) - 1;
        while (argc < 15 && av[argc]) {
          char *s = (char *)av[argc];
          slots[argc] = (uint)sp;
          while (*s && sp < lim)
            *sp++ = *s++;
          *sp++ = 0;
          argc++;
        }
        slots[argc] = 0;
        argvdst = area;
        execmem[curr][2] = area;
      }
    }
    p->pdispatch = db + im->dispoff;
    p->pirqresume = db + im->irqoff;
    p->plr = db + im->lroff;
    p->thunk = tb + im->thunkoff;
    p->pmail = db + im->mailoff;
    W(db + im->sysoff) = k_sysentry;
    W(p->pdispatch) = p->thunk; /* preset; entryoff skips crt0's write */
    uint regs = db + im->dispoff - 0x54; /* .regs base */
    W(regs + 0) = argc;                  /* r0 */
    W(regs + 4) = argvdst;               /* r1 */
    vfork_release(p);
    /* exec does not return: continue at the fresh image's crt0. */
    p->state = RUNNING;
    kexit(curr, tb + im->entryoff);
    return;
  }
  case SYS_exit: {
    p->xstate = m->a0;
    if (fsready)
      kfs_exit((int)curr);
    kfree_exec((int)curr);
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
        setret(q, p->pid);
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
    setret(p, ret);
    p->state = RUNNING;
    kexit(curr, W(p->plr));
    return;
  }
  if (p->state == SLEEPING)
    setret(p, ret); /* pause/wait/fork: value for when it resumes */
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
