# Agent instructions for dma-cpu

CPU made of DMA on Raspberry Pi Pico: a toolchain (emulator, assembler/
linker, loader, eventually LLVM and an xv6-derived kernel) for the
Turing-complete DMA controller in the RP2 family (RP2040/RP2350).

Before architectural work, read `prompts/overview.md` (design analysis and
phased plan). Phase outcomes are logged in `prompts/00N-*-results.md` /
`prompts/004-hw-calibration.md` — newest number is the current state.

## Hard rules

- Never commit third-party reference material: `doc/ece4760.pdf` and the
  code ZIPs it links (keep under git-ignored `third_party/`). They are
  copyrighted; see "Coding rules" in `prompts/overview.md`.
- Do not use "Cornell" or "ECE4760" in code, identifiers, comments, or
  repo-facing files. Name things after what they do (e.g. `fetchexec`);
  cite `prompts/overview.md` instead of the source article. The literal
  file path `doc/ece4760.pdf` in prompts/.gitignore is the only exception.
- Code, comments, and docs are written in English.
- Every self-built tool is Go, standard library only (single module).
  Exceptions: the future LLVM backend (C++) and target-side code that
  runs on the Pico (`target/`, C99).
- Write "RP2" for family-generic statements. Name a specific SKU only in
  datasheet citations ("RP2040 datasheet §2.5", "RP2350 datasheet §12.6")
  and where a value is genuinely SKU-specific.

## Architecture invariants

- All SKU-specific encodings — CTRL bit layout, global register offsets,
  sizes, DREQ numbers, GPIO fields — live only in `emu.Variant`
  (`emu/variant.go`, instances `emu.RP2040`/`emu.RP2350`). Never hardcode
  them elsewhere. `TestVariantEncodings` pins them against the datasheets.
- Control words and DMX images are per-SKU and not portable; producers
  and loaders agree on the SKU out of band (`doc/dmx.md`).
- CTRL's CHAIN_TO and TREQ_SEL are fields, not flags: never OR a new
  value over a ctrl word that already has one (TREQ=permanent is all
  ones); rebuild the word.
- The emulator is silicon-calibrated (RP2350; see
  `prompts/004-hw-calibration.md` for the verified facts: pre-write quiet
  on null CTRL_TRIG, zero-count immediate completion, credit cleared on
  trigger, trigger-drop while EN=0, CRC bit order, 15 sys-clk/block).
  Semantic changes to `emu/dma.go`/`emu/machine.go` need re-validation on
  hardware, and new behaviour must be tested on both SKUs (use the
  `forEachVariant` test helper).
- ABI v0 is frozen in `doc/abi.md` (channels, register file, calling
  convention, safepoint rule, HALT/NOP encodings). Changing it means a
  version bump and updating dmaasm, img, target/loader, dmxgen, and the
  doc together.
- Interrupts use approach B only (injector channel + safepoints;
  `prompts/006-phase3-results.md`). Never freeze (EN-clear) or
  abort-divert a running machine expecting to resume it — both wedge
  ~71 % of the time on silicon; CHAN_ABORT is for full restarts only.
- DMA-machine programs are written in `.dasm` (assembled by `dmaasm`,
  SKU chosen at assembly); the HIL images in `prog/hil/` are the
  reference programs — `cmd/dmxgen` assembles them into the firmware
  header, so hardware runs validate the assembler.
- C compiles via stock clang IR + the `dmacc` translator (Phase 4,
  `prompts/007-phase4-results.md`): `clang --target=armv6m-none-eabi
  -O1 -fno-unroll-loops -fsigned-char -ffreestanding -S -emit-llvm`,
  then `llir` (parser) + `dmacc` (codegen) emit SKU-portable .dasm. No
  register allocator by design: every SSA value is an SRAM word. v0
  limits: no recursion (static frames), no i64/float/varargs/indirect
  calls. Differential tests (`dmacc/testdata/`) pin dmacc against host
  clang execution; regenerate goldens with `make llgen` (host clang
  required; keep -fsigned-char on both sides or `char` semantics
  diverge).
- The full-range comparison macros (`jsign`/`jeq`/`jlt`/`jltu`) exist
  because `jneg` is only correct for |v| < 2^28; compiled code must use
  them for arbitrary values. They dispatch through a pooled trampoline
  arena appended to .text (ABI v0.1, doc/abi.md).
- libc = picolibc (submodule `lib/picolibc`, BSD-licensed — the ONLY
  third-party code that may be committed/referenced; the Cornell rule
  above still stands). It is compiled through the normal pipeline, not
  ported: curated sources -> IR goldens in `libc/ll/` (`make libc`),
  linked by passing them to dmacc. Config lives in `libc/picolibc.h`
  (hand-written; integer-only stdio). stdout is UART0: dmacc maps the
  `__dma_uart_dr`/`__dma_uart_fr` globals to `%uartdr`/`%uartfr`; the
  emulator captures DR writes in `Machine.ConsoleOut`. See
  `prompts/008-libc-results.md` and `libc/README.md`.
- dmacc supports varargs (static va areas, whole-program sized),
  indirect calls (<= 4 register args), and multi-module linking
  (`llir.Merge`). Still rejected: recursion, i64 values, floats,
  variadic-indirect calls.

## Build, test, hardware

- `make test` = `go vet` + all golden tests. Run it before committing.
- `make llgen` regenerates the compiler IR goldens + host expectations
  (needs host clang; only when dmacc/testdata/*.c change).
- `make build` builds the `dmaemu`/`dmaasm`/`dmacc` CLIs; `make images` regenerates
  `target/firmware/generated/images.h` via `cmd/dmxgen` (required whenever
  test programs or emulator semantics change); `make firmware` builds the
  HIL firmware; `make test-hw` flashes it.
- Toolchain defaults (this machine; override via Makefile vars):
  pico-sdk 2.3.0 + GCC + CMake + Ninja under `~/.pico-sdk/`, OpenOCD at
  `~/dev/github.com/raspberrypi/openocd/prefix/bin/`.
- HIL bench: Pico 2 (RP2350) on a Debug Probe; UART `/dev/cu.usbmodem102`
  at 115200 prints TEST/CAL/EXP lines every few seconds. Gotchas: a
  VS Code OpenOCD or `minicom` may hold the probe/UART; if SWD
  examination fails (wild-machine episode), rescue once with
  `target/rp2350-rescue.cfg`, then flash; avoid flashing while the
  stress experiments are mid-run.

## Conventions

- Each phase ends with a `prompts/NNN-<topic>.md` results document
  recording what was built, findings, and open items.
- Commits: short imperative subject + a body listing the substantive
  changes (see `git log`).
- Temporary/experiment files go outside the repo, never committed.
