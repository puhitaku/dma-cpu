# 044 — A real timebase: TIMERAWL at the point of use

`show` reported a 40 ms slide draw as **0.00s**, and had done since the
viewer was written. The number was not rounded, dropped or truncated.
It was correct, for the question it was asking.

## The bug, stated exactly

`ticks` (`xv6/dma/kproc.c`) counts scheduler quanta the tick injector
DELIVERED. That is all it has ever counted, and the mechanism makes it
a poor clock:

- the kernel has no safepoints — the frozen invariant that lets every
  kernel data structure be lock-free;
- the injector is one-shot and re-armed at `kexit`, and its DREQ credit
  is cleared on trigger;
- so fires that land while the kernel is running collapse into the
  single `tickpending` word and `ticks` advances **at most once per
  kernel round trip**.

A 640x480 slide is drawn by ONE `SYS_read`. Measured in the emulator:
12.5M cycles inside the kernel, 833 quanta expected, **0 observed**. On
silicon at 300 MHz: ~10,400 expected, 1–2 delivered. `SYS_uptime`
returned `ticks`, `show` subtracted two of them, and printed the truth
about a counter nobody wanted to know about.

Everything downstream inherited it: `klogts()` stamped every kernel log
line `[0.000]` through a boot that really takes milliseconds, and
`pause(n)` slept n *delivered quanta*, which is n×100 us only when
nothing eats them.

## What was NOT done

`ticks` is unchanged — same variable, same increment, same meaning, and
`SYS_meminfo` still reports it (as "ticks", no longer mislabelled
"uptime" by `toolbox free`). There is no reconciliation state, no
catch-up loop, no attempt to guess how many quanta went missing. A tick
counter that lies about time is the bug; a time source that pretends
missing quanta were delivered would be worse.

## The fix

Wallclock is the TIMER block's free-running microsecond counter, read
at the point of use. It is genuinely independent: on silicon it runs
off its own 1 MHz reference, so it does not care that the feather
overclocks clk_sys to 300 MHz, and it does not care that the kernel is
in the middle of a 12M-cycle read.

- `__dma_timerawl` / `__dma_timerawh`: two compiler-known MMIO globals,
  resolved per SKU by dmacc (`hwMMIO`) and dmaasm (`%timerawl`,
  `%timerawh`), exactly as the UART registers already were. The TIMER
  block is at 0x40054000 on RP2040 and 0x400B0000 on RP2350, and
  **TIMERAWH is at +0x24, four bytes BELOW TIMERAWL at +0x28** — +0x2C
  is DBGPAUSE, which is a debug-control register and not time.
- `wall_now(hi, lo)`: the high-low-high coherent read. The halves latch
  independently, so a rollover between two reads pairs a stale high
  with a fresh low and reports a value 2^32 us out. Read high, low,
  high; retry if the high moved. At most two passes — a second wrap
  would need another 71.6 minutes.
- `wall_since` and `us_div`: 64-bit subtract and divide in hand-rolled
  32-bit halves, because dmacc has no i64. `us_div` runs the high word
  through the machine's 32-bit divide and then brings the low word down
  a bit at a time.
  - It reads the low word through a DESCENDING MASK rather than
    shifting out of it. Written the obvious way — `rem = (rem << 1) |
    (l >> 31)` next to `l <<= 1` — clang recognizes the pair as a
    funnel shift and emits `llvm.fshl.i32`, which this machine's
    compiler does not implement. Writing the halves as `x + x` and a
    comparison does not help: instcombine canonicalizes them straight
    back into `fshl`. With `l` never shifted there is no pair to match.
- `klogts()` and `SYS_uptime` compute elapsed against a boot epoch
  captured in `kboot_init`. `SYS_uptime` keeps its unit (100 us), so no
  user program changed: `show` still formats it the same way and now
  gets a number that moves.
- Timed sleeps (Option B): `SYS_pause` and `SYS_select`'s timeout store
  a MICROSECOND deadline in `proc.wake_us` (renamed from `wake_tick`),
  `TIMERAWL + n*100`, compared wrap-safe. The horizon shrinks from
  ~2.5 days to ~35 minutes, against a tree whose longest sleep is
  `pause(1000)` = 100 ms.

### The tick path got cheaper, not dearer

`tick_income` is resident code (.ramtext, `kernResident`), so the one
TIMERAWL read it needs is behind an `ntimed` guard — a hint, not a
refcount: the walk RECOUNTS it, so a sleeper woken by `sel_wake` or a
kill costs one extra walk and then settles, and it can never under-count
into a missed wake.

The guard turned out to be worth far more than the read costs. The old
code walked all 8 proc slots on every one of the 10,000 ticks a second
whether anything was sleeping or not; now an idle system pays a load
and a branch. Measured across the xsh benchmark suite that is **950 to
2300 cycles per delivered tick**, which is 6–18% of whole-command
cycles and a third of the vi suite.

