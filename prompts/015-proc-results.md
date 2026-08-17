# Phase 5d results: the proc.c adaptation — policy moves to C

Goal (xv6/PORT.md): replace the hardwired two-process dasm scheduler
with a real xv6-shaped process layer: struct proc with the upstream
state enum, an N-slot run queue, sleep/wakeup, true pause/exit/wait
semantics — and shrink kernel.dasm to pure mechanism.

## Architecture

`xv6/dma/kproc.c` REPLACES upstream proc.c + syscall.c + sysproc.c
(they are built around per-process kernel stacks, swtch and paging;
the shapes survive). kernel.dasm shrinks from a hardwired A/B
scheduler to two entry stubs totalling 14 instructions:

- `sched_entry` (tick detour): EOI curr's dispatch, save curr's
  resume, call `dma_ktick()`, jump to `nextResume`.
- `sys_entry` (voluntary syscall call): call `dma_ksyscall()`, jump
  to `nextResume`.

"Who is current" is now DATA the C kernel maintains: `pCurDisp`,
`curThunk`, `pCurResume`, `nextResume`. Three consequences:

- **One injector, no chain.** Only the running process's dispatch
  needs patching; the C scheduler retargets the injector's WRITE_ADDR
  at every switch. Channel 4 is freed.
- **One shared syscall vector.** The caller is by definition `curr`,
  so the per-process sys_from_a/b vectors are gone.
- **The scheduler is C code**: `struct proc[NPROC]` (all-uint layout,
  word offsets are loader ABI), round-robin `pick()`, RUNNING/
  RUNNABLE/SLEEPING/ZOMBIE/UNUSED transitions, `sleep(chan)` /
  `wakeup(chan)`, and the syscall dispatch — 16 KB of compiled text.

## Blocking without kernel stacks

The kernel runs to completion on every entry (compiled without
safepoints; never preempted). A blocking syscall cannot sleep inside C
and resume mid-function, so:

- `pause(n)`: records `wake_tick = ticks + n`, sleeps on `&ticks`;
  the tick handler wakes expired sleepers. The syscall's return value
  is written into the mailbox BEFORE sleeping — the caller only reads
  it after resuming at its saved lr.
- `wait(&st)`: reaps an existing ZOMBIE child immediately; otherwise
  sleeps on the proc's own struct (upstream's channel choice) and the
  **exiting child deposits** pid + status directly into the sleeping
  parent's mailbox and wakes it — deposit-at-exit replaces upstream's
  reap-in-wait because the parent cannot re-run its scan. exit() with
  no waiting parent leaves a ZOMBIE for a later wait().
- `exit(status)`: never returns; the slot is reaped to UNUSED by
  (or into) wait().

## Airtight tick accounting

The injector is one-shot and only re-armed at kernel exit (single-fire
discipline), so at most one fire is ever outstanding. On kernel entry
the injector is retargeted at a kernel-owned `tickpending` word, so
fires during kernel execution (e.g. a long SYS_write at UART pace)
land harmlessly; fires that hit curr's dispatch just before entry are
detected by comparing the dispatch word against the thunk. Every fire
is consumed exactly once — by the dasm detour, the dispatch-word
check, or the tickpending check — and ticks stretch rather than die
under kernel load. This closes, by construction, the class of
lost-tick races that killed the Phase 5c trap-shaped design and
required the two-injector chain's EOI discipline in Phase 5a.

If nothing is runnable the kernel parks the machine at a `khalt` HALT
block; a live system keeps an always-runnable process (the idle
counter, or dma-sh, which never sleeps).

## Validation

- `TestXv6Proc` (new): three instances of one image branching on
  getpid() — idle counter, a parent blocking in wait(), a child that
  pause(5)s then exit(42)s. Asserts the deterministic console order,
  wait() returning pid 3 with status 42, the child slot UNUSED, the
  parent ZOMBIE, idle still advancing. PASS both SKUs (ticks=19 at
  completion, parent reaped at tick 12).
- `TestXv6Syscalls` re-based on the new kernel: identical console and
  behavior, pid 1's slot ends ZOMBIE with xstate 0.
- `TestPreemptiveScheduler` and `TestShellSystem` re-based: identical
  assertions pass (the shell's `stat` now reads the C kernel's ticks).
- dmxgen: all three bundles (sched/shell/syscall) rebuilt on the
  four-image shape (kernel stubs + kproc + processes) with a shared
  generation-time wiring helper and inline emulator verification; the
  sched bundle fits the narrow rp2040 layout (kproc: 15,984 B text +
  2,020 B data).

## Silicon: PASS

Pico 2, full pass on the first flash of the new kernel — 23
PASS/MATCH, 0 FAIL/DIFF:

    EXP sched: PASS ticks=28->141 counterA=605->2482 counterB=1350->6750
    EXP syscall: start (pid 1 speaks via SYS_write)
    hello from pid 1 via SYS_write
    pid 1 saw the clock advance
    pid 1 exiting
    EXP syscall: PASS ticks=108 donetick=11 exit=0 bgcount=329->1499

donetick=11 matches the emulator exactly. The interactive shell then
runs ON the proc-table kernel: ticks=76514 bgcounter=3678246 at the
prompt; across `primes 20` the background process advanced 353,620
counts, every switch decided by compiled C.

## Next

- Kernel-created processes: allocproc + a loader path so the kernel
  (not dmxgen) instantiates images — the precursor to exec/fork.
- fork(): copy + re-relocate a Tier-2 image (the relocation table is
  exactly the fork recipe); vfork-style sharing as the cheap variant.
- Console input via the kernel (SYS_read) so xv6's sh.c can replace
  dma-sh; then the file layer (fs.c stack on a flash block device).
