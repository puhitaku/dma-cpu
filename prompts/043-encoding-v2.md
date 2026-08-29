# 043 — Compact encoding v2: measured, and closed

The measurement and design phase for prompts/042 §7 ("per-page or
per-function template dictionaries so common record shapes pay 4 B, not
8"), run 2026-08-29 against 82c245c.

**Verdict: do not build.** The best encoding that this machine can
actually execute buys **-3.4% to -11.6% of record bytes** and costs
**+9% to +16% of executed records' cycles**, at a fixed exchange rate of
roughly **1.4–2.5% of cycles per 1% of text**. It needs three DMA
channels the RP2040 boards do not have — including gamepico, which is
the image where the win is largest. It touches dmaasm's planner, its
literal pool, its block-field addressing and its trampoline arena at
once. The project's own revealed preference (§6 kept a dead 8-byte
frame trailer rather than pay +1.25% on `echo hi`; §10 (c) spent
+1.1 KiB to buy -0.5%) puts a +10% cycle bill an order of magnitude
outside the envelope.

What is on record here is not a hand wave: the 4-byte encoding was
**built and run**. `host/dmaasm/zz_reccycles_test.go` configures the
indirection machine out of real DMA channels, executes records through
it in the emulator, and prices it at 4.000 cycles/record against the
shipping encoding's 3.000. The question was never whether the hardware
can do it. It was whether the bytes are there, and they are not.

## 1. What a record is (verified, not assumed)

There is no CPU in the record loop, and this is worth stating precisely
because every "decode stage" idea dies on it.

- `target/loader/dmx.c:dmx_start` (compact branch) writes four
  registers — fetch's `READ_ADDR` (the PC), `WRITE_ADDR` (the current
  bank window), `TRANS_COUNT` = 2, and `CTRL_TRIG` — and returns.
  `emu.SetupFetchExec` does the identical thing in Go.
- `target/firmware/main.c` then calls `park_forever()`
  (target/firmware/executor.c), which executes `cpsid i` and spins on a
  mailbox forever. The ARM's remaining jobs are flash erase/program, SD
  sectors and the end-of-sync XIP restore — it never fetches from flash
  again and never touches a record. On the feather, core 1 is inside
  `video_feeder()`, a `.time_critical` SRAM loop that must not stall.
- Execution is therefore: fetch moves 2 words into the current bank's
  AL2 tail (`READ_ADDR` at `+0x28`, `WRITE_ADDR_TRIG` at `+0x2C`); the
  second write triggers the bank; the bank performs one transfer and
  chains back to fetch. Fetch's 8-byte write ring snaps its write
  pointer back to the window, which is why there is no fix channel.
  Auto-return banks (size8/size8W/size8RW/bswap/size16) chain through
  cleanup, which rewrites fetch's `AL2_WRITE_ADDR_TRIG` with the plain
  window — the restore IS the re-trigger.

So a record is **two 32-bit absolute addresses and nothing else**.
There is no CTRL word, no count field, no opcode, no register number:
"the transfer mode IS the fetch window" (host/dmaasm/compact.go). This
is what makes §7's framing slippery — asking for "the record with its
variable operands abstracted out" when the record is *entirely*
variable operands. The probe therefore reports all three abstractions
that exist:

- the exact pair `(S, D)` — what a zero-operand dictionary index names;
- `(*, D)` — what a destination-sticky half record names;
- `(S, *)` — what a source-sticky half record names.

**Measured cost of one record: 3.000 cycles** (2 fetch transfers + 1
bank transfer; chaining is free on the emulator's clock, which is the
clock every cycle figure in prompts/042 is quoted on). Measured by
`RECCYC=1 go test ./host/dmaasm/ -run TestZZRecordCycles`.

## 2. Method

`SHAPES=1 go test ./host/dmacc/ -run TestZZShapes -v`
(host/dmacc/zz_shapes_test.go) assembles each deployable image, walks
its record regions, and reconstructs the machine state statically.

- **Record regions.** Segment 0 up to the constant-rodata block that
  `XIPText` appends to the text tail (found from the generated `.dasm`
  marker and the first label after it), plus all of segment 2
  (`.ramtext`, which also carries the sign-dispatch trampoline arena).
  Cross-check: fs-kern-xip decodes 195472 record bytes + 2776 rodata =
  198248, exactly the text TestZZAllSizes reports; sh(K2) decodes
  45216 = its whole text.
