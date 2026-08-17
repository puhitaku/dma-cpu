# Porting xv6 to the DMA machine

This tree was vendored pristine at the commit recorded in `UPSTREAM`;
every DMA-specific change lives in commits after that one, so
`git diff <vendor-commit> -- xv6/` is always the complete port.

## Rules

- Upstream files are modified **in place, minimally** — no
  reformatting, no gratuitous renames. New DMA-machine code goes in
  `xv6/dma/` (clearly ours) or replaces a machine-dependent file
  outright (noted in the table below).
- Types: the DMA machine is ILP32 with no i64. `uint64` in
  machine-dependent code becomes `uint`; the on-disk fs format is
  already 32-bit. `long` is 32-bit under our ABI (ILP32) — upstream
  uses it only for alignment.
- Build: selected sources compile through the standard pipeline
  (clang -Oz → `xv6/ll/*.ll` goldens via `make xv6-ll` → linked by
  dmacc). No xv6 Makefile, no RISC-V toolchain, no qemu.
- Concurrency: one hart, interrupts only at safepoints — spinlocks
  degenerate to no-ops (acquire/release keep their API), and
  `push_off/pop_off` becomes dispatch-thunk save/restore if ever
  needed.

## File disposition (kernel/)

| Upstream | Fate |
|---|---|
| string.c | KEEP (32-bit clean; first file through the pipeline) |
| fs.c, file.c | KEEP — compile VERBATIM against `xv6/dma/shim` headers (no-op locks, pointer-data bufs, fs-view proc); prompts/019 |
| bio.c, log.c, virtio_disk.c | REPLACED by `xv6/dma/kbio.c` (RAM disk: bread returns pointers into the image; no log) |
| pipe.c | REPLACED by `xv6/dma/kpipe.c` (deposit-rendezvous: peers complete blocked ends; no kernel stacks to sleep on) |
| proc.c, syscall.c, sysproc.c | REPLACED by `xv6/dma/kproc.c` (upstream's are built around kernel stacks/swtch/paging; the shapes survive — struct proc, the state enum, sleep/wakeup, exit/wait, round-robin scheduler(), upstream syscall numbers) |
| sysfile.c | REPLACED by the fd-level bodies in `xv6/dma/kfsglue.c` (mailbox ABI instead of trapframe args) |
| console.c, printf.c | ADAPT (backed by the `__dma_uart_*` path) |
| spinlock.c, sleeplock.c | ADAPT (single hart: no-op locks with intact API) |
| exec.c | ADAPT (loads DMX images via Tier-2 relocation instead of ELF+paging) |
| kalloc.c | ADAPT (region allocator, no page tables) |
| vm.c, vm.h | DELETE (no MMU; isolation by relocation) |
| trap.c, kernelvec.S, trampoline.S, swtch.S, entry.S, start.c | REPLACE (approach-B safepoints, injector chains, crt0/loader — already built in the substrate) |
| riscv.h, memlayout.h, plic.c, uart.c, virtio_disk.c | REPLACE (DMA-machine equivalents in `xv6/dma/`) |

user/: KEEP where portable (umalloc.c, ulib.c, sh.c, the utilities);
usys.pl's ecall stubs REPLACED by dispatch-patch syscall stubs.

## Progress

- [x] `user/umalloc.c` + `kernel/string.c` compile unmodified and run
  on the machine (self-checking allocator exercise,
  `TestXv6Malloc`); `xv6/dma/sbrk.c` provides the heap.
- [x] Syscall mechanism: call-shaped kernel entry (`xv6/dma/usys.c`
  stubs → kernel.dasm vectors → C kernel core). write/getpid/uptime/
  pause/exit live under preemption (`TestXv6Syscalls`, prompts/014).
  Upstream `kernel/syscall.h` numbering.
- [x] proc.c adaptation (`xv6/dma/kproc.c`, prompts/015): N-slot proc
  table with the upstream state enum, sleep/wakeup channels, real
  pause(n)/exit/wait with ZOMBIE reaping and deposit-at-exit, the
  scheduler in C, kernel.dasm reduced to two entry stubs, a single
  one-shot tick injector. Silicon-validated.
- [x] The file system (prompts/019): fs.c + file.c VERBATIM over shim
  headers; RAM disk (kbio), deposit-rendezvous pipes (kpipe), fd
  tables + cwd per process, console as devsw[CONSOLE], exec from
  DMX-exec files on disk (fsimg: Go mkfs + executable format), arena
  freeing. cat/wc run byte-for-byte upstream; redirection and pipes
  work at the silicon $ prompt. ls awaits the compact-encoding rung
  (RAM budget).
- [x] UPSTREAM sh.c as the shell (prompts/018): dmacc gained tail-call
  optimization (frameless single-call wrappers) and bounded recursion
  via depth cloning (functions on call cycles — plus fork-callers
  reachable from them, the vfork-reentrancy set — get per-depth
  frames); the kernel completes syscalls into the caller's r0. sh.c
  runs byte-for-byte upstream: exec with argv, `;` lists over nested
  vfork, error paths. Silicon-validated. Pipes/redirection await fs.
- [x] SYS_read + argv (prompts/017): cooked console input (the
  consoleintr slice of console.c in kproc.c: echo, backspace, CR→NL),
  blocking read() via tick-retry, argv passed through the exec'd
  image's r0/r1. Upstream ulib.c + echo.c run unmodified (printf.c
  narrowed to ILP32); dma-sh spawns them interactively with `run`.
  Silicon-validated; also fixed a silicon-only lost-tick window in
  the kernel entry path. Upstream sh.c is BLOCKED on dmacc dynamic
  frames (parsecmd/runcmd recursion) — the next compiler rung.
