# Phase 17b results: the downsizing campaign, items 4–6

Continuing prompts/030 (item 3, XIP text). Items 4–6 are compiler
transformations; each was committed separately, kept the full suite
green, and was spot-checked on silicon.

## 4/6 — copy-chain folding (text peephole)

`move A, T; move T, B` with T referenced exactly decl+def+use folds to
`move A, B` — the tail of nearly every load-then-pass-as-argument
sequence. sh text −3.0%.

## 5/6 — descriptor comparison sites

An outlined compare was five records (two target moves, two operand
moves, jump). Now two: park a descriptor address, jump to a `_d`
helper that copies the constant `[&b][t][f][&a]` block onto the
contiguous `cw_pb..cw_pa` cells with one `count=N` byte move,
dereferences the operands, and falls into the plain helper. 689 sites
in the fs kernel, 203 in sh; text −9% at both. `.word` became legal in
`.text`, so XIP builds keep the descriptors in flash instead of SRAM.

Silicon found the sharp edge: `kflash_sync` runs from SRAM while the
QMI session tears down XIP — its descriptors would be unreachable, so
RAMTextFuncs sites keep the old all-SRAM four-move protocol. The
emulator now bus-faults any XIP read while direct mode is enabled,
catching this class off-silicon.

## 6/6 — frame-slot coloring

A value defined and consumed inside one basic block shares a
per-function slot pool, recycled at block boundaries (never within a
block, so no lowering order can alias a live operand). Escapes — a
use in another block, a phi-edge read, a use by a forwarding op —
keep dedicated words. Data −22% on the lean kernel; sh's parse frames
shrank enough that 16-deep parentheses now run to completion inside
the 4 KiB frame stack instead of degrading.

## The campaign, measured (rp2350 compact unless noted)

    image        before (pre-1/6)      after 6/6           SRAM (XIP)
    lean kernel  85,872 / 10,048       73,024 /  9,756     (classic)
    fs kernel    157,456 / 40,140      139,264 / 40,536    61 KiB
    sh           91,720 / 15,644       47,456 / 14,192     18 KiB
    ls            9,648 /  2,824        9,008 /  2,824

(sh's big step was 2/6 frame-stack recursion: 91,720 → 52,304.)
On the Pico 2, the xsh exec arena grew from 75 KiB to 255 KiB — the
kernel and sh fetch text from flash, and their SRAM footprint together
is now 79 KiB where it was ~250 KiB.

Alongside, the emulator's scheduler got event-driven channel selection
(cycle-for-cycle identical, 2× faster wall clock — the dmacc suite
dropped from ~296 s to ~150 s).
