# Phase 18 results: the speed ledger — benchmarks, and -Os becomes a choice

The downsizing campaign (prompts/030–031) optimized bytes and never
priced cycles. The bill arrived at the prompt: `ls` on silicon fell
from ~380 B/s to ~150 B/s. This phase built the yardstick, attributed
the cost per step, and split the compiler into a balanced default and
an explicit size mode — the -Os / -O2 separation.

## The benchmark

`TestZZBenchXsh` (DMACC_BENCH=1) boots the xsh bundle in the emulator
with TXPace off and measures machine cycles from feeding a command
line to the prompt returning — end-to-end compute, exact to the cycle
via a UART-write watchpoint. It is committed on the `bench` branch at
the base of the downsizing series (e4993ec, on top of 2b08b9c), so
any historical step can be measured against the same yardstick, and
on the mainline for what comes next.

## Cycles per step (warm run)

    command      base   1/6 GEP  2/6 frames  3/6 XIP  4/6 fold  5/6 desc  6/6 pool
    echo hi      2.79M   3.12M    2.85M       2.83M    2.83M      9.23M    13.3M
    ls          29.9M   30.6M    30.7M       30.0M    29.7M      39.8M     41.4M
    cat README   4.5M    4.4M     4.5M        4.7M     4.7M       9.4M     11.5M
    ((((echo))))  1.4M    1.3M     4.0M        4.3M     4.4M      10.5M     15.2M

Toggling the two suspects independently at HEAD settled it: with
descriptor comparisons off, every command returns to base cost
(pooling alone is ≤9%, via lost copy-folds); with pooling off but
descriptors on, the full regression stays. **The descriptor compare
(5/6) was the whole slowdown** — its unpack is a byte-wise `count=16`
copy plus two indirections, ~20 extra transfers per branch, and
branches are everywhere. Frame-stack recursion (2/6) costs 3× on
paren-heavy paths but buys unbounded depth; it stays.

## Silicon wall clock (Pico 2, `ls` = 505 bytes)

    base (pre-campaign, SRAM text)      1.34 s   377 B/s
    HEAD with descriptors (-Os)         3.0–3.4 s  ~150 B/s
    HEAD balanced (this phase)          1.23 s   412 B/s

Two conclusions. XIP text is effectively free at runtime — the XIP
cache absorbs the machine's fetch stream, and the balanced HEAD beats
the all-SRAM base. And the post-`sync` serial-XIP state measured the
same, for the same reason.

## The policy: Options.OptSize

Descriptor comparison sites now sit behind `dmacc.Options.OptSize`
(-Os): ~9% smaller text for ~2× command cost. Every shipped build —
kernel, sh, user programs — uses the balanced default: four-move
compare sites, pooling, copy-folds, GEP fusion, frame-stack
recursion, XIP text. The price of the default over full -Os is +2 KiB
SRAM and +4 KiB flash on the fs kernel:

    fs-kern-xip  text 140296  data 39348  ramtext 25528  [SRAM 63 KB]
    fs-xip-Os    text 136448  data 37288  ramtext 25832  [SRAM 61 KB]

The -Os path stays exercised: the XIP differential and recursion
tests compile with OptSize, and TestZZAllSizes tracks both rows. If
-Os ever needs to be fast too, the known lever is a word-copy compact
bank so the descriptor unpack costs 4 transfers instead of 16.
