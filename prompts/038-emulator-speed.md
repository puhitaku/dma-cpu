# Phase 24: the suite from 370 s to 16 s

An afternoon of profiling and a three-phase plan (measure first,
guardrails always): the dmacc compiler turned out to be <1 s per
test — the emulator was 95-98% of everything, and the suite ran
serially on 18 cores.

## Phase A — parallel harness (370 -> 76 s)

t.Parallel() on all 34 independent tests (each owns its Machine),
plus a keyed cache for the deterministic kernel compiles.

## Phase B — emulator fast paths (per-word cost, all cycle-exact)

- Plain (op 0) DMA-reg writes skip the atomic-alias pre-read whose
  result applyAlias discarded — the machine's instruction path.
- A decoded-CTRL cache per channel (treq, size, strides, rings,
  flags; ctrlChanged is the single writer) replaces per-word bit
  extraction.
- Per-channel resolved memory windows serve SRAM/flash/PSRAM
  transfers as direct slice accesses (negative-cached for MMIO,
  invalidated on QMI direct-mode transitions).
- Timers moved from tick-every-cycle accumulators to a closed-form
  next-fire schedule; idle timer-paced waits jump to the next pulse.
- A burst engine runs bulk sequences (sole-ready permanent-TREQ
  channel, plain windows, no sniffer/trace/watch/ring, remaining
  >= 16) as one tight loop — same word order, same final cycle.

EMU_NO_FAST=1 forces the plain per-cycle model; TestZZBenchXsh's
per-command cycle counts are bit-identical between modes. usertests
72.8 -> 58.1 s, fbcon 54.4 -> 44.0 s at this point.

## Phase C — the harness again, where the real gold was

Sharding usertests' 35 exam subtests with t.Parallel() (73 -> 12 s)
and Machine.Clone() + a golden boot per board (boot once to the
prompt, hand every console-script test an independent deep copy)
were both planned. The surprise was neither: reading TestXv6Fbcon
for a split revealed every console test ran ONE Run() with a fixed
900M-2.5B cycle budget — and a machine at the prompt never idles
(UART poll + idle proc), so every such Run burned its entire budget.
The scenario work was 10-50x smaller. runScript() stops at a
quiescent prompt (input drained, output stable, "$ " suffix);
Persist keeps its mailbox servicing, Blink watches GPIO events
instead of clock time. Fbcon 50 -> 3.5 s, Mount 32 -> 2.2 s,
Persist 31 -> 1.6 s.

One test kept its fixed shape deliberately: TestXv6EchoCtl's whole
premise is type-ahead landing mid-boot, so it boots fresh
(buildXshBoard) instead of cloning the golden.

## Score

370 s -> 16 s wall (23x); the pole is now vi's own settle loops.
The lesson for the next round: profile the harness, not just the
engine — the biggest waste was cycles nobody needed emulated at all.

## Postscript: 300 MHz silicon (prompts/038.5, same session family)

The machine IS the bus, so overclocking clk_sys is overclocking the
CPU: 300 MHz (2x) with vreg at 1.30 V. Everything that derives from
clk_sys moved with it — clk_peri divided back to a in-spec 150 MHz
(the UART garbled both directions at the correct baud until it was),
PSRAM QMI M1 retimed register-only (psram_reinitialize wedged the
QPI-mode chip and dropped flash to serial XIP), flash M0 at
CLKDIV=4/RXDELAY=4 (75 MHz quad, the 150 MHz map's margins), and the
scheduler tick derives from Board.ClkSysKHz (100 us wall either
way). The RP2350 vreg gotcha cost the afternoon: vreg_set_voltage
alone is silently CLAMPED to 1.15 V; the chip ran but every logic
path was marginal — deterministic garbage with per-run single-bit
flips, which looked exactly like a baud mismatch until no baud in a
sweep decoded it. Silicon score at 300 MHz: 21/21 HIL PASS,
fc0-measured clk_sys=300000 kHz, video untouched (126 MHz HSTX
PLL), fbtest 22 s -> 5 s, slide load 1.55 -> 1.04 s (SPI wire is
the floor now), ticks 2x (kernel-bound, as always).
