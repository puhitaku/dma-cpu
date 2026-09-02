# 045 — The tick stops walking, and the profiler learns to see SRAM

Two kernel-side items, both of them about the same thing from opposite
ends: the kernel spends most of its records in a window nobody was
measuring, and the two decisions that govern that window were being made
by rule rather than by number.

Everything below is emulator-measured on the feather unless a board is
named. The ratchet (`host/dmacc/testdata/ratchet.txt`) carries the
figures; the deltas quoted here are what regenerating it moved.

## 1. The "next deadline" guard in tick_income

**What it was.** Every delivered tick with any timed sleeper standing
read TIMERAWL and compared all eight proc slots against their deadlines.
The `ntimed` hint kept an idle system out of it — one load, one branch —
but a system with *one* sleeper paid the whole walk on every tick. A
10 kHz tick against `pause(1000)` does that a thousand times to wake one
process once.

Over twelve nyancat frames:

| | walks | tick-path records | share of all kernel records |
|---|---|---|---|
| before | 12,610 | 13,172,152 | 7.85% |
| after | 12 | 1,047,956 | 0.73% |

One walk a tick became one walk a frame. All kernel records over the
same window fell 167,844,220 → 142,805,449, −14.9% — more than the tick
path's own share, because the walk's compares are millicode calls billed
to `__cw_*` and not to `tick_income`.

The workloads with no timed sleeper are unmoved, as they should be: the
xsh benchmark set 703,556 → 703,730 records, the vi session 2,157,554 →
2,157,554 exactly.

**What it is now.** A second gate in front of the walk: `next_us`, the
earliest deadline any sleeper holds. Nothing can be due before it, so a
tick landing short of it skips the proc table entirely.

The invariant is one-sided and lives beside the declaration in
`target/xv6/dma/kproc.c`:

- **stale-EARLY is harmless.** A `next_us` older than the true minimum
  costs one walk that wakes nobody and then recomputes — exactly the old
  behaviour.
- **stale-LATE would MISS a wake.** So every path that arms a deadline
  folds it in (`SYS_pause` and `SYS_select`'s timeout now share
  `arm_timed`) and every walk that runs recomputes the minimum over the
  sleepers it leaves behind.

"No timed sleeper" needs no sentinel value. `ntimed` is never stale
*low* — only the walk clears it, and the walk recounts — so `ntimed == 0`
already means the cache holds nothing, and `arm_timed` sets rather than
minimizes in that case. That is also what keeps a `next_us` from an
older epoch out of the comparison. The wrap horizon is `wake_us`'s own:
32 bits of TIMERAWL microseconds compared as signed differences.

**The walk moved out of SRAM.** `tick_wake` is now an ordinary XIP
function (noinline, not in `kernResident`). It is the bulk of the tick
path's code and, behind the guard, almost none of its executions;
`tick_income` already called out to flash for `cons_poll`, and ticks
that land while the kernel is running are absorbed by `tickpending`, so
a flash session — the one time XIP is down — never reaches it.

That gave the resident window back **712 bytes on every xv6 board**, and
the board that needed them is not the one the brief for this work named:
the feather had 504 bytes free, but **pico and pico2 had 32**. Their
kernels carry no framebuffer driver and their `.ramtext` window is sized
to match. An in-place version of the guard — walk and all, kept
resident — cost +296 bytes and did not fit them at all.

**Tests.** `TestXv6TickGuard` counts walks by the only instrument that
costs the shipped kernel nothing: `tick_wake`'s entry word, fetched
exactly once per call, read out of a profile window over the kernel's
XIP text. 300 delivered ticks short of a 100 ms deadline give 0 walks —
**306 with the guard patched out**, so the test was checked against a
broken kernel and not only a fixed one — and the deadline itself gives
exactly 1, which wakes the sleeper.

`TestXv6TickGuardStaleEarly` drives the other half through the only
program in the tree that opens that door. nyancat parks in
`select(fd 0, DELAY_TICKS)` once a frame; a keystroke commits input,
`cons_poll` calls `sel_wake`, and `next_us` is left pointing at a
timeout nobody will claim. The next timed sleeper still wakes, and the
stale minimum costs exactly the one cleanup walk the invariant allows.

