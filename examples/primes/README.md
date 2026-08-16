# Hello, DMA machine

A template for writing your own C programs for the RP2 DMA machine.
This one sieves the primes up to 200.

## Run it

Needs a host `clang` (Xcode's is fine) and Go. From this directory:

```console
$ make run
exit: 4604227 (0x464143)  cycles: ...  sku: rp2350
nprimes: 46
primes: 2 3 5 7 11 13 ...
```

`make run` compiles `primes.c` with clang to LLVM IR, lowers it with
`dmacc` to DMA control blocks, and executes it in the silicon-calibrated
emulator. `main()`'s return value is the exit code; `-dump name[:count]`
(see `DUMPS` in the Makefile) prints any global variable after the run.

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

- `main(void)` returning `int` is the entry point; there is no libc and
  no I/O — results come out through the exit code and globals.
- No recursion (frames are static), no `long long`/`double`/`float`,
  no varargs, no function pointers.
- Loops that only touch compile-time constants get evaluated by clang
  on your laptop — read at least one input from a `volatile` global if
  you want the DMA machine to do the work.
- Cost intuition: `+ - & | ^` are cheap (3–6 blocks ≈ sub-µs on
  silicon), comparisons 12–18 blocks, `*` ~900 blocks, `/` and `%`
  ~1800 blocks (~200 µs). memcpy/memset are native DMA and nearly free.
- Every loop back-edge carries an interrupt safepoint (ABI approach B)
  by default; benchmark without them via `dmacc -nosafepoints`.

To run a program on real hardware, add it to the HIL specs in
`cmd/dmxgen/main.go` (see the `cc_*` entries) and `make test-hw` from
the repo root — the firmware checks it against the emulator's results.
