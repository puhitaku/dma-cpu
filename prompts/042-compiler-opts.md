# 042 — Compiler optimization roadmap

Ideas surveyed on top of the mature dmacc/dmaasm pipeline (2026-08-28),
to revisit after the trivial steps in flight. Goal axes: text/data
size and executed-record count, in that combined order. Ranked by
leverage per effort; every item rides the existing differential-test
and emulator harness.

Status 2026-08-29: §1 (the PGO loop), §2 (static cases), §3, §4, §6,
§9 and §10 (a) + (a1) + (a2) + (c) are DONE (eqzp/ltp shipped, then the
whole-program parameter/return bounds that feed them, then the
`nsw`/`nuw` wrap flags — which are sound, tested and worth one routed
site in the game and nothing anywhere else, and say so; then (c), which
moved the OptSize carve-out from whole functions down to individual
compare SITES: -1.1% on the xsh cold sum and -104 bytes of kernel text,
-0.5% on the game's Benchmark scene for +1.1 KiB; §10's (b) planner
idea is measured and CLOSED); §5 is measured and CLOSED as not worth
building; §7 remains open. §6 is the biggest single size win of the
wave — sh's text is down 32.8% — and it also lifted sh's recursion
bound from a clone count to a byte budget. The 2026-08-29 wave also
measured where executed records actually go (comparison lowering ~65%,
see §10), which reranks everything still open. §1's block layout
closed alongside (c): `Options.ColdBlocks`
sinks never-executed blocks to the end of their function, worth a
uniform ~0.3% of cycles (xsh, vi, fbcon) and a few hundred bytes, and
zero on the game — small, but it costs nothing when the map is empty
and it closes the last knob the profile driver already measured.

## 1. The PGO loop — DONE

Every optimization up to here was profile-DISCOVERED but hand-APPLIED.
The loop is closed now: `make pgo` runs the driver in
`host/dmacc/zz_pgogen_test.go` (TestGenPGO, gated on GEN_PGO), which
boots every deployable payload in the emulator, drives its
representative workload, and rewrites the committed settings in
`host/pgo`. Those files are build INPUTS, not goldens — regenerating
moves layout and cycle counts, so it is a measurement to report.

**What the driver measures.** `emu.Machine.ProfileWindows` counts bus
reads per word over several disjoint ranges at once, so one emulated
run prices everything:

- literal-pool reads, folded back onto pool keys through
  `dmaasm.Result.LitAddrs`. Images are profiled in their DEPLOYED
  shape: LitAddrs names a key's address whether it landed resident in
  SRAM data or cold in the flash text tail, so counting both regions
  covers the whole pool. (Profiling an UNSPLIT image was the obvious
  route and does not work — sh's all-resident data overruns its board
  window.)
- per-function text reads, one window over the image's XIP text minus
  the cold pool words sharing its tail. A text read IS an instruction
  fetch, so the same histogram is execution heat and the flash-parking
  signal that ranks ResidentFuncs.
- the same over the kernel's `.ramtext`, which prices what the current
  ResidentFuncs list is already buying.
- per-SITE comparison executions, off the same text window (added by
  §10 (c)). dmacc labels every outlined compare site `cws_<func>_<n>`,
  so the word histogram resolves to sites as well as functions.

Ownership comes from the `f_` function labels alone, which sidesteps
the §8 attribution trap: under XIPText the runtime and compare
millicode live in `.ramtext`, so the XIP text a histogram attributes
holds nothing but dmacc's own labels. The site scan reads the same
symbol table, which is why the site labels are neither `__`-prefixed
(dmaasm drops those) nor `f_`-prefixed.

**Workloads.** kernel/sh: a feather boot to the prompt plus
TestZZBenchXsh's command set run cold and warm; vi: TestZZBenchVi's
editing session, on the same machine; game: gamepico boot to the menu,
menu navigation, then Dino, LANWalk and Yacht to their first scoring
event. Changing a workload re-derives every setting together.

**What it produces.** `pgo.KernelLits` / `ShLits` / `ViLits` /
`GameLits` (hot literal pools for all four images, replacing the
kernel-only hand-run `XSHHotLits`), `pgo.KernelHotFuncs` /
`GameHotFuncs` — the per-FUNCTION carve-out of `dmacc.Options.OptSize`
(`Options.HotFuncs`: OptSize everywhere, four-move compares on the
functions covering the top 97% of executed text reads) — and, since
§10 (c), `pgo.KernelHotSites` / `GameHotSites`, which make the same
call per compare SITE and take that job off HotFuncs (which goes on
gating the outliner). Each literal set is
ranked by read count and trimmed until the resident half fits every
board that ships the image with 256 bytes of the window to spare; vi's
is trimmed harder still, to the slack inside kalloc's 256-byte
rounding, so its hot pool costs the arena nothing.

