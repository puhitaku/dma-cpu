# Agent instructions for dma-cpu

CPU made of DMA on Raspberry Pi Pico: a toolchain (emulator, assembler/
linker, loader, a C compiler over stock clang IR, an xv6-derived kernel)
for the Turing-complete DMA controller in the RP2 family (RP2040/RP2350),
plus the boards it is deployed on.

Before architectural work, read `prompts/overview.md` (design analysis and
phased plan). Phase outcomes are logged in the numbered
`prompts/NNN-*.md` documents — newest number is the current state.

## Hard rules

- Never commit the reference article `references/datasheets/ece4760.pdf`
  or the code ZIPs it links (keep local copies git-ignored). They are
  copyrighted; see "Coding rules" in `prompts/overview.md`. Vendor
  datasheets and the licence-cleared trees under `references/` are
  committed on purpose — the rule is about that article, not about
  third-party material as such.
- Do not use "Cornell" or "ECE4760" in code, identifiers, comments, or
  repo-facing files. Name things after what they do (e.g. `fetchexec`);
  cite `prompts/overview.md` instead of the source article. The literal
  file path `references/datasheets/ece4760.pdf` in `.gitignore`, this rule
  and `prompts/overview.md`'s reference list, plus README's Special Thanks
  attribution, are the only exceptions.
- Code, comments, and docs are written in English.
- Every self-built tool is Go, standard library only (single module).
  Exceptions: the future LLVM backend (C++) and target-side code that
  runs on the Pico (`target/`, C99).
- Go source is gofmt's output, always — there is no reason good enough
  to override it, least of all hand-aligned struct fields or comment
  columns (interleaving a comment mid-struct is what drifted the tree
  before). Fix with `gofmt -w ./host`; `make test` fails on `gofmt -l`.
- Write "RP2" for family-generic statements. Name a specific SKU only in
  datasheet citations ("RP2040 datasheet §2.5", "RP2350 datasheet §12.6")
  and where a value is genuinely SKU-specific.

## Architecture invariants

- All SKU-specific encodings — CTRL bit layout, global register offsets,
  sizes, DREQ numbers, GPIO fields — live only in `emu.Variant`
  (`host/emu/variant.go`, instances `emu.RP2040`/`emu.RP2350`). Never hardcode
  them elsewhere. `TestVariantEncodings` pins them against the datasheets.
- Control words and DMX images are per-SKU and not portable; producers
  and loaders agree on the SKU out of band (`references/design_docs/dmx.md`).
- CTRL's CHAIN_TO and TREQ_SEL are fields, not flags: never OR a new
  value over a ctrl word that already has one (TREQ=permanent is all
  ones); rebuild the word.
- The emulator is silicon-calibrated on both SKUs (RP2350:
  `prompts/004-hw-calibration.md` for the verified facts — pre-write quiet
  on null CTRL_TRIG, zero-count immediate completion, credit cleared on
  trigger, trigger-drop while EN=0, CRC bit order, 15 sys-clk/block;
  RP2040: `prompts/040-gamepico.md`, whose headline is
  `Variant.SelfCountWedge` — a channel that writes its own TRANS_COUNT
  mid-transfer wedges past any abort or reset).
  Semantic changes to `host/emu/dma.go`/`host/emu/machine.go` need re-validation on
  hardware, and new behaviour must be tested on both SKUs (use the
  `forEachVariant` test helper).
- ABI v0 is frozen in `references/design_docs/abi.md` (channels, register file, calling
  convention, safepoint rule, HALT/NOP encodings). Changing it means a
  version bump and updating dmaasm, img, target/loader, dmxgen, and the
  doc together.
- Interrupts use approach B only (injector channel + safepoints;
  `prompts/006-phase3-results.md`). Never freeze (EN-clear) or
  abort-divert a running machine expecting to resume it — both wedge
  ~71 % of the time on silicon; CHAN_ABORT is for full restarts only.
- DMA-machine programs are written in `.dasm` (assembled by `dmaasm`,
  SKU chosen at assembly); the HIL images in `host/prog/hil/` are the
  reference programs — `host/cmd/dmxgen` assembles them into the firmware
  header, so hardware runs validate the assembler.
