# Phase 1 Results: DMX Image Format and Loaders

Status as of 2026-08-16. Both Phase 1 items of `prompts/overview.md` (the
Tier-1 image format + loader, and Tier-2 relocatable images with the fixup
loop) are implemented and green; hardware validation of the C loader waits
on the Phase 0 HIL rig.

## What was built

### DMX format (`references/design_docs/dmx.md`, v1)

A deliberately small loadable format: byte segments (program blocks and
data are both opaque bytes), one ABS32 relocation type (`{seg, off, ref}`:
add segment `ref`'s placement delta to the word at `seg:off`), ordered MMIO
init writes (optionally rebased, for sniffer config / timers / arming an
injector channel), and a (segment, offset) entry point. Linkable-format
concerns (symbols, section merging) are explicitly out of scope — they
belong to the Phase 2 ELF toolchain, which will emit DMX as its output.

### `img/` — builder, codec, and host loader

- `img.Builder` / `Seg`: programmatic image construction with
  `Word`/`WordRef`/`BlockP`/`RelocAt`/`SetWord` — offsets + relocs stand in
  for symbols; forward references are patched like in the golden tests.
  This is the producer API the Phase 2 assembler will target.
- `Encode`/`Decode` with full validation (magic, flags, table bounds,
  alignment, trailing bytes).
- `Image.Load`: placement → delta computation, relocation into scratch
  copies (images stay reusable), overlap checking, segment copy-in, ordered
  init writes. `LoadAndStart` wraps it with the standard 3-channel machine
  setup; `img.DefaultMachine()` carries the ABI v0 draft (channels 0/1/2,
  scratch `0x2003FF00`).

### `target/loader/dmx.c` — RP2040-side loader

Freestanding C99, no Pico SDK dependency (volatile-pointer MMIO), ~150
lines as predicted in the overview: bytewise word reads (flash alignment),
bounds/alignment validation, copy + in-place fixup + init writes, and
`dmx_start` mirroring `emu.SetupFetchExec` register-for-register. Compiles
clean under `-std=c99 -Wall -Wextra -Werror` (host compiler; no
`arm-none-eabi-gcc` on this machine yet — cross-compile and HIL validation
are open items).

### CLI integration

`dmaemu` configs accept `"image": {"file": "prog.dmx", "placement":
{"1": "0x20020000"}}` as an alternative to the raw `"machine"` section
(mutually exclusive). Smoke-tested: the add program as a DMX image, with
both segments moved from their link addresses, still yields `0x3333` in 23
cycles.

## Test coverage (`img/img_test.go`)

Encode/decode round-trip; decode rejection (bad magic, truncation,
trailing bytes); Tier-1 load-at-link-address; **Tier-2 acceptance: the
same image runs correctly with text moved, data moved, and both moved**;
jump-target literals (data words pointing into text) rebased across
placement; init-write rebasing (injector-style channel armed with a placed
data address); overlap rejection; entry-alignment rejection after
placement.

## Notes and decisions

1. **Placement deltas use wrapping u32 arithmetic**, so segments can move
   down as well as up; rebase-by-addition is exact mod 2³².
2. **The C loader treats placement 0 as "use link address"** — 0 is never
   a valid RP2040 SRAM load address, which keeps the API malloc-free.
3. **Init writes are ordered and may trigger channels.** This is the
   loader-level hook for everything Phase 3 needs (arming the interrupt
   injector before start), so interrupts require no format change.
4. The host loader enforces segment-overlap checks; the C loader trusts
   its placement input (the host toolchain is expected to have validated
   it).

## Open items

- Cross-compile `target/loader/` with `arm-none-eabi-gcc` (not installed
  here) and validate on hardware together with the Phase 0 HIL golden
  captures.
- A `dmxpack`-style CLI producer is deferred to Phase 2: today images are
  produced via the `img` builder API (tests) — the assembler is the real
  producer and arrives next phase.

## Suggested next step

Phase 2: `dmaasm` assembler + minimal linker emitting DMX, then freeze
ABI v0 (register file, calling convention, safepoint rules).
