# Phase 11 results: can the machine write flash unaided? — a definitive characterization

The question from the persistence rung: does machine-only flash writing
require the ARM, or is it possible? A deep silicon diagnostic session
answered it precisely. **On the RP2350, the DMA machine cannot
autonomously write flash — and the reason is a specific, reproducible
bus-architecture limitation, not a software bug.**

The one-line proof, printed by the machine on silicon:

    CAL flash2: peripheral read normal=0035a448 under_EN=00000000
    after_EN=00000000 -> machine-only flash BLOCKED (EN freezes the
    DMA read path)

## What works

- **The machine drives QMI/QSPI writes perfectly.** The full bootrom
  exit-XIP dance — bit-banged through IO_QSPI output overrides and
  PADS_QSPI pull enables (CS-high/IOs-pulled-low x32 clocks,
  CS-low/IOs-pulled-high x32, driven FFh FFh) — completes on the
  machine (micro-phase markers reached 18/18). Every register WRITE
  the flash driver needs works.
- **The machine reads normal peripherals fine** — the microsecond
  timer read returns a correct, advancing value (measured
  delta=800804 us over a spin), same as it reads UART/sniffer.

## What is impossible, and exactly why

Three findings, each isolated on silicon by capturing the machine's
fetch/exec PC and probe values while it ran (the ARM waited in an
SRAM-resident loop, never touching flash):

1. **The DMA engine cannot READ QMI registers.** A bare read of
   `QMI_DIRECT_CSR` (0x400D0000), before any dance, freezes the fetch
   channel hard (PC frozen, exec stuck on 0x400D0000). The QMI
   register block is not reachable by the DMA read path.

2. **Entering QMI direct mode (`DIRECT_CSR.EN=1`) freezes the DMA
   engine's reads of ALL peripherals.** With EN set, the machine's
   timer read returns 0 (SRAM fetches keep working, so the machine
   runs on — it just reads zeros). Probe: normal=0x35a5fc, under
   EN=0x00000000.

3. **Clearing EN does not restore the read path.** after_clear stays
   0. Once the machine touches direct mode, its peripheral reads are
   dead until a full bootrom-class XIP re-init (clock setup, QMI
   reconfiguration) that the machine cannot perform.

Together these defeat every autonomous strategy:
- Status polling (RDSR/WIP) needs QMI reads — blocked by (1).
- The blind write-only workaround (issue commands, wait a fixed time
  by reading the timer, never read the QMI) is defeated by (2)+(3):
  to hold CS across a multi-byte command you must set EN, and the
  moment you do, the timer you need to time the erase delay reads 0 —
  permanently. The machine literally cannot time its own wait.
- Verification needs reads (QMI or XIP) — blocked.

The SDK's flash routines work because they run on the ARM and perform
the heavy connect-internal-flash + XIP re-init around every direct-mode
operation. The DMA machine has no equivalent it can drive on itself.

## The shipping answer

Persistence continues to work exactly as committed in prompts/022:
the kernel owns all POLICY (dirty-sector map, header-last commit,
generation counter) and posts erase/program primitives to the parked
ARM, which runs the SDK's XIP-safe routines. Verified again this
session: files survive hard reboots ("disk: FLASH SLOT gen 2",
`cat keep keep2` -> the two files). The ARM is a dumb disk controller;
all the interesting decisions are the machine's.

So: **not a failure of nerve or code — a hardware truth.** "Can the
machine write flash without the ARM?" On RP2350: no, because the QMI
register block is unreadable by DMA and direct mode freezes the DMA
read path irrecoverably. On a SoC without XIP-mode entanglement it
would; here the ARM's role is irreducible to ~a dozen SDK calls.

## Durable artifacts

- emu/flash.go: a QSPI/NOR model (XIP window + QMI direct-mode FIFO +
  a NOR command state machine) — lets the persistence path be
  emulator-tested (TestXv6Persist, the read-based reference driver).
- kflash.c: the real bit-banged exit-XIP dance and the QMI reference
  driver (used by the emulator; the ARM executor ships on silicon).
- cal_flash: the reproducible three-probe finding, printed every boot.
- The diagnostic method: firmware sampling the machine's fetch/exec
  channel PCs while the ARM waits in SRAM — turns an opaque wedge into
  an exact instruction + faulting address, wedge-proof.

## Next (unchanged roadmap)

kill() + reparenting, per-process heap, parenthesized sh; then the
presentation goals: HSTX DVI, DisplayLink over PIO USB, mount() + SD.
