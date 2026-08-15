# DMX Executable Format (v1)

DMX is the loadable image format for DMA-machine programs (Phase 1 of
`prompts/overview.md`). It carries program blocks and data as opaque byte
segments, a table of ABS32 relocations, a table of MMIO init writes, and an
entry point. Producers: the `img` Go package (and, later, the `dmaasm`
linker). Consumers: `img/load.go` (emulator/host, the behavioural
reference) and `target/loader/dmx.c` (RP2 bare-metal).

Design rationale (`prompts/overview.md` §4.3–§4.4): every operand on this
machine is a 32-bit absolute address, so a single "add the segment's
placement delta to this word" relocation covers program text, data, and
loader-performed register writes alike. Tier 1 (static) images are simply
images loaded at their link addresses; Tier 2 (relocatable) loading places
segments anywhere and runs the fixup loop.

## Layout

All fields are little-endian `u32`. No padding between tables. Multi-byte
alignment of the file itself is not required (the target loader assembles
words bytewise).

| Offset | Field | Notes |
|---|---|---|
| 0x00 | `magic` | `0x31584D44` ("DMX1") |
| 0x04 | `flags` | 0 in v1; nonzero is rejected |
| 0x08 | `nSegments` | |
| 0x0C | `nRelocs` | |
| 0x10 | `nWrites` | |
| 0x14 | `entrySeg` | index of the segment holding the entry block |
| 0x18 | `entryOff` | byte offset of the entry block; multiple of 16 |
| 0x1C | segment table | `nSegments × { linkAddr, size }` |
| … | reloc table | `nRelocs × { seg, off, ref }` |
| … | write table | `nWrites × { addr, value, ref }` |
| … | segment data | concatenated in table order |

Constraints (validated by both loaders):

- `linkAddr`, `size`, reloc `off`, and write `addr` are multiples of 4.
- Reloc `off + 4 ≤ size[seg]`; all segment indices in range.
- The resolved entry address is a multiple of 16 (control-block size).
- Placed segments must not overlap (host loader enforces; the C loader
  trusts the placement it is given).

## Semantics

Loading with placement `place[i]` (default: `linkAddr[i]`; the C loader
uses 0 as "no override" since 0 is never a valid RP2 SRAM address):

1. `delta[i] = place[i] - linkAddr[i]` (mod 2³²).
2. Copy each segment's bytes to `place[i]`.
3. For each reloc: add `delta[ref]` to the u32 at `place[seg] + off`.
4. For each write, in table order: write `value` (plus `delta[ref]` if
   `ref != 0xFFFFFFFF`) to MMIO/memory address `addr`. Writes may have
   side effects (channel triggers), so order is significant. Typical uses:
   sniffer configuration, pacing timers, arming an interrupt injector.
5. Entry = `place[entrySeg] + entryOff`.

Starting the machine is separate from loading: the loader configures the
fetch/execute/fix channels (ABI v0: channels 0/1/2, scratch word
`0x2003FF00`) and writes the fetch channel's `CTRL_TRIG` last, which
begins execution. Reference implementations: `emu.SetupFetchExec` (Go) and
`dmx_start` (C).

## What DMX is not

DMX is a *loadable* format, not a *linkable* one: symbols and section
merging live in the Phase 2 ELF-based toolchain, whose linker emits DMX as
its final output. Keeping the loadable format this small is what makes the
target-side loader a ~150-line fixup loop.
