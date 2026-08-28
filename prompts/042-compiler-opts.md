# 042 — Compiler optimization roadmap

Ideas surveyed on top of the mature dmacc/dmaasm pipeline (2026-08-28),
to revisit after the trivial steps in flight. Goal axes: text/data
size and executed-record count, in that combined order. Ranked by
leverage per effort; every item rides the existing differential-test
and emulator harness.

Status 2026-08-29: §2 (static cases), §3 and §9 are DONE; §10 is
partly done (eqzp/ltp shipped, its (b) planner idea measured and
CLOSED); §5 is measured and CLOSED as not worth building; the rest
are open. The 2026-08-29 wave also measured where executed records
actually go (comparison lowering ~65%, see §10), which reranks
everything still open.

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

## 5. Copy coalescing — MEASURED, CLOSED (don't build)

The premise was "every eliminated move is 8 bytes AND a cycle";
measurement (2026-08-29) says the class an intra-function coalescer
can actually touch — same-function slot-to-slot copies, excluding the
fixed ABI cells and constant loads — is 2.5-2.6% of static records
and 1.3-1.4% of EXECUTED records in both the xsh kernel and the game.
Even a 100%-yield coalescer caps below 3% of cycles; a realistic one
lands under 1%. The structural reason: `move` is this machine's
cheapest instruction (1 record, against 5-7 for arithmetic and 24-25
for the compare macros in compact), so moves are 58% of instructions
but only ~9% of records. foldCopies already harvests the free cases.
Not worth whole-function liveness + interference + a parallel-copy
sequencer; measured with the record-labelling probes described in §8.

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

Two hard-won methodology notes from the 2026-08-29 measurement round,
for whoever builds it: dmaasm drops every `__`-prefixed symbol from
Result.Symbols, so address-range attribution silently credits the
runtime and compare millicode to whatever compiled function precedes
them — derive ownership from the .dasm label stream instead. And the
xsh cycle bench quantizes on the 15,000-cycle scheduler tick (blocked
shells absorb whole idle ticks), so single commands are only good to
~10 ticks; compare 5-command aggregates, or the deterministic cc_*
image cycles.

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

## 10. Comparison lowering — the measured 65%, partly DONE

Fetch-attributed profiling (2026-08-29) put comparison lowering at
~65% of ALL executed records — xsh commands and the game alike — with
`x == 0` alone 52-58% of invocations at ~21 records each (2-record
descriptor site + 19-record __cw_eqz). Nothing else in the program is
within an order of magnitude. Two findings frame the design space:
whole-image InlineCompares is a dead end (+69% text, overflows the
board RAM windows — measured, not estimated), and the compact
encoding's bank state is 23.0% of all executed records — which looked
like a dmaasm planner project until it was measured (see (b) below).

Shipped (host/dmacc/facts.go + compare.go): a per-function BOOL/NONNEG
fact lattice, fixed-point from the pessimistic bottom, routes sites to
two shorter helpers — __cw_eqzp (a == 0 with bit 31 provably clear:
one add of -1 replaces eqz's sub/or pair) and __cw_ltp (both operands
nonneg: the sign of a-b IS the answer, one sub against the four-term
borrow). eqzp covers 43% of the kernel's zero-tests and 75% of the
game's. Measured: cc_collatz -7.9%, cal_flash -3.9%, cc_control -2.8%.

Still on the table, in measured-value order: (a) a range analysis (or
interval narrowing from the dominating branch) — __cw_ltp fires on
only 0.5% of lt/ltu sites because loop bounds arrive as parameters or
i32 loads with no fact; (c) per-site descriptor-vs-four-move selection
from the §1 profile.

### (b) The compact bank-state planner — MEASURED, CLOSED (don't build)

The tax is real and was priced twice (2026-08-29). Statically it is
16.5% of the xsh kernel's 33,574 records and 18.7% of the game's
34,861; at runtime, classifying every fetched record of a booted
feather xsh over five commands by its write address
(`host/dmacc/zz_banktax_test.go`) gives 1,501,534 switch records and
1,300 count reloads against 5,021,334 payload records — **23.0% of
executed records**, and 99.9% of that is window switches.

None of it is canonicalization slack. A record has no CTRL word, so
the transfer mode IS the fetch window, and changing mode costs exactly
one record; `cstate.switchTo` already emits one per transition and
never more. `planSync`'s trailing switch is not a second transition —
it is the one the next macro would emit anyway, because every sniffer
macro ends on the sniff bank (its deferred read runs there) and every
macro, sniffer or not, starts with a plain-bank record. Carrying bank
state across runs that contain no label, no control transfer and no
segment break therefore *relocates* switches rather than removing
them: instrumenting the planner with exactly that scheme saved **66 of
33,574 records in the xsh kernel (0.20%)**, 98 of 34,861 in the game
(0.28%), and — weighting each site by its execution count — **0.58% of
executed records**, i.e. 2.5% of the 23% tax. Per macro the ledger is
visibly conservative: `add` sites gave up 1,074 records and the `move`
sites that follow them took back 1,243.

What that would have cost: cross-instruction state in both passes,
`planPayloadDelta`/`planPrefix` becoming incoming-state dependent, and
the per-instruction canonical invariant — the thing that makes the
planner auditable, and the thing the two-pass size cross-check
verifies — downgraded to a dataflow property. Worse, the invariant is
not local to one image: the current window is fetch's WRITE_ADDR
register, shared by every image on the machine. Guests jump into a
host kernel's vector page by absolute address, the scheduler swaps
processes at safepoints, and loaders arm fetch alone — all of them
assume plain-bank/counts-1 at every instruction boundary, not merely
at the labels one assembly can see.

The switches are only reclaimable by changing the record stream: run a
macro's plain records on the sniff bank where the accumulator is dead,
so back-to-back sniffer macros stay in one window. Every candidate
(seeding SNIFF_DATA, clearing it through the CLR alias) depends on the
silicon order of a transfer's write versus its sniff accumulation,
which is not a calibrated fact — the emulator writes then accumulates,
and nothing has checked the hardware. That is a macro rewrite in
emit.go behind a HIL run, not a planner change, and it belongs with
the §7 encoding-v2 rebuild if it is ever wanted.

## If only two

§1 (it compounds: every future heuristic becomes automatic) and the
rest of §10 (comparisons remain the dominant executed cost even after
eqzp). The range analysis, §10 (a), is now the biggest unclaimed cycle
lever on the books on its own: the compact planner beside it priced
out at 2.5% of its own tax and is closed.