- **Bank state.** Switch records (`dst == fetch AL3_WRITE_ADDR`, `src`
  a pool literal holding a bank window) are replayed to track which
  bank each record executes on — the static twin of what
  zz_banktax_test.go classifies at runtime.
- **Entry points.** Every text symbol plus every pool literal whose
  *value* lands in a record region. dmaasm drops `__`-prefixed labels
  from `Result.Symbols`, so the literal pool is the only complete view
  of where jumps go. §4's sensitivity run bounds what this
  approximation could cost.
- **Self-modified records.** Any record whose destination lands inside
  a record region marks the record it patches.
- **Bases.** TextBase 0x10000000, DataBase 0x20010000, RAMTextBase
  0x20000000 — chosen so every operand class stays distinguishable
  (TestZZAllSizes' DataBase of 0x50000000 sits on top of the DMA
  register block, harmless there and fatal to an operand classifier).
  Sizes do not depend on the bases.
- **Caveat.** `vi` is built standalone here; the shipped image uses
  `RuntimeExtern` to share the kernel's runtime, so its absolute
  baseline differs. Shape statistics are unaffected in kind.

Record counts and record bytes (text records + ramtext records; the
rodata tail is excluded from every figure below):

| image | records | record bytes | distinct pairs | distinct/records |
| --- | --- | --- | --- | --- |
| fs-kern-xip | 29939 | 239512 | 14846 | 0.496 |
| fs-xip-pgo | 28574 | 228592 | 13668 | 0.478 |
| sh(K2) | 5652 | 45216 | 2627 | 0.465 |
| vi | 20361 | 162888 | 9756 | 0.479 |
| game | 33245 | 265960 | 13072 | 0.393 |

## 3. The histograms

### 3.1 Top-K coverage, globally

Exact pair `(S, D)` — the share of all records covered by the K most
frequent pairs:

| image | K=4 | 8 | 16 | 32 | 64 | 256 | 1024 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| fs-kern-xip | 15.7% | 19.5% | 24.5% | 29.2% | 32.8% | 39.7% | 49.7% |
| fs-xip-pgo | 17.1% | 21.1% | 26.0% | 31.4% | 35.5% | 42.5% | 52.3% |
| sh(K2) | 13.4% | 17.8% | 23.1% | 29.7% | 36.2% | 52.5% | 71.6% |
| vi | 14.3% | 17.6% | 22.1% | 26.6% | 31.3% | 41.3% | 54.4% |
| game | 21.8% | 27.3% | 33.3% | 38.5% | 43.1% | 49.9% | 59.6% |

Destination alone `(*, D)`:

| image | K=4 | 8 | 16 | 32 | 64 | 256 |
| --- | --- | --- | --- | --- | --- | --- |
| fs-kern-xip | 49.8% | 64.0% | 74.4% | 78.4% | 80.7% | 85.7% |
| fs-xip-pgo | 53.1% | 63.5% | 72.7% | 77.1% | 79.6% | 84.9% |
| sh(K2) | 40.2% | 57.8% | 72.4% | 79.5% | 85.4% | 94.1% |
| vi | 47.3% | 62.9% | 73.6% | 79.4% | 83.8% | 90.6% |
| game | 55.3% | 64.3% | 74.5% | 81.4% | 83.8% | 88.9% |

Source alone `(S, *)`:

| image | K=4 | 8 | 16 | 32 | 64 | 256 |
| --- | --- | --- | --- | --- | --- | --- |
| fs-kern-xip | 25.7% | 34.3% | 41.4% | 46.8% | 51.1% | 59.8% |
| fs-xip-pgo | 27.8% | 37.2% | 43.8% | 49.7% | 54.1% | 62.4% |
| sh(K2) | 21.8% | 32.9% | 40.3% | 49.9% | 57.8% | 75.2% |
| vi | 22.0% | 30.8% | 38.2% | 45.7% | 52.5% | 64.4% |
| game | 33.8% | 42.4% | 49.0% | 54.1% | 58.5% | 67.6% |

**Read this as: destinations are concentrated, sources are not.** Four
destinations cover half the machine — they are fetch's `READ_ADDR`
(`%pc`, 13–19% of all records), fetch's `AL3_WRITE_ADDR` (the bank
switch, 13–18%), `%sniff` and `null`. The entropy is all on the source
side, which is where the literal-pool addresses and the register cells
live. That asymmetry is the single most important fact in this
document, and it is why candidate A (below) exists at all and why it
still fails.

The record class taxonomy for fs-kern-xip, which shows the same thing
in words (top classes, share of all records):

