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
 * dispatch/irqresume/lr register-bank words, its usys mailbox (0 for
 * processes that never syscall), and its crt0 resume thunk. */
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
  uint killed;     /* 12: kill() pending; enforced at kernel entry */
  uint heapbase;   /* 13: sbrk heap region (0 = none yet) */
  uint heapmax;    /* 14: region end */
  uint brk;        /* 15: current program break */
  uint sigctx;     /* 16: &usys sigctx {entry,resume,save0,save1};
                    *     0 = no handler (SIGINT takes default death) */
  uint sigpend;    /* 17: 0 idle, 1 delivery pending, 2 in handler */
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
uint *volatile kw_park;    /* kernel.dasm parkloop: spin when nothing
                            * is runnable */
uint *volatile kw_parkvec; /* &parkvec: the park loop's dispatch word;
                            * the injector patches it to wake us */

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
extern int kfs_mount(uint srcaddr, uint tgtaddr);
extern int kfs_umount(uint tgtaddr);
extern int kflash_sync(void);
extern void kflash_init(void);
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
#define NIMG 20 /* flash-resident apps: one row per NAME (toolbox
              * links each get a row aliasing the same blob) */

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
uint initpid;           /* loader-patched: adopter of orphans (0 = no
                         * reparenting). The init proc never waits, so
                         * its adoptees skip ZOMBIE and free directly. */
uint fgpid;             /* loader-patched: the console shell's pid;
                         * Ctrl-C interrupts its foreground job. 0
                         * disables the interrupt key. */
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

/* The heap chunk a slot ALLOCATED (0 = none). Distinct from the proc
 * fields: a vfork child copies its parent's heapbase/heapmax/brk and
 * shares the region, but only the allocating slot owns the chunk and
 * frees it (exit or re-exec). */
static uint heapmem[NPROC];

static void
kfree_exec(int slot)
{
  for (int i = 0; i < 3; i++) {
    kfree(execmem[slot][i]);
    execmem[slot][i] = 0;
  }
  kfree(heapmem[slot]);
  heapmem[slot] = 0;
  struct proc *p = &proc[slot];
  p->heapbase = p->heapmax = p->brk = 0;
  p->sigctx = p->sigpend = 0;
}

/* SYS_sbrk (upstream sys_sbrk semantics, minus paging: the laziness
 * flag is meaningless and both flavors are eager). The heap region is
 * an arena chunk allocated at the first call — at least HEAPCHUNK so
 * later small growth (the sbrk* tests) has headroom, or the ask when
 * it is bigger (umalloc's morecore wants 32 KB in one call) or when
 * the arena cannot spare HEAPCHUNK — and the break moves within it;
 * there is no growth past the chunk. Newly exposed bytes are zeroed,
 * as upstream's fresh pages are. Returns the old break, or -1
 * (SBRK_ERROR). */
#define HEAPCHUNK 16384u

static uint
ksbrk(struct proc *p, int n)
{
  if (p->heapbase == 0) {
    if (n < 0)
      return (uint)-1;
    uint want = ((uint)n + 0xFFu) & ~0xFFu;
    uint size = want < HEAPCHUNK ? HEAPCHUNK : want;
    uint chunk = kalloc(size);
    if (chunk == 0 && size > want) {
      size = want;
      chunk = kalloc(size);
    }
    if (chunk == 0)
      return (uint)-1;
    heapmem[curr] = chunk;
    p->heapbase = p->brk = chunk;
    p->heapmax = chunk + size;
  }
  uint old = p->brk;
  if (n >= 0) {
    if ((uint)n > p->heapmax - p->brk)
      return (uint)-1;
    for (uint a = old; a < old + (uint)n; a++)
      *(volatile uchar *)a = 0;
    p->brk += (uint)n;
  } else {
    if ((uint)-n > p->brk - p->heapbase)
      return (uint)-1;
    p->brk -= (uint)-n;
  }
  /* vfork: the image — and the K&R allocator's statics inside it —
   * is shared with the suspended parent chain (upstream sh parses,
   * and so mallocs, in the CHILD). Introduce the chunk to the chain
   * and hoist its ownership to the top, or the child's exec/exit
   * would free memory the parent's free list still references. The
   * BREAK is not mirrored here: a child that exits without exec rolls
   * its growth back (as upstream's per-process memory would), keeping
   * usertests' free-page accounting honest; exec syncs it instead
   * (vfork_sync_brk), because then the allocator state hands off. */
  int slot = (int)(p - proc);
  for (struct proc *q = p;;) {
    struct proc *par = 0;
    for (int i = 0; i < NPROC; i++) {
      if (proc[i].state == SLEEPING && proc[i].chan == (uint)q) {
        par = &proc[i];
        break;
      }
    }
    if (!par)
      break;
    if (par->heapbase != p->heapbase) {
      par->heapbase = p->heapbase;
      par->heapmax = p->heapmax;
      par->brk = p->heapbase;
    }
    if (heapmem[slot]) {
      heapmem[par - proc] = heapmem[slot];
      heapmem[slot] = 0;
    }
    slot = (int)(par - proc);
    q = par;
  }
  return old;
}

