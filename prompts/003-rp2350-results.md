# RP2350 Compatibility Results

Status as of 2026-08-16. The toolchain now targets both RP2 SKUs: the
emulator, image builder, CLI, and C loader are parametrized by SKU, and
the entire golden-test suite passes on RP2040 and RP2350.

## What differs between the SKUs (verified against `doc/rp2350-datasheet.pdf` §12.6)

The programming model is shared, but the encodings are not:

| Aspect | RP2040 | RP2350 |
|---|---|---|
| DMA channels | 12 | 16 |
| DMA IRQ outputs | 2 | 4 |
| SRAM | 264 KiB (`0x42000`) | 520 KiB (`0x82000`) |
| CTRL: INCR_WRITE | bit 5 | bit 6 (bits 5/7 are new INCR_*_REV) |
| CTRL: RING_SIZE/SEL | 9:6 / 10 | 11:8 / 12 |
| CTRL: CHAIN_TO | 14:11 | 16:13 |
| CTRL: TREQ_SEL | 20:15 | 22:17 |
| CTRL: IRQ_QUIET/BSWAP/SNIFF_EN/BUSY | 21/22/23/24 | 23/24/25/26 |
| TRANS_COUNT | 32-bit count | 28-bit count + MODE nibble (NORMAL / TRIGGER_SELF / ENDLESS) |
| TIMER0 … N_CHANNELS offsets | 0x420 … 0x448 | 0x440 … 0x468 |
| SNIFF_CTRL / SNIFF_DATA | 0x434 / 0x438 | 0x454 / 0x458 |
| IO_BANK0 base | 0x40014000 | 0x40028000 |
| GPIO CTRL OUTOVER / OEOVER | 9:8 / 13:12 | 13:12 / 15:14 |
| DREQ: PWM_WRAP0 / ADC | 24 / 36 | 32 / 48 (PIO0_RX0 = 4 on both) |

Unchanged: DMA base, channel-register aliases and stride, trigger/null-
trigger/chaining semantics, TREQ timer selects (0x3B–0x3F), SNIFF_CTRL
bit layout, atomic register aliases, credit-based DREQs, pacing timers.

**Consequence for the toolchain:** control words are not portable between
SKUs. A DMA-machine program must be assembled for its target chip; DMX
images carry SKU-specific payload and the SKU is agreed out of band
(documented in `doc/dmx.md`).

## Implementation

- `emu.Variant` (`emu/variant.go`): per-SKU descriptor owning the CTRL
  encode/decode, global register offsets, SKU addresses
  (`SniffDataAddr()`, `TimerAddr()`, `GPIOCtrlAddr()`, `GPIOOutCtrl()`),
  sizes, and named DREQs. `emu.RP2040` / `emu.RP2350` are the two
  instances; `emu.NewMachine(v)` picks the emulated chip. Shared
  definitions stay package-level in `emu/regs.go`.
- The DMA model handles the per-IRQ register blocks generically
  (`0x404 + 0x10·i`, careful: the fourth slot of each stride belongs to
  other registers), 16-channel state, and the RP2350 TRANS_COUNT modes:
  TRIGGER_SELF (re-trigger after completion) and ENDLESS (no decrement,
  no completion, ends only via CHAN_ABORT), plus reverse address
  increments in the ring/increment logic.
- `FetchExecConfig.ExecCtrl(v)` and `SetupFetchExec` build machine ctrl
  words through the variant; channel numbers are range-checked per SKU.
- `cmd/dmaemu`: `"sku": "rp2040" | "rp2350"` config field (default
  rp2040).
- `target/loader/dmx.c`: `-DDMX_TARGET_RP2350` selects the RP2350 CTRL
  layout; both configurations compile clean under
  `-std=c99 -Wall -Wextra -Werror`.

## Test coverage

- The full golden suite (ALU idioms, control flow, GPIO, halt, paced
  loop, interrupt dispatch, CRC determinism, plain copy, atomic aliases)
  runs on **both** SKUs via `forEachVariant` — 47 passing subtests.
- RP2350-only: channels 12–15 work (and are unmapped on RP2040),
  TRIGGER_SELF and ENDLESS modes, Tier-2 relocation into the upper
  256 KiB of RP2350 SRAM, and an SRAM-bounds test proving the same
  placement fails on RP2040.
- `TestVariantEncodings` pins the datasheet bit positions and addresses
  for both SKUs so refactors cannot silently swap layouts.
- CLI smoke: the add program assembled for RP2350, relocated to
  `0x20060000/0x20070000` (RP2350-only addresses), runs via
  `dmaemu -c` with `"sku": "rp2350"`.

## Notes for later phases

1. `dmaasm` (Phase 2) must take a target SKU and encode ctrl words via
   the same field definitions; a `--sku` flag and per-SKU golden outputs
   follow naturally from `emu.Variant`.
2. RP2350's ENDLESS mode is a candidate simplification for the Phase 3
   interrupt injector (no re-arm block needed in the ISR epilogue) —
   worth an experiment when interrupts land.
3. RP2350 SECCFG/MPU registers are unmodelled (read as zero); revisit if
   the xv6 work ever wants DMA-side memory protection.
4. Hardware validation (HIL) still pending for both SKUs.
