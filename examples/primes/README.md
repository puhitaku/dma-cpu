# Hello, DMA machine

A template for writing your own C programs for the RP2 DMA machine.
This one sieves the primes up to 200.

## Run it

Needs a host `clang` (Xcode's is fine) and Go. From this directory:

```console
$ make run
Hello, DMA machine!
primes up to 200:
   2    3    5    7   11   13   17   19   23   29
  ...
count=46 checksum=4227
exit: 4604227 (0x464143)  cycles: ...  sku: rp2350
nprimes: 46
primes: 2 3 5 7 11 13 ...
```

`make run` compiles `primes.c` with clang to LLVM IR, lowers it with
`dmacc` to DMA control blocks together with the picolibc modules
(`target/libc/README.md` — that `printf` is the real picolibc, running on the
DMA machine), and executes it in the silicon-calibrated emulator.
printf output goes to UART0: the emulator shows it as console text; on
real hardware the same bytes appear on the serial port. `main()`'s
return value is the exit code, and `-dump name[:count]` (see `DUMPS` in
the Makefile) prints any global variable after the run — handy for
programs without printf (drop `LIBC_LL` for a libc-free build).

Other targets:

- `make dasm` — write the generated DMA assembly to `build/primes.dasm`
  (worth a look: every C operation becomes a handful of 16-byte DMA
  control blocks).
- `make dmx` — produce a relocatable `.dmx` executable for the target
  loader (`doc/dmx.md`).
- `make SKU=rp2040 run` — same source, RP2040 encodings.

## Writing your own program

Copy this directory, rename the `.c` file, and set `PROG` (or just edit
`primes.c`). Rules of the road (v0 compiler — violations are
compile-time errors, never miscompiles):

- `main(void)` returning `int` is the entry point. stdio: `printf`,
  `puts`, `putchar`, `snprintf` (integer formats — no `%f`, no `%lld`)
  plus the common string.h functions; no scanf/stdin, no malloc.
- No recursion (frames are static), no `long long`/`double`/`float`.
  Varargs and function pointers work (indirect calls carry at most 4
  args).
- Loops that only touch compile-time constants get evaluated by clang
  on your laptop — read at least one input from a `volatile` global if
  you want the DMA machine to do the work.
- Cost intuition: `+ - & | ^` are cheap (3–6 blocks ≈ sub-µs on
  silicon), comparisons 12–18 blocks, `*` ~900 blocks, `/` and `%`
  ~1800 blocks (~200 µs). memcpy/memset are native DMA and nearly free.
- Every loop back-edge carries an interrupt safepoint (ABI approach B)
  by default; benchmark without them via `dmacc -nosafepoints`.

To run a program on real hardware, add it to the HIL specs in
`host/cmd/dmxgen/main.go` (see the `cc_*` entries) and `make test-hw` from
the repo root — the firmware checks it against the emulator's results.
