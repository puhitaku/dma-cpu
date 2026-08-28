# Phase 4 Results: C on the DMA Machine

Status as of 2026-08-16. The Phase 4 compiler exists and is validated on
silicon: **C source compiles through stock clang and the new `dmacc`
translator to DMA-machine code, and six differential test programs
produce bit-identical results in host execution, the emulator (both
SKUs), and on the Pico 2.** The UART line that closes the loop:

    TEST cc_arith: PASS
    TEST cc_control: PASS
    TEST cc_memory: PASS
    TEST cc_func: PASS
    TEST cc_bits: PASS
    TEST cc_collatz: PASS

## The build-vs-port decision

Overview §4.5's de-risking order says "do not start with LLVM" and
sanctions an LLVM-IR-to-dmaasm translator as the compiler. Phase 4 took
that path deliberately, not as a fallback:

- **Front half: stock clang.** `clang --target=armv6m-none-eabi -O1
  -fno-unroll-loops -fsigned-char -ffreestanding -S -emit-llvm` gives
  ILP32 IR with opaque pointers, mem2reg done, and loops in phi form —
  everything a backend wants, with zero LLVM source to maintain.
- **Back half: Go, stdlib only** (`llir` parser + `dmacc` codegen +
  `cmd/dmacc`), per the project language policy. The whole toolchain
  remains one `go build`.
- The translator is the **executable specification** for a future
  in-tree backend (Phase 4b if wanted): every lowering decision —
  instruction selection, comparison synthesis, calling convention,
  safepoint placement — is now locked and regression-tested against
  silicon. A SelectionDAG port would reimplement, not re-research.

## dmaasm v0.1: what the compiler needed first

Compiled code cannot promise `|v| < 2^28`, so `jneg` alone cannot lower
`icmp`. Added to the assembler (all silicon-validated through the
compiled programs; ABI v0.1, references/design_docs/abi.md):

- **Full-range comparisons**: `jsign` (4 blocks), `jeq` (12),
  `jlt`/`jltu` (16, signed/unsigned borrow formulas) — all isolate the
  *true* sign bit (bit 7 after BSWAP, not jneg's bit 4) and dispatch
  through trampoline pairs at +0/+128. Pairs pool 8-to-a-bank in an
  arena appended to .text, so slots pack with zero waste; `jeq x, y`
  costs 12 blocks where jneg's idiom would be unsound. Verified by a
  450-pair exhaustive sweep per SKU (`TestFullRangeComparisons`)
  including 0x80000000/0xFFFFFFFF edges.
- `jbool` (6 blocks): two-way dispatch for materialized i1 values.
- `and` (6 blocks, via CLR-alias double complement) and `andn` (3) —
  the "and with a runtime operand" item left open in Phase 2.
- `sym+off` operands and literals (constant-GEP addresses), `incrr`/
  `incrw` move flags (native memcpy/memset), `at2` temp (from the
  reserved .regs space).

## dmacc: design

- **No register allocator, by design** (overview §4.5): every SSA
  value, parameter, and phi gets its own SRAM word — on this machine a
  spill costs exactly a register. This sidesteps the accumulator-machine
  friction that kills naive ports.
- **Phis** resolve through shadow words: every edge writes all the
  target's phi shadows before jumping (safe even for the untaken edge),
  the target's head latches shadows into value words — swap/cycle-proof
  without stub blocks.
- **icmp fusion**: a compare whose only use is the same-block branch
  emits one fused compare-and-jump; otherwise it materializes 0/1.
- **Static frames**: recursion is a compile-time error (tested), not a
  miscompile. Calls follow ABI v0 — args r0–r3 (5th+ arg written
  directly into the callee frame), result r0, lr spilled by non-leaf
  callees.
- **Memory**: loads/stores through link-time-constant addresses (globals,
  allocas, const-GEPs) are direct moves; runtime pointers use the
  machine's own idiom — patch the next block's READ/WRITE field. i8/i16
  use size8/size16 transfers with zero-extended value words; sub-word
  arithmetic re-masks; signed sub-word compares sign-extend via
  `(x^S)-S` (3+5 blocks, no branch).
- **Runtime library** (.dasm, appended on demand): mul (Horner,
  32 iters), udiv/urem/sdiv/srem (restoring division; big-divisor
  special case avoids remainder overflow; divisor 10 goes to the
  shift-add reciprocal instead, and a constant power-of-two divisor
  never reaches the library at all — prompts/042 §9),
  shl/lshr/ashr (MSB-first bit
  loops — the machine has no right shift), memcpy/memset (one patched
  INCR block: a DMA engine memcpy is a single instruction; count 0 is
  the silicon-verified zero-count NOP, so no length guard).
- **Safepoints** at every backward branch by default (ABI rule;
  `-nosafepoints` to disable), dispatch/thunk initialized by crt0 — so
  compiled programs are approach-B interruptible out of the box.

## Validation

Differential testing (`dmacc/cc_test.go`, `make llgen` regenerates):
six C programs — LCG-driven arithmetic sweep (all binary ops incl.
runtime div/shifts), comparison edges + switch, structs/sort/strings,
6-arg nested calls, sub-word signed/unsigned wraparound, Collatz — are
compiled by host clang for the host and by clang+dmacc for the DMA
machine; exit codes must match exactly. All pass on both SKUs. The same
six images ship in the HIL firmware (`cc_*` tests) with the host-truth
exit codes as expected values: **all six PASS on the Pico 2**, alongside
all Phase ≤3 tests and calibration lines (perf still 10.000 M blocks/s).
Clang constant-folding initially hollowed out three tests (41-cycle
"programs"); volatile inputs restored real computation (arith now runs
455 k emulator cycles of live mul/div/shift work).

## Numbers

| Program | emu cycles | DMX size |
|---|---|---|
| cc_arith | 454,763 | 22.7 KB |
| cc_control | 12,036 | 16.6 KB |
| cc_memory | 22,641 | 22.3 KB |
| cc_func | 40,524 | 22.0 KB |
| cc_bits | 185,897 | 20.3 KB |
| cc_collatz | 2,049,368 | 9.3 KB |

Cost intuition: ALU ops 3–6 blocks, comparisons 12–18, runtime mul
~900 blocks, division ~1,800 — a C `/` by a value the compiler cannot
see costs about 200 µs on silicon. Constant divisors have since stopped
paying it (prompts/042 §3 and §9): a power of two is inline byte lanes,
and 10 is ~410 emulator cycles against the long division's ~6,900.
Code density lands where overview §5 predicted (~50–80 B per C-level
operation): the risk-1 mitigation list (compressed blocks, overlays)
stays live for the xv6 phase.

## Limitations (v0, all diagnosed — never miscompiled)

No recursion (static frames), no i64/float/vector/varargs, no indirect
calls, no memmove, no external functions beyond the intrinsic set
(memcpy/memset/expect/abs/min/max). `char` is compiled signed
(`-fsigned-char` on both sides) so host and target agree.

## Open items

- In-tree LLVM backend (Phase 4b, optional): the translator now defines
  its acceptance tests.
- Performance: compiler use of the cheap `jneg` under value-range
  proofs; direct-address folding through more GEP shapes; dead
  value-word elimination. (Byte-lane fast paths for constant shifts
  were listed here and are done — prompts/042 §3.)
- Recursion via a frame-pointer discipline (indirect frame addressing
  exists — it is the load/store patch idiom) when xv6 needs it.
- ISR-in-C: compile a function into an approach-B ISR bank (the
  injector arming in DMX init writes is still pending from Phase 3).
- RP2040 board HIL run still pending (emulator covers both SKUs).
