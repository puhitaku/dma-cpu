# DMA-Machine ABI v0

Frozen 2026-08-16 (Phase 2). Implemented by `dmaasm` (assembler),
`img.DefaultMachine` (host loader), `target/loader` (RP2 loader), and the
HIL layouts in `host/cmd/dmxgen`. Changes require bumping to v1 and updating
all four, plus AGENTS.md.

v0.1 (Phase 4, additive): the reserved word at 0x5C is assigned as `at2`
(second assembler temporary), and the full-range comparison macros below
were added. Layout and all existing encodings are unchanged.

## Machine configuration

| Item | Value |
|---|---|
| Fetch channel (PC = its `READ_ADDR`) | DMA channel 0 |
| Exec channel (sniffer `DMACH`) | DMA channel 1 |
| Fix channel | DMA channel 2 |
| Interrupt injector (Phase 3) | DMA channel 3, `HIGH_PRIORITY` set |
| Scratch word | loader-chosen, outside program segments (defaults: `img.DefaultMachine`, dmxgen layouts) |

Program CTRL words: `EN | SIZE | TREQ=permanent | CHAIN_TO(fix) |
IRQ_QUIET` (SKU-encoded), plus `SNIFF_EN`/`BSWAP`/size/TREQ variations per
instruction. CHAIN_TO and TREQ_SEL are fields — never OR over them.

## Register file (`.regs` directive)

Registers are SRAM words. `.regs` reserves 32 words (128 bytes) at its
position in `.data` and defines, in order:

| Offset | Name | Role |
|---|---|---|
| 0x00–0x3C | `r0`–`r15` | general purpose |
| 0x40 | `lr` | link register (return address) |
| 0x44 | `sp` | stack pointer (software convention; unused in v0) |
| 0x48 | `zero` | always 0 — never write (assembler does not enforce) |
| 0x4C | `null` | write-only discard ("bit bucket") |
| 0x50 | `at` | assembler/compiler temporary |
| 0x54 | `dispatch` | interrupt dispatcher word (overview §3.2) |
| 0x58 | `irqresume` | safepoint resume address |
| 0x5C | `at2` | second assembler/compiler temporary (v0.1) |
| 0x60–0x7C | reserved | |

Per-program register banks are intentional (context switch = different
addresses); a system-wide convention comes with the kernel work.

## Architectural registers (MMIO, per SKU)

`%sniff` (accumulator = `SNIFF_DATA`), `%sniffctrl`, `%sniffset` /
`%sniffclr` / `%sniffxor` (atomic aliases), `%pc` (fetch `READ_ADDR`),
`%intr`. There is no flags register: conditions are materialized as block
addresses (`jneg`).

## Sniffer ownership

At entry the loader has configured the sniffer to SUM mode observing the
exec channel with `SNIFF_DATA = 0` (the assembler emits these init writes
unless `.nosniffinit`). Any sequence that reconfigures the sniffer (CRC
use) must restore SUM mode before the next arithmetic macro. `%sniff` is
caller-saved everywhere: no macro preserves it.

## Calling convention (v0)

- Arguments in `r0`–`r3`, return value in `r0`.
- `r4`–`r11` callee-saved; `r12`–`r15`, `at`, `%sniff` caller-saved.
- `call f` = store return address into `lr`, jump — one level deep.
  Nested calls must spill `lr` manually (`sp` discipline is not yet
  mechanized; v0 programs are leaf-or-manual).
- `ret` = indirect jump through `lr`.

## Control flow encodings (silicon-verified semantics)

- HALT: the all-zero block (null trigger). Raises the exec channel's
  INTR bit as an end-of-chain notification (quiet null-trigger IRQ).
- NOP: a zero-length block (`TRANS_COUNT = 0`, normal ctrl): completes
  immediately and chains on.
- Unconditional jump: copy a pool literal into `%pc`.
- `jneg v, neg, pos`: 6 blocks — BSWAP sign-bit trick, CLR mask
  `0xFFFFFFEF`, sniffer add of the trampoline base, push to `%pc`, then
  two trampoline jump slots (slot 0 = non-negative). Requires |v| < 2^28
  for correctness of the bit 4–7 sign copy.
- Full-range comparisons (v0.1; no magnitude restriction): `jsign v,
  neg, nonneg` (4 blocks), `jeq a, b, eq, ne` (12), `jlt a, b, lt, ge`
  (signed, 16), `jltu a, b, lo, hs` (unsigned, 16). All isolate the true
  sign bit (bit 7 after BSWAP, CLR mask `0xFFFFFF7F`) and dispatch
  through a pooled trampoline pair: slot 0 (+0) sign clear, slot 1
  (+128) sign set. Pairs pack 8 to a 256-byte arena bank appended after
  the program text. `jeq` clobbers `at`; `jlt`/`jltu` clobber `at` and
  `at2`. The remaining predicates are operand/target swaps: `gt` =
  `jlt b, a`; `ge`/`le`/`hs`/`ls` = swapped targets.
- `jbool v, ifzero, ifone` (6 blocks): two-way dispatch on a word that
  must be 0 or 1 (16·v trampoline offset) — the cheap branch for
  materialized booleans.
- `and a, b, d` (6 blocks, clobbers `at`) and `andn a, b, d` = `a & ~b`
  (3 blocks) via the accumulator CLR alias.

## Safepoint rule (for Phase 3 interrupts)

At every loop back-edge and function return, interruptible code emits:
store the resume-address literal into `irqresume`, then jump indirectly
through `dispatch`. `dispatch` normally holds the resume thunk (one block:
`irqresume` → `%pc`); the injector patches it to the ISR entry. The ISR
uses its own register bank, must save/restore `%sniff` and the sniffer
config, restores `dispatch` (EOI), re-arms the injector, and returns via
`irqresume`. Compilers must bound the longest safepoint-free path.

## Segments and images

Programs are two segments — `.text` (16-byte blocks) and `.data` (words,
including the register file and the literal pool) — packaged as DMX
(doc/dmx.md), fully relocatable via ABS32 relocs. Binaries are
SKU-specific; sources (`.dasm`) are SKU-portable.
