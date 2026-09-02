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

/* The TIMER block's free-running microsecond counter, mapped by dmacc
 * (hwMMIO) so the address stays SKU-correct. TIMERAWH is the high
 * word and lives BELOW TIMERAWL in the block (+0x24 vs +0x28).
 *
 * This is the system's ONLY wallclock. `ticks` below is not one: it
 * counts scheduler quanta the injector actually DELIVERED, and the
 * kernel has no safepoints, so a long kernel stay (one SYS_read that
 * paints a 307200-byte slide) advances it at most once. Anything that
 * wants elapsed time reads these two words at the point of use. */
extern volatile unsigned int __dma_timerawl;
extern volatile unsigned int __dma_timerawh;

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
  uint wake_us;    /* 4: TIMERAWL deadline for a timed sleep (see
                    * SYS_pause); compared wrap-safe, so the horizon
                    * is 2^31 us ~ 35 minutes */
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

/* What each slot is RUNNING, basename only and NUL-terminated: the
 * one thing the table carried no record of, and the only reason `ps`
 * (SYS_procinfo, toolbox.c) can name a row. The loader names the boot
 * slots exactly as it sets their pids; exec renames from there.
 *
 * It sits BESIDE struct proc rather than in it, and that is a
 * measurement, not a preference. fork copies the struct whole
 * (*c = *p); twelve more bytes inside it widened that copy — and
 * every other whole-struct move — by 240 bytes of the kernel's
 * .ramtext window, which on the video board is the scarcest window
 * there is (XIPText turns each self-modified record into a resident
 * stub; TestDeploySizes prints what is left). Beside the table, fork
 * pays one explicit copy and the window pays for one. */
char procname[NPROC][12];

/* The kernel's only name copy: fork's inheritance and procinfo's
 * readout share it, so the .ramtext window buys one load/store pair
 * instead of two. Kept out of line for exactly that reason. */
__attribute__((noinline)) static void
namecpy(char *d, const char *s)
{
  for (int j = 0; j < 12; j++)
    d[j] = s[j];
}

/* ticks: scheduler quanta DELIVERED, not elapsed time. The injector
 * is one-shot and re-armed at kexit, so this stops advancing for as
 * long as the kernel stays in — by design, and never to be papered
 * over with reconciliation. Wallclock is __dma_timeraw{l,h} read at
 * the point of use; see wall_now() and klogts(). */
uint ticks;

/* Boot epoch: the 64-bit microsecond counter as of the kernel's
 * one-time init (kenter). Zero until then, which just means elapsed
 * is measured from machine start — honest either way. */
static uint wall0_hi, wall0_lo;

/* ntimed: how many processes hold a wake_us deadline. A HINT, not a
 * refcount — tick_income recounts it during its walk, so a sleeper
 * woken by anything else (sel_wake, kill, terminate) costs one extra
 * walk and then settles. What it buys is the common case: with no
 * timed sleeper the resident tick path does one load and one branch
 * and never touches the proc table or the timer at all. */
static uint ntimed;

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
extern int kfs_seek(int fd, uint off);
extern int kfs_selready(int fd); /* select: read would not block */
extern void kdmacpy(uint dst, uint src, uint len); /* kdma.c */
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

/* HDMI framebuffer + fbcon (kfb.c / kfbcon.c, prompts/036). */
extern int kfb_init(void);
extern int kfb_active(void);
extern uint kfb_base(void);
extern int kfb_w(void);
extern int kfb_h(void);
extern uint kfb_owner(void);
extern void kfb_setowner(uint pid);
extern void kfb_pause(void);
extern void kfb_resume(void);
extern int kfb_syscall(uint op, uint a1, uint pid, int badinfo);
extern void kfbcon_putc(int c);
extern void kfbcon_cursor(void); /* the batch's cursor, once at the end */
extern void kfbcon_reset(void);

/* Tick injector registers (family-common DMA base). Classic machines
 * use ABI channel 3; a compact-machine system takes channel 9 of the
 * board pool (the injector slot by convention, emu/compact.go), so
 * the loader patches these when the system runs in Tier-C encoding. */
