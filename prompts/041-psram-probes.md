# PSRAM probes: the ~1 ms/word verdict was contention, not silicon

Goal: decompose prompts/036's recorded "DMA-master accesses through the
QMI PSRAM window are ~1000x slower than CPU accesses" — measured back
then with the line copier saturating CS1, never on a quiet bus — and
find the real constraint on using PSRAM again. Vehicle: cal_psram()
in the feather dev firmware (HIL_DEV=1), five CAL sections plus four
operator-judged display phases.

## Results (silicon: Feather RP2350, clk_sys 300 MHz, 2026-08)

| probe | result |
|---|---|
| ARM window write / read (uncached 0x15) | 117 / 121 ns/word |
| ARM read, cached 0x14 alias | 476 ns/word (cache buys nothing on CS1) |
| DMA channel burst read, count=256 | 29 us = 113 ns/word (97 over SRAM control) |
| DMA channel single-beat retrigger | 78 ns/beat over control |
| XIP streamer from 0x15... | OK, 105 ns/word, data verified |
| XIP streamer from 0x14... | BAD DATA — stream only the uncached alias |
| Streamer sustained, 256 KiB | 43.5 MB/s (fb refresh budget: 18.4) |

Display phases (scanout live, operator watching): idle, ARM window
writes, and streamer drains all held sync; saturating DMA window
reads lost it; recovery was clean after the traffic stopped.

## The corrected model

- **Intrinsic DMA-master access to PSRAM is wire-speed** (~113
  ns/word, same as the ARM). The 036 figure was queueing behind the
  copier era's perpetually-behind CS1 consumer, full stop.
- **The real law is about who issues the QSPI transaction.** Window
  accesses put QSPI transactions on the shared DMA read master;
  under saturation the occasional long beat (CS-break/refresh
  collision) exceeds the scanout's ~1.3 us FIFO budget and sync
  slips — even though the pixel pair is HIGH_PRIORITY. The streamer
  moved the same data rate with a stable screen because its QSPI
  fetches happen inside the QMI and the read master only drains a
  DREQ-paced FIFO port. While scanning: QSPI rides the QMI or the
  ARM, never the read master.
- Untested nuance: only a *saturating* machine hammer was shown
  fatal. Sparse/throttled machine window access under live video is
  an open follow-up probe.

## What this unlocks / doesn't

- **PSRAM as a storage tier, yes**: streamer reads at 43.5 MB/s and
  ARM-mailbox (or display-off machine) writes are both display-safe
  — an 8 MB machine-readable store (fs volume, slide library).
- **PSRAM as framebuffer, still no** — but for a new reason: refresh
  now has 2.4x the needed bandwidth via the streamer, and it is the
  *render* side (machine window writes, no write-side streamer) that
  sits in the display-fatal traffic class.
- **PSRAM as arena/working memory, no while displaying**: machine
  execution against PSRAM words is sustained window traffic.
