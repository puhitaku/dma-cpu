# Phase 14 results: parenthesized sh commands (and graceful overflow)

The silicon session (Pico 2, golden disk):

    $ (echo a; (echo b))
    a
    b
    $ ((echo x))
    x
    $ (cat README | wc) > n
    $ cat n
    1 6 35
    $ ((((((echo waydeep))))))
    recursion too deep
    $ echo alive
    alive

## What it took

Upstream sh.c's parser and runcmd recurse per nesting level (the
parseline/parsepipe/parseexec/parseblock cycle), and everything runs
in the vfork child. Single-level parens already fit the K=8 clone
budget from Phase 8; two levels did not — and worse, blowing the
budget hit dmacc's recursion-overflow HALT, which stops THE MACHINE.

*Superseded by prompts/042 §6: the clone budget is K=2 now and the
deep tail rides the frame stack, so nesting is bounded by FrameStack
bytes rather than by K — `(a; (b; c))` and triple-plus parens work,
and the ~26 KB below comes back.*

- sh's RecursionDepth goes 8 -> 12 (~6.5 KB text + 1.2 KB data per
  level; 97.7 KB text total). An xsh RAM rebalance pays for it: the
  kernel windows tighten to measured sizes, the arena keeps 71.5 KB
  by claiming the dead 3.5 KB below the machine scratch, and every
  offset in dmxgen/buildXsh and the test boot moves accordingly.
  K=12 admits `((x))`, `(a; (b))`, sequential subshells, and
  redirected subshell pipelines; `(a; (b; c))` and triple-plus parens
  exceed it.
- dmacc's depth-K sink is now routable: if the program defines
  `__dmacc_recursion_overflow`, the rewrite calls it (args dropped —
  the sink takes none and must not return) instead of emitting HALT;
  collectGarbage keeps it as a root (the only caller is the rewrite,
  which runs later). usys.c provides it: write(2, "recursion too
  deep") + exit(-2). An overflowing subshell now dies as a PROCESS —
  the shell prints the message and prompts on. Kernels don't link
  usys and keep the HALT semantics.

## Validation

- Emulator: nested/sequential/redirected paren forms against
  upstream sh; the too-deep case degrades politely and `echo end`
  still runs. Full suite green both SKUs.
- Silicon: 5-check interactive demo above.

## Next (per the recorded roadmap)

More peripherals for the machine; then the presentation goals: HSTX
DVI out, DisplayLink over PIO USB, mount() + SD.