**Measured, feather + gamepico.** Flash reads over the profiling
workload: kernel 27.7M -> 14.0M (the old hand-run hot set covered only
91.4% of this workload's pool reads; the new one covers 99.9% with 704
keys against 1195, and `cursor_xor` joining ResidentFuncs took another
19%), sh 416K -> 336K, vi 16.9M -> 13.3M (-21.4%, and free: its 268
bytes fit the rounding slack), game 60.2M -> 36.8M. Deployed sizes:
kernel flash text 245584 -> 238184 with SRAM data unchanged at 32768;
game SRAM data 156476 -> 141020 (-15.1 KiB) for +9 KiB of flash text.
Per-function OptSize on the game's LANWalk scene: 60.77M cycles
balanced, 69.99M all-Os (+15.2%), 60.28M with the hot carve-out — the
size win without the speed loss. On the kernel the same policy takes
204296 bytes of text against 208512 balanced and 202496 all-Os, i.e.
73% of the descriptor saving, and the xsh bench did not regress.

### Block layout: cold blocks out of line — DONE, and worth ~0.3%

The third knob off the same measurement. `blockHeat` folds the text
histogram onto `B_<func>_<block>` labels instead of `f_` ones (both
kinds are in `Result.Symbols`, and the scan tracks the `f_` labels too
so a function's prologue is not credited to the last block of its
neighbour), and `host/pgo/blocks_gen.go` names, per image, the blocks
the workload fetched ZERO words of inside functions it did execute.
`dmacc.Options.ColdBlocks` sinks those to the end of their function:
entry block first, the rest in IR order, cold ones last — a stable
partition, no hot-path chaining. The blocks that run end up adjacent,
so `elideFallthroughJumps` drops the jumps that used to step over the
cold ones. Cold-set rather than hot-set: an unlisted block is left
where it is, which makes a stale table a lost optimization instead of
a wrong image. Sets: kernel 310 of 935 blocks in executed functions,
sh 181/347, vi 529/1007, game 76/708.

**LOWERED in IR order, PLACED in layout order.** Each block goes to
its own buffer and the buffers are concatenated at the end of
`funcCtx.emit`. This is not a style choice. Lowering carries state
between blocks: a fully-static GEP registers a link-time address
(`constAddr`) and a pure copy registers an alias (`fwd`), both
emitting NO code and both read at every later use site. Lowering out
of order silently rewrites the code inside a block — a use reached
before its own folded definition falls back to a value word nothing
ever writes. It did: sinking `B_dino_run_48`, whose three folded GEPs
the loop below it used, turned four constant stores into
self-modified indirect ones, and the game wrote 4 bytes to address
0xa. Placement moves finished text, which nothing downstream can
observe. It also makes the safepoint guarantee structural — backedges
are decided during the IR-order lowering pass (`funcCtx.backward`
compares IR block indices), so no cold set can move a safepoint;
`TestColdBlockSafepoint` sinks a loop header and demands one anyway,
and `TestColdBlockSameCode` demands that every non-jump instruction
survive an arbitrary cold set unchanged.

**Measured, feather.** The xsh five-command cold sum 9320894 ->
9290885 (-0.32%), warm 8683796 -> 8668787 (-0.17%); with
`((((echo deep))))` the cold sum is 10788457 -> 10743330 (-0.42%).
vi's editing session 174.0M -> 173.5M (-0.29%). The fbcon workload
sum 114.82M -> 114.33M (-0.42%), its 12x scroll 103.90M -> 103.31M
(-0.57%). Deployed text: kernel 231996 -> 231976, sh 47928 -> 47568,
vi 161220 -> 161180, game 255928 -> 256016. The game is the honest
zero: its Benchmark scene runs 46173272 -> 46173086 cycles, because
76 cold blocks in 708 is nothing to move and the compute kernels have
no cold arms at all. So: real, uniform, and small — the shipped
mechanism costs nothing when the map is empty (byte-identical output,
`TestColdBlockLayoutOff`) and about a third of a percent when it is
not. The wave's precedent stands: this is the a2-sized result, not a
§6-sized one.

Regenerating also refreshed the pool and hot-function tables, which
had drifted: they predate §6's recursion work, and sh's pool is a
different shape now (155 resident keys of 1433, against 68 of 1867).
That refresh alone moves no cycles — measured, the xsh bench is
identical with it and without — but it accounts for sh's +372 bytes
of SRAM data and most of its -360 bytes of text.

**Still open**, with what the driver already provides toward it:

- per-site compare INLINING (InlineCompares is all-or-nothing today).
  The site identity this needed is built and shipped — §10 (c) labels
  every compare site `cws_<func>_<n>` and the driver ranks them by
  executions — so what is left is only the third form: a site named in
  `HotSites` could take the 14-18-block inline macro instead of the
  four-move protocol. That is a much bigger byte bet per site than
  (c)'s three records, so it wants its own measurement, on the top few
  dozen sites rather than all 377.
- ResidentFuncs past `cursor_xor`: the ranking says `cell_addr`
  (14.8% of kernel XIP reads, 792 B) and `kfbcon_putc` (29.1%, 8.9
  KiB) are next, and neither fits what the KernCRText window has left
  (176 B on feather). They need a window move, not a setting.
- the outliner's hot set (§4). It gates on "block lies on a CFG
  cycle" today, which is blunt enough to cost it 2.9 points of text;
  Options.HotFuncs is already wired as the plug for the measured set.

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