**What it does not buy.** Nothing in `nyancat/frame/*`, and that is not
a disappointment: the frame interval is a wallclock deadline with the
UART setting the pace above it, so work removed from a frame becomes
idle time, not frame rate. What the guard buys is headroom and 712 bytes
of the scarcest window in the tree.

## 2. HotSites, and the finding that was a reporting bug

**The finding, as it stood.** The PGO driver's `siteCounts` was only
ever called with an image's XIP-text window, so none of the kernel's
~142 labelled compare sites in `.ramtext` appeared in
`pgo.KernelHotSites`. `TestProfileConsole` reported all of them as
`DESCRIPTOR` and drew the obvious conclusion: a whole window's worth of
the hottest code in the kernel — the tick path, the console rings,
`kfbcon_putc` with csi/sgr/draw_glyph inlined into it — left slow by
omission, with 504 bytes sitting there to fix it.

**It was not true.** `dmacc`'s `siteFourMove` answers `fc.inRAM` *before*
it consults `HotSites`: a resident site's descriptor would live in flash
text and be loaded with the XIP window down, so those sites are
four-move by rule whatever a profile says. Adding all 141 of them to
`KernelHotSites` and rebuilding produced an image identical **byte for
byte** in all three segments. The probe was asking the pgo sets a
question only dmacc could answer, and its `form` helper now asks it in
dmacc's own order.

So the promotion the finding asked for does not exist. The one that does
is **inlining** — the only form that removes the millicode call itself,
and the thing that matters here, because comparison millicode is ~40% of
the kernel's records during rendering (`__cw_eq` 14% alone) and
four-move still calls it.

**What was done.**

- The driver profiles the kernel's `.ramtext` window for sites as well
  as for functions, with the same reads ÷ site-words normalization.
  Result: **92 of the kernel's 506 executed sites are resident, and they
  carry 90.3% of its 5,916,298 comparison executions.** That is the size
  of the gap the measurement had.
- `HotSites` is now derived from the flash half alone, against its own
  total. Ranking resident sites there would emit entries that change no
  byte of any image.
- `siteInline`'s `.ramtext` exclusion is gone. It was a fit argument
  living in the code generator, and fits belong to the trim that prices
  them. An inline site has no descriptor and no helper call; its only
  indirection is the sign-dispatch trampoline pair, which is
  assembler-private and lands in `.ramtext` with the arena — so it is if
  anything the most flash-independent of the three forms.
- The kernel's inline trim now runs in **two stages**, and that is the
  substantive design decision in this item.

**Why two stages.** The two kinds of candidate are not priced alike. A
flash candidate spends `.ramtext` on one trampoline pair — 16 bytes, and
only when a bank of 16 rolls over. A resident candidate spends it on the
macro's own records, measured at ~160 bytes each. Ranked as one list by
executions, the resident sites win every slot, because they *are* the
hotter code. That run was made, and it is on the record because it is
the kind of result a ranking can produce while looking perfectly
reasonable:

> 8 resident sites in, covering 49.04% of all comparisons; all 40 flash
> sites out. Cost: +2 to +11% on every xsh row, +2 to +6% on fbcon, to
> buy −0.15% of a nyancat frame.

Heat per site is the wrong comparison across a tenfold difference in
price. So the flash half is chosen first, against its own population and
its own bar — unchanged from before, 40 of 40 candidates, 87.31% of the
571,802 comparisons made outside `.ramtext` — and the resident half is
fitted hottest-first into the window that is left.

**What the window bought.** Three resident sites:

| site | executions | share of all comparisons |
|---|---|---|
| `cws_swtch_1` | 1,159,604 | 19.60% |
| `cws_swtch_2` | 522,544 | 8.83% |
| `cws_kcons_aim_2` | 265,866 | 4.49% |

**32.93% of every comparison the workload makes, in three macros.** The
distribution is as concentrated as expected — 43 resident candidates
clear the bar and carry 88.77% between them, but the first three carry a
third of the whole image on their own, and the rest are priced out of
the window rather than out of the ranking.

`.ramtext` after both items:

| board | used | window | spare |
|---|---|---|---|
| pico2 | 44,264 | 44,544 | 280 |
| pico | 44,264 | 44,544 | 280 |
| feather | 56,080 | 56,576 | 496 |

Kernel data is 35,328 of 35,584 — 256 spare, the PGO trim's own margin,
unchanged.

