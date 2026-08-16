# dma-cpu

CPU made of DMA on Raspberry Pi Pico.

The DMA controller in the RP2 microcontroller family (RP2040, RP2350, and
compatible chips) is Turing-complete. This project builds a full toolchain
for it: an emulator, an assembler/linker, a program loader, LLVM/Clang
support, and eventually an xv6-derived kernel running entirely on DMA
channels. See `prompts/overview.md` for the design analysis, the phased
development plan, and references.

## Layout

- `emu/` — `dmaemu` core: a deterministic, DMA-machine-level emulator of
  the RP2 DMA subsystem (channels, triggers, chaining, DREQ credits,
  pacing timers, sniffer, atomic register aliases). Both SKUs are
  supported via `emu.Variant` (`emu.RP2040`, `emu.RP2350`) — the CTRL bit
  layout, register offsets, sizes, and DREQ numbers differ between them,
  so programs are assembled per SKU. The golden tests in
  `emu/machine_test.go` build the machine's ALU and control-flow idioms
  block by block, run the whole suite on both SKUs, and prove out the
  interrupt-dispatch design from `prompts/overview.md` §3.2.
- `dmaasm/` + `cmd/dmaasm` — the assembler: SKU-portable `.dasm` sources
  (labels, literal pools, instruction-field addressing, the ABI v0
  register file and macro instruction set — see `doc/abi.md`) assembled
  into SKU-specific DMX executables with a symbol table. Validated on
  silicon: the HIL firmware runs assembler-produced binaries.
- `prog/hil/` — the HIL test programs as `.dasm` assets (embedded).
- `img/` — the DMX executable format (`doc/dmx.md`): builder, encoder/
  decoder, and the reference loader with Tier-2 relocation (same image runs
  at any placement).
- `cmd/dmaemu/` — CLI front end; runs a raw block image or a DMX executable
  under a JSON config and reports results as JSON (see the comment in
  `main.go` for the format).
- `target/loader/` — bare-metal C loader for the RP2 side; parses DMX,
  relocates, and starts the machine. No SDK dependency; build with
  `-DDMX_TARGET_RP2350` for RP2350 (RP2040 is the default). Validated on
  RP2350 silicon.
- `target/firmware/` + `cmd/dmxgen` — the HIL (hardware-in-the-loop)
  runner: dmxgen bakes emulator-computed expectations into the firmware,
  which runs the images on the real DMA machine and reports
  expected-vs-observed over UART. The emulator is silicon-calibrated
  against a Pico 2; see `prompts/004-hw-calibration.md` for the results
  (all golden tests pass on hardware at ~10 M blocks/s).
- `doc/` — project documents (`dmx.md` is the image format spec) and
  references. The RP2040 and RP2350 datasheets are committed; third-party
  reference material is copyrighted and stays untracked (see Coding rules
  in `prompts/overview.md`).

## Build and test

```console
$ make build   # builds bin/dmaemu and bin/dmaasm
$ make test    # go vet + golden tests
```

Requires Go ≥ 1.26. No dependencies outside the standard library.

## Special Thanks

This project is heavily inspired by [the original idea](https://people.ece.cornell.edu/land/courses/ece4760/RP2040/C_SDK_DMA_machine/DMA_machine_rp2040.html)
published by the authors in Cornell University.