## 4. Record-level outliner — DONE (host/dmacc/outline.go)

Shipped 2026-08-29: an exact-match outliner plus its ICF warm-up, both
text-level passes over the finished .dasm, in the same layer as
foldCopies and elideFallthroughJumps. On by default
(Options.NoOutline turns both off).

Outlining happens at the INSTRUCTION level, not over raw records. The
instruction is the machine's safe boundary — the compact planner
canonicalizes to plain bank / counts 1 at every one of them (see §10
(b) and host/dmaasm/compact.go), so a helper entered by a jump and left
by a jump assembles like any other code and needs nothing from the
planner. Symbolic operands also compare cleanly, which raw records do
not.

Two site forms, neither carrying an lr:

- **tail** — the candidate ends in a control transfer that is the same
  at every occurrence, so the helper IS the branch, exactly as the
  compare millicode is. The site is one record, `jump __ol_N`, and no
  state is parked at all.
- **open** — the run continues. The site parks its resume label in the
  shared word `__ol_ret` (1 record) and jumps (1 record); the helper
  ends `jumpr __ol_ret`. One cell is enough for the whole program
  because candidate runs contain no `call` and no `safepoint`, so
  nothing can re-enter or preempt between the park and the jumpr —
  compare.go's argument for cw_t/cw_f, applied to this cell.

Safety conditions, all structural and all enforced when the candidate
runs are built: no label inside a run (the only way into the middle of
a straight-line stretch, and also the only way to name a record as a
patch target, so one test covers re-entry and self-modifying code); no
`.read`/`.write`/`.count`/`.ctrl` block-field reference and no
`@`-placeholder operand; no `call`, no `safepoint`, and only
whitelisted mnemonics; a control transfer only as the last instruction;
never across a section boundary, so a .ramtext site never jumps into
flash text; and only code owned by a compiled function — the crt0, the
rt_/__cw_ bodies and the shared-runtime vector page are entered from
other images at frozen addresses and are left alone.

Costing has to be encoding-blind: dmacc does not know whether dmaasm
will assemble classic 16-byte blocks or compact 8-byte records. The
model therefore uses the CLASSIC record count of each instruction,
which is <= the compact one for every mnemonic (measured: move 1/1,
add 3/5, sub 5/7, shl 3/5, mulc 3/9, and 6/6, or/xor/andn 3/3, jump
jumpr ret halt 1/1), times the compact record width of 8 bytes, plus 4
bytes per literal-pool word (an open site adds one per site; a tail
site one in total). A candidate that pays under that model pays under
both encodings.

**The census** (baseline xsh kernel and sh, .text + .ramtext,
eligibility as above but without the loop gate; "records" are the
classic model):

| image | instrs | records | runs | instrs in runs |
|---|---|---|---|---|
| xsh kernel | 19,284 | 27,374 | 6,970 | 16,067 (83%) |
| sh (K12, xip) | 6,300 | 8,452 | 2,368 | 5,048 (80%) |

Runs are short — the kernel's length histogram is 1:3628 2:1352 3:477
4:452 5:680 6:196 7:55 8:20 9:17 10:28 >10:65 — because a comparison
site is four moves and a jump, and every jump ends a run. Repeated
k-grams with a positive saving, xsh kernel (distinct / occurrences /
records saved):

| k | open | tail |
|---|---|---|
| 2 | 27 / 556 / 1783 | 106 / 623 / 411 |
| 3 | 39 / 490 / 2642 | 48 / 111 / 78 |
| 4 | 38 / 408 / 3136 | 1 / 2 / 2 |
| 5 | 35 / 329 / 3271 | — |
| 6 | 32 / 261 / 3182 | — |
| 8 | 26 / 133 / 2078 | — |
| 10 | 12 / 24 / 292 | — |
| 12 | 7 / 14 / 217 | — |

Two things the census settled. First, the candidate volume is small
enough — a few hundred repeated k-grams, not tens of thousands — that
a suffix automaton is not needed: the implementation sorts the
suffixes of an interned instruction stream, reads repeats off the
adjacent common prefixes, and commits them best-first. Second, what
repeats is NOT the roadmap's guess. Phi-copy bundles and call
protocols barely repeat, because their operands are per-function value
words and their labels per-site; the dominant candidates are the
`shl sc0, sc0` chains of constant multiplies and shifts (§3), whose
operands are the global scratch words, and short comparison-site tails
whose parked constant happens to match. Whole-program greedy ceiling:
145 helpers / 1,502 records / 12,016 bytes (5.5%) on the kernel,
36 helpers / 259 records / 2,072 bytes (3.1%) on sh.

**The gate is a loop filter, and it is the whole cycle story.**
Ungated, the pass took 7.8% off the kernel's text — and cost 2.0% of
the xsh five-command warm sum (10.77M -> 10.99M cycles) and 2.3% of
the vi burst (177.0M -> 181.0M). The reason is the census: the bodies
that repeat are loop bodies, so an outlined site lands where it is
re-executed. Excluding every block that lies on a CFG cycle
(`loopBlocks`) removes the regression completely and keeps most of the
size. Options.HotFuncs is the second, pluggable filter — never
outlined, unioned with Options.ResidentFuncs — and is where a
generated hot-function set from §1 drops in.

