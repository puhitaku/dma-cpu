# Phase 1.5 Results: First Silicon & Emulator Calibration

Status as of 2026-08-16. First run of the DMA machine on real hardware:
Pico 2 (RP2350) via Debug Probe (SWD flash through OpenOCD, UART capture at
115200). **All golden tests pass on silicon; three emulator divergences
were found, fixed, and pinned with regression tests; the loader stack
(dmxgen → DMX image → C loader → machine start) worked on hardware
unmodified.**

## Setup

- `cmd/dmxgen` builds the test images per SKU, runs each in the emulator,
  and bakes the emulator's results into `target/firmware/generated/images.h`
  as expected values — a FAIL on the UART log therefore means "silicon and
  emulator disagree", which is the measurement.
- `target/firmware/` (pico-sdk, `PICO_BOARD=pico2`) loads each image with
  the C DMX loader, starts the 3-channel machine, polls the done flag, and
  checks results; it then runs C-side register-level calibration
  experiments for every `TODO(hw-calibration)` in the emulator. Output
  repeats every ~2.5 s on UART.
- Machine SRAM region: text `0x20040000`, data `0x20050000`, scratch
  `0x2005FF00`; the firmware asserts its own `.bss` stays below the region.
- Flashing used the already-running OpenOCD server's telnet console
  (port 50002); a stale probe claim and a `minicom` holding the UART were
  the only bring-up hiccups.

## Golden tests on silicon (all PASS)

add, logic (OR/AND/XOR), condjump_pos, condjump_neg, gpio, perf — the
full fetch/execute/fix machine, the sniffer ALU idioms, the byte-swap
conditional jump, GPIO output via IO_BANK0 overrides, and the DMX
Tier-1 load path all behave exactly as the emulator predicts.

**Measured machine speed: 9,999,920 blocks/s** (RP2350 @ 150 MHz,
free-running counter loop, 4 blocks/iteration). That is exactly 15
sys-clk per block = 2.5 sys-clk per bus transfer (each block is 6
transfers: 4 fetch + 1 exec + 1 fix). The emulator's 1-transfer-per-cycle
model therefore maps to hardware time as ≈2.5 sys-clk per emulated cycle
on an otherwise idle bus. (Cornell's RP2040 figure of ~8 M blocks/s at
133 MHz gives the same ≈16.6 clk/block ballpark.)

## Calibration experiments: expected vs observed

| Experiment | Emulator (before) | RP2350 silicon | Verdict |
|---|---|---|---|
| Trigger while `EN=0`, then enable | dropped, never starts | dropped, never starts | **MATCH** — confirms the fact the interrupt design rests on (overview §3.3) |
| Null write to `CTRL_TRIG` on quiet channel | no IRQ (quiet judged post-write) | **IRQ raised** | **DIVERGED → fixed**: quiet is judged on the pre-write CTRL |
| Null write to `TRANS_COUNT_TRIG` on quiet channel | IRQ raised | IRQ raised | MATCH |
| Trigger with `TRANS_COUNT == 0` (loud) | silent no-op | **completes immediately: IRQ fires, no transfer, chain fires** | **DIVERGED → fixed**: zero-length sequences complete instantly (a hardware-accurate NOP block) |
| DREQ credit banked while idle (timer-paced) | completes instantly after trigger | **paced: 300 µs for 4 transfers @ 100 µs/pulse** | **DIVERGED → fixed**: credit does not survive into a new trigger (cleared on trigger) |
| Sniffer SUM (seed 0x1000 + 0x234) | 0x1234 | 0x1234 | MATCH |
| Sniffer CRC32 (seed 0xFFFFFFFF, word 0x12345678) | 0xAD37D056 | 0xAD37D056 | **MATCH** — CRC bit/byte order confirmed; `TODO(hw-calibration)` resolved |

After the three fixes (`emu/dma.go`), the firmware was rebuilt with the
updated expectations and re-run: **every line matches.** Regression tests
pin the calibrated behaviour on both SKUs: `TestNullCtrlTrigQuietIRQ`,
`TestZeroCountCompletes`, `TestCreditClearedOnTrigger`.

## Design consequences

1. **The interrupt architecture survives contact with silicon.**
   Trigger-drop while disabled (approach C's killer) is confirmed, and the
   injector design is unaffected by the credit fix: the injector is armed
   *before* its DREQ arrives, and credits delivered to a busy channel are
   honoured. Only the (never-relied-upon) idle banking is gone. Timer
   ticks landing between ISR entry and re-arm coalesce — exactly the
   overview §3.2 semantics.
2. **HALT raises an IRQ.** The all-zero halt block null-triggers the exec
   channel whose previous block had `IRQ_QUIET=1`, so silicon flags INTR —
   a free "machine halted" notification for the ARM side (this is the
   datasheet's intended end-of-chain interrupt). The loader/runtime can
   use it instead of polling a done word.
3. **Zero-count blocks are true NOPs** — immediate completion with chain —
   usable by the assembler as padding/alignment filler.

## Remaining gaps

- RP2040 (Pico 1) not yet on the bench: the same firmware builds for it
  (`-DDMX_TARGET_RP2350` off, dmxgen `-sku rp2040`), pending hardware.
- Flash/capture automation (`make test-hw` diffing UART against dmxgen
  output) still manual; wire it up when HIL becomes a CI stage.
- Not yet probed on silicon: BSWAP+sniffer interaction corner cases,
  ring wrap, INCR_*_REV, ENDLESS/TRIGGER_SELF modes, and the approach-B
  injector end-to-end (Phase 3 will do it with PIO).

## Verdict

The emulator is now silicon-calibrated on every marked unknown, and the
whole Phase 0–1 stack is validated on hardware. Phase 2 (`dmaasm`, ABI v0
freeze) proceeds on a verified foundation.