- C compiles via stock clang IR + the `dmacc` translator (Phase 4,
  `prompts/007-phase4-results.md`): `clang --target=armv6m-none-eabi
  -Oz -fno-unroll-loops -fsigned-char -ffreestanding -S -emit-llvm`,
  then `llir` (parser) + `dmacc` (codegen) emit SKU-portable .dasm. No
  register allocator by design: every SSA value is an SRAM word.
  Frames are static, so recursion buys its depth: a software frame
  stack (Options.FrameStack) for ordinary cycles; cycles that can span
  a fork get Options.RecursionDepth shallow clones and then fall into
  frame-stacked tail copies behind an inline fork-site barrier. Values
  wider than a word (i64) and floats are rejected outright.
  Differential tests (`host/dmacc/testdata/`) pin dmacc against host
  clang execution; regenerate goldens with `make llgen` (host clang
  required; keep -fsigned-char on both sides or `char` semantics
  diverge).
- The full-range comparison macros (`jsign`/`jeq`/`jlt`/`jltu`) exist
  because `jneg` is only correct for |v| < 2^28; compiled code must use
  them for arbitrary values. They dispatch through a pooled trampoline
  arena appended to .text (ABI v0.1, references/design_docs/abi.md).
  Where an operand's bit 31 is provably clear the algebra collapses to
  a single `jsign` (the restricted-range predicates in that doc).
- libc = picolibc (submodule `target/libc/picolibc`, BSD-licensed).
  Third-party code may be committed when its licence permits and LICENSE
  records the attribution per origin (xv6, picolibc, the vi port); the
  reference-article rule above still stands. picolibc is compiled through
  the normal pipeline, not ported: curated sources -> IR goldens in
  `target/libc/ll/` (`make libc`), linked by passing them to dmacc.
  Config lives in `target/libc/picolibc.h`
  (hand-written; integer-only stdio). stdout is UART0: dmacc maps the
  `__dma_uart_dr`/`__dma_uart_fr` globals to `%uartdr`/`%uartfr`; the
  emulator captures DR writes in `Machine.ConsoleOut`. See
  `prompts/008-libc-results.md` and `target/libc/README.md`.
- The xv6 tree (`target/xv6/PORT.md`) is sorted by ROLE, not by
  provenance: `kernel/` is the kernel, `user/` every user command and the
  user library, `dma/` the machine layer alone. Upstream files are
  patched in place — the pristine-vendor and verbatim rules are retired.
  Every board installs the SAME app set (`boards.stdApps`); missing
  hardware is a kernel `-ENODEV`, never a dropped binary.
- dmacc supports varargs (static va areas, whole-program sized),
  indirect calls (<= 4 register args), and multi-module linking
  (`llir.Merge`), and recursion (frame stack + fork-spanning clones).
  Still rejected: i64 values, floats, variadic-indirect calls.
- The compact encoding (Tier C, prompts/010 + 011): 8-byte records on
  a channel bank, `dmaasm` Options.Compact / `img.CompactMachine()` /
  loader `DMX_COMPACT_MACHINE_CFG`; classic remains the assembler
  default, but every shipped system (the xv6 bundles, the game) is
  compact. The planner enforces canonical state at instruction
  boundaries and cross-checks pass-1 sizing against emission. Mind the
  mode-domain rules in host/dmaasm/compact.go (notably: every record runs at its bank's
  CURRENT count; sniff sequences must consume the accumulator within
  one macro). `.ifcompact` gates encoding-specific dasm; block .count/
  .ctrl fields do not exist in compact (use %cnt8w/%cnt8rw + dyncount).
- Processes (Phase 5a, prompts/012): a process = a relocated image
  instance; context switch = swapping irqresume at a safepoint (all
  shared scratch is dead there by construction — keep it that way: no
  safepoints inside macros, millicode, or the runtime). The scheduler
  mechanism is host/prog/hil/kernel.dasm (policy lives in the compiled
  kernel); ticks arrive via a single one-shot injector — ABI ch3, ch9
  in compact — whose WRITE_ADDR the scheduler aims at the running
  process's dispatch word and re-arms at kernel exit only. dmacc's crt0
  thunk is the exported `crtthunk` (kernels use it as the dispatch EOI
  value).
