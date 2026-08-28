# Porting xv6 to the DMA machine

This tree was vendored at the commit recorded in `UPSTREAM` and is
patched in place from there. Two early rules are RETIRED and must not
come back:

- **The pristine rule is dead.** The tree no longer promises that
  `git diff <vendor-commit>` isolates the port, and upstream files
  are not kept verbatim (the no-verbatim decision, prompts/029:
  printf's ~20 KB tax bought nothing a small write() helper didn't).
  Patch upstream sources wherever it pays — in upstream's own style,
  with changes a reviewer of the file would accept.
- **Provenance is not the sorting key.** Files live where their ROLE
  puts them, following upstream xv6's own layout culture — that
  convention is the first thing to respect when working inside an
  existing OSS tree. xv6's license is permissive and this project's
  additions are distributed under it, so there is no licensing reason
  (and no other reason) to quarantine "our" files apart from theirs.

## Layout

- `kernel/` — the kernel: upstream sources, patched in place.
- `user/` — user space: the library (ulib/umalloc/printf) and EVERY
  user command, upstream or DMA-native alike (`show`, `fbtest`,
  `toolbox`, `hwtools`, the signal demos). A user program never
  lives in `dma/`.
- `dma/` — the machine layer only: kernel-side replacements and
  drivers (`k*.c`), the syscall veneer (`usys.c`, this machine's
  "ecall"), the `shim/` headers, and bare-metal probe images that
  are not xv6 programs at all (`calflash.c`).

## Device absence

Every board builds and installs the SAME user command set. A command
must be portable **as an executable**: it always loads and runs, no
matter whether the hardware it drives exists on the board. Missing
hardware is the KERNEL's problem — the driver or its stub answers
`-ENODEV` (`kernel/types.h`) and the command reports the miss (`show`
on a displayless board prints "no fb" and exits). Never solve a
missing device by dropping a binary from a board's app set.

## Rules

- New machine-layer code goes in `xv6/dma/`; new user commands go in
  `xv6/user/`; a machine-dependent upstream file may be replaced
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

Every upstream file still sits in `kernel/`; the port compiles only
string.c (XV6_SRCS) plus fs.c and file.c (XV6_FS_SRCS). The table
records what took over for the rest — DELETE/REPLACE mean "nothing
here builds it", not that the file was removed.

