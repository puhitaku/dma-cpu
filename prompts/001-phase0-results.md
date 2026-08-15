# Phase 0 Results: `dmaemu` Emulator Core

Status as of 2026-08-16. Phase 0 step 2 of `prompts/overview.md` (the
DMA-machine-level emulator and its golden tests) is implemented and green;
step 1 (hardware golden captures) and the reference-code fetch remain open.

## What was built

All in Go, standard library only, per the language policy in
`prompts/overview.md` §5.

### `emu/` — the DMA-machine emulator

A deterministic emulator of the RP2040 DMA subsystem at bus-transfer
granularity (one transfer per scheduler cycle). Deliberately not a
full-chip emulator: it models exactly the semantics the DMA computing
machine relies on.

- All 12 channels with the four register aliases and full trigger
  semantics: null triggers (all-zero block = HALT), triggers dropped while
  `EN=0`, trigger-while-busy ignored, `TRANS_COUNT` reload on trigger.
- Chaining (`CHAIN_TO`, self = disabled), completion IRQs (`INTR`/`INTE`/
  `INTS`), `CHAN_ABORT`, `MULTI_CHAN_TRIGGER`.
- Credit-based DREQ scheme with saturating per-channel counters; external
  pulses injected via `Machine.PulseDREQ` (the emulator-side stand-in for a
  PIO GPIO-edge bridge); the four fractional (X/Y) pacing timers.
- The sniffer: SUM, CRC32/CRC32R, CRC16/CRC16R, parity, sniff-side BSWAP,
  and `OUT_REV`/`OUT_INV` read transforms.
- Atomic register aliases (`+0x1000` XOR, `+0x2000` SET, `+0x3000` CLR)
  across the whole peripheral space; unmodeled peripheral registers act as
  scratch words so programs can use arbitrary SFRs.
- GPIO output decoding (the `0x3300`/`0x3200` OUTOVER idiom) into a
  timestamped event list; bus-fault and alignment checking; optional
  per-transfer trace writer.
- Scheduler: `HIGH_PRIORITY` channels first, then lowest index; run loop
  stops on idle (halt), stall (busy but starved of external DREQs), watched
  writes, or a cycle budget.

`emu/fetchexec.go` sets up the 3-channel fetch/execute/fix machine
(`SetupFetchExec`) and is the reference implementation for the Phase 1
ARM-side loader.

### Golden tests (`emu/machine_test.go`)

Each test hand-assembles a block program and runs it on the emulated
machine: add, OR/AND/XOR via the atomic aliases, subtract via two's
complement, multiply-by-constant (multi-count pass-through), shift-left,
unconditional jump, the byte-swap conditional-jump idiom
(positive/zero/negative all verified), GPIO output ordering, null-trigger
halt, and a timer-paced loop whose iteration rate is timer-bound.

`TestInterruptDispatch` validates the approach-B interrupt design
(`prompts/overview.md` §3.2) end to end: dispatcher word, DREQ-armed
injector channel, ISR with EOI and re-arm, resume, and a second delivery
after re-arming — plus the negative case (no ISR without a pulse).

### `cmd/dmaemu` — CLI front end

Runs a raw block-program image under a JSON config: load images, poke
words, set up the fetch/execute machine (or raw register writes for custom
arrangements), run with watchpoints and a cycle budget, dump memory, and
report stop reason + GPIO events as JSON. Relative paths resolve against
the config file. Smoke-tested end to end (an add program: `0x1111 + 0x2222
= 0x3333` in 23 cycles).

### Housekeeping

`Makefile` (`build`, `test` = vet + golden tests, `test-hw` stub),
`.gitignore` (untracked third-party reference material per the Coding
rules), README with layout and build instructions.

## Findings

1. **The injector channel must set `HIGH_PRIORITY`.** With plain
   lowest-index arbitration the 3-channel machine is busy every cycle and
   starves the injector indefinitely. The same applies on real hardware's
   round-robin arbiter in spirit (delivery jitter), so the ABI should
   mandate `HIGH_PRIORITY` on the injector. Encoded in
   `TestInterruptDispatch`.
2. **Documentation fix:** `SNIFF_DATA` is at offset `0x438`, not `0x434`
   (`0x434` is `SNIFF_CTRL`). `prompts/overview.md` §2 and §4.2 were
   corrected.
3. **CTRL words cannot be OR-composed over a nonzero TREQ field.**
   `TREQ=permanent` is all-ones, so "add a timer TREQ" must rebuild the
   ctrl word. The future `dmaasm` should treat TREQ (and CHAIN_TO) as
   proper fields, never flags.

## Hardware-calibration TODOs

Marked `TODO(hw-calibration)` in the source; to be settled by the Phase 0
HIL diffing once a Pico runner exists:

- Exact bit/byte ordering of the sniffer CRC variants (only SUM is
  load-bearing for the machine ABI).
- Behaviour of a trigger with `TRANS_COUNT == 0` (emulator: no-op).
- Whether a null `CTRL_TRIG` write raises the quiet-mode IRQ based on the
  pre-write or post-write `IRQ_QUIET` bit (emulator: post-write).

## Open items from Phase 0

- Fetch the reference code ZIPs into a git-ignored directory (network /
  manual step) and capture hardware golden outputs (`make test-hw` is a
  stub until a Pico runner is attached).

## Suggested next step

Phase 1 (image format + loader, using `SetupFetchExec` as the reference) or
Phase 2 (`dmaasm`) if locking the ABI first is preferred.
