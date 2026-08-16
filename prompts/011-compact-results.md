# Phase 5-pre Results: the Compact Encoding, Built and Validated

Status as of 2026-08-16. The Tier-C 8-byte-record encoding designed and
silicon-calibrated in `prompts/010-compact-isa.md` is now implemented
end to end: `dmaasm -compact`-equivalent (Options.Compact), emulator and
C loader support, and the **entire differential suite passes in both
encodings, byte-identical, on both SKUs** — the same C programs, the
same picolibc printf, the same console text. Silicon-validated on the
Pico 2 (`TEST ccc_*: PASS`).

## What was built

- **dmaasm Options.Compact**: a planner (bank-state machine,
  `dmaasm/compact.go`) converts every classic block into records,
  inserting window-switch and count-set records as needed. Pass 1 sizes
  each instruction by running the same planner; pass 2 re-runs it and
  **cross-checks the record count per instruction** — sizing drift is
  an assembly error, never a miscompile. Canonical state (plain bank,
  all counts 1) holds at every instruction boundary, so labels and
  control-flow joins are always consistent.
- **Auto-return banks**: the bswap/size8/size16 banks chain through a
  cleanup channel that restores the window selector to plain. This came
  out of the phase's best catch (below) and deleted both the
  pre-swapped-switch-literal machinery and the channels-0..3
  constraint from the assembler.
- **Trampoline re-arithmetic**: jneg isolates bit 3 (8-byte stride,
  |v| < 2^27); jbool scales by 8 with a seed-compensated in-bank count
  restore; the jsign arena packs 16 pairs per 256-byte bank (same
  ±128 dispatch). jeq/jlt/jltu get restructured compact sequences that
  leave the sniff bank only through reads.
- **`.ifcompact`/`.else`/`.endif`** conditional assembly; the runtime
  memcpy/memset write their dynamic counts to the bank channel's
  reload register (`%cnt8w`/`%cnt8rw` + the `dyncount` flag) since
  records have no count field.
- **Block-field addressing** (`.read`/`.write`) resolves to the
  instruction's *payload* record, past planner-inserted prefix records.
- Loader/emulator: `emu.FetchExecConfig.Compact` /
  `img.CompactMachine()` / `DMX_COMPACT_MACHINE_CFG` — all fetch-only,
  because the assembler emits the entire bank/fix/cleanup configuration
  as DMX init writes; dmxgen grew compact spec twins. **dmacc did not
  change** except making its switch jump-table slot scale
  encoding-conditional (see bugs).

## Bugs the machinery caught (all pre-silicon)

1. **Every record runs at its bank's current count.** After jbool's ×8
   accumulate, the *switch-out record itself* executed 8 times,
   polluting the live accumulator — and on an INCR bank it would have
   walked over memory. Fix: auto-return banks (hardware chain does the
   switch, no record at all) plus, for sniff count-runs, the
   seed-compensated in-bank count restore (seed −k; the restore record
   adds k·1 back while resetting the reload).
2. **Deferred sniff-reads repeat too** — guarded on count 1.
3. **`.read` is field offset zero**, so the payload-shift fix needed a
   real block-field flag, not a `field != 0` test; before that, patches
   overwrote the planner's switch record.
4. **dmacc's jump tables baked the 16-byte slot size into the IR
   lowering** — the one place the "encoding-portable dasm" abstraction
   leaked; now `.ifcompact`-conditional.

## Results

| Program (rp2350 HIL) | classic flash | compact flash | text ratio |
|---|---|---|---|
| stdio (printf) | 42,732 B | 27,672 B | ~2.0× |
| memory | 8,460 B | 6,584 B | ~1.6× |
| collatz | 3,196 B | 2,612 B | ~1.5× |

Text alone hits the projected ~2× (moves/jumps halve exactly); totals
are diluted by unchanged data. Cycle cost: stdio +2.3 %, collatz
+7.7 % (mode-switch churn around arithmetic). **From the Phase 4.5
starting point, the printf program has gone 223,972 → 27,672 bytes:
−88 %.**

Validation: the compact assembler passes its own suite (HIL programs,
the 121-pair full-range comparison sweep, macros/call/patching, a
density pin), the complete C differential suite runs in both encodings
with bit-exact exit codes and console bytes, and the silicon HIL run
passes `ccc_memory`, `ccc_collatz`, and `ccc_stdio` (printf over
8-byte records) alongside every classic test.

## Notes and open items

- Classic remains the default encoding; compact is opt-in per
  assembly/spec. ABI: the compact machine map (channels 0–8 + injector
  9 + cleanup 10) should be folded into the ABI doc when compact
  becomes the default.
- Compact-mode cost intuition changed: plain moves/jumps 2×, or/xor/
  and cheaper, add/sub slightly cheaper, mulc/jbool slightly larger
  (count churn). Approach-B interrupts carry over (safepoint = 2
  records); an end-to-end compact IRQ HIL program is future work.
- Hand-written sniff sequences must consume the accumulator within one
  macro (mode-domain rule); the stock macros all do.
- Next big capacity lever for xv6 stays XIP-streamed overlays.
