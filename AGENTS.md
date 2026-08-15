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
- ABI v0 draft (until Phase 2 freezes it): machine on channels 0/1/2,
  interrupt injector on 3 with HIGH_PRIORITY, scratch word per
  `img.DefaultMachine()` / the dmxgen HIL layout.

## Build, test, hardware

- `make test` = `go vet` + all golden tests. Run it before committing.
- `make build` builds the `dmaemu` CLI; `make images` regenerates
  `target/firmware/generated/images.h` via `cmd/dmxgen` (required whenever
  test programs or emulator semantics change); `make firmware` builds the
  HIL firmware; `make test-hw` flashes it.
- Toolchain defaults (this machine; override via Makefile vars):
  pico-sdk 2.3.0 + GCC + CMake + Ninja under `~/.pico-sdk/`, OpenOCD at
  `~/dev/github.com/raspberrypi/openocd/prefix/bin/`.
- HIL bench: Pico 2 (RP2350) on a Debug Probe; UART `/dev/cu.usbmodem102`
  at 115200 prints TEST/CAL lines every ~2.5 s. Gotchas: a running VS
  Code OpenOCD claims the probe (flash through its telnet console on port
  50002 instead of killing it) and a `minicom` may hold the UART device.

## Conventions

- Each phase ends with a `prompts/NNN-<topic>.md` results document
  recording what was built, findings, and open items.
- Commits: short imperative subject + a body listing the substantive
  changes (see `git log`).
- Temporary/experiment files go outside the repo, never committed.