- [x] fork/exec (prompts/016): the loader lives IN the kernel — an
  image registry (pre-parsed segments + packed relocs), a bump
  allocator, and exec() that places, relocates and runs a fresh
  image. fork() has vfork semantics (no MMU: child shares the image,
  parent suspended until exec/exit; exec and exit use private syscall
  stubs so the shared frames survive). The fork() return value is
  deposited by the child's exec/exit. Silicon-validated
  (fork→exec→wait→exit end to end).
- [x] Compact (Tier-C) whole-system encoding (prompts/020): kernel,
  sh, and all user programs in 8-byte records; `ls` restored, clone
  depth 8, 128 KiB disk, 60 KiB arena. Required a machine-global
  window selector (dmaasm CompactScratch) — per-image selectors
  cannot share one machine — and the injector on compact channel 9.
  Closed the long-open compact+scheduler validation. Silicon-green.
- [x] The exam (prompts/021): upstream usertests.c compiles verbatim
  (shadow riscv/memlayout shims) and runs preloaded, one test per
  boot — 30/30 on the curated roster (all fs tests, vfork-discipline
  process tests). Caught the console-inode bug (disks now carry a
  real T_DEVICE console, as mkfs does), sbrk shrink, and dmacc's i64
  copy-pair lowering. Exclusion reasons documented.
- [x] Persistence (prompts/022): single flash slot (header-last
  commit, generation counter, word-sum checksum, golden fallback).
  Sync policy lives in the kernel (log_write dirty-sector map,
  incremental burns); primitives run on a pluggable executor — QMI
  direct mode (reference, emulator-validated three-boot loop) or the
  parked ARM's SRAM loop running SDK flash routines (silicon: the
  quad-mode exit-XIP dance belongs to the bootrom). Files survive
  hard reboots on hardware ("disk: FLASH SLOT gen 2").