**The margin is new here.** The kernel's `.ramtext` fit used to be
exact, on the argument that a trampoline bank is discrete — no "nearly
fits" in SRAM — and that what shares the window with the arena does not
move under the settings a run emits. Both halves of that retired the
moment a resident site could be named: such a site spends the window on
its own records, ~160 bytes and not a bank, so the fit lands wherever
the ranking runs out, and the first run left pico2 sitting on **exactly
0 bytes free**. That is the failure `windowMargin` exists for. The
kernel's `.ramtext` now leaves the same allocator page of slack every
other window in the tree does, and it is what bounds the resident set to
three rather than five.

**Fixed point.** `make pgo` was iterated until consecutive passes agreed
on `KernelHotSites` (368), `KernelInlineSites` (43 = 40 flash + 3
resident) and `KernelHotFuncs` (19). The game's tables were **carried
over from HEAD, not re-derived**: this wave has no game in it — the
game's site scan is XIP-only, so no game site can be resident-named and
lifting the `inRAM` gate changes nothing for it — and the driver's own
header says a change with no game in it has no business moving the
game's settings. `TestGameChute` photographs a fixed cycle and fails on
a game that is merely a frame faster, which is exactly what re-deriving
them did.

## Ratchet

Both items, against `c3e28f4`. Sizes:

| figure | before | after | delta |
|---|---|---|---|
| `deploy/feather-kernel/ramtext` | 56,072 | 56,080 | +8 |
| `deploy/feather-kernel/data` | 35,328 | 35,328 | 0 |
| `deploy/feather-kernel/text` | 233,124 | 234,512 | +1,388 |
| `size/fs-xip-pgo/ramtext` | 44,512 | 44,264 | −248 |
| `size/fs-xip-pgo/text` | 206,056 | 207,384 | +1,328 |
| `size/fs-xip-pgo/data` | 46,852 | 46,980 | +128 |
| `size/fs-kern-xip/ramtext` | 44,256 | 43,544 | −712 |
| `size/fs-xip-Os/ramtext` | 44,256 | 43,544 | −712 |
| `size/lean/text` | 123,152 | 124,000 | +848 |

The `.ramtext` line is the story of the wave in one number: item 1
freed 712 bytes and item 2 spent 720 of them on three inline macros, for
a net eight bytes against HEAD and a third of the kernel's comparisons
taken off the millicode.

Cycles (deployed, PGO shape):

| row | before | after | delta |
|---|---|---|---|
| `vi/TOTAL` | 125,000,000 | 121,000,000 | −3.20% |
| `vi/phase/quit (:q!)` | 4,000,000 | 3,500,000 | −12.50% |
| `vi/phase/subst %s/a/A/g` | 48,500,000 | 46,500,000 | −4.12% |
| `nyancat/frame/free` | 21,716,666 | 21,633,333 | −0.38% |
| `nyancat/frame/paced` | 24,750,000 | 24,700,000 | −0.20% |
| `fbcon/feather/echo 40x` | 2,038,368 | 2,008,936 | −1.44% |
| `fbcon/feather/cat README` | 1,118,215 | 1,106,446 | −1.05% |
| `fbcon/pico2/echo 40x` | 1,665,249 | 1,729,042 | +3.83% |
| `fbcon/pico2/cat README` | 950,429 | 922,946 | −2.89% |
| `xsh/free/warm` | 617,933 | 607,285 | −1.72% |
| `xsh/ls/warm` | 2,220,068 | 2,205,161 | −0.67% |
| `xsh/((((echo deep))))/cold` | 991,286 | 1,039,770 | +4.89% |

The rest of the xsh table moves by ±1-2% in both directions. None of
these workloads holds a timed sleeper, so none of it is the guard: it is
XIP text shifting under a warm run, plus three macros' worth of inline
compare in `swtch` and `kcons_aim`. The game's rows are unchanged — its
tables were carried over.

## What is not done

- The resident ranking has 40 more candidates over the bar, carrying
  another ~56% of the image's comparisons between them, and no window to
  put them in. Deploying them needs a map move, not a setting.
- `nyancat/frame/*` cannot see kernel work while the frame is
  delay-bound and the UART is above it. A bench that measures the
  kernel's own records per frame would price this wave properly; the
  numbers in §1 came from a throwaway probe.
- The game's `.ramtext` sites are still unprofiled. The same gap, the
  same fix, and no reason to open it in a wave with no game in it.
