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
  means recognizing the loops, not the calls. Done in the C instead:
  both trees now step a word at a time when dst and src are mutually
  word-aligned (8-14% off echo/pipe workloads).

Still open: constant length with RUNTIME addresses (needs the IR
`align` attribute, which host/llir drops, plus a self-patching record —
RAM-resident under XIPText); variable lengths.

## 3. Byte-lane constant shifts — DONE

Implemented in host/dmacc/func.go (laneShr / laneShl / shlConst /
laneShrConst / emitShrConst); the sniffer routines stayed as the
variable-count fallback. Every constant shl/lshr/ashr is now inline.

Where the sketch below guessed differently: the composition for
n = 8k+r does NOT need the reversed domain. Shifting right by 8k
first leaves at least eight leading zeros, so the remaining r bits
come out of a left shift by 8-r plus one more lane; below one byte the
word splits at the byte boundary and the two halves merge with an OR.
`mulc`'s counted accumulate carries those sub-byte shifts in three
blocks up to six bits. ashr needs no jsign-picked lane fill either:
the fold (y ^ s) - s with s = 1 << (31-n) is two blocks on top of the
logical shift. __rt_mul got byte-wide leading-zero skipping (not a
tail early-out — the accumulator still owes one doubling per remaining
bit, so only LEADING zeros are free).

Measured (feather images, emulator cycles / flash bytes): cc_bits
188837/11028 -> 56779/5612, cc_collatz 398663/3956 -> 335681/2720,
cc_arith 431879/10680 -> 327199/10148, cc_stdio 3637588/41532 ->
3372664/36644, fs-kern-xip text 214240 -> 205288, xsh warm commands
-2% overall.

The original sketch, for the record:

> __rt_lshr's OUT_REV sniffer trick (rev, n doublings, rev back;
> ~21+4n) made the GENERAL routine fast. Byte-lane lowering removes the
> call entirely for the static cases: little-endian byte addressability
> means `x >> 8` is the three bytes at &x+1 — zero the result word plus
> one 3-byte burst, 2 records inline vs ~53+call today (n=16 currently
> falls into the ~7*(32-n) rebuild loop, ~112). `(x >> k) & 0xFF` is
> ONE record with the mask fused; shl by 8k mirrors. Constant counts
> n = 8k+r compose in the reversed domain (rev, byte-lane 8k, r
> doublings, rev) for a fixed ~20 records at any constant n. ashr needs
> a jsign-picked 0x00/0xFF lane fill. Dispatch belongs next to
> emitMulConst's constant path; the sniffer routine stays as the
> variable-count fallback.

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

## 9. Division by a constant divisor — DONE

clang -Oz leaves division by a constant as an IR `udiv`/`sdiv`/`urem`/
`srem` on this target (no backend runs after it), so every one of them
used to become the general `__rt_udivmod` — 31 restoring-division
rounds, ~6,900 emulator cycles compact. Implemented in
host/dmacc/func.go (emitDivConst, divConstant, divConstInline,
signBias) and host/dmacc/runtime.go (`__rt_udivmod10`):

- **Powers of two, no call at all.** `udiv x, 2^n` is the byte-lane
  logical shift §3 already had; `urem x, 2^n` is one `andn`. The signed
  pair needs C's truncation toward zero, which a shift does not do:
  `sdiv x, 2^n` is `(x + bias) >>a n` with `bias = (x < 0 ? 2^n-1 : 0)`,
  computed branchlessly as `(x >>a 31) >>u (32-n)`; `srem x, 2^n` is
  `((x + bias) & (2^n-1)) - bias`, which beats subtracting the shifted
  quotient. A negative constant divides by the magnitude and negates
  the quotient (the remainder takes the dividend's sign either way), so
  `x / INT_MIN` falls out as the n = 31 case.
- **Divisor 10 (and 100, two chained calls), outlined.**
  `__rt_udivmod10` multiplies by 204/256 and finishes the reciprocal
  with the two byte-granular steps x257/256 and x65537/65536, then one
  sub-byte `>>3`: 3435973836/2^35, which is 2.3e-11 short of 1/10, so
  the quotient never overshoots and a single compare fixes the
  remainder (a sweep of all 2^32 dividends bounds it by 13). 204*x
  would overflow, so the low byte multiplies separately —
  `204x >> 8 == 204*(x>>8) + (204*(x&255) >> 8)`, exactly. Measured
  412 cycles compact / 860 classic against __rt_udivmod's 6,871 /
  8,315, for ~1.4 KB of shared .ramtext (the kernel windows moved
  +512 B / +256 B to fit it).
- **The dynamic divisor was the real hot one.** Both printf digit
  loops (xv6 printint, picolibc __ultoa_invert) take the base as a
  PARAMETER, so no constant-divisor lowering can ever see them.
  `__rt_udivmod` therefore tests for 10 itself — 16 records ahead of a
  ~6,900-cycle loop — and tail-jumps into the reciprocal, which fills
  the same rt_dquo/rt_drem cells.

Not done, and not worth doing: the general constant divisor. The cure
is a magic-number multiply, whose `(x * M) >> 32` needs a 64-bit high
product; the sniffer accumulates 32 bits and drops the carry. Summing
16x16 partial products does reach it, but at three multiplies plus the
adds it is no cheaper than the reciprocal call it would replace. New
divisors go in `divConstChain` (powers of ten compose: one call per
digit) or as a new case in emitDivConst.

Measured (feather images, emulator cycles / flash bytes):
cc_stdio 3372616/36504 -> 2998486/37708, ccc_stdio 3179894/22812 ->
2887076/24104, cc_collatz and cal_flash unchanged. cc_arith
327199/10148 -> 328759/11616 is the honest cost side: it divides only
by runtime values, so it pays the 16-record base test on all 40 of its
divisions (~1,600 cycles) and links the reciprocal beside the long
division it still uses.

xsh warm cycles: ls 3539995 -> 3239986 (-8.5%), free 2834984 ->
2115028 (-25%), cat README | wc 2444994 -> 2400225, cat README
1499970 -> 1454991, echo hi 989983 -> 975004. Sizes: fs-kern-xip text
205176 -> 205136 with ramtext 41968 -> 43488, sh-xip 62888/7696 ->
63640/6208 (sh's `srem` by 8 went inline and its `/10` moved to the
reciprocal, so it stopped linking __rt_srem, __rt_udiv and the long
division altogether), lean 115552 -> 116576,
ls 9392 -> 9368.

## If only two

§1 (it compounds: every future heuristic becomes automatic) and §2+§3
together (about a week, aimed at exactly the record-count hot spots
the traces keep showing: bulk moves and shift-heavy inner loops). §3
and §9 are done; §2 is still open.
