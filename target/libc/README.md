# libc for the DMA machine (picolibc)

C programs on the DMA machine get a real libc: a curated subset of
[picolibc](https://github.com/picolibc/picolibc) compiled through the
normal clang → `dmacc` pipeline — the library is not ported, it is
*compiled for the DMA machine* like any other C code.

## What is in this directory

This directory holds two kinds of thing, and the distinction is the
point:

- **DMA-specific code, committed and maintained here** — `picolibc.h`,
  `dma_stdio.c`, and `include/dma/mmio.h`. This is the glue that makes
  picolibc target *this* machine (UART stdout, the config picolibc's
  meson build would otherwise generate). It is original to this project.
- **`picolibc/` — the upstream source, vendored as a git submodule**
  (BSD-licensed). Nothing here is edited; it is pinned unmodified and
  used only as a compilation input.

The build wires them together:

    picolibc/  (vendored .c)  +  picolibc.h / dma_stdio.c  (DMA glue)
             │                          │
             └──────────  clang  ───────┘        (make libc)
                            │
                            ▼
                    ll/*.ll   (committed IR goldens)
                            │
                            ▼
                   dmacc links them into your program

So the submodule is not reference material — its curated sources are
compiled to the IR goldens in `ll/`, which are then linked into every C
program that calls the standard library. `make libc` at the repo root
regenerates `ll/` from `picolibc/` plus the glue above (host clang
required); the goldens are committed so a normal build needs no libc
rebuild.

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
  are a compile-time error at the call site), no scanf/stdin (the
  UART's RX side is reachable, but picolibc's input is not wired to
  it), no malloc (no sbrk story yet).

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

    dmacc -run prog.ll target/libc/ll/*.ll

(see `examples/primes/Makefile`). Unreferenced modules cost data words
but no runtime; the whole set adds roughly 150 KB of text when printf
is used, and dmacc's default link map leaves 192 KiB of text headroom
on either SKU.

The compiler features that make this possible — varargs (static va
areas sized whole-program), indirect calls (picolibc's `FILE` is three
function pointers), multi-module linking with internal-symbol renaming
— are documented in `prompts/008-libc-results.md`.