uint inj_wreg = 0x500000C4u; /* CH3 WRITE_ADDR */
uint inj_treg = 0x500000DCu; /* CH3 AL1_TRANS_COUNT_TRIG */
#define INJ_WRITE_ADDR (*(volatile uint *)inj_wreg)
#define INJ_COUNT_TRIG (*(volatile uint *)inj_treg)
/* The injector's plain-alias register block: WRITE_ADDR sits at +0x04,
 * so READ_ADDR is one word below and TRANS_COUNT one above. The count
 * read distinguishes fire sources once console DMA is on: 0 means the
 * timer fired (and needs the kexit re-arm), nonzero means the fire was
 * the console wake channel. */
#define INJ_READ_ADDR (*(volatile uint *)(inj_wreg - 4))
#define INJ_COUNT (*(volatile uint *)(inj_wreg + 4))

#define W(a) (*(volatile uint *)(a))

/* Console DMA (kcons.c / kconsstub.c, kfsstub-style): the three
 * board-pool channels that take the UART wire off the kernel's hands.
 * kproc keeps only the seams — cputc_wire and crx_next fall back to
 * the classic polling paths when kcons_tx/kcons_rx report "off". */
extern int kcons_on(void);
extern int kcons_tx(uint b); /* 1 = queued; 0 = console DMA off */
extern void kcons_kick(void);
extern int kcons_rx(void); /* byte; -1 ring empty; -2 off */
extern int kcons_pending(void); /* cheap peek: input waiting? */
extern void kcons_aim(uint addr); /* wake target; 0 = kernel scrap */
static uint tick_taken; /* this kernel entry consumed the timer fire */

/* --- Process creation (Phase 5e): image registry + region allocator.
 * The registry rows are pre-parsed DMX images (segments + a packed
 * relocation table + the symbol offsets the kernel needs), poked by
 * the loader/dmxgen at generation time; exec() places a fresh copy
 * with the bump allocator and applies the relocations — the loader
 * now lives in the kernel. Packed reloc word: bit31 = target segment
 * (0 text, 1 data), bit30 = referenced segment, low 30 bits = byte
 * offset within the target segment. */
#define NIMG 24 /* flash-resident apps: one row per NAME (toolbox
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
  /* Pre-relocated rows (sramhome != 0): the image was assembled at
   * its final addresses — text executes in place from XIP flash, and
   * exec only places [ramtext][data] at sramhome, the arena's first
   * allocation (first-fit hands out the bottom, so the address is
   * deterministic — or busy, and the exec fails cleanly). No relocs;
   * ramtext carries the self-modifying records XIPText split out.
   *
   * "Or busy" is the mechanism's standing limit, and the toolbox
   * (boards.XIPApps) is what makes it visible: two live execs cannot
   * both have the bottom, so `ls | ps` can answer "exec ps failed"
   * when the load-anywhere stage wins the race. It stays survivable
   * only because no toolbox applet reads stdin — the pipe position
   * that breaks is the one no meaningful command uses, and the useful
   * direction (`ps | cat`) is the one that works. The real repair is
   * an arena floor kalloc never hands out; the cheap substitute —
   * moving load-anywhere images to kalloc_top — was measured and
   * rejected, because separating a process's data from its argv
   * across the compact encoding's address windows cost +3%..+21% on
   * every shell command. */
  uint sramhome;
  uint rtext, rtextlen; /* ramtext blob source + byte length */
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
uint xv6_commit;        /* loader-patched: the port's git commit, low
                         * 28 bits as 7 hex digits (0 = unwired) */

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

/* kalloc_top: like kalloc, but carves from the TOP of the LAST free
 * block. Heap chunks (ksbrk) allocate here so the arena's bottom
 * stays deterministic for exec images — a pre-relocated image's
 * fixed sramhome is the bottom-most allocation, and the shell's own
 * malloc heap must never race it there. */
