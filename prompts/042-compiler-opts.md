# 042 — Compiler optimization roadmap (parked)

Ideas surveyed on top of the mature dmacc/dmaasm pipeline (2026-08-28),
to revisit after the trivial steps in flight. Goal axes: text/data
size and executed-record count, in that combined order. Ranked by
leverage per effort; every item rides the existing differential-test
and emulator harness.

## 1. Close the PGO loop (highest leverage)

Every best optimization so far was profile-DISCOVERED but hand-APPLIED
(XSHHotLits, ResidentFuncs, SizeApps, InlineCompares). Build the
driver that turns emulator traces of representative workloads into
committed settings:

- per-FUNCTION OptSize (descriptor compares in cold code, four-move
  in hot) instead of the per-app boolean — the 9% size vs 2x speed
  trade becomes near-free;
- per-site compare inlining (InlineCompares is all-or-nothing today);
- hot/cold literal pools for every image (only the xsh kernel has a
  generated hot set);
- ResidentFuncs selection from measured flash-read parking, not
  intuition;
- hot-edge fallthrough + cold-block out-of-line layout (a taken jump
  into unprefetched XIP parks the shared read master, so layout
  counts double here).

All the mechanisms exist; only the trace→settings harness is missing.

## 2. Alignment-aware memcpy/memset — DONE for the static cases

__rt_memcpy bursts size8 — one transfer per byte, always — and still
does, because its length and addresses are runtime values. What
changed: calls whose length is a compile-time constant no longer go
there at all. dmaasm grew the `wcount=N` move flag (N whole words at
the encoding's widest incrementing step), and dmacc emits an inline
record for every memcpy/memset with a constant length and link-time
addresses, plus emitFramePush/Pop's whole-frame saves (@FRW_, a
static word count on a patched record). Word alignment comes from the
symbol+offset, not from the IR attribute: every dmacc data label is
word-aligned, so only a folded byte offset can misalign one; unaligned
or partial lengths take a size8 tail record.

Two findings for whoever picks up the rest:

- the COMPACT encoding cannot do this at all. Its bank map has one
  incrementing channel and it is size8 (emu/compact.go); a 32-bit
  incrementing bank would be a tenth machine channel, i.e. an ABI and
  loader change. Compact keeps byte transfers and wins only the call
  overhead. Since every deployed image is compact, the cycle win lands
  in the classic-encoding builds (and in the descriptor-compare
  millicode, 3-5% on the cc_* goldens).
- FS block copies and pipe transfers do NOT hit the runtime: xv6
  defines memmove/memset itself, as C byte loops (kernel/string.c,
  usr/ulib.c), and a size8RW transfer counter over the xsh benchmark
  shows single-digit burst transfers per command. Speeding those up
  means recognizing the loops, not the calls.

Still open: constant length with RUNTIME addresses (needs the IR
`align` attribute, which host/llir drops, plus a self-patching record —
RAM-resident under XIPText); variable lengths.

## 3. Byte-lane constant shifts (complements the sniffer path)

__rt_lshr's OUT_REV sniffer trick (rev, n doublings, rev back;
~21+4n) made the GENERAL routine fast. Byte-lane lowering removes the
call entirely for the static cases: little-endian byte addressability
means `x >> 8` is the three bytes at &x+1 — zero the result word plus
one 3-byte burst, 2 records inline vs ~53+call today (n=16 currently
falls into the ~7*(32-n) rebuild loop, ~112). `(x >> k) & 0xFF` is
ONE record with the mask fused; shl by 8k mirrors. Constant counts
n = 8k+r compose in the reversed domain (rev, byte-lane 8k, r
doublings, rev) for a fixed ~20 records at any constant n. ashr needs
a jsign-picked 0x00/0xFF lane fill. Dispatch belongs next to
emitMulConst's constant path; the sniffer routine stays as the
variable-count fallback. (While there: fix runtime.go's stale header
comment — it still describes the pre-sniffer doubling-only lowering —
and give __rt_mul an early-out once the remaining multiplier bits are
zero instead of the fixed 31 iterations.)

## 4. Record-level outliner (biggest remaining size lever)

The compare millicode is hand-made outlining and it's the best size
decision in the compiler; generalize it. Post-lowering, run a suffix
automaton over the whole program's record stream and outline repeated
sequences with the same no-lr "the helper IS the branch"/jumpr-back
trick where control flow allows. Phi-copy bundles, GEP chains, and
call protocols repeat constantly at 8 B/record; comparable outliners
take 5-15% of text. Gate by the §1 profile so only cold code pays the
jump. Warm-up: trivial ICF (fold byte-identical function bodies).

## 5. Copy coalescing — this machine's register allocator

Every eliminated `move` is 8 bytes AND a cycle; with values in SRAM
words, copy elimination is the whole value of register allocation.
foldCopies, cast forwarding, and within-block slot coloring exist;
the missing piece is an interference-based coalescer over whole
functions (phi-edge copies are the target-rich zone). MEASURE FIRST:
count surviving reg-reg-shaped moves in the xsh kernel; build it only
if they exceed a few percent of records.

## 6. PGO-shaped recursion clones

sh pays ~26 KB for depth-12 clones, but depth >= 3 is cold by nature.
Both mechanisms already exist: keep clones for depths 0-2 (hot,
fast), collapse the deep tail into the frame-stack push/pop mode.
Most of the 26 KB back for near-zero observed cycles.

## 7. Deep rebuild candidate — compact encoding v2 (and a non-goal)

If another step-change in text size is wanted: per-page or
per-function template dictionaries so common record shapes pay 4 B,
not 8. Touches dmaasm + emulator + the silicon executor at once; only
behind the differential harness, and only after §1/§4 take the cheap
wins. NON-goal: a smarter mid-end — stock clang -Oz plus a curated
opt pipeline (suppress switch-to-lookup-table where our jump tables
are cheaper; tune the inliner threshold) captures nearly all IR-level
value without owning any of it.

## 8. Make the trace a product

Every past win started as "watching the trace". Build the query
engine once: cycle AND flash-stall attribution from emulator traces
through dmaasm symbols back to C lines, plus size/cycle ratchets in
CI (the bench tests exist — pin them). The recurring zz_ throwaway
probes are this tool asking to be born.

## If only two

§1 (it compounds: every future heuristic becomes automatic) and §2+§3
together (about a week, aimed at exactly the record-count hot spots
the traces keep showing: bulk moves and shift-heavy inner loops).