- Size discipline (`prompts/009-size-results.md`): the standard clang
  flag is -Oz; dmacc garbage-collects unreachable functions/globals,
  forwards pure copies, and lowers comparisons through shared millicode
  helpers by default (4-5 blocks/site; Options.InlineCompares restores
  the fast inline form, Options.OptSize shrinks the site further to two
  descriptor records at ~2x the branch cost). A value-range analysis
  (`host/dmacc/facts.go`: an upper bound per SSA word, fixed-point from
  the pessimistic top, narrowed inside the region a dominating branch
  proves it in, and whole-program — a parameter's bound is the meet
  over every call site, a call's result the meet over the callee's
  returns, with an escape rule that keeps address-taken, entry and
  loader-entered functions unbounded) routes the sites whose operands
  provably keep bit 31 clear to the shorter `__cw_eqzp`/`__cw_ltp`
  bodies — same site size, less helper. The same comparison may lower
  differently in two blocks. A record-level outliner and an ICF fold
  run last (`host/dmacc/outline.go`, prompts/042 §4): repeated
  instruction sequences move into shared helpers entered by a jump and
  left by a `jumpr` through one shared cell, ~5% of kernel text. Both
  are gated to cold code — blocks off every CFG cycle, and never
  Options.HotFuncs or ResidentFuncs — because an outlined site pays a
  record or two every time it runs; Options.NoOutline turns them off.
  `dmacc -size` prints block attribution and `dmacc -bounds` the value
  ranges with the call site that pinned each parameter — measure
  before optimizing. dmxgen bakes relocations out
  of the HIL images (they load at link addresses only). When touching
  the lowering, keep the differential suite bit-exact — it caught the
  phase's only miscompile.
