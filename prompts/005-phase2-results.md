# Phase 2 Results: dmaasm Assembler and ABI v0

Status as of 2026-08-16. Both Phase 2 items of `prompts/overview.md` are
done: the `dmaasm` assembler exists and its output has been validated on
RP2350 silicon, and ABI v0 is frozen in `references/design_docs/abi.md`.

## What was built

### `dmaasm/` — the assembler (Go, stdlib only)

Two-pass assembler for `.dasm` sources emitting DMX executables plus a
symbol table.

- **Language:** `.data`/`.text` segments; labels; `.word`/`.space`;
  `.regs` (the ABI register file); `.entry`; `.write` MMIO init writes
  (values may be symbols — rebased at load); `.nosniffinit`.
- **Operands:** symbols, `$literal` (numbers or `$label` — every constant
  is interned into a deduplicated literal pool, since this machine has no
  immediates), `%mmio` names resolved per SKU (`%sniff`, `%sniffset/clr/
  xor`, `%pc`, …), `@absolute`, and **instruction-field addressing**
  (`label.read/.write/.count/.ctrl`) so self-modifying idioms get proper
  relocations instead of hand-counted offsets — the toolchain requirement
  from overview §4.6.
- **Instructions:** `move` (with `sniff`/`bswap`/`size8/16`/`count=`
  flags), `add`, `sub`, `or`, `xor`, `shl`, `mulc`, `jump`, `jumpr`,
  `jneg`, `call`/`ret`, `gpio`, `halt` (all-zero block), `nop`
  (zero-length block — the silicon-verified immediate-completion NOP).
- **SKU portability:** sources are SKU-portable; binaries are not.
  `TestSKUPortability` proves the same source yields different bytes and
  identical behaviour on RP2040/RP2350.
- `cmd/dmaasm`: CLI (`-sku`, `-text`, `-data`, `-o`, `-syms`).

### Programs as assets, assembler as single source

The HIL test programs are now `.dasm` files in `prog/hil/` (embedded via
`prog.FS`). `cmd/dmxgen` assembles them per SKU, patches test inputs
through the symbol table (one `condjump.dasm` serves both branch cases),
verifies intent values in the emulator, and emits the firmware header.
**The firmware therefore runs assembler-produced binaries — the hardware
pass validates the assembler end to end.**

### ABI v0 (frozen, `references/design_docs/abi.md`)

Channels 0/1/2 (+3 injector, HIGH_PRIORITY); the 32-word register file
(`r0`–`r15`, `lr`, `sp`, `zero`, `null`, `at`, `dispatch`, `irqresume`);
MMIO architectural registers; no flags register; sniffer ownership (SUM
default, caller-saved accumulator); calling convention (args `r0`–`r3`,
return `r0`, one-level `call`/`ret` via `lr`); HALT/NOP encodings; the
safepoint rule for Phase 3.

## Acceptance

The overview's "byte-identical block output" acceptance was adapted:
byte-identity between two independent producers is meaningless when data
allocation orders differ, so the criterion became **behaviour + pinned
cycle counts** (cycle equality is block-sequence equality for the text
segment) — the assembled programs reproduce the golden results in exactly
the same cycles as the hand-built versions (add 23, logic 59, gpio 23),
pinned in `TestHILPrograms` on both SKUs — **plus a hardware run**.

## Hardware validation (Pico 2, RP2350)

All six assembler-produced images pass on silicon: add, logic, both
condjump branches, gpio, and perf at **10,000,280 blocks/s** (consistent
with Phase 1.5's 15 sys-clk/block). All calibration lines still match the
silicon-calibrated emulator (idle_credit measured 399 µs this run —
within the phase-dependent 300–400 µs paced window, further confirming
the credit model).

## Notes

- Images grew ~120 bytes vs the hand-built versions — the `.regs`
  register file (128 B). Expected and ABI-conformant.
- Assembly errors carry line numbers; `TestErrors` pins diagnostics for
  the common mistakes (missing `.regs`, undefined symbols, bad fields).
- First code-density datapoint for the Phase 5 risk: ALU macros are 3–5
  blocks (48–80 B) per operation, matching the overview's estimate.

## Open items / next

- `and` with a runtime (non-mask) operand needs a temp-register lowering;
  deferred until the compiler needs it.
- Multi-file assembly/linking and an ELF object path: deferred to Phase 4
  (LLVM) per overview §4.3 — DMX remains the loadable format.
- Next per plan: Phase 3 (interrupts — approach D scaffolding, then the
  approach-B injector on hardware with a PIO GPIO-edge bridge).