`kenter` is resident too, and was carrying the entire one-time boot
block — banner, `kfb_init`, `kfs_start`, `kflash_init` — in the
scarcest memory in the system. It is now `kboot_init`, out of line and
in flash, where code that runs once before the display is even up
belongs.

Resident text, in emitted blocks:

| function | before | after |
| --- | ---: | ---: |
| `tick_income` | 96 | 113 |
| `kenter` | 190 | 111 |
| `kboot_init` (new, NOT resident) | — | 77 |
| net .ramtext | | **-464 bytes** |

## The emulator half

`host/emu/flash.go` returned `Cycle << 8` for TIMERAWL — 256 "us" per
cycle, so that timer-based waits would finish quickly off-silicon. With
the kernel now reading that register for time, the model had to become
honest, and there is only one honest answer available: every rig arms
the scheduler's DMA pacing timer at 15000 cycles for a 100 us quantum,
so on the emulated machine **a microsecond IS 150 cycles**
(`emu.DefaultCyclesPerUS`). Anything else would have the same machine
contradict itself.

The model lives in `host/emu/timer.go` as `Machine.Timer`, a
`TimerModel{Mul, Div}` whose zero value is honest.

- **The flash paths pay nothing.** Audited before touching the
  multiplier: `kflash.c` reads TIMERAWL in exactly three places, all
  diagnostic timestamps inside `kflash_cal`, and every wait in the
  driver polls the RDSR WIP bit. The emulator's flash model completes
  operations instantly, so those polls exit on the first read. No fixed
  microsecond spin exists to slow down. `TestXv6Persist` runs in
  **0.719 s before and 0.740 s after** — noise, not a timer bill.
- **The game keeps the fast model, on purpose.** `target/game/src`
  spends real microseconds by design: 280 ms of fixed ST7789 reset
  delays at panel bring-up (`lcd.c`) and a TIMERAWL-paced frame loop
  (`input.c`). Honest, an emulated boot would burn 42M cycles before
  the first pixel and then pace every frame at 60 Hz. The two game rigs
  (`host/dmacc` `bootGameImage`, `host/cmd/dmxgen` `buildGame`) declare
  `emu.TimerFreeRun`, and the whole game half of `images.h` is
  byte-identical across this change.

## Tests

- `host/emu/timer_test.go` — the cycles-to-microseconds mapping on both
  SKUs and both models, TIMERAWH's address (+0x24, not +0x2C), and a
  table-driven high-low-high coherency test that forces the low word to
  wrap between the reads and checks both that the retry converges on
  the second pass and that the naive pair would have been wrong.
- `host/dmacc/wallclock_test.go`
  - `TestXv6ShowWallclock`: the regression. Stages a full-size 307200-byte
    slide on the FAT SD model, runs `show`, and brackets the draw with
    the machine cycles at which "Opened …" and "Done drawing …" reach
    the console — a measurement made outside the kernel's own clock.
    **Before: `Done drawing /sd/big.sld (0.00s)` over a bracket the
    harness clocks at 12,920,157 cycles = 86.1 ms, with every kernel
    stamp in the session reading `[0.000]`. After: `(0.08s)` over
    12,880,166 cycles = 85.9 ms, and the framebuffer bring-up stamped
    at the `[0.004]` it really costs.**
  - `TestXv6WallclockWrap`: the same draw with the machine parked 5 ms
    short of the 32-bit microsecond rollover, so `wall_since`'s borrow
    and `us_div`'s high-word division are on the live path. Kernel
    stamps must cross 4294.967 s, stay ordered, and never jump the
    4295 s that a mismatched pair produces.
  - `TestXv6PauseDeadline`: Option B. Catches `fbtest` in its
    `pause(1000)`, checks the deadline is 100 ms out, then advances the
    machine past it with no tick delivered — the long kernel stay,
    synthesized. The sleeper wakes on the **first** delivered tick.
    Under a tick-counted deadline it would have needed a thousand.

## Ratchet

Regenerated in both modes. Sizes: kernel flash text +2.1% (the pair
arithmetic and the boot block coming out of .ramtext), .ramtext -464 B,
data -1068 B on the feather deploy. Cycles: xsh -5.8% to -18.4% across
all twelve figures, vi TOTAL -33.3%, three of four fbcon figures on each
board better by 5–15%.

The exception, recorded rather than explained away:
`fbcon/feather/cat README` went 1,349,986 -> 1,889,021 (+40%) while the
same workload on pico2 went -12%. Bisected to the `ntimed` guard alone
(with the guard removed and everything else in place it measures
1,364,983, i.e. baseline). The feather is the only board with an HSTX
scanout streaming 18 MB/s against the workload, and the guard makes the
whole session reach that command at a different point in the scanout's
cadence. Worth a look on silicon, where the contention is real rather
than modelled.