| class | share |
| --- | --- |
| `lit -> %pc` (jump) | 17.9% |
| `lit -> fetch AL3_WRITE_ADDR` (bank switch) | 14.8% |
| `lit -> text` (block-field patch) | 8.8% |
| `data -> text` | 8.0% |
| `%sniff -> data` | 7.1% |
| `data -> %sniff` | 6.1% |
| `data -> data` | 5.1% |
| `lit -> data` | 4.5% |
| `lit -> null` | 3.8% |

### 3.2 Per-function and per-page — localization LOSES

There is no hardware page. Fetch's `READ_ADDR` is a flat 32-bit
incrementing pointer with **no read-side ring**; the only ring in the
machine is fetch's 8-byte *write* ring, which snaps the write pointer
back to the current bank window. "The fetch window" is a window in the
DMA register file, not a range of the instruction stream. So there is
no granularity the executor imposes, and the only sub-image scope with
a structural meaning is the **function**, which control flow enters at
a known label. Fixed 256 B and 1 KiB windows are reported as the
arbitrary alternative the §7 sketch also names.

Local dictionary size (entries needed if each scope carries its own
table) against the 14846-entry global dictionary for fs-kern-xip:

| scope | scopes | local entries | vs global | top4 | top8 | top16 | top32 | top64 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| whole image | 1 | 14846 | — | 15.7% | 19.5% | 24.5% | 29.2% | 32.8% |
| function | 190 | 17690 | +19% | 21.1% | 29.3% | 39.4% | 51.8% | 66.2% |
| 1 KiB page | 235 | 20637 | +39% | 22.4% | 31.4% | 42.7% | 56.1% | 80.7% |
| 256 B page | 937 | 24475 | +65% | 29.1% | 43.2% | 67.8% | 100% | 100% |

Same shape on every image (game: global 13072, per-function 15582
(+19%), per-1 KiB 19972 (+53%)). The top-K numbers rise as the scope
shrinks, which is exactly what §7 hoped for — and it is an illusion:
a 256 B page holds 32 records, so "top32 = 100%" is arithmetic, not
locality. What matters is total storage, and **localizing the
dictionary makes it 19–65% bigger**. The §7 sketch's "per-page or
per-function" qualifier is the one part of the idea that measurement
rejects outright: if a dictionary is built at all, it must be global.

### 3.3 Reuse depth — the singleton wall

Share of records whose exact pair occurs *n* times in the image:

| image | ×1 | ×2 | ×3–4 | ×5–16 | ×17+ |
| --- | --- | --- | --- | --- | --- |
| fs-kern-xip | 42.1% | 8.0% | 6.5% | 9.2% | 34.2% |
| fs-xip-pgo | 40.8% | 7.4% | 6.2% | 8.7% | 36.9% |
| sh(K2) | 37.0% | 8.4% | 8.9% | 15.3% | 30.3% |
| vi | 40.1% | 7.3% | 6.9% | 12.7% | 32.9% |
| game | 32.3% | 7.2% | 6.3% | 9.4% | 44.7% |

A third to a fifth of every image is records that occur **exactly
once**. A pooled record costs 4 B plus its share of an 8 B entry, so a
singleton costs 12 B against 8 — pooling it is a 50% loss. This is the
wall: any dictionary scheme must be able to *skip* singletons, and
skipping them requires a second encoding mode, and a mode costs a
record to enter. Everything below is a way of paying that bill.

The reason the residue is this incompressible is that the cheap
redundancy is already gone. §4's record-level outliner harvests
repeated record *sequences*; foldCopies harvests the free moves; §10
(b) proved the bank-state stream has 0.20–0.28% of slack. What
remains is genuine per-site operand entropy.

### 3.4 Run lengths — the raw material for candidate A

Maximal runs of consecutive records that share a destination, broken at
entry points, self-modified records and auto-return banks:

| image | eligible | longest run | in runs ≥2 | ≥4 | ≥7 | ≥10 |
| --- | --- | --- | --- | --- | --- | --- |
| fs-kern-xip | 95.0% | 34 | 3.66% | 2.13% | 1.03% | 0.47% |
| fs-xip-pgo | 94.8% | 34 | 4.01% | 2.38% | 1.22% | 0.49% |
| sh(K2) | 96.4% | 8 | 3.50% | 1.88% | 0.67% | 0.00% |
| vi | 95.8% | 24 | 3.07% | 1.52% | 1.03% | 0.55% |
| game | 97.0% | 17 | 7.87% | 3.80% | 1.52% | 0.42% |