Measured, with the loop gate (text bytes, TestZZAllSizes):

| image | before | after | ICF alone |
|---|---|---|---|
| fs-kern-xip | 208,512 | 198,232 (-4.9%) | 208,056 (-0.2%) |
| fs-kernel | 232,448 | 221,208 (-4.8%) | 231,992 |
| fs-xip-Os | 202,496 | 193,056 (-4.7%) | 202,048 |
| lean | 117,152 | 114,368 (-2.4%) | 116,256 (-0.8%) |
| sh-xip | 67,168 | 65,496 (-2.5%) | 67,168 (0) |
| sh (K12) | 69,008 | 67,336 (-2.4%) | 69,008 (0) |
| ls | 13,056 | 12,512 (-4.2%) | 13,056 (0) |

The kernel gets 62 helpers over 414 sites, lean 13/69, sh 10/52, ls
3/10. The gamepico bundle's game text goes 249,520 -> 244,592 (-2.0%):
per-frame code is nearly all loop, so the gate declines most of it.
.data grows a little (fs-kern-xip 47,676 -> 48,380) because each open
site interns a resume-address literal; under dmxgen's PoolText those
cold literals ride the flash text tail instead of SRAM.

Cycles, with the gate: xsh five-command warm sum 10,769,988 ->
10,080,007 (-6.4%) — smaller images make exec copy less — and the vi
burst TOTAL 177.0M -> 177.0M with every human-paced per-key figure
unchanged. The dmxgen feather images are byte-identical and
cycle-identical for every cc_*/ccc_*/cal_flash program: they are small
and loop-dominated, so the gate declines all of them.

