# Phase 5b Results: dma-sh — an Interactive Shell on Silicon

Status as of 2026-08-17. The shell rung of the xv6 ladder is complete:
verified in the emulator on both SKUs, and **interactive on the
Pico 2**. A live session with the DMA controller, ARM parked:

    dma> stat
    ticks=297534 bgcounter=25580040
    dma> primes 50
       2    3    5    7   11   13 ...
    (15 primes <= 50)
    dma> stat
    ticks=300176 bgcounter=25802000

The background process advanced 221,960 counts while the shell was
computing primes for the user — preemptive multitasking observable
from the prompt. `peek 0x50000458` reads the machine's own live
accumulator; `echo hello from silicon` does what it says.

## What was built

- **UART RX**: the emulator models input (`Machine.ConsoleIn`,
  `FeedConsole`) — DR reads pop the queue, FR gained a live RXFE bit;
  `dma/mmio.h` exports `DMA_UART_FR_RXFE`. On hardware the DMA machine
  reads the real RX FIFO directly (pico stdio never touches RX).
- **dma-sh** (`dmacc/testdata/shell.c`): a compiled-C shell — line
  editing with echo and backspace, commands `help`, `echo`, `stat`,
  `peek`/`poke` (a live memory/MMIO monitor: `peek 0x50000458` reads
  the accumulator), `primes`. It runs as **process A under the Phase 5a
  kernel** with the counter program as process B; the input-poll loop
  crosses a safepoint every iteration, so the prompt itself is
  preemptible and the background process keeps running — no syscalls
  needed for this rung.
- `TestShellSystem`: the scripted three-image session; `stat` twice
  around a `primes` run shows the background counter advancing
  (multitasking observable from inside the shell). The same session is
  re-verified inside dmxgen (`verifyShell`) every time the header is
  generated.
- dmxgen `shellBundle` (`HIL_HAS_SHELL`): kernel + shell(+libc) +
  counter at fixed rp2350 offsets, cross-image pointers and the shell's
  stat pointers patched at generation time, relocations baked.
- Firmware: after one full test/cal/exp pass, `shell_start()` loads the
  bundle, arms the tick chain, starts the shell, prints a handoff
  banner, and parks the ARM off the UART for good.
- Toolchain fixes en route: `nneg` cast flag; freestanding-`-Oz`
  `memset`/`memcpy` libcalls lower to the native runtime.

## Silicon status (honest)

During bring-up the bench failed in a way that blocks verification:
the Debug Probe's **USB-UART bridge went silent host-side** — zero
bytes at any baud rate, including the firmware boot banner that prints
before any DMA activity — while the same probe's SWD interface flashes
and verifies normally. This began around an earlier forced takeover of
the serial port and survives target rescues/reflashes, so it needs a
physical replug of the probe.

Separately, one open observation to check once the console returns:
with the shell system running, OpenOCD intermittently failed core-0
examination (and one reset attempt needed the rescue DP). exp_sched
(same kernel mechanics, simpler process A) passes every iteration, so
if this is real it is specific to the shell workload on silicon — the
first capture-from-boot after the replug will show exactly how far the
system gets (all TEST/EXP lines print before the handoff).

## To bring the shell up (after replugging the probe)

1. Reset or reflash (`make test-hw`); watch one full test pass, then
   `=== handing console to dma-sh ===` and the banner.
2. Open minicom on `/dev/cu.usbmodem102` @115200 and press Enter for a
   fresh `dma> ` prompt — or run the scripted session
   (scratchpad `chat2.py` pattern: knock with `\r`, then
   `help`/`stat`/`primes 50`/`stat`).