static uint
kalloc_top(uint n)
{
  if (!kheap_init) {
    kheap_init = 1;
    kfreelist = (struct khdr *)arena;
    kfreelist->size = arena_end - arena;
    kfreelist->next = 0;
  }
  n = ((n + 0xFFu) & ~0xFFu) + 0x100u;
  struct khdr **pp = &kfreelist, **cand = 0;
  for (struct khdr *h = kfreelist; h; pp = &h->next, h = h->next) {
    if (h->size >= n)
      cand = pp;
  }
  if (!cand)
    return 0;
  struct khdr *h = *cand;
  if (h->size - n >= 0x200u) { /* shrink in place, take the top */
    h->size -= n;
    struct khdr *piece = (struct khdr *)((uint)h + h->size);
    piece->size = n;
    return (uint)piece + 0x100u;
  }
  *cand = h->next;
  return (uint)h + 0x100u;
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
 * an arena chunk allocated at the first call — sized to twice the
 * ask (floor HEAPCHUNK) so later growth has headroom, halved toward
 * the ask when the arena cannot spare that — and the break moves
 * within it;
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
    /* The HEAPCHUNK floor is load-bearing: the chunk is one-shot,
     * a fork child inherits the parent's (rwsbrk grows there), and a
     * first ask says nothing about later ones (vi's first malloc is
     * a tiny strdup; its 10 KB text buffer follows). Under pressure
     * the halving loop degrades toward the ask instead of failing. */
    uint size = want < HEAPCHUNK ? HEAPCHUNK : want;
    uint chunk = kalloc_top(size);
    while (chunk == 0 && size > want) {
      size /= 2u;
      if (size < want)
        size = want;
      chunk = kalloc_top(size);
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

/* Registry name by index for /dev/apps (kdev.c); rows are packed
 * from 0, so the first empty name ends the walk. Returns 0 past it. */
const char *
kimg_name(int i)
{
  if (i < 0 || i >= NIMG || kimages[i].name[0] == 0)
    return 0;
  return kimages[i].name;
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

/* cputc_wire: one byte onto the UART — through the console-DMA TX
 * ring when configured (kcons.c), else the classic FIFO-full poll. */
static void
cputc_wire(uint b)
{
  if (kcons_tx(b))
    return;
  while (__dma_uart_fr & (1u << 5))
    ;
  __dma_uart_dr = b;
}

static void
cputc(int c)
{
  if (c == '\n')
    cputc_wire('\r');
  cputc_wire((uchar)c);
  kfbcon_putc(c); /* the console tee: every byte goes to UART and fbcon */
}

/* Exported console I/O (also the devsw[CONSOLE] backend once the fs
 * is up): kconswrite paces cputc; kconsread hands out cooked lines,
 * -2 (EAGAIN) when none is ready — the usys read() wrapper retries. */
void kconswrite(const char *b, int n);

/* --- Wallclock (prompts/044): 64-bit microseconds out of the TIMERAW
 * pair, in hand-rolled 32-bit halves. dmacc has no i64, so every wide
 * value here is a (hi, lo) pair and every operation on one is spelled
 * out. All three users are cold — a log stamp, SYS_uptime, and the
 * boot anchor — so the 32-round long division below is bought at a
 * price nobody pays twice. The SLEEP path deliberately does NOT come
 * through here: it works in the 32-bit low word alone, where a
 * wrap-safe compare is one subtract (see SYS_pause). --- */

/* wall_now: the counter, read coherently. The two halves latch
 * independently, so a low-word wrap between the reads would pair a
 * stale high with a fresh low — one second reported as 4295. Read
 * high, low, high and retry if the high moved; the loop runs at most
 * twice, since a second wrap would need another 71.6 minutes. */
static void
wall_now(uint *hi, uint *lo)
{
  uint h = __dma_timerawh;
  for (;;) {
    uint l = __dma_timerawl;
    uint h2 = __dma_timerawh;
    if (h2 == h) {
      *hi = h;
      *lo = l;
      return;
    }
    h = h2;
  }
}

/* wall_since: microseconds elapsed since the (hi, lo) epoch, as a
 * pair. Borrow-propagating 64-bit subtract. */
static void
wall_since(uint ehi, uint elo, uint *hi, uint *lo)
{
  uint nh, nl;
  wall_now(&nh, &nl);
  *lo = nl - elo;
  *hi = nh - ehi - (nl < elo ? 1u : 0u);
}

/* us_div: divide the pair in place by d (0 < d < 2^31) and return the
 * remainder. Long division: the high word goes through the machine's
 * own 32-bit divide, then the low word is brought down a bit at a
 * time, restoring shift-and-subtract.
 *
 * The low word is READ through a descending mask instead of being
 * shifted out of. Spelled the obvious way — rem = (rem << 1) | (l >>
 * 31) beside l <<= 1 — clang recognizes the pair as a funnel shift
 * and emits llvm.fshl.i32 no matter how the two halves are written
 * (x + x and a comparison get canonicalized straight back into it),
 * and this machine's compiler does not implement that intrinsic.
 * With l left alone there is no pair to match. */
static uint
us_div(uint *hi, uint *lo, uint d)
{
  uint l = *lo, qh = *hi / d, ql = 0, rem = *hi % d;
  for (uint bit = 0x80000000u; bit != 0; bit >>= 1) {
    rem = rem + rem; /* rem < d < 2^31: rem + rem + 1 cannot overflow */
    if (l & bit)
      rem += 1u;
    ql = ql + ql;
    if (rem >= d) {
      rem -= d;
      ql += 1u;
    }
  }
  *hi = qh;
  *lo = ql;
  return rem;
}

/* klogts: "[seconds.millis] " since the boot epoch, for kernel log
 * lines (fb bring-up, the SD driver, panics). User console output
 * never comes through here. Reads the wallclock, so a stamp is
 * honest even when it lands in the middle of a long kernel stay that
 * delivered no ticks at all. */
void
klogts(void)
{
  uint hi, lo;
  wall_since(wall0_hi, wall0_lo, &hi, &lo);
  uint us = us_div(&hi, &lo, 1000000u);
  uint sec = lo; /* hi is zero short of 136 years */
  uint ms = us / 1000u;
  char b[20];
  int n = 0;
  b[n++] = '[';
  char d[10];
  int k = 0;
  do {
    d[k++] = (char)('0' + sec % 10u);
    sec /= 10u;
  } while (sec && k < 10);
  while (k)
    b[n++] = d[--k];
  b[n++] = '.';
  b[n++] = (char)('0' + ms / 100u);
  b[n++] = (char)('0' + (ms / 10u) % 10u);
  b[n++] = (char)('0' + ms % 10u);
  b[n++] = ']';
  b[n++] = ' ';
  kconswrite(b, n);
}

void
kconswrite(const char *b, int n)
{
  for (int i = 0; i < n; i++)
    cputc(b[i]);
  kfbcon_cursor(); /* one underline for the whole write, not per byte */
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

/* --- select (SYS_select): readiness wait, a Linux-flavored subset.
 * v1 readiness is the console (cooked: a committed line; raw: any
 * byte). Pipe reads already block kernel-side (the peer deposits) and
 * file reads never spin, so their bits report ready immediately — a
 * select that SLEEPS is therefore always waiting on the console, and
 * the wake can deposit the caller's full mask without re-checking
 * per-fd state. Two channels split the deadline bookkeeping: timed
 * sleepers park on selwait_to (tick_income scans their wake_us),
 * untimed on selwait_inf. */
static uint selwait_inf, selwait_to;

int
kcons_ready(void)
{
  return cons_r != cons_w;
}

static void
sel_wake(void)
{
  for (int i = 0; i < NPROC; i++) {
    struct proc *q = &proc[i];
    if (q->state != SLEEPING ||
        (q->chan != (uint)&selwait_inf && q->chan != (uint)&selwait_to))
      continue;
    volatile struct dma_sysmail *qm = (volatile struct dma_sysmail *)q->pmail;
    setret(q, qm->a0); /* console-waiters only: the whole mask is ready */
    q->chan = 0;
    q->state = RUNNABLE;
  }
}

static void deliver_sigint(void);
int kgpio(uint op, uint pin, uint val);   /* kgpio.c */
int kpinmux(uint pin, uint func);
int kpio(uint op, uint a, uint b);

/* crx_next: one input byte, or -1 when none waits — from the
 * console-DMA RX ring when configured, else the UART FIFO. */
static int
crx_next(void)
{
  int c = kcons_rx();
  if (c != -2)
    return c;
  if (__dma_uart_fr & (1u << 4)) /* RXFE: nothing buffered */
    return -1;
  return (int)(__dma_uart_dr & 0xFFu);
}

static void
cons_poll(void)
{
  uint w0 = cons_w;
  /* Stop draining when the cooked buffer is full: popping a byte
   * would DROP it, and the every-tick drain (fgpid systems) outruns
   * readers on scripted input. Backpressure leaves the rest in the
   * RX ring (or FIFO) until a reader makes room. */
  while (cons_e - cons_r < INPUT_BUF) {
    int ci = crx_next();
    if (ci < 0)
      break;
    uint c = (uint)ci;
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
  kfbcon_cursor(); /* the echo above is a batch like any other */
  if (cons_w != w0)
    sel_wake(); /* committed input: readiness for select sleepers */
}

static void
tick_income(void)
{
  ticks++;
  rearm = 1;
  /* wakeup(&ticks): timer sleepers whose deadline passed — and timed
   * select sleepers, whose 0-on-timeout return was deposited at sleep
   * time. Deadlines are TIMERAWL microseconds, so a sleeper woken
   * here slept the time it asked for even if the ticks that should
   * have counted it out were never delivered; the compare is
   * wrap-safe. This is resident code (dmxgen kernResident): the whole
   * walk, the timer read included, stays behind the ntimed hint so an
   * idle system pays a load and a branch. */
  if (ntimed) {
    uint now = __dma_timerawl;
    uint left = 0;
    for (int i = 0; i < NPROC; i++) {
      struct proc *p = &proc[i];
      if (p->state != SLEEPING)
        continue;
      if (p->chan != (uint)&ticks && p->chan != (uint)&selwait_to)
        continue;
      if ((int)(now - p->wake_us) >= 0) {
        p->chan = 0;
        p->state = RUNNABLE;
        continue;
      }
      left = 1;
    }
    ntimed = left;
  }
  /* Drain the RX FIFO every tick, not just on SYS_read: Ctrl-C must
   * be seen even while a compute-bound foreground job runs and the
   * shell sits in wait() reading nothing (prompts/026). Gated on the
   * interrupt key being configured: a system without fgpid may read
   * the UART raw from user space (dma-sh does), and the drain would
   * steal its bytes. */
  if (fgpid != 0 && kcons_pending())
    cons_poll();
}

/* fire_income: a dispatch fire was consumed. Without console DMA every
 * fire is the timer. With it, the wake channel patches the same words,
 * and the tick injector's own TRANS_COUNT tells the sources apart
 * (0 = the timer fired and awaits kexit's re-arm; tick_taken dedups
 * the double-checked kenter/kexit window). Input is drained either
 * way — immediate echo and Ctrl-C are the point of the wake. */
static void
fire_income(void)
{
  if (!kcons_on()) {
    tick_income();
    return;
  }
  if (INJ_COUNT == 0 && !tick_taken) {
    tick_taken = 1;
    tick_income();
  }
  if (fgpid != 0 && kcons_pending())
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

/* kboot_init: the kernel's one-time bring-up, on the first entry
 * after the loader configured dma_disk. Out of line, and kept that
 * way, because its only caller is RESIDENT: kenter lives in the
 * .ramtext window (dmxgen kernResident) and this code runs exactly
 * once, before the display is up, so it has no business spending the
 * scarcest memory in the system. */
static __attribute__((noinline)) void
kboot_init(void)
{
  /* Boot epoch, before the first stamp: every klogts() and every
   * SYS_uptime is measured from here. (kmain is only a GC anchor —
   * this function IS the kernel's init.) */
  wall_now(&wall0_hi, &wall0_lo);
  /* The one-time boot banner: the port's commit (loader-patched;
   * 0000000 in unwired test builds) over the upstream lineage. */
  klogts();
  kconswrite("xv6-dma version ", 16);
  {
    const char *hx = "0123456789abcdef";
    char h[8];
    for (int i = 0; i < 7; i++)
      h[i] = hx[(xv6_commit >> (24 - 4 * i)) & 0xFu];
    kconswrite(h, 7);
  }
  kconswrite(" based on xv6-riscv & xv6-ns (rp2dma-xv6-dmacc)\n", 48);
  int fbkb = kfb_init();
  if (fbkb > 0) {
    kfbcon_reset();
    klogts();
    kconswrite("fb: 640x480x8 on hstx-dvi\n", 26);
  } else if (fbkb < 0) {
    klogts();
    kconswrite("fb: psram fail\n", 15);
  }
  kfs_start();
  kflash_init();
}

/* Consume any fire that landed on curr's dispatch word or in
 * tickpending, then aim in-kernel fires at tickpending. */
static void
kenter(void)
{
  rearm = 0;
  tick_taken = 0;
  kcons_aim(0); /* in-kernel wake fires land on kcons's scrap word */
  if (!fsready && dma_disk)
    kboot_init();
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
      fire_income();
    }
  }
  INJ_WRITE_ADDR = (uint)&tickpending;
  if (tickpending) {
    tickpending = 0;
    fire_income();
  }
}

/* Round-robin: next RUNNABLE slot after curr (curr itself last). The
 * wrap stays UNSIGNED: signed % is a full runtime division on this
 * machine (~2k records), and it sat in the tick path — the scheduler
 * was spending more records picking a process than running it.
 *
 * With one exception, and it is worth a paragraph. The orphan adopter
 * (`initpid`, prompts/024) is a busy loop — the smallest schedulable
 * program in the tree — and it is therefore RUNNABLE forever. A plain
 * round-robin treats it as a peer, so every tick delivered in user
 * mode alternated the real process with the spinner and handed away
 * half of every quantum it could preempt. Measured on the nyancat
 * port: 103 quanta a frame went to the adopter, ~6% of the frame.
 *
 * So the adopter is a FILLER: it is picked only when the round is
 * otherwise empty. That is a policy statement about the process, not
 * about the slot — a real init, which sleeps in wait(), is never a
 * candidate here anyway, and nothing else about it changes. When no
 * adopter is configured (initpid = 0) no live pid can match it, and
 * the loop is exactly the round-robin it was. */
static int
pick(void)
{
  int filler = -1;
  for (int off = 1; off <= NPROC; off++) {
    int i = (int)((curr + (uint)off) % (uint)NPROC);
    if (proc[i].state == RUNNABLE) {
      if (proc[i].pid != initpid)
        return i;
      filler = i;
    }
  }
  return filler;
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
    fire_income();
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
    fire_income();
  }
  if (kcons_on()) {
    /* Bytes that arrived while the kernel ran raised no visible fire
     * (the wake aimed at the scrap word): drain them now, then hand
     * any buffered output to the drain channel and aim the wake at
     * the resuming process's dispatch word, tick-injector style. */
    if (fgpid != 0 && kcons_pending())
      cons_poll();
    kcons_kick();
    kcons_aim(p->pdispatch);
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
      fire_income();
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
      fire_income();
    }
    if (kcons_on()) {
      /* Drain before parking (a byte already in the ring raises no
       * further wake) and let input break the park like a tick. */
      if (fgpid != 0 && kcons_pending())
        cons_poll();
      kcons_kick();
      kcons_aim((uint)kw_parkvec);
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
  fire_income(); /* the delivered detour that brought us here */
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
  if (kfb_owner() == (uint)p->pid) {
    kfb_setowner(0); /* a dying fb owner must not blank the console */
    kfbcon_reset();
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
  case SYS_uptime: { /* elapsed since boot in 100 us units — the unit
                      * upstream's sys_uptime returned ticks in, and
                      * the one show.c formats seconds out of. The
                      * VALUE is now wallclock, so a draw that pinned
                      * the kernel for 40 ms reports 40 ms instead of
                      * zero. Wraps at 2^32 units (~4.9 days), as the
                      * tick count did. */
    uint hi, lo;
    wall_since(wall0_hi, wall0_lo, &hi, &lo);
    us_div(&hi, &lo, 100u);
    ret = lo;
    break;
  }
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
  case SYS_seek:
    ret = fsready ? (uint)kfs_seek((int)m->a0, m->a1) : (uint)-1;
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
    /* The machine-executor sync runs a QMI direct-mode session that
     * owns the XIP bus, so the display is bracketed across it
     * (prompts/036; the pause/resume pair is a no-op now that the
     * scanout runs entirely out of SRAM). Bracketing here — not
     * inside kflash_sync — keeps the fb driver out of the sync's
     * .ramtext closure. */
    kfb_pause();
    ret = fsready ? (uint)kflash_sync() : (uint)-1;
    kfb_resume();
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
  case SYS_pause: /* sleep a0 ticks on &ticks (upstream sys_sleep).
                   * The deadline is wallclock: TIMERAWL now plus the
                   * requested 100 us units, in the 32-bit low word
                   * alone. Sleeps here are short — the longest in the
                   * tree is pause(1000), 100 ms — and the wrap-safe
                   * compare in tick_income carries 2^31 us of them. */
    ntimed++;
    p->wake_us = __dma_timerawl + m->a0 * 100u;
    sleep((uint)&ticks);
    ret = 0;
    block = 1;
    break;
  case SYS_select: { /* a0: fd readiness bitmask (fds 0..30); a1:
                      * timeout in 100 us units, 0 = wait forever.
                      * Returns the ready subset of a0, 0 on timeout.
                      * The wait is wallclock, like SYS_pause's. */
    uint mask = m->a0, rdy = 0;
    for (uint fd = 0; fd < 31; fd++) {
      if (!((mask >> fd) & 1))
        continue;
      int r = fsready ? kfs_selready((int)fd) : kcons_ready();
      if (r)
        rdy |= 1u << fd;
    }
    if (rdy != 0 || mask == 0) {
      ret = rdy;
      break;
    }
    if (m->a1 != 0) {
      ntimed++;
      p->wake_us = __dma_timerawl + m->a1 * 100u;
      sleep((uint)&selwait_to);
    } else {
      sleep((uint)&selwait_inf);
    }
    ret = 0; /* the timeout answer; sel_wake overwrites with the mask */
    block = 1;
    break;
  }
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
    namecpy(procname[ci], procname[curr]); /* until the child execs */
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
      fsim.sramhome = 0; /* fs images are always relocatable */
      im = &fsim;
    } else {
      im = lookup((const char *)m->a0);
      if (!im) {
        ret = (uint)-1;
        break;
      }
      if (im->sramhome) {
        /* Pre-relocated: text runs in place, one arena claim holds
         * [ramtext][data] and must land exactly at the link home. */
        uint rt = (im->rtextlen + 7u) & ~7u; /* records are 8-aligned */
        db = kalloc(rt + im->datalen);
        if (db != im->sramhome) {
          kfree(db);
          ret = (uint)-1;
          break;
        }
        kdmacpy(db, im->rtext, rt);
        kdmacpy(db + rt, im->data, (im->datalen + 3u) & ~3u);
        tb = im->text;
        db += rt; /* every data-relative offset below */
      } else {
        tb = kalloc(im->textlen);
        db = kalloc(im->datalen);
        if (!tb || !db) {
          kfree(tb); /* a half-failed exec must not leak: one leaked
                      * text region poisoned every later exec (the fs
                      * path above always freed both) */
          kfree(db);
          ret = (uint)-1;
          break;
        }
        /* Bulk DMA copy (kdma.c): a 57 KB toolbox text used to be an
         * interpreted word loop; channel 11 moves it a word per bus
         * slot. Lengths round up to the word the old loop copied. */
        kdmacpy(tb, im->text, (im->textlen + 3u) & ~3u);
        kdmacpy(db, im->data, (im->datalen + 3u) & ~3u);
      }
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
    if (im->sramhome) {
      execmem[curr][0] = 0; /* text is flash: nothing to free */
      execmem[curr][1] = im->sramhome;
    } else {
      execmem[curr][0] = tb;
      execmem[curr][1] = db;
    }
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
    /* Name the slot after what was exec'd: the basename of a0, which
     * for a registry image is the row name the shell typed — so a
     * toolbox link shows as `free`, not as `toolbox`. Scanned and
     * copied in ONE pass: a separate basename scan would cost a
     * second .ramtext record for the same bytes, and this kernel's
     * window is measured in hundreds. It reads the caller's path from
     * the same place the argv copy above reads its strings, and every
     * failure path is behind it — a refused exec never renames. */
    {
      char *d = procname[curr];
      int j = 0;
      for (const char *q = (const char *)m->a0; *q; q++) {
        if (*q == '/')
          j = 0;
        else if (j < 11)
          d[j++] = *q;
      }
      d[j] = 0;
    }
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
                       * [5] proc slots used  [6] NPROC
                       * [7] ticks DELIVERED (not uptime — see the
                       *     `ticks` declaration; SYS_uptime is the
                       *     wallclock one) */
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
  case SYS_procinfo: { /* a0: rows out, a1: how many the buffer holds.
                        * One 6-word row per LIVE slot — [0] pid
                        * [1] ppid [2] state (enum procstate)
                        * [3..5] the 12-byte name — and the row count
                        * is the return value. `ps` is the whole
                        * consumer; meminfo's o[5]/o[6] stay the cheap
                        * slot census, which is all `free` wanted. */
    uint max = m->a1 > NPROC ? NPROC : m->a1;
    if (badbuf(p, m->a0, max * 24))
      break;
    uint *o = (uint *)m->a0;
    uint n = 0;
    for (int i = 0; i < NPROC && n < max; i++) {
      if (proc[i].state == UNUSED)
        continue;
      o[0] = proc[i].pid;
      o[1] = proc[i].ppid;
      o[2] = proc[i].state;
      namecpy((char *)&o[3], procname[i]);
      o += 6;
      n++;
    }
    ret = n;
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
  case SYS_fb: /* a0: op (0 info, 1 acquire, 2 release); a1: &fbinfo.
                * The body lives in kfb.c so lean kernels stay lean. */
    ret = (uint)kfb_syscall(m->a0, m->a1, (uint)p->pid,
                            m->a0 == 0 && badbuf(p, m->a1, 4 * 5));
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