- [x] Machine-only flash writes: CHARACTERIZED AS HARDWARE-BLOCKED on
  RP2350 (prompts/023). Deep silicon diagnostic (firmware samples the
  machine's fetch/exec PC while the ARM waits in SRAM) proved: the DMA
  engine cannot read QMI registers (reads stall), and setting
  DIRECT_CSR.EN freezes ALL its peripheral reads irrecoverably (they
  stay 0 after EN is cleared). So the machine can drive flash WRITES
  (the bit-banged exit-XIP dance completes) but can neither poll
  status, time its own delays, nor verify. The ARM executor is the
  irreducible ~dozen SDK calls; persistence ships on it (re-verified,
  gen 2). Reproducible cal_flash probe prints the finding every boot.
- [x] kill() + init-style orphan reaping (prompts/024): a `killed`
  flag enforced at kernel entry, one shared terminate() path for
  exit/kill, orphans adopted by a loader-named init pid (the idle
  proc, which never waits, so adoptees free without lingering). The
  disk gains compact printf-free `kill` and `spin` utilities; the
  silicon demo (`spin &` … `kill 5`) stops the dots mid-prompt.
  Chasing a timer regression this exposed fixed two latent lost-tick
  hazards: preloaded processes now first-schedule at `warmstart` with
  dispatch preset by the loader (a cold-entry crt0 could clobber a
  just-landed fire), and the nothing-runnable park is now a wakeable
  spin through a kernel-owned `parkvec` the injector patches, instead
  of an unwakeable HALT.
- [x] Per-process heap (prompts/025): SYS_sbrk in the kernel — per-proc
  heapbase/heapmax/brk, chunks allocated lazily from the exec arena
  (the 36 KB static BSS heap every malloc-linked binary carried is
  gone), new bytes zeroed, and fs buffers in the returned region
  [brk, heapmax) refused (rwsbrk's contract). vfork sharing is
  honored: upstream sh mallocs in the CHILD, so chunk identity and
  ownership mirror up the suspended parent chain, and exec syncs the
  break while exit rolls it back. Exam roster grows to 36 with
  rwsbrk, sbrkarg, sbrklast, sbrk8000 (heap) and reparent, reparent2
  (adoption); sbrkbasic/sbrkmuch stay out (fork-divergent memory /
  100 MB VA). The emulator's loader now refuses cross-image overlaps
  — the silent-clobber class this phase kept hitting.
- [x] Signals, with user-space handling in commands (prompts/026):
  Ctrl-C interrupts the foreground job — the subtree under the fgpid
  shell's wait()/vfork suspension; a shell at its prompt has no
  foreground job, so background work survives. Default action is the
  kill() death (wait reports -1); signal(SIGINT, fn) registers a
  user-space handler — the kernel diverts the victim's next resume
  into the image's usys stub (saving r0/r1 and the resume point in a
  registration-time sigctx), a sleeping victim's syscall returns -1
  first, and SYS_sigreturn restores everything. The RX FIFO drains
  every tick (gated on fgpid, so raw-UART programs keep working).
  Silicon-validated: ^C kills a foreground cat, the `trap` demo
  catches it and exits politely, and a background spin outlives a
  prompt-time ^C.
- [x] Parenthesized sh commands (prompts/027): sh's clone budget goes
  to K=12 (an xsh RAM rebalance pays the ~26 KB of parse-cycle
  clones) — `((x))`, `(a; (b))`, `(a) ; (b)`, and redirected subshell
  pipelines `(ls | wc) > n` all work. Deeper nesting no longer halts
  the machine: dmacc's recursion-overflow sink is routable to a
  program-defined `__dmacc_recursion_overflow` (usys reports
  "recursion too deep" and exits), so the overflowing vfork child
  dies as a process and the shell survives.
- [ ] More peripherals for the machine (GPIO/PIO surface).

## Presentation goals (beyond xv6)

The machine presents itself at an upcoming event. Display output, two
options, both PIO-era techniques on the machine's own terms:

- [ ] Option 1 — DVI out: the PIO/HSTX DVI technique (RP2350 HSTX
  serializer driving a DVI signal; framebuffer fed by the machine).
- [ ] Option 2 — USB out: driving a DisplayLink-class USB display
  adapter with a PIO USB host; reference OSS vendored as the
  `references/pico-usb-disp` submodule (htlabnet Pico_USB_Disp — the
  T6 protocol encoder + PIO USB host are the parts to study).
- [ ] mount() + external SD card: a second block device (SPI SD via
  PIO or spare channels) mounted into the fs when the internal disk
  runs short; syscall/design reference vendored as `references/xv6-ns`
  (an xv6 fork with mount and more syscalls — we take mount, NOT
  namespaces).

`references/` submodules are study material, not vendored code: if
anything is derived from them into the tree, it gets a LICENSE
section per the project's attribution format at that moment.