Sharing a source is worse everywhere (kernel: 0.65% in runs ≥7,
longest run 13). The concentrated destinations of §3.1 are *scattered*:
the planner interleaves a bank switch or a payload record between them
by construction, and 23.0% of executed records are bank state (§10 (b)).

## 4. The candidates

### Candidate A — sticky-operand half records

**Layout.** 4 B, one field: a 32-bit absolute address. That is the
whole record. The other operand is not in memory at all — it is the
bank channel's persisted `READ_ADDR` or `WRITE_ADDR`. The "template
dictionary" is the DMA register file.

**Mechanism.** Every alias row of a DMA channel ends in a trigger
register, and two of them take an address:

- `AL3_READ_ADDR_TRIG` (`+0x3C`) sets `READ_ADDR` and fires, reusing
  the persisted `WRITE_ADDR` → a **destination-sticky** record;
- `AL2_WRITE_ADDR_TRIG` (`+0x2C`) sets `WRITE_ADDR` and fires, reusing
  the persisted `READ_ADDR` → a **source-sticky** record.

So half mode is: fetch `TRANS_COUNT` 2 → 1, write `RING_SIZE` 3 → 2
(8 B → 4 B, so the pointer still snaps back), `WRITE_ADDR` → the chosen
half-window. The bank is the existing plain bank (ch0), which already
chains back to fetch. **Zero extra channels for the mode itself.**

**Residence.** Nowhere. No table, no index, no relocation.

**Boundaries.** Auto-return banks are excluded: cleanup rewrites
fetch's `AL2_WRITE_ADDR_TRIG` with the *plain 8-byte window*, which
drops the machine out of half mode. Records that write `%pc` are
excluded: the mode is fetch's own state and a jump carries it into the
target, so the canonical-state rule of host/dmaasm/compact.go has to
grow to cover fetch's CTRL and count. Self-modified records are
excluded (their patch target is a 2-word record).

**Decoder cost: none.** A half record is one bus transfer instead of
two, so half mode is *faster* per record: 2 cycles against 3.

