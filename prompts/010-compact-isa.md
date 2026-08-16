# Tier C: Compact 8-Byte Encoding — Design and Silicon Feasibility

Status as of 2026-08-16. The Tier-C compressed instruction format is
**designed, prototyped in the emulator, and validated on the Pico 2**:
every load-bearing hardware semantic is confirmed by `CAL compact:
MATCH`. The assembler/loader implementation is scoped below and not yet
built — per the Phase 1.5 discipline, silicon went first.

## The design: channel-bank machine

An instruction becomes an 8-byte record — just `(READ_ADDR,
WRITE_ADDR)` — fetched into the *tail of the alias-2 window* of an exec
channel, where the second word (`WRITE_ADDR_TRIG`) triggers the
transfer. CTRL and TRANS_COUNT are not part of the instruction stream
at all: they are preset per channel and persist (TRANS_COUNT reloads
from its last-written value on every trigger).

Instead of rewriting CTRL to change transfer modes (the first design —
see "prototype findings"), the machine keeps **one exec channel per
mode**, each with a static CTRL: plain, always-sniffed, bswap,
size8 (+incr variants), size16. The fix channel re-arms fetch by
copying a scratch word into fetch's `AL2_WRITE_ADDR_TRIG`; that scratch
word *is* the current-bank selector, so **switching modes is one
ordinary record that rewrites scratch** with another bank's window
address. No control register is ever written by the machine; the
sniffer's DMACH never changes.

- HALT: the all-zero record. A null `WRITE_ADDR` trigger is dropped and
  raises the quiet null-trigger IRQ — byte-for-byte the same semantics
  as the classic all-zero block (Phase 1.5 calibration).
- Proposed channel map (both SKUs): 0 plain, 1 size8, 2 size8+incrW,
  3 size8+incrRW, 4 sniff, 5 bswap, 6 size16, 7 fetch, 8 fix,
  9 injector. Channels 0–3 sit below window offset 0x100 on purpose —
  see the byte-switch rule.

## Mode-domain rules (assembler contract)

The emulator prototype (`TestCompactMachineRaw`) caught two real
hazards on day one and the rules that neutralize them:

1. **Switch records travel through the current mode's data path.** A
   switch-out-of-bswap record's window literal must be pre-swapped
   (bswap∘bswap = id). A switch out of a size8 bank transfers one byte
   — which works *because* the size8 banks and plain live on channels
   0–3: all their window addresses share the upper three bytes, so the
   byte written (the plain window's low byte, which is also the low
   byte of the full window literal) is sufficient. size16 switches out
   with a halfword for the same reason (all windows share the upper
   half). This is why the channel map is what it is.
2. **Switching off the sniff bank pollutes the accumulator** (the
   switch record's data is accumulated). Rule: results are read from
   `SNIFF_DATA` *before* leaving the sniff bank — the delivered data is
   exact (silicon-confirmed); the self-accumulation and the switch-out
   pollution only touch a dead accumulator, which every arithmetic
   macro reseeds anyway. Symmetrically, seeds are written from an
   unsniffed bank (exact).
3. **Canonical state at labels**: every macro ends on the plain bank
   with all counts = 1, so control-flow joins never see divergent
   machine state. Jumps that compute their target in sniff/bswap mode
   stage the target in `at` and push to `%pc` from the plain bank.

## Silicon calibration (Pico 2)

`cal_compact` in the HIL firmware runs an 11-record program through
channels 6–10: plain moves, a bswap-bank round trip (pre-swapped
restore literal), a sniffer add with seed/read discipline, and the
all-zero HALT. Result:

    CAL compact: MATCH dst0=11223344 dst1=ddccbbaa dst2=11223344
                 sum=0001000d irq=1

matching the emulator exactly. Confirmed semantics: TRANS_COUNT
reloads on `WRITE_ADDR_TRIG` triggers with CTRL untouched; window
switching via scratch rewrite (including from bswap mode); sniffed
reads of SNIFF_DATA deliver exact data; the null-trigger HALT raises
INTR. (One episode during bring-up: the firmware's expected-sum
constant was hand-miscomputed; silicon and emulator agreed with each
other and disagreed with me.)

## Expected density (from the record-count derivations)

move/jump/call/ret/safepoint 2.0×; or/xor/andn 2.0×; and 2.0×;
sub 1.43×; add 1.2×; shl 1.2×; mulc slightly worse (count switches);
compare macros ~1.3× but they live almost entirely in the millicode
helpers. Weighted by the post-Tier-A histogram (~55 % plain moves and
jumps), text shrinks an estimated **1.6–1.8×**; data is unchanged.
On the stdio program that projects ~31 KB → ~18–19 KB of text,
~30 KB total.

## Remaining build (next phase)

1. `dmaasm` Options.Compact: record emitter behind the block-level
   `mv()` with the bank-state machine, per-instruction record counts in
   layout (with an emit-vs-layout self-check), 8-byte trampoline
   strides for jneg/jbool (bit-3 isolate, |v| < 2^27) and the ±128
   arena pairs re-derived at 8 B/slot, entry alignment 8.
2. `.ifcompact`/`.else`/`.endif` conditional assembly; compact variants
   of the runtime memcpy/memset (dynamic counts write the bank
   channel's `AL2_TRANS_COUNT` reload directly).
3. `emu.SetupFetchExec` compact variant + `target/loader` support +
   dmxgen/HIL wiring; ABI v1 note for the compact channel map.
4. Differential suite + HIL in compact mode (same bit-exact bar), then
   size/cycle comparison tables. dmacc itself should not change.
