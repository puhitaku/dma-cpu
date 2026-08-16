# libc for the DMA machine (picolibc)

C programs on the DMA machine get a real libc: a curated subset of
[picolibc](https://github.com/picolibc/picolibc) (vendored as the git
submodule `lib/picolibc`, BSD-licensed) compiled through the normal
clang → `dmacc` pipeline — the library is not ported, it is *compiled
for the DMA machine* like any other C code.

## What works

- `printf`/`puts`/`putchar` and `sprintf`/`snprintf` — picolibc's
  integer-only variant (`__IO_DEFAULT 'i'`): `%d %i %u %x %X %o %p %c
  %s %%`, widths, precision, `0`/`-`/`+`/space flags, `h`/`l`
  modifiers. Verified byte-for-byte against the host libc
  (`TestLibcStdio`) and on silicon (`cc_stdio`).
- string.h: `strlen strnlen strcmp strncmp strcpy strncpy strchr
  memchr memcmp` (plus `memcpy`/`memset`, which clang lowers to the
  native DMA runtime — one INCR block).
- No floats (`%f` prints nothing useful), no `%lld` (long long varargs
  are a compile-time error at the call site), no scanf/stdin (there is
  no input device yet), no malloc (no sbrk story yet).

## How it fits together

- `picolibc.h` — the hand-written configuration header (picolibc's
  meson would normally generate it).
- `include/dma/mmio.h` — declares `__dma_uart_dr`/`__dma_uart_fr`;
  `dmacc` maps loads/stores of these globals to the SKU's UART0
  `DR`/`FR` registers (`%uartdr`/`%uartfr` in dmaasm), so the same IR
  works on both SKUs.
- `dma_stdio.c` — `stdout`/`stderr`: a picolibc `FILE` whose `put`
  function busy-waits on `FR.TXFF` and writes `DR`. In the emulator
  `FR` reads 0 and the bytes land in `Machine.ConsoleOut`; on hardware
  they appear on the board's serial port, paced by the real FIFO.
- `ll/*.ll` — committed IR goldens for the curated source list;
  `make libc` at the repo root regenerates them (host clang required).

Link by passing the goldens to dmacc after your program:

    dmacc -run prog.ll libc/ll/*.ll

(see `examples/primes/Makefile`). Unreferenced modules cost data words
but no runtime; the whole set adds roughly 150 KB of text when printf
is used, so the RP2350 layouts give text 192 KB of headroom.

The compiler features that make this possible — varargs (static va
areas sized whole-program), indirect calls (picolibc's `FILE` is three
function pointers), multi-module linking with internal-symbol renaming
— are documented in `prompts/008-libc-results.md`.
