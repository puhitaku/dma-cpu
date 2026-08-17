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
- [ ] Persistence (NEXT): single-slot flash layout, kept simple by
  decision — region 1 = firmware + rodata (baked images, golden
  fs.img), region 2 = ONE fs slot (4 KB header: magic/generation/
  length/CRC32, then the disk image), no free area, no A/B. Sync is
  kernel-driven over QMI direct mode with the ARM parked in an
  SRAM-resident `wfi` loop (no flash fetches); header programmed
  last, so a torn sync falls back to the golden image. `cal_flash`
  silicon experiment gates the QMI driver.
- [ ] kill() + init-style orphan reaping (expands the usertests
  roster: killstatus, reparent, preempt-adjacent tests).
- [ ] Per-process heap (real sbrk semantics; admits the sbrk* tests).
- [ ] Parenthesized sh commands (deeper clone budget exists now).
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