**ICF**, the warm-up, is IR-level rather than text-level: functions
whose bodies render to the same key (locals and block labels numbered
by first appearance, everything else spelled out) share one emitted
body under all of their entry labels, so every symbol still resolves at
its own name. Yield is honest and small — 0.2% of the kernel's text,
0.8% of lean's, nothing on sh or ls — because C rarely produces exact
duplicates. Pinned out: address-taken functions (C gives distinct
functions distinct addresses), variadic ones (the caller fills the
callee's static va area), anything with different recursion-frame or
.ramtext membership, and **anything that can reach fork()**. That last
one cost a debugging round: the fork-spanning depth clones of
computeRecursion are byte-identical by construction, and folding them
back together is exactly the aliasing the cloning exists to prevent —
sh's `echo one; echo two` ran the second command twice.

Deliberately not done. Parameterized outlining (operands lifted into
the shared cells so near-matches merge) is the obvious next step and
the census says where the value is: the comparison sites, whose four
moves differ only in two labels and two operand words. It was not
built because exact matching had to prove itself first. Bodies
containing a `call` stay out: the resume cell would be live across code
that can re-enter it, which needs a stack or a per-site cell and
neither is free. And the loop gate is deliberately blunt — the
2.9 percentage points of text it leaves on the table are recoverable
the moment §1's profile can say which loops are actually hot.

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

## 6. PGO-shaped recursion clones — DONE

sh paid ~26 KB for depth-12 clones (~23 KB at the deployed K=8), but
depth >= 3 is cold by nature. Both mechanisms already existed, so the
job was to make them meet: keep clones for the hot shallow depths,
collapse the deep tail into the frame-stack push/pop mode.

**The three-way split** (`computeRecursion`, host/dmacc/dmacc.go).
Cycle members that cannot reach fork() ride the frame stack as before
(sh's whole parser). Fork-spanning members keep K depth clones —
`Options.RecursionDepth`, now K=2 by default and at every deployed
call site — and then fall into ONE extra copy per member, suffix
`__rt`, compiled in frame-stack mode by the same `rec=true` machinery
recSet uses. Depth-K intra-set calls and every intra-set call inside a
tail copy route to the tail copies, which are in `g.forkSet` (slot
coloring stays off) and in `funcIdx` before `analyzeBounds` runs.

**The safety obligation.** Until now no frame-stacked function could
reach fork(), which is why the frame stack could be stateful at all.
Breaking that invariant costs one new mechanism and one new exclusion:

- Direct fork CALLERS are excluded from the tail (and from recSet).
  A vfork child re-emerges from fork() inside them and RETURNS out of
  them (sh's `fork1` does exactly that); a frame pop there would drop
  fsp below the suspended parent's and hand the parent a restored lr
  belonging to the child. Left as clones, that return moves nothing.
  Past that point the program's vfork discipline — unchanged, and the
  same one the pure-clone scheme always relied on — says the child
  recurses deeper and then execs or exits. So every write the child
  makes to the frame stack is at or above the parent's fsp.
- Every direct fork call site gets an INLINE barrier
  (`emitForkPush`/`emitForkPop`, host/dmacc/func.go). Before the call
  it pushes the parent's `g___dmacc_fsp` onto a small shadow stack (64
  words, emitted only when a tail exists) and bursts the fork caller's
  own frame plus the whole tail-frame block onto the frame stack above
  fsp; after the call it branches on the result word and restores all
  three on the nonzero return (parent resume, or a failed fork),
  leaving them untouched on the zero return (the child). Nesting works
  out because a child's own fork sites push and pop above its parent's
  slot. Inline and not a helper: a shared helper's static lr cell is
  itself vfork-clobberable. Shadow overflow diverts to `__fovf` like a
  frame-stack overflow; `__fovf` deliberately does NOT reset the shadow
  pointer, because a dying child's suspended parent still owns the slot
  beneath it. A child killed mid-flight leaks its slots — the same
  accepted-leak class as the existing parse-depth leak.
- Fallback: if fork's address is ever taken, an indirect call could
  reach it from code no barrier was emitted into, so the image drops to
  pure depth clones with K as a hard bound (`expandClones`).

The tail-frame block is saved with ONE burst because the tail copies'
frames are emitted back to back in .data; `emitFunc` fails the build if
anything lands between them.

**Behavior improvement, not just size.** Deep nesting is now bounded by
`Options.FrameStack` bytes (4096) rather than by K, so `(a; (b; c))`
and triple-plus parens — which prompts/027 recorded as beyond the K=12
budget — work, and `echo 1;...;echo z` runs twelve runcmd activations
deep. Overflow still reaches the same program-defined sink
(`__dmacc_recursion_overflow`, usys prints "recursion too deep" and
exits), so it kills the vfork child and the shell survives; forty
nested parens still do exactly that.

**Sizes** (TestZZAllSizes, sh at K=12 before / K=2 + tail after):

| image | text before | text after | data before | data after |
| --- | --- | --- | --- | --- |
| sh | 67336 | 45216 (-22120, -32.8%) | 15288 | 12396 (-2892) |
| sh-xip | 65496 | 48560 (-16936, -25.9%) | 17180 | 14464 (-2716) |

sh-xip's ramtext also drops 6664 -> 5856, taking its deployed SRAM
share from 23 KB to 19 KB. The other images move by exactly 8 bytes of
data (lean kernel 10124 -> 10116, fs-kernel 40752 -> 40744, fs-kern-xip
48368 -> 48360, fs-xip-Os 44528 -> 44520, fs-xip-pgo 45284 -> 45276, ls
2760 -> 2752): the inert `g___dmacc_fsp`/`g___dmacc_fstack` pair
non-recursive images used to carry is gone, because the comment that
justified it ("usys links the stack cells unconditionally") was stale —
usys.c never referenced them. Text is unchanged on all of those.

**Cycles** (TestZZBenchXsh, cold / warm; TestZZBenchVi total):

| command | before | after |
| --- | --- | --- |
| echo hi | 1415970 / 808716 | 1416217 / 808795 (+0.02% / +0.01%) |
| ls | 2808907 / 2820021 | 2838596 / 2820004 (+1.06% / 0.00%) |
| cat README | 1227566 / 1200001 | 1227813 / 1214999 (+0.02% / +1.25%) |
| cat README \| wc | 2006347 / 1980009 | 1976599 / 1950011 (-1.48% / -1.51%) |
| free | 1862148 / 1890004 | 1861669 / 1889987 (-0.03% / 0.00%) |
| ((((echo deep)))) | 1496855 / 1500023 | 1467563 / 1469988 (-1.96% / -2.00%) |
| vi TOTAL | 174000000 | 174000000 (0.00%) |

The residual +/-1-2% is layout, not mechanism: sh emits fewer records
everywhere and the moves go both ways in one build. The barrier itself
prices out: with it compiled out (measurement only, not a shipping
configuration) every command lands within tens of cycles of these
numbers.

**Two things deliberately NOT taken.** The dead per-push frame trailer
(`[frame base][frame size]`, laid down for a `__dmacc_funwind` that
never existed) is documented as dead but kept: deleting it gives back 7
records and 8 bytes per push, and measured +1.25% cold / +3.38% warm on
`echo hi` from the text it shifts. Hot-path cycles outrank those bytes.
And `make pgo` was re-run against the new sh — the regenerated pools
change the xsh benchmark by literally zero cycles (sh's pool reads are
99296 over the whole workload, against 100K+ text reads per command),
so the committed host/pgo inputs stay as they are.

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

(a) is DONE as far as a per-function analysis can take it. The
BOOL/NONNEG bit lattice became an upper-bound lattice — one uint32 per
SSA value, "this word is <= max", with NONNEG and BOOL as its named
thresholds — carrying the arithmetic of bounds through and/or/xor/add/
mul/shift/div/rem/trunc/phi/select. On top of it, a dominator tree and
BRANCH-DOMINATED narrowing: a block whose only predecessor is its
immediate dominator picks up what that edge proves, and the comparison
sites read the facts at their own block. The narrowings are the
unsigned bounds (`ult`/`ule` against anything bounded), the signed
zero guards (`x >= 0`, `x > -1` and their negations), the signed
compares once one side is known nonneg, `eq` against anything bounded,
and switch case edges; conjunctions are walked through LLVM's
`select`-shaped `&&`. Phis read each incoming value on ITS OWN edge and
re-derive it there, which closes the unsigned loop counter — including
the rotated shape whose header is its own latch — with no assumption at
all.

Routing, static sites (before -> after): xsh kernel ltp 7 -> 35 of 218
lt/ltu (3.1% -> 23%), the game 6 -> 26 of 274 (2.1% -> 9.6%), sh 1 -> 2
of 88. eqzp is flat (259 -> 260 of 592 kernel zero-tests): zero-tests
were already routed by the value lattice. Cycles: cc_control 17235 ->
16803 (-2.5%), vi TOTAL 218.0M -> 217.5M (-0.23%), every other golden
and the xsh 5-command sum unchanged; all text/data sizes unchanged.

What (a) cannot reach from inside one function, measured: SIGNED
counters. `slt i, n` bounds i's word only once i is known nonneg, so
the derivation must assume what it proves. An assume-and-verify round
for exactly that shape (seed the counter phi AND its `add phi, k` steps
at the nonneg bound, run the fixed point, re-derive, drop whatever
lands past bit 31, repeat) was built, proved — a state where every
stored bound is implied by the same rules over the stored bounds of its
inputs is an inductive invariant, since SSA values are written once and
a phi's inputs are produced strictly earlier — and MEASURED: it
discharges the assumption on 36 kernel and 20 game counters and moves
ONE comparison site. It was removed again. The reason it does not pay:
a signed loop's BOUND is an i32 parameter or load (`s:load|` 22,
`s:call|` 12, `s:param|` 9 in the game alone), `slt a, b` needs BOTH
sides nonneg, and LLVM's canonical rotated loop exits on `icmp eq inc,
n`, which bounds nothing at all.

### (a1) Whole-program parameter and return ranges — DONE

The per-function lattice grew an interprocedural layer (facts.go,
`ipBounds` + `gen.analyzeBounds`): a parameter's bound is the meet (the
maximum) of its argument's bound at EVERY call site, a call's result is
the meet over the callee's `ret` bounds, and the two run to a fixed
point over the whole merged module — descending from the top, every
commit taking the minimum of the candidate and the stored bound, so
each bound only tightens and the local lattice's termination argument
carries over one level up. Returns fell out of the same loop for free:
unlike parameters they do not depend on the caller set at all, so no
escape rule touches them.

Soundness rests on counting EVERY caller. The escape enumeration, all
in the `escapedFuncs` comment: the entry point (crt0 calls it with no
arguments, loaders enter at `warmstart`); the recursion-overflow sink
(expandClones calls it with Args nil); every function whose ADDRESS is
a value anywhere — operand, phi input, or indirect-call pointer, the
parser rendering a function-as-value as VGlobal; every function named
by a global INITIALIZER (dispatch tables — the game's `bench_run.kf`
is one); the functions a hand-written .dasm enters by address, i.e.
kernel.dasm's ktickv/ksysv patched with &f_dma_ktick/&f_dma_ksyscall,
which is the one class no IR analysis can see and so lives as a named
list; and, implicitly, any function with no visible call site, since
the meet over zero sites would be ZERO. A site passing fewer arguments
than the callee has parameters tops the callee. Variadic callees keep
their FIXED parameters bounded (the tail is read back by loads).
The vfork double return does not need a rule: the value the kernel
deposits into a suspended process arrives through the INDIRECT trap
call of usys.c, which is unbounded by rule. Each of those has an
adversarial test in facts_test.go, and the escape and partial-site
guards were mutation-checked (removing either makes its test fail).

Measured. Bounds gained: 35/291 kernel parameters bounded (33 nonneg)
and 38 returns; 96/223 game parameters (93 nonneg) and 8 returns;
16/89 sh parameters. Loads gained nothing and cannot — there is no
memory analysis, and a `load i32` stays at the top.

Routing, static sites (before -> after): the xsh kernel ltp 34 -> 41 of
222 and eqzp 259 -> 321 of 590 zero-tests (43.9% -> 54.4%); the game
ltp 26 -> 31 of 280 and eqzp 307 -> 334 of 408 (75.2% -> 81.9%); sh ltp
2 -> 2 of 88 and eqzp 36 -> 44 of 136. eqzp is where the win is, which
is where the executed records are (x == 0 is 52-58% of invocations).

Cycles: the xsh five-command sum 11.31M -> 10.57M cold (-6.6%) and
10.77M -> 9.98M warm (-7.3%) — `cat README` -12.6% cold / -16.7% warm,
`ls` -11.2%, `((((echo deep))))` -7.8%, `free` -3.7%, `echo hi` -1.1%
cold (its warm figure is scheduler-quantized and moves +3.5%, i.e.
under one tick). vi TOTAL 177.0M -> 173.5M (-2.0%); the human-paced
per-key figures are unchanged. Of the dmxgen feather goldens only the
two stdio images move at all (cc_stdio -102 cycles, ccc_stdio -51):
those programs are single-module C where the meet had nothing to add.
All text/data/ramtext sizes are unchanged, as expected — a routed site
is the same two/four records, only the shared helper body differs.

Where the remaining compares are blocked, classified by the defining op
of the operand that fails NONNEG (a site with two unproven operands
counts twice), before -> after: the kernel `load` 61 -> 61, `phi` 51 ->
50, `call` 37 -> 32, `param` 35 -> 34; the game `phi` 70 -> 68, `add`
62 -> 62, `load` 45 -> 45, `param` 37 -> 25, `call` 26 -> 26. Loads are
now the kernel's single largest blocker and phis the game's — and the
phis are the signed counters of (a2) below. Worth noting for whoever
takes that up: the assume-and-verify round removed above was priced
when a signed loop's BOUND was unbounded; with 33 kernel and 93 game
parameters now proven nonneg, the "both sides nonneg" requirement of
`slt` is half satisfied at many more sites, so its price should be
re-measured rather than inherited. It was — see (a2) below: still one
site.

The remaining lever for those was (a2), honouring `nsw`/`nuw` — built,
measured and DONE below. It is worth ~nothing, and the section says
why.

(c), per-site descriptor-vs-four-move selection from the §1 profile, is
DONE and measured below. (b), the compact bank-state planner, is
measured and CLOSED below.

### (a2) The `nsw`/`nuw` wrap flags — DONE, and worth ~nothing

Shipped (host/llir + host/dmacc/facts.go): `llir.Instr` keeps the two
wrap flags the parser used to drop (`NSW`/`NUW`; `exact`/`disjoint`/
`nneg` are still dropped, nothing asks what they promise), and
`insBound` reads them in four rules, each a pure function of the
instruction and its operand bounds so `edgeBound` re-derives with them
too:

- `add nsw a, b`, both words nonneg: the operands ARE their own int32
  values, so a sum that does not overflow int32 is a nonnegative int32
  — bound `min(A+B, 2^31-1)`.
- `mul nsw a, b`, both words nonneg: the same argument on the product.
- `sub nuw a, b`: no borrow means a >= b, so the difference never
  exceeds the minuend — bound A. (Before this, only `sub x, 0` had a
  rule at all.)
- `add nuw a, b`: nothing. `addMax` already saturates to the top
  exactly when the sum does not fit a word, which is the case `nuw`
  promises away, so the flag adds nothing the unsigned rule did not
  already say. Recorded as a rule so the next reader does not re-derive
  it.

No flag is read on an i64 op: that value is a word PAIR, and its low
half wraps whatever the 64-bit arithmetic does (`wrapFlagWord`, with
an adversarial test that fails if the guard is removed).

**The policy decision, and it is on the record in facts.go's header.**
LLVM defines an overflowing `nsw`/`nuw` op as producing poison; this
machine has no poison, its adds wrap, always. Honouring the flags means
taking clang's promise that the SOURCE program never overflows those
ops — the same contract every optimizing C compiler applies to the same
flags — and deriving bounds the wrapped word would violate if it did.
The blast radius is bounded and small: the only consumer of these
bounds is the comparison lowering, so a program that does overflow a
flagged op gets one comparison routed to a restricted-range helper
whose answer for a negative word is wrong. A WRONG BRANCH, in a program
that was already undefined. Nothing here feeds an address, a length or
a bank plan, so no bound of ours can become memory unsafety.

**Measured, and this is the point of the section.** Bounds gained:
the kernel not one parameter or return (35/297 bounded, 33 nonneg; 35
returns, 29 nonneg — identical); the game one parameter (96 -> 97 of
223, 93 -> 94 nonneg) and no return. Routing, static sites: the xsh
kernel ltp 43 of 227 lt/ltu and eqzp 323 of 594 zero-tests, both
UNCHANGED; the game ltp 32 -> **33** of 283 and eqzp 335 of 410
unchanged; sh unchanged at ltp 2 of 73 and eqzp 44 of 136. Cycles: the
xsh five-command sum, `vi` TOTAL (174.0M) and the fbcon workloads are
bit-identical to the pre-change run; every size in TestZZAllSizes is
byte-identical.

Why the rules fire (14 `add`, 38 `sub`, 0 `mul` tightenings in one
kernel compile; 10/16/2 in the game) and still move one site: the flags
can only rescue a bound that SATURATED — two nonneg words whose sum ran
past bit 31. They cannot lift an operand that is at the top, and the
blockers counted in (a1) are exactly that: loads (61 kernel, 45 game)
and phis (50 / 68) with no bound at all. A signed counter phi is
likewise unreachable: `phi [0, entry], [add nsw i, 1, loop]` needs i
nonneg to apply the nsw rule and the phi's own bound to get it, and the
lattice descends from the top, so the cycle never starts. Only the
shape whose guard already bounds the counter and whose STEP overflows
the nonneg threshold closes (facts_test.go:
TestFactsNSWClosesSaturatedCounter, with its unflagged twin as the
mutation guard).

**And that answers (a1)'s closing question about re-pricing `slt`.** It
was re-measured with parameters bounded, not inherited: one more `slt`
site in the game routes to `__cw_ltp`, none in the kernel or sh — the
same order as the assume-and-verify round that was priced and removed
in (a) ("moves ONE comparison site"). The two independent routes to the
signed counters now agree on the price, so the `slt` lowering needs no
redesign and the signed-counter shape is closed as a lever. The rules
stay: they are cheap, sound, tested, and the `sub nuw` one gives `sub`
a bound rule it never had.

### (c) Per-SITE descriptor-vs-four-move selection — DONE

The OptSize carve-out used to be per FUNCTION: `Options.HotFuncs`
named the functions covering 97% of executed text reads, and every
compare site inside one kept the four-move protocol while every site
outside took the two-record descriptor. A hot function is mostly not
hot, though — its argument checks and error paths run once — so that
rule bought speed for code that never executes and sold it on code
that does. Per site, the same question has a much better answer.

**The labelling.** `emitCmpSite` now emits `cws_<func>_<n>` before
every site, n counting that function's sites in EMISSION order. The
ordinal is what makes the identity stable: the form a site takes does
not change how many sites there are or in what order they come, so a
profile collected from one build still names the same sites in the
next. Two constraints the name has to satisfy, both from the §8
attribution trap: not `__`-prefixed (dmaasm drops those from
`Result.Symbols`) and not `f_`-prefixed (that is the function scan's
key). The labels cost zero bytes — but only after the outliner was
taught to step over them (`olRuns`): a marker between two instructions
otherwise ends a candidate run, and that alone cost sh 72 bytes of
text. With the step-over, every image in TestZZAllSizes assembles to
the byte it did before, and the compiled .dasm is identical modulo the
label lines.

**The attribution.** A site spans from its label to the next symbol
(measured: 16, 32 or 40 bytes, i.e. 2, 4 or 5 compact records; capped
at 5 records in case a `__`-prefixed successor was dropped). Reads are
divided by the site's own word count to get EXECUTIONS — without that
division the ranking would prefer the sites the last profile made five
records long, and the choice would ratchet on its own output.

**The policy, and a wrong turn worth recording.** The first cut copied
`funcHotCover` and kept the sites covering 97% of executions. That is
the wrong shape one level down: 429 of the kernel's 1822 sites execute
at all, over four orders of magnitude, and 97% of the total lands
inside a handful of loops — the cut kept 163 sites, saved 1048 bytes
of text and cost 0.6% of the xsh cold sum. An absolute bar reads the
distribution the right way round, because a site is cheap to keep (24
bytes) and expensive to lose (a flash-resident descriptor unpacked on
every branch). At `siteHotExecs = 8` the kernel keeps 377 sites and
the game 348, covering 99.95% and 99.99% of their comparisons.

**Measured, against 7f98c0b.** Kernel (fs-xip-pgo): text 197056 ->
196952, data 45276 -> 45456. xsh cold cycles: echo hi 1416217 ->
1458029, ls 2838596 -> 2774528, cat README 1227813 -> 1203141, cat
README | wc 1976599 -> 1903824, free 1861669 -> 1858328, ((((echo
deep)))) 1467563 -> 1468960 — the six-command sum -1.13%. vi is
unchanged at 173.5M (its bench quantizes to 500k). Game: the Benchmark
scene 46174253 -> 45924473 cycles (-0.54%) for +1108 bytes of text,
data unchanged — the promotion direction, since the game's site
profile is wider than its hot-function set.

`echo hi` is the one command that regresses, and consistently: +2.9%
here, +0.8% at a bar of 1, +0.8% under a promote-only rule. It is the
shortest command and the most XIP-miss-bound, and the deltas across
those three policies are bimodal (echo hi lands on 1.427M or 1.458M,
free on 1.858M or 1.904M) in a way 52 sites cannot explain — this is
layout, not compare form. Per-command deltas below ~2% on the xsh
bench should be read as noise; the sum is the signal.

**Two policies that do NOT pay, both measured and dropped.** Keeping
every site the workload executed at all (bar of 1) gives -0.71% on the
sum for +136 bytes — worse on both axes than a bar of 8. Unioning the
site set with the old per-function rule, so the profile can only ever
promote, gives -0.98% for +760 bytes: the demotions are not costing
speed, so paying to keep them is pure loss. HotSites therefore
REPLACES HotFuncs in the compare decision whenever it is non-empty,
and an empty map (no profile) leaves the per-function rule exactly as
it was — a mutation test pins that byte for byte.

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

§10 (a1), whole-program parameter ranges, was the other half of this
pair and is DONE (see §10 above: -6.6% on the xsh five-command sum,
-2.0% on vi, no size cost). §10 (a2), the `nsw`/`nuw` flags that were
to follow it, is DONE too — the poison-semantics policy is settled and
recorded in facts.go's header, and the payoff is one routed site in the
game and zero cycles anywhere, because the operands that block the
compares are loads and phis at the top, which no wrap flag can lift.
§1 followed (it compounds: every future heuristic becomes automatic),
and §10 (c) — per-site descriptor-vs-four-move selection from the §1
profile — followed that and is DONE. Both halves of the pair are now
spent; what is left in §1's list is the block-layout work, which needs
an emission side dmacc does not have yet.