/* exec hands the shared image (with the child's mallocs live in it)
 * back to the suspended vfork parents: their break must match. */
static void
vfork_sync_brk(struct proc *p)
{
  for (struct proc *q = p;;) {
    struct proc *par = 0;
    for (int i = 0; i < NPROC; i++) {
      if (proc[i].state == SLEEPING && proc[i].chan == (uint)q) {
        par = &proc[i];
        break;
      }
    }
    if (!par)
      break;
    par->heapbase = p->heapbase;
    par->heapmax = p->heapmax;
    par->brk = p->brk;
    q = par;
  }
}

/* rwsbrk's contract: the kernel refuses fs buffers in the RETURNED
 * part of the heap ([brk, heapmax)). Buffers outside the heap region
 * (data, frames) stay fair game — there is no MMU to say otherwise. */
static int
badbuf(struct proc *p, uint addr, uint n)
{
  return p->heapmax != 0 && n != 0 && addr < p->heapmax &&
         addr + n > p->brk && addr + n >= addr;
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
static uint parked;  /* left the kernel into the park loop */
static uint waspark; /* this entry is a park-loop wake (set by kenter) */
static void terminate(struct proc *p, int status);

/* --- Cooked console input (the consoleintr slice of kernel/console.c,
 * see xv6/PORT.md): SYS_read drains the UART RX FIFO through a line
 * discipline — echo, backspace editing, CR->NL — and hands out only
 * committed lines. There is no RX interrupt: draining happens on each
 * SYS_read poll (the usys read() wrapper retries once per tick). */
#define INPUT_BUF 128
static char cons_buf[INPUT_BUF];
static uint cons_r, cons_w, cons_e; /* read, committed, edit (free-running) */
/* Raw mode (SYS_ttyraw): bytes pass through uncooked and unechoed —
 * no line discipline, no CR->NL, Ctrl-C delivered as a byte. Owned by
 * the enabling process so a dying editor cannot wedge the console. */
static uint cons_raw, cons_raw_pid;

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

static void deliver_sigint(void);
int kgpio(uint op, uint pin, uint val);   /* kgpio.c */
int kpinmux(uint pin, uint func);
int kpio(uint op, uint a, uint b);

static void
cons_poll(void)
{
  /* Stop draining when the cooked buffer is full: popping the DR
   * would DROP the byte, and the every-tick drain (fgpid systems)
   * outruns readers on scripted input. Backpressure keeps the rest
   * in the RX FIFO until a reader makes room. */
  while (cons_e - cons_r < INPUT_BUF &&
         !(__dma_uart_fr & (1u << 4))) { /* RXFE clear: a byte waits */
    uint c = __dma_uart_dr & 0xFFu;
    if (cons_raw) { /* uncooked: every byte, immediately, no echo */
      cons_buf[cons_e % INPUT_BUF] = (char)c;
      cons_e++;
      cons_w = cons_e;
      continue;
    }
    if (c == 3) { /* Ctrl-C: never buffered, interrupts the fg job */
      deliver_sigint();
      continue;
    }
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
      if (c < ' ' && c != '\n' && c != '\t') {
        /* ECHOCTL: a control byte echoes as ^X, never verbatim — a
         * raw ESC [ A would command the user's terminal (the caret
         * walks the screen when arrows are typed mid-command). */
        cputc('^');
        cputc((int)c + 64);
      } else {
        cputc((int)c);
      }
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
  /* Drain the RX FIFO every tick, not just on SYS_read: Ctrl-C must
   * be seen even while a compute-bound foreground job runs and the
   * shell sits in wait() reading nothing (prompts/026). Gated on the
   * interrupt key being configured: a system without fgpid may read
   * the UART raw from user space (dma-sh does), and the drain would
   * steal its bytes. */
  if (fgpid != 0)
    cons_poll();
}

/* --- SIGINT (prompts/026): Ctrl-C interrupts the foreground job ---
 *
 * The foreground job is the subtree under the fgpid shell's current
 * wait: the youngest live child while the shell blocks in wait(), or
 * the vfork child it is suspended on (upstream sh runs commands —
 * including whole pipelines — in that child). A shell at its prompt
 * has no foreground job and the interrupt is dropped, so background
 * jobs (`spin &`) survive Ctrl-C.
 *
 * Per victim: a registered handler (SYS_signal deposited a usys
 * sigctx) gets sigpend=1 — kexit diverts its next resume into the
 * image's signal stub, saving r0/r1 and the original resume in the
 * ctx; SYS_sigreturn undoes the diversion. A sleeping victim's
 * syscall is completed with -1 first so the handler runs on the way
 * out. No handler means the kill() path: synchronous death when
 * SLEEPING, the killed flag otherwise. */
static int
in_subtree(struct proc *root, struct proc *q)
{
  for (int hops = 0; q && hops < NPROC; hops++) {
    if (q == root)
      return 1;
    if (q->ppid == 0)
      return 0; /* roots of the tree have no parent */
    struct proc *par = 0;
    for (int i = 0; i < NPROC; i++) {
      if (proc[i].state != UNUSED && proc[i].pid == q->ppid) {
        par = &proc[i];
        break;
      }
    }
    q = par;
  }
  return 0;
}

static void
sigint_one(struct proc *v)
{
  if (v->sigctx != 0) {
    if (v->sigpend != 0)
      return; /* already pending or in the handler: drop */
    if (v->state == SLEEPING) {
      setret(v, (uint)-1); /* the interrupted syscall returns -1 */
      v->chan = 0;
      v->state = RUNNABLE;
    }
    v->sigpend = 1;
  } else if (v->state == SLEEPING) {
    terminate(v, -1);
  } else {
    v->killed = 1; /* enforced at its next kernel entry */
  }
}

static void
deliver_sigint(void)
{
  if (fgpid == 0)
    return;
  struct proc *sh = 0;
  for (int i = 0; i < NPROC; i++) {
    if (proc[i].state != UNUSED && proc[i].pid == fgpid) {
      sh = &proc[i];
      break;
    }
  }
  if (!sh || sh->state != SLEEPING)
    return;
  struct proc *root = 0;
  if (sh->chan == (uint)sh) { /* wait(): the youngest live child */
    uint best = 0;
    for (int i = 0; i < NPROC; i++) {
      if (proc[i].state != UNUSED && proc[i].state != ZOMBIE &&
          proc[i].ppid == sh->pid && proc[i].pid > best) {
        best = proc[i].pid;
        root = &proc[i];
      }
    }
  } else { /* vfork suspension: chan names the child directly */
    for (int i = 0; i < NPROC; i++) {
      if ((uint)&proc[i] == sh->chan && proc[i].state != UNUSED) {
        root = &proc[i];
        break;
      }
    }
  }
  if (!root)
    return;
  cputc('^');
  cputc('C');
  cputc('\n');
  /* Snapshot the subtree before acting: terminate() reparents. */
  uint mask = 0;
  for (int i = 0; i < NPROC; i++) {
    if (proc[i].state != UNUSED && proc[i].state != ZOMBIE &&
        in_subtree(root, &proc[i]))
      mask |= 1u << i;
  }
  for (int i = 0; i < NPROC; i++) {
    if ((mask >> i) & 1)
      sigint_one(&proc[i]);
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
  if (!fsready && dma_disk) {
    kfs_start();
    kflash_init();
  }
  waspark = parked;
  if (parked) {
    /* Woken from the park loop by the fire that detoured us here
     * (accounted by the caller). curr may be a freed zombie: never
     * dereference its dispatch. */
    parked = 0;
    entry_disp = 0;
  } else {
    struct proc *p = &proc[curr];
    entry_disp = p->pdispatch;
    entry_thunk = p->thunk;
    if (W(entry_disp) != entry_thunk) { /* fire landed just before entry */
      W(entry_disp) = entry_thunk;
      tick_income();
    }
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
  if (p->sigpend == 1 && p->sigctx != 0) {
    /* Pending SIGINT with a handler: divert this resume into the
     * image's signal stub. Save r0/r1 (the resume point may consume
     * a syscall return) and the original resume in the usys sigctx;
     * SYS_sigreturn restores all three. */
    uint regs = p->pdispatch - 0x54;
    W(p->sigctx + 4) = resume;
    W(p->sigctx + 8) = W(regs);
    W(p->sigctx + 12) = W(regs + 4);
    resume = W(p->sigctx); /* ctx.entry: the stub */
    p->sigpend = 2;        /* in handler: further Ctrl-C drops */
  }
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
    /* Nothing runnable: spin at kernel.dasm's parkloop with the
     * injector aimed at parkvec — the next tick patches it and the
     * spin detours into sched_entry (prompts/024). curr may be a
     * freed zombie, so every published cur* word points at the park
     * cells, never into its image; kenter's `parked` flag skips the
     * dispatch checks on the way back in. A tick consumed below may
     * make someone runnable again — they run one fire later. */
    if (entry_disp && W(entry_disp) != entry_thunk) {
      W(entry_disp) = entry_thunk;
      tick_income();
    }
    *kw_parkvec = (uint)kw_park;
    *kw_pcurdisp = (uint)kw_parkvec;
    *kw_curthunk = (uint)kw_park;
    *kw_pcurresume = (uint)kw_parkvec;
    *kw_nextresume = (uint)kw_park;
    INJ_WRITE_ADDR = (uint)kw_parkvec;
    parked = 1;
    if (tickpending) {
      tickpending = 0;
      tick_income();
    }
    if (rearm)
      INJ_COUNT_TRIG = 1;
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
  /* A park-loop wake arrives with curr sleeping (or gone): nothing
   * was executing, so there is nothing to save or kill here. */
  if (!waspark) {
    struct proc *p = &proc[curr];
    if (p->killed) {
      terminate(p, -1); /* the pending kill lands here */
      swtch();
      return;
    }
    p->resume = *kw_curresume; /* saved by the dasm stub */
    if (p->state == RUNNING)
      p->state = RUNNABLE;
  }
  swtch();
}

/* Ends process p with the given status: closes its fs state, frees
 * its exec'd image, releases vfork/wait sleepers, reparents its
 * children to initpid, and leaves the slot ZOMBIE or UNUSED. Works
 * for the current process and (kill) for a sleeping victim alike. */
static void
terminate(struct proc *p, int status)
{
  int slot = (int)(p - proc);
  if (cons_raw && cons_raw_pid == p->pid) {
    cons_raw = 0; /* a dying editor must not wedge the console */
    cons_raw_pid = 0;
  }
  p->xstate = (uint)status;
  if (fsready)
    kfs_exit(slot);
  kfree_exec(slot);
  vfork_release(p); /* also ends a pre-exec vfork suspension */
  /* Orphans go to init; init never waits, so its adoptees (including
   * already-ZOMBIE children of the dying process) free immediately. */
  if (initpid != 0) {
    for (int i = 0; i < NPROC; i++) {
      struct proc *q = &proc[i];
      if (q->state != UNUSED && q != p && q->ppid == p->pid) {
        q->ppid = initpid;
        if (q->state == ZOMBIE)
          q->state = UNUSED;
      }
    }
  }
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
  if (reaped || (initpid != 0 && p->ppid == initpid))
    p->state = UNUSED; /* init-adopted processes never linger */
  else
    p->state = ZOMBIE;
  p->killed = 0;
}

void
dma_ksyscall(void)
{
  kenter();
  struct proc *p = &proc[curr];
  if (p->killed) { /* a kill raced this syscall: die instead */
    terminate(p, -1);
    swtch();
    return;
  }
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
    if (badbuf(p, m->a1, m->a2))
      r = -1;
    else if (fsready)
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
  case SYS_sync:
    ret = fsready ? (uint)kflash_sync() : (uint)-1;
    break;
  case SYS_read: {
    int r;
    if (badbuf(p, m->a1, m->a2))
      r = -1;
    else if (fsready)
      r = kfs_read((int)m->a0, m->a1, (int)m->a2);
    else
      r = kconsread(m->a1, (int)m->a2);
    if (r == -3)
      block = 1; /* pipe: already sleeping; the peer deposits */
    ret = (uint)r;
    break;
  }
  case SYS_sbrk: /* a0: n (signed); a1: laziness flag (eager either
                  * way — no paging) */
    ret = ksbrk(p, (int)m->a0);
    break;
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
    vfork_sync_brk(p); /* before kfree_exec clears this proc's view */
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
    terminate(p, (int)m->a0);
    block = 1;
    break;
  }
  case SYS_mount: /* a0: source ("fat0"; 0 = list into a1) */
    ret = fsready ? (uint)kfs_mount(m->a0, m->a1) : (uint)-1;
    break;
  case SYS_umount:
    ret = fsready ? (uint)kfs_umount(m->a0) : (uint)-1;
    break;
  case SYS_meminfo: { /* a0: uint[8] out — real memory consumption:
                       * [0] arena total  [1] arena free
                       * [2] largest free block
                       * [3] heap bytes (live sbrk chunks, w/ headers)
                       * [4] exec bytes (live images + argv areas)
                       * [5] proc slots used  [6] NPROC  [7] ticks */
    if (badbuf(p, m->a0, 32))
      break;
    uint *o = (uint *)m->a0;
    o[0] = arena_end - arena;
    o[1] = 0;
    o[2] = 0;
    if (!kheap_init) {
      o[1] = o[2] = o[0];
    } else {
      for (struct khdr *h = kfreelist; h; h = h->next) {
        o[1] += h->size;
        if (h->size > o[2])
          o[2] = h->size;
      }
    }
    o[3] = o[4] = o[5] = 0;
    for (int i = 0; i < NPROC; i++) {
      if (heapmem[i])
        o[3] += W(heapmem[i] - 0x100); /* the kalloc size header */
      for (int j = 0; j < 3; j++) {
        if (execmem[i][j])
          o[4] += W(execmem[i][j] - 0x100);
      }
      if (proc[i].state != UNUSED)
        o[5]++;
    }
    o[6] = NPROC;
    o[7] = ticks;
    ret = 0;
    break;
  }
  case SYS_ttyraw: /* a0: 1 = raw console (uncooked, unechoed), 0 =
                    * back to the line discipline. Owned per process. */
    if (m->a0) {
      cons_raw = 1;
      cons_raw_pid = p->pid;
      /* Commit any half-typed cooked line: keys pressed while the
       * editor was still exec-loading must reach it now, not after
       * the next keystroke (they only commit on newline in cooked
       * mode). */
      cons_w = cons_e;
    } else {
      cons_raw = 0;
      cons_raw_pid = 0;
    }
    ret = 0;
    break;
  case SYS_gpio: /* a0: op (0 write, 1 read), a1: pin, a2: value */
    ret = (uint)kgpio(m->a0, m->a1, m->a2);
    break;
  case SYS_pinmux: /* a0: pin, a1: FUNCSEL */
    ret = (uint)kpinmux(m->a0, m->a1);
    break;
  case SYS_pio: /* a0: op (0 load, 1 init, 2 gate), a1/a2 per op;
                 * pointer args are small read-only structs */
    if ((m->a0 == 0 || m->a0 == 1) && badbuf(p, m->a1, 4 * 7))
      ret = (uint)-1;
    else
      ret = (uint)kpio(m->a0, m->a1, m->a2);
    break;
  case SYS_signal: /* a0: signum (SIGINT only); a2: &usys sigctx
                    * (0 = revert to the default death) */
    p->sigctx = m->a2;
    p->sigpend = 0;
    ret = 0;
    break;
  case SYS_sigreturn: { /* the stub's handler returned: restore and
                         * resume the interrupted point */
    uint ctx = p->sigctx;
    if (ctx == 0)
      break; /* stray: fall through as a failed syscall */
    uint regs = p->pdispatch - 0x54;
    p->sigpend = 0;
    W(regs) = W(ctx + 8);
    W(regs + 4) = W(ctx + 12);
    p->state = RUNNING;
    kexit(curr, W(ctx + 4));
    return;
  }
  case SYS_kill: {
    int found = -1;
    for (int i = 0; i < NPROC; i++) {
      if (proc[i].state != UNUSED && proc[i].pid == m->a0) {
        found = i;
        break;
      }
    }
    if (found < 0 || proc[found].state == ZOMBIE) {
      ret = (uint)-1;
      break;
    }
    if (found == (int)curr) { /* suicide: exit now */
      terminate(p, -1);
      block = 1;
      break;
    }
    if (proc[found].state == SLEEPING) {
      /* Not running and not schedulable mid-syscall: the kernel can
       * execute its death synchronously. */
      terminate(&proc[found], -1);
    } else {
      proc[found].killed = 1; /* enforced at its next kernel entry */
    }
    ret = 0;
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