| Upstream | Fate |
|---|---|
| string.c | KEEP (32-bit clean; first file through the pipeline); memset/memmove copy a word at a time once dst and src are mutually word-aligned, byte-wise otherwise — same for `user/ulib.c` |
| fs.c, file.c | KEEP — compile VERBATIM against `xv6/dma/shim` headers (no-op locks, pointer-data bufs, fs-view proc); prompts/019 |
| bio.c, log.c, virtio_disk.c | REPLACED by `xv6/dma/kbio.c` (RAM disk: bread returns pointers into the image; no log) |
| pipe.c | REPLACED by `xv6/dma/kpipe.c` (deposit-rendezvous: peers complete blocked ends; no kernel stacks to sleep on) |
| proc.c, syscall.c, sysproc.c | REPLACED by `xv6/dma/kproc.c` (upstream's are built around kernel stacks/swtch/paging; the shapes survive — struct proc, the state enum, sleep/wakeup, exit/wait, round-robin scheduler(), upstream syscall numbers) |
| sysfile.c | REPLACED by the fd-level bodies in `xv6/dma/kfsglue.c` (mailbox ABI instead of trapframe args) |
| console.c, printk.c | REPLACED by the console paths in `xv6/dma/kproc.c` (cooked input, the `__dma_uart_*` wire) and printk in `kfsglue.c` |
| spinlock.c, sleeplock.c | REPLACED by the no-op bodies in `xv6/dma/kfsglue.c` (single hart; the API stays intact) |
| exec.c | REPLACED by SYS_exec in `xv6/dma/kproc.c` (loads DMX images via Tier-2 relocation instead of ELF+paging) |
| kalloc.c | REPLACED by the arena allocator in `xv6/dma/kproc.c` (first-fit with coalescing, no page tables) |
| vm.c | DELETE (no MMU; isolation by relocation) — vm.h survives for its SBRK_* flags |
| trap.c, kernelvec.S, trampoline.S, swtch.S, entry.S, start.c | REPLACE (approach-B safepoints, injector chains, crt0/loader — already built in the substrate) |
| riscv.h, memlayout.h, plic.c, uart.c, virtio_disk.c | REPLACE (DMA-machine equivalents in `xv6/dma/`) |

user/: KEEP where portable (umalloc.c, ulib.c, sh.c, the utilities);
usys.pl's ecall stubs REPLACED by dispatch-patch syscall stubs
(`dma/usys.c`). DMA-native commands live here too (see Layout).

## File disposition (user/vi.c)

`user/vi.c` is BusyBox 1.38.0's editor (prompts/033) compiled against
`user/libbb.h`, this tree's shim for the BusyBox runtime; the feature
set it builds with is the `ENABLE_FEATURE_VI_*` block at the top of
that header. Where the port departs from vendor vi.c:

| Change | Why |
|---|---|
| `refresh()` re-formats only the screen lines the change since the last one can have reached — `text_changed()` records the touched span, how much text[] grew there and how many newlines came or went, and a screen the change did not reach is skipped whole (`text_repainted()` clears it, `screen_erase()` invalidates it) | vendor vi re-formats and 80-column-diffs all 23 lines on every keystroke, one changed cell or none; that was most of what a keypress cost on this machine. A byte moving is not a line moving: only a newline coming or going dirties the lines below |
| `format_edit_status()` reads the kept `total_lines` where vendor vi computes `cur + count_lines(dot, end - 1) - 1` | the vendor call walks to the end of the file after every change — the one per-keystroke term that grew with file size. `total_lines` counts the same newlines incrementally, in the two holes text[] changes through plus the handful of in-place writers (`stupid_insert`, ctrl-V, `J`, `~`) |
| `open(NULL)` guarded, 2-arg `open()`, no getopt32, no EXINIT/`.exrc`, `main()` exits rather than returns | the xv6 API, and no environment to read; each marked `dma:` at its site |

`TestXv6ViScreen` (host/dmacc/viscreen_test.go) is the regression net
for all of it: it folds vi's escape output back into a 24x80 cell grid
and pins the rendered screen, phase by phase, against a golden taken
before the repaint work. vi may emit different bytes; it may not draw
a different screen.

## Progress

- [x] `user/umalloc.c` + `kernel/string.c` compile and run
  on the machine (self-checking allocator exercise,
  `TestXv6Malloc`); the heap came from a `xv6/dma/sbrk.c` stub, since
  replaced by the kernel's SYS_sbrk (below).
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
- [x] Machine-only flash writes: WORK (prompts/028, retracting
  prompts/023's "hardware-blocked"). The prompts/023 stalls were
  ACCESSCTRL bus faults: XIP_QMI and XIP_CTRL reset with DMA access
  FORBIDDEN (0xB8, datasheet §10.6.2.1) while everything else the
  machine touches resets open (0xFC). Two password-carrying writes in
  the firmware's main() open them, and the reinstated QMI direct-mode
  driver runs entirely on the machine: exit-XIP dance, WREN, real
  RDSR/WIP polling, erase/program, then a serial-read XIP config so
  metadata reads keep working. kflash_arm defaults to 0 — SYS_sync is
  machine-only on silicon (verified: sync with the ARM in wfi, hard
  reset, "disk: FLASH SLOT gen 1", file intact); the ARM mailbox
  executor remains as a dormant fallback. The ARM's only remaining
  job is boot: load, unlock, park.
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
- [x] `free` command (prompts/029): SYS_meminfo reports the exec
  arena (total/used/free/largest), the heap and exec-image shares
  inside it, proc-slot usage and uptime; `free` prints it. Silicon
  shows sh's 33 KB malloc chunk and the running tool's own image.
- [x] `mount` command and mechanism (prompts/029): SYS_mount/
  SYS_umount, a mount table with path-prefix routing in kfsglue,
  FAT-aware cwd (cd into and out of the mount, relative reads, exec
  falls back to the xv6 root), read-only guards on every write path,
  and vfs_* dispatch shims that file.c reaches via shim-header
  renames (compiled with -DDMA_VFS_CALLS) — fs.c/file.c stay
  unpatched. Busy mounts (open files, cwds inside) refuse umount.
- [x] vfat / FAT32 (prompts/029): a read-only FAT32 driver
  (xv6/dma/kfat.c) over an XIP-resident volume — BPB-driven geometry,
  cluster-chain walks, 8.3 + VFAT long names, dirs synthesized as
  xv6 dirents so upstream ls works — plus a Go FAT32 image builder
  (fsimg/fatimg.go). Mountable in the emulator AND on silicon: the
  firmware stages a golden 64 KB volume into flash at 0x10140000 and
  `mount fat0 /mnt` reads it from real flash. This phase also ended
  the printf tax (the no-verbatim decision): cat/ls/sh emit via tiny
  write() helpers, the dma utilities merged into one multi-call
  `toolbox` binary (busybox-style argv[0] dispatch, hard links from
  fsimg.AddLink), the disk slimmed to 96 KB, and the machine RAM
  base dropped to 0x20002000 (the firmware's unused headroom).
- [x] More peripherals for the machine (prompts/034): SYS_gpio /
  SYS_pinmux / SYS_pio drive IO_BANK0, PADS_BANK0 and the PIO register
  files straight from the machine (`xv6/dma/kgpio.c`, front ends in
  `user/hwtools.c`), and devfs lists the machine's resources as
  readable files under /dev (`xv6/dma/kdev.c`).

## Presentation goals (beyond xv6)

The machine presents itself at an upcoming event. Display output, two
options, both PIO-era techniques on the machine's own terms:

- [x] Option 1 — DVI out (prompts/036): the RP2350 HSTX serializer
  driving a DVI signal, fed by a pure-DMA scanout the machine owns —
  640x480x8 in SRAM plus a terminal emulator on it (`xv6/dma/kfb.c`,
  `kfbcon.c`); SYS_fb hands the framebuffer to a user program.
- [ ] Option 2 — USB out: driving a DisplayLink-class USB display
  adapter with a PIO USB host; reference OSS vendored as the
  `references/pico-usb-disp` submodule (htlabnet Pico_USB_Disp — the
  T6 protocol encoder + PIO USB host are the parts to study).
- [x] mount() + external SD card (prompts/037): `mount sd0 /mnt` puts
  a vfat card under the fs — SPI SD driven by the machine itself
  (`xv6/dma/ksd.c`, CMD17 sectors and CMD18 spans) behind the same
  read-only FAT32 driver as the XIP volume; syscall/design reference
  vendored as `references/xv6-ns` (an xv6 fork with mount and more
  syscalls — we take mount, NOT namespaces).

`references/` submodules are study material, not vendored code: if
anything is derived from them into the tree, it gets a LICENSE
section per the project's attribution format at that moment.