**Entry cost.** 8 B to set the sticky operand (a plain record writing
ch0's `AL1_READ_ADDR`/`AL1_WRITE_ADDR`), 8 B to switch fetch's mode
(see §5.2 for the mechanism), 8 B to switch back. A run of L records
costs `24 + 4L` against `8L`: **break-even at L = 6**.

**Result** (optimal DP segmentation per entry-point-free span):

| image | base | best | delta |
| --- | --- | --- | --- |
| fs-kern-xip | 239512 | 239048 | **-0.19%** |
| fs-xip-pgo | 228592 | 228104 | **-0.21%** |
| sh(K2) | 45216 | 45184 | **-0.07%** |
| vi | 162888 | 162576 | **-0.19%** |
| game | 265960 | 265360 | **-0.23%** |

The elegant candidate is worth a fifth of one percent. §3.4 said so in
advance: about 1% of records live in runs long enough to pay for the
mode, and the DP finds exactly that 1%, halved.

### Candidate B — universal pointer indirection

**Layout.** 4 B, one field: the 32-bit absolute address of an 8-byte
dictionary entry. Entries are the ordinary `(READ_ADDR, WRITE_ADDR)`
pairs, 8-byte aligned, and may live in flash text (they are read-only
to the machine) or in `.ramtext` when a record is self-modified.

**Mechanism** (built and run — host/dmaasm/zz_reccycles_test.go):

- fetch: `TRANS_COUNT` 1, 4-byte write ring, `WRITE_ADDR` = the
  **expander** channel's `AL3_READ_ADDR_TRIG`;
- expander: `TRANS_COUNT` 2, incrementing read, 8-byte write ring,
  `WRITE_ADDR` = the plain bank's window. Triggered by fetch with the
  entry address as its `READ_ADDR`, it copies the entry's two words
  into the window, whose second write fires the bank;
- bank: unchanged, chains back to fetch.

HALT still works unchanged: an all-zero entry writes 0 to
`WRITE_ADDR_TRIG`, the null trigger the encoding already uses.

**Residence.** One global dictionary. §3.2 forbids per-page or
per-function tables.

**Boundaries.** None — there is no mode. Every record is a pointer.

**Decoder cost: 1 extra channel, 1 extra bus transfer.**
**Measured: 4.000 cycles/record against 3.000 — +33.3%**, everywhere,
on every record, hot and cold alike.

**Result** (`4n + 8d` exactly; nothing is approximated):

| image | base | v2 | delta |
| --- | --- | --- | --- |
| fs-kern-xip | 239512 | 238524 | **-0.41%** |
| fs-xip-pgo | 228592 | 223640 | **-2.17%** |
| sh(K2) | 45216 | 43624 | **-3.52%** |
| vi | 162888 | 159492 | **-2.08%** |
| game | 265960 | 237556 | **-10.68%** |

The singleton wall in one line: with `d/n ≈ 0.48`, `4n + 8d ≈ 8n`. The
kernel pays a third more cycles for four hundredths of one percent.

### Candidate C — the hybrid (pointer mode where it pays)

Candidate B plus a mode, so singletons stay inline at 8 B. This is the
best encoding that exists for this machine, and it is the one the
recommendation is about.

**Layout.** Inline records are today's 8 B pair, bit for bit. Pointer
records are candidate B's 4 B entry address. The two are told apart by
the machine's *mode*, never by a tag bit — there are no spare bits: an
entry address is 8-byte aligned, but its low three bits are consumed by
the expander using it directly as `READ_ADDR`.

**Mode switch.** Entering pointer mode must change fetch's `CTRL`
(ring size), `WRITE_ADDR` (window → expander trigger) and
`TRANS_COUNT`, and must not stall the machine between them — fetch is
re-triggered by the bank's chain after every record, so any
intermediate state must still fetch correctly. Two helper channels do
it atomically:

- **Ha**: `TRANS_COUNT` 3, incrementing read, 16-byte write ring,
  `WRITE_ADDR` = fetch `AL3_CTRL` (`+0x30`). Its three-word template
  `{ctrl, window, count}` lands on `AL3_CTRL`/`AL3_WRITE_ADDR`/
  `AL3_TRANS_COUNT` — contiguous, and none of them a trigger, so the
  machine does not restart mid-change. One template per mode, shared by
  the whole image (24 B total).
- **Hb**: `TRANS_COUNT` 1, static, `READ_ADDR` = fetch's own
  `READ_ADDR` register, `WRITE_ADDR` = fetch's `AL3_READ_ADDR_TRIG`.
  Ha chains to it; it copies the PC back onto itself, which re-triggers
  fetch in the new mode. This is what keeps the template PC-free.

The switch instruction is then one record naming the template:
`move $template, Ha.AL3_READ_ADDR_TRIG` — **8 B from inline mode, 4 B
from pointer mode** (where it is itself a pooled pointer record).

**Boundaries.** The canonical-state rule grows from "plain bank, counts
1" to "plain bank, counts 1, **inline mode**" at every point control
can enter from outside the fall-through: every label, every jump, every
safepoint, every process switch, every guest entry into a host kernel's
vector page. The mode lives in fetch's registers, which every image on
the machine shares — the same argument host/dmaasm/compact.go already
makes for the window. Additionally: auto-return banks need a second
cleanup channel (cleanup restores the *plain window*, not the expander
trigger), and bank-switch records need a second form (in pointer mode
the window belongs to the expander, not to fetch), which the assembler
knows statically and which costs seven extra dictionary entries.

**Decoder cost.** 3 extra channels (expander, Ha, Hb). Pointer records
cost 4 cycles against 3; a mode switch costs 6 (fetch 2, Ha 3, Hb 1).

**Result.** Optimal two-mode DP over the record stream, pooling pairs
seen ≥ 2 times, charging 8 B per entry actually referenced, 8 B/4 B per
mode switch, and requiring inline mode at every entry point:

| image | base | v2 | delta | pointer records | entries | switches |
| --- | --- | --- | --- | --- | --- | --- |
| fs-kern-xip | 239512 | 226592 | **-5.39%** | 28.5% | 807 | 1985 |
| fs-xip-pgo | 228592 | 214148 | **-6.32%** | 31.4% | 814 | 1993 |
| sh(K2) | 45216 | 43676 | **-3.41%** | 25.0% | 187 | 375 |
| vi | 162888 | 156612 | **-3.85%** | 27.2% | 564 | 1659 |
| game | 265960 | 235252 | **-11.55%** | 47.3% | 1362 | 2559 |

Thresholds of 3 and 4 are within 0.5 points everywhere; the frontier is
flat.

**Sensitivity.** Because the probe over-approximates entry points (any
text symbol, any pool literal pointing into text), the DP was re-run
with the canonical-mode rule dropped entirely. This is *unsound* — it
would let a jump carry pointer mode into an inline target — but it
bounds what the approximation can be hiding: -6.94% (fs-kern-xip),
-8.17% (fs-xip-pgo), -6.21% (sh), -7.55% (vi), -14.23% (game). And it
raises the pointer-record share to 52–67%, i.e. it buys the extra
1.5–2.8 points of text with another 8 points of cycles. **The exchange
rate does not improve anywhere on the frontier.**

**The unattainable bound.** If mode switching were free and entry
points did not exist — `Σ min(8c, 4c+8)` over the pair histogram — the
ceiling is -21.45% (fs-kern-xip), -22.56% (fs-xip-pgo), -22.05% (sh),
-22.15% (vi), -26.85% (game). That number is what §7 was imagining. The
gap between it and candidate C's -3.4…-11.6% is entirely the price of
telling pooled records from inline ones on a machine whose mode is a
DMA register.

### What is architecturally impossible

Two encodings that look obvious on paper cannot exist here, and it is
worth writing down why so nobody re-derives them.

**Narrow operands.** Every operand of every image lives in at most
seven 64 KiB pages: the probe counts **4–7 distinct upper halfwords**
and 3–4 distinct upper bytes across every image's 11–66 thousand
operands. A
16-bit operand field would therefore *fit*. It cannot be built: a
record must end with a write to a **trigger** register, and the trigger
is the fourth word of every alias row. The only contiguous
(operand, trigger) pair in the whole channel map is `0x28`/`0x2C` —
`READ_ADDR` then `WRITE_ADDR_TRIG`, four bytes apart, which is exactly
today's 8-byte record. No pair of *halfword* fields two bytes apart
exists in any alias, so a 16-bit-operand record has nowhere to land.
(Byte-wide writes to channel registers do work — the encoding used a
byte-lane window switch before cleanup's auto-return retired it — so
the obstacle is the register map, not the bus.)

**Index-plus-operand in 4 bytes.** A 12-bit index and a 20-bit operand
would need the operand widened to a 32-bit address before it reaches a
channel register, i.e. an add. There is no adder outside the sniffer,
and a sniffer add is 5–7 records. Any packed-field encoding costs more
records to unpack than it saves bytes, by an order of magnitude.

**Two triggers per fetch.** Making fetch's 4-byte write ring point both
of its words at one trigger register would give two 4-byte records per
8-byte fetch with no mode at all. It races: the first trigger starts
the bank while fetch still has a transfer outstanding, the bank's chain
re-triggers a busy fetch (a trigger on a busy channel is lost), and
fetch's second word can overwrite the bank's `READ_ADDR` before the
bank reads it. Not buildable.

## 5. The feasibility crux

### 5.1 A CPU decode stage is not available, and would be 5× slower

The ARM cannot participate. `park_forever()` runs with `cpsid i` from
SRAM and owns flash erase/program, SD sectors and the XIP restore; on
the feather, core 1 is a `.time_critical` pixel feeder that must never
stall (prompts/036 measured that a one-microsecond stall loses HDMI
sync). Interposing the ARM between records would also put it back in
the path of every flash sync it exists to service.

The arithmetic, if one tried: a record is 3 cycles ≈ 20 ns at 150 MHz.
An ARM decode step — read a 4-byte record, index a table, store two
words to the channel window, poll for completion — is 15–20
instructions with two loads and two stores, ~100 ns even from SRAM with
no XIP stalls. That is a **5× slowdown**, before considering that the
polling loop cannot be interrupted. There is no version of a
CPU-driven expansion that is not catastrophic.

### 5.2 A DMA decode stage is available, costs +33%, and was measured

The whole point of candidates B and C is that expansion needs no CPU:
the expander channel *is* the decode stage, and it costs exactly one
extra bus transfer. This is measured, not modelled —
`host/dmaasm/zz_reccycles_test.go` builds fetch/expander/bank out of
real channels, runs 1000 records through the chain, checks the result
and reports:

```
RECCYC classic-compact  3.000 cycles/record
RECCYC pointer-indirect 4.000 cycles/record
```

### 5.3 The channel budget kills it on the boards that want it most

| channel | use |
| --- | --- |
| 0–6 | transfer-mode banks |
| 7 | fetch |
| 8 | cleanup |
| 9 | interrupt injector (ABI convention); **audio streamer on gamepico** |
| 11 | gamepico's bulk memcpy/SPI helper |
| 14, 15 | feather scanout ring (`SCAN_CH_MASK`) |

Candidate C needs three more: expander, Ha, Hb (and a second cleanup
for auto-return banks in pointer mode, making four).

- **RP2040 has 12 channels.** gamepico (RP2040) has channel 10 free and
  nothing else. The image with the largest measured win — -11.55%, more
  than twice any other — **cannot host the machine that produces it.**
- **RP2350 has 16.** pico2/feather leave 10, 12, 13 free: candidate C
  fits with exactly zero headroom, and takes the last channels any
  future board driver could claim.

### 5.4 Interrupts and safepoints

The safepoint rule (abi.md) stores a resume address into `irqresume`
and jumps through `dispatch`; the injector patches `dispatch` to the
ISR entry, and the ISR restores it as its EOI. Every one of those is a
control transfer, so under candidate C every one is a canonical-mode
boundary — which the DP already charges for, and which is why 13–19% of
records (the `%pc` writers) are permanently ineligible for pointer
mode.

The harder point is *sharing*. The mode is fetch's `CTRL`,
`TRANS_COUNT` and `WRITE_ADDR`: one register set, shared by the kernel,
by every guest that jumps into its vector page by absolute address, by
the scheduler's process swap, and by loaders that arm fetch alone. An
image compiled to v2 and an image compiled to v1 cannot coexist on one
machine unless v1 images are re-linked to leave fetch in inline mode —
which they already do, but only because inline mode is v1's only mode.
The ABI would need a v1 bump (abi.md is frozen at v0/v0.1) and all four
implementations updated together.

### 5.5 Cost to the emulator, to dmaasm, and to dmacc

- **Emulator: zero.** The v2 machine is built from channels emu already
  models exactly — the probe in §5.2 is the proof. This is the one
  genuinely cheap part.
- **dmacc: near zero.** It emits `.dasm`; the encoding is below it.
  Interaction is limited to the record-level outliner (§4), whose
  outlined runs would want to be mode-homogeneous.
- **dmaasm: substantial.** A pair-interning table alongside the literal
  pool (with its own relocations and its own hot/cold split, since
  entries are read once per execution and belong in the same
  flash-vs-SRAM decision `PoolText` makes); the two-mode DP as a third
  pass, with pass-1/pass-2 cross-checking like the current planner;
  `planPayloadDelta` and every `.read`/`.write` block-field user
  rewired, because a pointer record's two words are in the dictionary
  and not at `label+0`/`label+4`; and the sign-dispatch trampoline
  arena, whose 8-byte compact slot stride is baked into the `jsign`/
  `jbool` bit arithmetic (abi.md: 16·v classic, 8·v compact) and would
  become 4·v for pointer-mode slots, changing which bit the BSWAP trick
  isolates.

## 6. Cycle cost, executed-weighted

Static pointer-record shares are 25–47%; each costs 4 cycles instead of
3. The executed share is what matters, and one bound is already
measured: zz_banktax_test.go found **23.0% of executed records are bank
switches**, and there are only seven distinct switch pairs per image,
so every one of them is pooled and every one of them becomes a pointer
record. That alone is **+7.7% of cycles**, before any other pooled
record.

Taking the static mix as the estimate for the executed mix:

| image | text | pointer records | est. cycles | cycles per 1% of text |
| --- | --- | --- | --- | --- |
| fs-kern-xip | -5.39% | 28.5% | +9.5% | 1.76 |
| fs-xip-pgo | -6.32% | 31.4% | +10.5% | 1.66 |
| sh(K2) | -3.41% | 25.0% | +8.3% | 2.44 |
| vi | -3.85% | 27.2% | +9.1% | 2.36 |
| game | -11.55% | 47.3% | +15.8% | 1.37 |

Plus the mode switches themselves (6 cycles against 3, at 375–2559
static sites). Under the unsound bound of §4 the shares rise to 52–67%
and the estimate to +17–22%, for 1.5–2.8 more points of text: the rate
gets *worse*, not better, as the scheme gets more aggressive.

For scale, from prompts/042: §6 declined to delete a provably dead
8-byte-per-push frame trailer because removing it measured +1.25% cold
on `echo hi`. §10 (c) is shipping because it buys -0.5% of the game's
Benchmark scene. A +9% kernel is not in the same universe.

## 7. What the differential-test plan would be, if it were built

For the record, since a future revisit should not have to re-derive it:

1. `dmaasm.Options.EncodingV2`, defaulting off. Every existing dmaasm
   test parameterized over {classic, compact, v2}, as `forEachVariant`
   already does over SKUs.
2. **Trace equivalence is the oracle.** The machine's entire observable
   behaviour is the sequence of transfers its *banks* perform. Run each
   golden program under compact and under v2 and require the two
   `(src, dst, size, datum)` streams to be identical — fetch and
   expander traffic excluded, since that is precisely what differs.
   `emu.Machine.TraceW` already logs exactly
   `cycle, channel, read, write, datum` per transfer, so this is a
   filter and a comparison, not new instrumentation.
3. The full emulator suite under both encodings: xsh boot to prompt,
   TestZZBenchXsh's five commands, TestZZBenchVi's editing session,
   every game scene test including TestGameSeq's captured SPI stream.
   Compare final state and console output, never cycles.
4. **The mode-switch chain is unvalidated silicon.** Two facts need a
   HIL run on both SKUs before anything ships: that a channel may
   re-trigger fetch by copying fetch's own `READ_ADDR` into its
   `AL3_READ_ADDR_TRIG` while fetch is idle (Hb), and that a
   `RING_SIZE` change written through a non-trigger alias takes effect
   on the next trigger and not on the one in flight. prompts/004's
   calibration programs are the template.
5. Ratchets: TestZZAllSizes and the cycle benches pinned in CI before
   the first v2 commit, since the whole question is a size/cycle trade
   and an unpinned regression would hide it.

## 8. Recommendation

**Do not build compact encoding v2.** Specifically:

- **Candidate A is closed.** -0.06% to -0.23%. The mechanism is
  beautiful — a dictionary that is a DMA register, a decoder that costs
  negative cycles — and the record stream simply does not contain the
  runs it needs (1% of records in runs ≥ 7).
- **Candidate B is closed.** -0.41% to -10.68% for a flat +33% of
  cycles on every record in the image. Only the game is even arguably
  in range, and the game is the one that cannot spare the channels.
- **Candidate C is the real proposal, and it is a no.** -3.4% to -11.6%
  of record bytes for an estimated +8% to +16% of cycles; three DMA
  channels that RP2040 boards do not have; an ABI v1 bump because the
  mode is machine-shared state; and a rewrite of dmaasm's planner,
  pool, block-field addressing and trampoline arena at once. The
  measured exchange rate — 1.4 to 2.4 percent of cycles per percent of
  text — is 30× worse than anything prompts/042 has been willing to pay
  in nine previous sections.
- **The §7 sketch's specific shape is refuted, not just outvoted.**
  Per-page and per-function dictionaries are strictly worse than a
  global one: 19% more entries per function, 39–65% more per page.

**The strongest counterargument, stated fairly.** The game gets
-11.55%, which is 30.7 KiB, and the game is not cycle-bound
everywhere — dmxgen's buildGame notes that the radiosity shooter is
"the one workload that wants the machine's full speed", and
pgo.GameColdBlocks already identifies blocks that never execute in the
profiled workload. A cold-only candidate C —
pointer mode for cold blocks alone, inline everywhere else — pays its
+33% on records that execute approximately never, so the cycle
objection evaporates and the size win survives in proportion to the
cold share. That is a real argument, and it is why the recommendation
is "don't build" rather than "impossible".

It still fails, for three reasons that are independent of cycles.
Gamepico is RP2040 with one free channel, so the image with the win
cannot run the machine. The game's text is XIP flash on a 4 MiB part —
flash is the one resource the game is not short of, and the SRAM side
(`.ramtext`, 35920 B of records, much of it the self-modified records
candidate C must leave inline) would give back a few KiB at best. And
the
entire dmaasm surface listed in §5.5 has to be built and differentially
validated whether the mode is used on 100% of the image or on 30% of
it. A 5% saving on the resource that is not scarce does not buy a third
encoding.

**If a step change in text size is wanted, it is not here.** The
measured ceiling for *any* record-pooling scheme is -22% to -27%, and
this document is the accounting for why two thirds of that is
unreachable. §8 (make the trace a product) remains the open item with
leverage.

## 9. Reproducing

```
SHAPES=1 go test ./host/dmacc/  -run TestZZShapes       -v
RECCYC=1 go test ./host/dmaasm/ -run TestZZRecordCycles -v
```

Both are analysis probes in the repository's `zz_` convention. Neither
changes production behaviour; the second one builds a working v2
machine out of DMA channels and prices it, which is the piece of this
phase worth keeping.
