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
  pacing timers, sniffer, atomic register aliases). The golden tests in
  `emu/machine_test.go` build the machine's ALU and control-flow idioms
  block by block, and prove out the interrupt-dispatch design from
  `prompts/overview.md` §3.2.
- `img/` — the DMX executable format (`doc/dmx.md`): builder, encoder/
  decoder, and the reference loader with Tier-2 relocation (same image runs
  at any placement).
- `cmd/dmaemu/` — CLI front end; runs a raw block image or a DMX executable
  under a JSON config and reports results as JSON (see the comment in
  `main.go` for the format).
- `target/loader/` — bare-metal C loader for the RP2 side; parses DMX,
  relocates, and starts the machine. No SDK dependency; not yet validated
  on hardware.
- `doc/` — project documents (`dmx.md` is the image format spec) and
  references. The RP2040 datasheet is committed; third-party reference
  material is copyrighted and stays untracked (see Coding rules in
  `prompts/overview.md`).

## Build and test

```console
$ make build   # builds ./dmaemu
$ make test    # go vet + golden tests
```

Requires Go ≥ 1.26. No dependencies outside the standard library.
