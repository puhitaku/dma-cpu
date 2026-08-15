# Phase 3 Results: Interrupt Approaches Compared on Silicon

Status as of 2026-08-16. All four interrupt approaches from
`prompts/overview.md` §3 were implemented and measured — in the emulator
and on the Pico 2 (RP2350). **Decision: adopt approach B (hardware vector
patching via safepoints) as the single interrupt mechanism.** A and D
survive only in narrow non-interrupt roles; C is rejected with data.
Arbitrary-point preemption of uninstrumented code is shown to be
fundamentally unsafe on this machine — see "The arbitrary-interruption
question" below.

## What was built

- `safepoint` assembler macro (2 blocks, per the ABI rule): store the
  resume literal into `irqresume`, jump indirectly through `dispatch`.
- `prog/hil/irq.dasm` — approach B: safepointed loop, resume thunk, ISR
  with FIFO-drain acknowledge, EOI, injector re-arm, return.
- `prog/hil/poll.dasm` — approach A: `jneg`-polled `pending` word.
  (Semantics note learned the hard way: `jneg` cannot see `0x80000000`
  as negative — raise with small-magnitude negatives like −1.)
- Firmware experiments: PIO GPIO-edge→DREQ bridge (3-instruction SM,
  internal loopback on GP3), injector on ABI channel 3 (HIGH_PRIORITY),
  latency histograms, freeze/thaw and abort/divert stress loops.
- Emulator: deterministic freeze/thaw sweeps.

## Results

### Approach B — injector + safepoints (ADOPTED)

| Metric | Result |
|---|---|
| GPIO-edge delivery (PIO bridge) | **1000/1000 delivered, 0 missed** |
| Delivery latency | **≤ 1 µs** (499× <1 µs, 501× 1 µs; at timer resolution) |
| Burst of 3 fast edges | **3/3 ISRs** — the PIO FIFO queues pending interrupts |
| Loop overhead (steady state) | 7 blocks/iter → **1.429 M iter/s**; emulator 41 cyc/iter |
| Throughput cost under 6.3 k ints/s | **0.4 %** (~12 blocks per interrupt) |
| Timer tick (pacing TIMER1) | reliable, but effective rate = **62.8 % of programmed** at 10/5/2.5 kHz exactly |

The 62.8 % timer fraction is rate-independent (628/1000, 314/500,
157/250), so it is calibratable (program Y accordingly) and does not
affect GPIO/FIFO-backed sources, which lose nothing. Root cause is an
open question (suspect: credit-clear + DREQ handshake re-initiation on
re-arm interacting with the pacing timer; investigate via `DBG_CTDREQ`
or a PWM_WRAP DREQ source). Everything else behaves exactly as designed
in overview §3.2, including interrupt queueing in the PIO FIFO.

### Approach A — software polling (fallback niche only)

Works: 1000/1000 delivered at ~1 µs (one poll period). But the poll
costs 9 blocks/iter → **1.111 M iter/s, 22 % slower than B's loop**, and
latency is strictly worse (B's safepoint is 2 blocks vs the 5-block
executed poll path). Keep only where the injector channel cannot be
spared; it needs no extra hardware.

### Approach C — asynchronous freeze/thaw (REJECTED)

- Emulator, atomic freeze (all three EN-clears with zero machine
  progress between them): 0/48 offsets wedge — C would be sound *iff*
  freezing were atomic, but no RP2 mechanism can clear three separate
  CTRL registers atomically with respect to machine progress.
- Emulator, interleaved freeze (realistic): **17/48 offsets wedge
  (35 %)**, deterministic, caused by chain/trigger events landing on a
  partially-disabled machine (triggers drop while EN=0 — silicon-
  verified in Phase 1.5).
- **Hardware: 354/500 freezes wedge (71 %)**; recovery requires a full
  machine reload. Worse than the emulator's best case, as predicted,
  because the ARM's clear-writes interleave with the machine.

### Approach D — abort and divert (debug/reset tool only)

Hardware, 500 trials: **30 % of aborts catch the fetch mid-block
(misaligned PC), 46 % catch the exec channel mid-transfer (replay/skip
hazard), and 71 % of divert-then-resume attempts wedge** even with PC
realignment. Worse, a wedged resume can send the machine through garbage
control blocks that issue writes to arbitrary MMIO — during this phase
one such episode required the RP2350 **rescue DP** to recover the chip
(SWD examination itself failed). D is fine for "stop everything and
restart" (debugger, panic reset) — never for resumable interrupts.

## The decision

**Adopt approach B alone.** It is simultaneously the fastest (≤1 µs),
cheapest (2 blocks per safepoint, 0.4 % throughput cost under load),
most reliable (zero losses, hardware queueing), and the only approach
that preserves machine invariants by construction (delivery only at
instruction boundaries chosen by the compiler). A is strictly dominated
where the injector channel exists; C and D are unsafe, now with numbers.

### The arbitrary-interruption question

No approach can safely preempt this machine at an *arbitrary* block:
triggers are dropped while channels are disabled (C) and aborted
in-flight state cannot be reconstructed (D) — both now measured, not
just argued. This is a fundamental property of the fetch/execute
machine, not an implementation gap. Consequently "arbitrary" preemption
is redefined the way GC safepoints redefine it for managed runtimes:
**all interruptible code must carry safepoints, and the compiler bounds
the longest safepoint-free path** (ABI rule), giving hard worst-case
latency of (path length × ~100 ns/block) + ~1 µs delivery. Code that
omits safepoints is by definition uninterruptible — a property to lint
for in the Phase 4 compiler, not to patch around at runtime. No second
mechanism is needed or advisable.

## Bench notes

- The stale VS Code OpenOCD server died mid-phase and its probe claim
  had to be replaced; flashing now uses a standalone OpenOCD invocation
  (`make test-hw`). If SWD examination fails after a wild-machine
  episode, run `target/rp2350-rescue.cfg` once, then flash.
- Do not flash while the experiments are mid-run if avoidable; the one
  system brick coincided with a flash during active DMA stress.

## Open items

- Characterize the 62.8 % pacing-timer delivery fraction (DBG_CTDREQ,
  PWM_WRAP source comparison).
- Port the injector arming into DMX init writes (the image format
  already supports it) so interrupt-enabled programs are self-contained.
- RP2040 board run for the same experiment set, when on the bench.
