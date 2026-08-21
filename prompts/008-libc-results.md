# Phase 4.5 Results: picolibc on the DMA Machine

Status as of 2026-08-16. **`printf` works on the DMA machine, and it is
picolibc's printf, not a lookalike** — the real sources, vendored as the
`target/libc/picolibc` submodule and compiled through the ordinary
clang → `dmacc` pipeline. The Pico 2's UART now carries text formatted
entirely by DMA control blocks:

    stdio on the DMA machine
    i=0 v=-200 u=4294967096 x=f38 c=a
    ...
    [-01234|left    |c0de]
    TEST cc_stdio: PASS

## The three compiler features that unlocked it

printf is the classic torture test for a minimal compiler; dmacc needed
exactly three new capabilities, each with a clean DMA-machine story:

1. **Varargs.** Because dmacc compiles whole programs, every variadic
   callee gets a *static* va area sized to the largest call anywhere in
   the program; callers write the variadic tail into it as contiguous
   words, and `llvm.va_start` stores the area's address into the
   va_list. Clang's AAPCS va_arg arithmetic (pointer bumps by 4) then
   just works. `%lld` is diagnosed at call sites (i64 varargs
   rejected); the i64 load in printf's ll-skip path lowers to a
   low-word load, valid for its only use (trunc).
2. **Indirect calls.** A picolibc `FILE` is three function pointers, so
   `putc` is an indirect call: store the return-address literal into
   `lr`, `jumpr` through the pointer word — two blocks, the machine's
   native indirect jump. Limited to four register args (the callee's
   frame is unknown); variadic-indirect is rejected.
3. **Multi-module linking.** `llir.Merge` links parsed .ll modules
   whole-program style: definitions beat external (tentative) globals,
   duplicate definitions are errors, colliding internal-linkage symbols
   are renamed per module, and IR aliases (`@fputc = alias ... @putc`)
   are flattened by rewriting references. `dmacc` now takes any number
   of .ll files.

Plus smaller subset growth forced by real library code: `insertvalue`/
`extractvalue` on single-word aggregates (`[1 x i32]` va_list
coercion), `llvm.ptrmask` (alloca alignment; allocas gained one word of
slack since .data is 4-aligned), forward-referenced named types,
calling-convention tokens, and return attributes on defines.

## Output: stdout is UART0

- The emulator now models UART0's `DR` register (per-SKU base from
  `emu.Variant`): DMA writes land in `Machine.ConsoleOut`; `FR` reads 0
  so the TX-full poll falls through. `cmd/dmacc -run` prints the
  console.
- C reaches the hardware through two compiler-known globals
  (`__dma_uart_dr`/`__dma_uart_fr`, `libc/include/dma/mmio.h`) that
  dmacc lowers to the new dmaasm `%uartdr`/`%uartfr` MMIO operands — IR
  stays SKU-portable; addresses resolve at assembly.
- On hardware, `dma_stdio.c`'s put function polls `FR.TXFF` then writes
  `DR`: the DMA machine paces itself against the real FIFO and shares
  the UART the firmware's own stdio initialized.

## What was taken from picolibc (and what was not)

Curated list (`make libc` → committed IR goldens in `libc/ll/`):
integer-only vfprintf (`__IO_DEFAULT 'i'` via a hand-written
`libc/picolibc.h`), printf/puts/putchar/fputs/fputc,
sprintf/snprintf/vsnprintf + filestrput, and nine string.h functions.
Not taken: float formatting (no FP on this target), scanf (no input
device), atomics-dependent paths (none reached the printf path), malloc
(no heap story yet). memcpy/memset stay native (one INCR block beats
any C loop).

## Validation

- `TestLibcStdio`: stdio.c runs on host libc and on the DMA machine
  (both SKUs); exit code and all 201 console bytes must match — they
  do, in 1.30 M cycles.
- Silicon: `cc_stdio` in the HIL set (rp2350 layout widened to 128 KiB
  text at 0x20040000, data 0x20060000). The emulator pre-verifies the
  console; the hardware pass checks the exit checksum and the text
  prints live on the UART. PASS, repeating, with all Phase ≤4 tests
  and calibration lines unchanged.
- `examples/primes` now prints its prime table with printf.

## Cost (code density, risk #1)

The printf-linked image is **224 KB** of DMX (vs 9–23 KB for the
numeric programs) — printf in 16-byte control blocks is the density
risk made concrete. Fine on RP2350 (520 KB SRAM); does not fit the
RP2040 HIL layout (cc_stdio is rp2350-only). A `%d` costs ~250 k cycles
(division by repeated-doubling per digit). Mitigations stay as listed
in overview §5 (compressed blocks, overlays) — now with a measurable
workload to evaluate them against.

## Open items

- malloc/heap (trivial bump allocator would do; needed for stdlib
  parts), atoi/strtol family (locale include chain), scanf + an input
  device (UART RX DREQ → the approach-B injector is the natural fit).
- `%lld` support would need i64 pairs in dmacc — not worth it before a
  real user appears.
- Shrink option: `__IO_VARIANT_MINIMAL` + `_NEED_IO_SHRINK` builds a
  smaller vfprintf if the 224 KB hurts before overlays land.