- Measurement is a package, not a probe (`host/trace`, prompts/042 §8).
  `emu.Machine.ProfileWindows` counts bus reads per word;
  `trace.Symbolize` turns a .dasm plus its assembly into a label table
  and `Table.Attribute` folds those counts onto functions, blocks,
  comparison sites, runtime/millicode helpers and dmacc's emission
  tags, with a ranked `Heat.Report`. Over TEXT a word read is an
  instruction fetch, so the counts are exact EXECUTION counts; they are
  not cycles (a cycle is one word MOVED, so a bulk-copy record costs
  far more than its single fetch), and the emulator models no XIP wait
  states, so "flash reads" means "reads that would park the read
  master", not stall time. Ownership comes from the .dasm label stream
  plus `dmaasm.Options.InternalSyms`: attributing over plain
  `Result.Symbols` drops every `__`-prefixed label and credits the
  runtime, the compare millicode and the outliner's return stubs to
  whatever compiled function precedes them (1.0% of the kernel's text
  reads, 8.5% of sh's).

- The HDMI display (prompts/036, Feather board): two board-pool
  channels (`boards.ScanoutTable`, walker ch14 + executor ch15) stream
  the SRAM framebuffer (`boards.FbBuf`) into the HSTX FIFO with no CPU
  in the path. What that cost, all silicon-measured: the descriptor
  table must RUN FROM SRAM (`Board.DTabRAM`) — the walker's own reads
  cannot touch the stallable XIP window; HIGH_PRIORITY belongs to the
  pixel pair ONLY; and everything else that reads flash must stay off
  the shared read master (exec's copies go through the QMI streamer,
  the idle machine off flash entirely) or the FIFO's ~1.3 us budget
  slips. The core-1 CPU feeder that preceded it survives behind
  `HIL_VIDEO_CPU_FEEDER=1` as the fallback. PSRAM is a storage tier,
  not working memory: sustained machine window traffic breaks sync
  even though the accesses themselves are wire-speed (prompts/041
  corrects the 036 "~1000x slower" figure — it was copier contention).
  kfb.c/kfbcon.c ride only framebuffer boards' kernels; every other
  build links the no-op `kfbstub.c` (kfsstub-style) — a kernel list
  that links kproc must include one of the two. The HSTX FIFO write
  port is base+4 (base+0 is STAT and discards silently). Framebuffer
  boards sync flash through the ARM mailbox executor, never QMI direct
  mode.

- The game console (prompts/040, gamepico board): `target/game/` is
  bare-metal C on the machine, no xv6 — one shared arena (`g_arena`)
  holds the running game's bulk state, and a 16 KiB ring at a 16
  KiB-aligned address feeds I2S through ch9. Two rules the silicon
  taught: (a) the machine has no right-shift instruction and no divide,
  so `>>`, `/` and `%` are only cheap when the compiler can see the
  count or the divisor — a constant count is a byte-lane copy and a
  constant power-of-two divisor a shift and a mask, both inline, and
  the divisor 10 is an outlined reciprocal (~410 cycles); a VARIABLE
  count or any other divisor is a runtime call, and a general divide
  costs thousands of cycles. Per-frame code still prefers fractional
  accumulators, lookup tables and left shifts; after a C edit run
  `make game-ll` and grep the regenerated IR for
  `ashr`/`lshr`/`sdiv`/`udiv`/`urem` on frame paths, and check that the
  operand is a constant; (b) the LCD flush
  is asynchronous and `gdma_rows` returns with its last row still
  draining, so every CPU-store path into `fb` calls `gd_wait()` first
  — but `frame_sync` must NOT, because ch11 belongs to pcm playback
  during clips (waiting there deadlocks the game-over sting). The
  ST7789 is write-only: no TE line, no MISO, so tearing is managed by
  the frame's own two-phase erase/draw order.
- Overclocking (the Feather runs clk_sys at 300 MHz, the gamepico at 250,
  via `boards.ClkSysKHz`), three silicon laws: (a) RP2350's POWMAN clamps
  VREG to 1.15 V until `vreg_disable_voltage_limit()` — a plain
  vreg_set_voltage is silently clamped and the chip garbles logic
  chip-wide at speed; (b) clk_peri is specced to 150 MHz — divide it
  back down (RP2350 gave it a divider) or the UART mangles bytes in
  both directions at the correct baud; (c) never call the SDK's
  `psram_reinitialize()` on a live card — it re-sends the SPI-mode
  QUAD_ENABLE to a chip already in QPI (wedging it) and its
  flash_start_xip drops flash to slow serial; rewrite QMI M1 TIMING
  only. The scheduler tick derives from the clock via
  `Board.TickCycles()` (100 us wall); the emulator keeps its own
  15000-cycle tick — emulator cycles were never silicon cycles.

## Build, test, hardware

- `make test` = `gofmt -l` + `go vet` + all golden tests. Run it before
  committing.
- `make llgen` regenerates the compiler IR goldens + host expectations
  (needs host clang; only when host/dmacc/testdata/*.c change).
- `make xv6-ll` / `make game-ll` / `make libc` regenerate the committed
  IR goldens of the kernel, the game console and picolibc; every C
  change on those trees needs the matching one.
- `make pgo` regenerates the profile-guided settings in `host/pgo`
  (hot literal pools per image, hot functions per image) by running
  every deployable payload's workload in the emulator — see
  `prompts/042-compiler-opts.md` §1. Those files are build INPUTS, not
  goldens: regenerating moves image layout and cycle counts, so it is
  a measurement to report, never a way to make a test pass. Re-run it
  after a workload-relevant C change on the kernel, sh, vi or the game;
  `make test` does not.
- `make ratchet` rewrites `host/dmacc/testdata/ratchet.txt`, the
  committed size and cycle figures `make test` then verifies EXACTLY —
  every `TestZZAllSizes` size and `TestZZBenchXsh`'s six-command
  cold/warm cycle table. The emulator is deterministic, so any drift
  fails, including an unrecorded IMPROVEMENT: the number is what the
  next round measures against. `make ratchet DMACC_BENCH=1` also
  refreshes the heavy rows (vi, fbcon, the game benchmark), which the
  cheap regeneration carries over untouched and which are only checked
  under `DMACC_BENCH=1`. Like `make pgo`, a regeneration is a
  measurement to report, not a way to make a red run green.
- `make build` builds the `dmaemu`/`dmaasm`/`dmacc` CLIs; `make images` regenerates
  `target/firmware/generated/images.h` via `host/cmd/dmxgen` for the
  selected board (required whenever test programs, IR goldens or
  emulator semantics change); `make firmware` builds the firmware;
  `make test-hw` flashes it. Everything board-dependent keys off
  `HIL_BOARD` (`pico2` default, `pico`, `feather`, `gamepico`), and
  `HIL_DEV=1` keeps the on-boot test/calibration suite that release
  builds drop.
- Toolchain defaults (this machine; override via Makefile vars):
  pico-sdk 2.3.0 + GCC + CMake + Ninja under `~/.pico-sdk/`, OpenOCD at
  `~/dev/github.com/raspberrypi/openocd/prefix/bin/`.
- HIL bench: Pico 2 (RP2350) on a Debug Probe; UART `/dev/cu.usbmodem102`
  at 115200 prints the boot log, and TEST/CAL/EXP lines every few seconds
  in an `HIL_DEV=1` build. Gotchas: a VS Code OpenOCD or `minicom` may
  hold the probe/UART; if SWD
  examination fails (wild-machine episode), rescue once with
  `target/rp2350-rescue.cfg`, then flash; avoid flashing while the
  stress experiments are mid-run.

## Conventions

- Each phase ends with a `prompts/NNN-<topic>.md` results document
  recording what was built, findings, and open items.
- Commits: short imperative subject + a body listing the substantive
  changes (see `git log`).
- Temporary/experiment files go outside the repo, never committed.
