# Phase 5a Results: Preemptive Multitasking on the DMA Machine

Status as of 2026-08-16. The first rung of the overview §5 xv6 ladder —
**timer-preemptive round-robin of two DMA "processes"** — runs in the
emulator (both SKUs) and on the Pico 2:

    EXP sched: PASS ticks=127->637 counterA=11051->55195 counterB=11031->55148

637 scheduler ticks in 100 ms (the calibrated 62.8 % of the 10 kHz
pacing rate), two compiled-C processes sharing the machine with 0.09 %
progress skew, zero host involvement after setup.

## The process model (this is the payoff of the whole architecture)

- **A process is a relocated image.** Both processes are the *same*
  compiled program (`dmacc/testdata/proc.c`) assembled twice at
  different bases: Tier-2 relocation gives each instance a private
  register bank, frame, dispatch and irqresume — per-process context
  banking is free, exactly as overview §3.2/§4.4 predicted.
- **Context switch is ONE word.** At a safepoint, everything shared —
  `at`/`at2`, `sc*`, millicode words, runtime locals, `%sniff` — is
  dead by construction (no safepoints inside macros, helpers, or the
  runtime), and registers live in per-process SRAM. The scheduler saves
  the preempted process's `irqresume` and jumps through the other's.
  No register file copy exists because there is nothing to copy.
- **The tick is approach B, doubled**: injector ch3 (pacing-timer TREQ)
  writes `&sched_from_a` over A's dispatch and chains to injector ch4,
  which writes `&sched_from_b` over B's. Whichever process is running
  detours into the scheduler at its next safepoint; the scheduler's EOI
  restores both dispatch thunks, saves the resume, bumps `ticks`,
  re-arms ch3, and resumes the other process. ~15 blocks per switch.

## What was built

- `prog/hil/kernel.dasm` — the scheduler (two vectors, cross-image
  pointer words the loader patches, EOI/save/switch paths).
- `dmacc/testdata/proc.c` — the scheduled process (a safepointed
  counter loop); dmacc's crt0 resume thunk is now the exported
  `crtthunk` so kernels can use it as the EOI value.
- `TestPreemptiveScheduler` — the full three-image system in the
  emulator: 33 ticks over 500 k cycles, counters 4701/4516, both SKUs.
- dmxgen: the `sched` bundle — kernel + two proc instances at fixed
  offsets in the machine region, cross-image pointers patched at
  generation time, the whole scenario emulator-verified before the
  header is written, relocations baked. Firmware `exp_sched` loads,
  arms the chain, starts A, and samples.

## Observations

- Preemption granularity: at ~6.3 k ticks/s and ~1.4 M safepoints/s,
  delivery latency stays deep sub-tick; the 0.09 % counter skew over
  ~630 switches shows the round-robin is essentially fair.
- A tick landing *during* the scheduler (which has no safepoints) just
  re-patches the dispatches and delivers at the next process safepoint
  — the same last-writer-wins coalescing as single-process approach B.
- The kernel uses the classic encoding; the compact encoding is
  compatible in principle (safepoints are plain records) but an
  end-to-end compact schedule is untested.

## Next rungs (overview §5 item 15)

1. **Syscalls**: voluntary entry by self-patching dispatch (`yield`
   needs only two loader-patched pointer words from C — no compiler
   change), then a mailbox convention for arguments; first syscalls:
   `yield`, `write` (console), `exit`.
2. **Blocked states + more processes**: the proc table generalizes from
   2 words to N; the scheduler needs a run queue.
3. **UART RX** for a console shell: emulator input modeling
   (`FR.RXFE` + DR reads) and a getchar path — the natural DREQ-driven
   wake-up already exists (UART RX DREQ → injector).
4. **Kernel in C**: the scheduler is deliberately tiny dasm; once
   syscalls exist, kernel logic (scheduling policy, drivers) should be
   compiled C in its own image.
5. Capacity for a real kernel: compact encoding (done) + XIP overlays
   (open) remain the density plan of record.
