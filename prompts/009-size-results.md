# Phase 4.6 Results: Code-Size Optimization (Tier A + outlining)

Status as of 2026-08-16. The size plan's measurement-first tiers were
executed; the printf-linked stdio program shrank **223,972 → 42,732
bytes (−81 %)** with a 4 % runtime cost, all differential tests staying
bit-exact and the HIL suite passing on the Pico 2. The numeric programs
shrank 49–84 %. The in-tree LLVM backend was (correctly) not needed for
any of it.

## Measure first: `dmacc -size`

The new size report attributes emitted blocks to IR constructs and
functions. The baseline exploded one assumption: it was not "printf is
big" — it was **comparisons are big**. Fused compares (under `br`) +
materialized `icmp` were ~50 % of all blocks (a full-range compare is
14–18 blocks = 224–288 B per `if`), phis 13 %, switch chains 7 %. The
report also exposed that most of the 224 KB DMX file was the
*relocation table*, not code.

## What was done (in measured order)

| Step | stdio blocks | Δ |
|---|---|---|
| baseline (Phase 4.5) | 5529 | |
| reachability GC | 3416 | −38 % |
| copy forwarding + identities | ~3475¹ | ~0 |
| **outlined comparisons** | 2492 | −28 % |
| switch jump tables | 2261 | −9 % |
| phi direct mode + edge stubs | 2205 | −3 % |
| clang -Oz input | 1921 | −13 % |

¹ forwarding pays off in cycles and composes with later steps; its
standalone block delta was noise-level on this program.

1. **Reachability GC**: functions/globals not reachable from the entry
   (through calls, value references, and global initializers — which is
   how address-taken indirect targets survive) are dropped. Linking
   `libc/ll/*.ll` now costs only what the program uses.
2. **Copy forwarding**: pure copies (zext, freeze, casts, single-word
   insert/extractvalue, llvm.expect, trivial trunc/sext, `x op 0`
   identities) emit nothing — the result name aliases its source
   operand. Copies of phi results stay real (their words mutate).
   `and` with a constant became the 3-block `andn` with the mask's
   complement (the 6-block general `and` remains for var-var).
3. **Outlined comparisons (millicode)**: the big one. A compare site is
   now 4–5 blocks — store the two branch-target addresses and operands
   into shared words (`cw_t/cw_f/cw_a/cw_b`), jump into a shared helper
   (`__cw_eq/eqz/lt/ltu`) that computes the sign predicate once and
   dispatches `jumpr cw_t` / `jumpr cw_f`. No lr, no return — the
   helper *is* the branch. eq-vs-0 gets a one-operand helper; bool
   branches became 3-block eqz sites. Cost: ~8 blocks of extra
   execution per branch (+4–6 % on real programs, +38 % on the
   branch-only microbench); `dmacc -inlinecmp` restores the old
   lowering for latency-critical code. Interrupt-safe: safepoints never
   fall inside a site and ISRs use their own bank.
4. **Switch jump tables**: dense switches (≥4 cases, span ≤ 2n+8)
   dispatch via bounds-check + `pc = base + 16·idx` + a 1-block slot
   per value, instead of an eq-chain per case. Sparse switches use
   outlined-eq chains.
5. **Phi direct mode**: phi words are written directly on the taken
   edge; multi-successor predecessors route through per-edge stubs, so
   the old "stray writes on the untaken edge" trick is gone (it was
   *wrong* once writes hit real phi words — the differential suite
   caught a one-block off-by-one in strlen's exit path, the only
   miscompile of the phase, fixed by the stub scheme). Shadow-and-latch
   survives only for blocks whose own phis feed each other (swap).
6. **-Oz input**: clang's size pipeline is now the standard flag
   (`llgen`, libc, examples); dmacc digested its IR shapes unchanged
   and the result was smaller *and* slightly faster.
7. **Baked relocations** (dmxgen): HIL images always load at their link
   addresses, where every placement delta is zero — the reloc table is
   dead flash weight and is dropped after emulator verification.
   dmxgen now reports flash vs resident bytes separately.

## Results (flash bytes, dmxgen)

| Program | before | after | Δ |
|---|---|---|---|
| cc_stdio (printf) | 223,972 | 42,732 | −81 % |
| cc_arith | 22,732 | 9,916 | −56 % |
| cc_control | 16,576 | 5,508 | −67 % |
| cc_memory | 22,276 | 8,460 | −62 % |
| cc_func | 21,972 | 3,488 | −84 % |
| cc_bits | 20,252 | 10,292 | −49 % |
| cc_collatz | 9,256 | 3,196 | −65 % |

Runtime: stdio 1.30 → 1.35 M cycles (+4 %), collatz +3 %; the numeric
microbenches pay more where compares dominate (control +50 % —
`-inlinecmp` exists for exactly that trade).

## Where the next factor comes from

Post-optimization attribution: phi copies (~19 %) and branches (~18 %)
lead, then shl chains, selects, GEP arithmetic — no single category
dominates any more. That means Tier A is close to exhausted and the
next big factor is structural, as planned: the **compressed 8-byte
block format** (persistent CTRL/TRANS_COUNT + alias-2 trigger tail,
needs silicon calibration of trigger-reload semantics), and for xv6,
**flash-resident overlays via DREQ_XIP_STREAM**. Both remain open items
in the size plan; measured baseline now in place to judge them.
