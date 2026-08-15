# DMA-CPU: Development Plan and Technical Analysis

## 1. Project Goals

Building on the fact that the RP2040/RP2350 DMA controller is Turing-complete
(see `doc/ece4760.pdf`), this project pursues:

1. **Enhance LLVM to support DMA programming** — make Clang emit programs that
   run on the RP2040 DMA machine.
2. **Implement a DMA program loader** and test it both in an emulator and on
   actual hardware.
3. **If interrupt handling and related issues are solved, port xv6** (or an
   xv6-derived kernel) to run natively on the DMA machine.

The rest of this document analyzes the two blocking design questions raised up
front — (a) interrupting/modifying the PC of a running DMA program from GPIO
and timer events, and (b) how to handle "registers in SRAM" at link time —
then lays out a phased development plan designed around an automated
build/test loop that a coding agent can drive.

**Reference documents:**

- `doc/ece4760.pdf` — the reference article describing the DMA computing
  machine architecture this project builds on (third-party copyrighted
  material, not committed; see Coding rules).
- `doc/rp2040-datasheet.pdf` — RP2040 datasheet: authoritative reference for
  the DMA controller (§2.5, incl. register aliases §2.5.2.1 and DREQs §2.5.3)
  and atomic register access (§2.1.2).
- `doc/rp2350-datasheet.pdf` — RP2350 datasheet: DMA controller §12.6.
  Note the RP2350 changes the CTRL bit layout, global DMA register
  offsets, channel/IRQ counts, SRAM size, IO_BANK0 base, and GPIO
  override bit positions — encodings are SKU-specific (see emu.Variant).

---

## 2. Background: the DMA machine in one page

The reference design (`doc/ece4760.pdf`) is a fetch/execute machine built
from three DMA channels:

- **Fetch channel (DMA0)** — its `READ_ADDR` *is the program counter*. It
  copies the next 16-byte control block (4 × 32-bit words: `READ_ADDR`,
  `WRITE_ADDR`, `TRANS_COUNT`, `CTRL_TRIG`) from a block array in SRAM into
  the execute channel's control registers, then chains to it.
- **Execute channel (DMA1)** — performs the data move described by the block,
  then chains to the fixer.
- **Fixer channel (DMA2)** — resets the fetch channel's `WRITE_ADDR` back to
  the execute channel's control registers, then re-triggers fetch.

The "ALU" is the DMA **sniffer** (a 32-bit accumulator with a hardware adder
and CRC32) plus the **atomic register aliases** every RP2040 peripheral
register has (`+0x1000` XOR, `+0x2000` SET, `+0x3000` CLR — RP2040 datasheet
§2.1.2), which give AND/OR/XOR/NOT as transport-triggered side effects.
Branches are absolute-address stores into the fetch channel's `READ_ADDR`;
conditional branches compute one of two block addresses in the sniffer and
store it there. Throughput is ~8 M blocks/s; one "assembler instruction"
(DMAasm macro) is typically 1–5 blocks, so effective speed is roughly 1.5–8
MIPS depending on instruction mix (multiplies and shifts are far slower).

Architectural state and where it physically lives:

| State | Location | Address class |
|---|---|---|
| PC | fetch channel `READ_ADDR` | MMIO, `0x50000000 + 0x40*ch + 0x00` |
| Accumulator | `SNIFF_DATA` | MMIO, `0x50000000 + 0x438` |
| General registers, LR, "flags" | ordinary SRAM words | SRAM |
| Zero register / bit bucket | SRAM words by convention | SRAM |
| Program text | array of 16-byte blocks | SRAM (must be writable — see §4.6) |

Two facts verified against the RP2040 datasheet
(`doc/rp2040-datasheet.pdf`) that constrain everything below:

- **There is no GPIO DREQ.** DREQs 0–39 are peripheral FIFOs (PIO, SPI, UART,
  I2C, ADC, XIP) plus `DREQ_PWM_WRAP0..7`; internal pacing timers are
  selected via `TREQ_SEL` 0x3B–0x3E. GPIO edges must be converted to DREQs
  through a PIO state machine.
- **A disabled channel ignores triggers.** Clearing `CTRL.EN` pauses a
  channel (resumable), but chain/DREQ triggers arriving while `EN=0` are
  *dropped*, not latched. Any scheme that freezes the 3-channel machine
  asynchronously risks losing an in-flight chain trigger and wedging the
  machine. This rules out naive preemption.

---

## 3. Question 1 — Interrupting and modifying the PC

An "interrupt" for this machine means: *asynchronously divert the fetch
channel's `READ_ADDR` to an ISR block sequence, in a way that (a) never
corrupts an instruction in flight, (b) records a resume address, and (c) can
return.* Four approaches, from most conventional to most exotic:

### 3.1 Approach A — Compiler-inserted polling (software interrupts)

The compiler inserts an interrupt-check sequence at every loop back-edge and
function return (the classic GC-safepoint placement). The check reads a
pending flag directly from the interrupt source's raw status register —
`IO_BANK0.INTR*` for GPIO, `TIMER.INTR`/PWM `INTR` for timers, both readable
without CPU involvement — and conditionally jumps to the ISR using the
paper's conditional-jump idiom.

- **Pros:** no extra channels, no races by construction, interrupts are
  delivered only at instruction boundaries (macro atomicity is free).
- **Cons:** the conditional-jump idiom costs ~4 blocks (~500 ns) *per poll
  site per iteration*, paid even when no interrupt is pending; worst-case
  latency is the longest poll-free path, which the compiler must bound.

### 3.2 Approach B — Hardware vector patching (recommended)

Exploit the DMA's own DREQ machinery to make the *hardware* deliver the
interrupt, while the running program only pays for a cheap indirect jump at
safepoints.

**Mechanism.** All safepoints jump indirectly through a single SRAM word,
`dispatch_target`:

1. At each safepoint the compiler emits 2 blocks:
   *store this site's resume address (a link-time constant) into
   `irq_resume`* → *copy `dispatch_target` into fetch `READ_ADDR`* (indirect
   jump).
2. Normally `dispatch_target` holds the address of a global 1-block
   `resume_thunk`: *copy `irq_resume` into fetch `READ_ADDR`* — i.e. fall
   straight back into the program. Steady-state overhead: **3 blocks
   (~375 ns) per safepoint**, cheaper than approach A's conditional jump.
3. A dedicated **injector channel** sits armed with `TREQ_SEL` = the
   interrupt's DREQ. When the DREQ fires, its single transfer copies the
   constant `isr_entry` over `dispatch_target`. The next safepoint therefore
   lands in the ISR instead of the thunk.
4. The ISR epilogue writes `&resume_thunk` back into `dispatch_target`
   (acting as both EOI and interrupt re-enable), re-arms the injector
   (trigger-write to its `TRANS_COUNT_TRIG` alias), and jumps through
   `resume_thunk`.

**Why it is race-free.** The only shared word is `dispatch_target`. The
injector's write and the safepoint's read are both single 32-bit bus
transactions; the reader sees either the old or the new value, and both are
valid entry points. If the write lands just after the read, delivery slips to
the next safepoint. No partial state is ever observable.

**Interrupt sources:**

- **Timer interrupt:** point the injector's TREQ at a DMA pacing timer
  (`TREQ_SEL` 0x3B–0x3E, fractional divider of sys_clk) or a
  `DREQ_PWM_WRAP*` slice for arbitrary periods. Ticks arriving while the ISR
  runs simply rewrite `dispatch_target` with the same value — periodic
  interrupts coalesce naturally, which is exactly the semantics a scheduler
  tick wants.
- **GPIO interrupt:** a 2-instruction PIO state machine (`wait 1 pin` /
  `in pins, 1` + autopush) converts a pin edge into an RX-FIFO push, which
  asserts `DREQ_PIOx_RXy`. The FIFO doubles as a 4-deep pending queue, and
  the value pushed can encode a vector number, so one PIO SM can serve as a
  tiny interrupt controller. The ISR drains the FIFO as its acknowledge.
- **Multiple sources:** either one injector channel per source, each
  patching `dispatch_target` with its own vector (last-writer-wins; the
  loser's DREQ credit/FIFO entry keeps it pending), or serialize all sources
  through one PIO SM that pushes vector numbers.

**ISR ABI.** Because "registers" are SRAM addresses, the ISR uses its *own
register bank* — a disjoint set of SRAM words — so nothing needs saving
except the true hardware state: `SNIFF_DATA` (accumulator) and the sniffer
control word, plus `irq_resume` if nesting is allowed (save to an SRAM
stack). This is the memory-register model paying off: context switch =
choose different addresses at compile time, like ARM FIQ banking.

**Return** is one block: copy the saved resume address into fetch
`READ_ADDR`. Indirect jumps are native to this machine.

### 3.3 Approach C — True asynchronous preemption (research track)

Freeze the interpreter mid-flight and run the ISR on a *second* 3-channel
fetch/execute machine while the first is paused:

- An injector chain writes `EN`-clear masks to the main machine's three
  channels via the `CTRL` CLR aliases, then triggers the ISR machine.
- A paused channel resumes exactly where it stopped when `EN` is set again,
  so in principle the main machine can be thawed after the ISR.

**Why this is not the baseline:** triggers arriving during `EN=0` are
ignored, and the 3-channel dance is asynchronous — if the freeze lands in
the window where DMA1 has completed but its chain trigger to DMA2 has not yet
been accepted (or vice versa), the trigger is lost and the machine never
wakes. Closing this window requires quiescing at a known point, which is
exactly what approach B's safepoints provide — at which point B is simpler.
Keep C as an experiment (it also burns 6+ channels of the 12 available), and
document the failure modes empirically in the emulator; if a race-free freeze
protocol is found it would give true zero-latency preemption and would be a
publishable result on its own.

### 3.4 Approach D — ARM-assisted interrupts (bring-up only)

The ARM core takes the real IRQ, aborts/pauses the fetch channel, rewrites
`READ_ADDR`, saves/restores sniffer state, and resumes. This violates the
"CPU-independent" goal but is trivial to implement and is the right harness
for validating the ISR ABI, the emulator's interrupt model, and xv6's trap
frame layout before the pure-DMA delivery path exists. Also the natural
mechanism for a debugger (breakpoints = patching blocks; single-step =
ARM-paced fetch triggers).

### 3.5 Decision

Adopt **B** as the architecture (with safepoint placement rules in the
compiler), keep **A** as a degenerate fallback (it needs no extra channels),
prototype **D** first as scaffolding, and pursue **C** as a stretch research
item. Latency budget for B: worst-case = longest safepoint-free path; the
compiler should bound it to N blocks (tunable), giving deterministic
worst-case latency of roughly `N / 8M` seconds plus one safepoint — entirely
adequate for a 100 Hz scheduler tick and human-scale GPIO.

---

## 4. Question 2 — Linking when "registers" live in SRAM

The premise to embrace: on this machine, *a register is just a symbol*. The
zero register, flags, LR, and the general-purpose file are ordinary words in
SRAM; the PC and accumulator are MMIO constants. That makes the linking story
*more* conventional than it first appears — everything reduces to 32-bit
absolute addresses in control-block fields.

### 4.1 Register file = linker-allocated symbols

- Define an ABI register file (say `__dma_r0` … `__dma_r15`, `__dma_lr`,
  `__dma_sp`, plus per-ISR banks) emitted into a dedicated section
  (`.dmacpu.regs`, NOLOAD, 4-byte aligned) placed by the linker script into
  striped SRAM. The backend references them as symbols; the linker assigns
  addresses; **no new mechanism is needed** — this is exactly how `.bss`
  variables already work.
- `__dma_zero`: a word initialized to 0 that the toolchain forbids as a
  write destination (assembler diagnostic, not hardware enforcement — SRAM
  has no read-only words). `__dma_null`: the write-only discard ("bit
  bucket").
- **Flags: don't have them.** The paper's conditional-jump idiom computes a
  *block address* from a predicate; a persistent flag register would add
  state for no benefit. Lower LLVM `icmp`+`br` directly into the fused
  compare-and-jump sequence (like a RISC-V-style compare-and-branch ISA).
  If an ABI-visible carry/overflow is ever needed, it is one more SRAM word.

### 4.2 PC and other hardware state = link-time constants

`PC` is not linked at all — it is the fetch channel's `READ_ADDR` register.
Provide the MMIO addresses as linker-script symbols derived from the channel
assignment:

```
__dma_fetch_ch   = 0;                     /* ABI: channels 0,1,2 = machine */
__dma_pc         = 0x50000000 + __dma_fetch_ch * 0x40;
__dma_sniff_data = 0x50000438;
```

Fixing the channel numbers in the ABI (with the injector on ch 3, ISR
machine on 4–6 if approach C is explored) keeps every hardware address a
link-time constant. If runtime channel assignment is ever needed, these
become loader-patched relocations like everything else.

### 4.3 Object format and relocations

An "instruction" is 1–5 control blocks; every field is a 32-bit word; every
operand is an *address* (source, destination, or jump target). Therefore:

- Use **ELF32 with a custom `e_machine` (EM_DMACPU)** and essentially one
  relocation type, `R_DMACPU_ABS32` (plus `R_DMACPU_ABS32_ADD16` style
  variants only if the ±16-byte conditional-jump offset trick needs linker
  awareness — it usually doesn't, since both targets are labels).
  Word-granular, no bit-slicing, no PC-relative forms: the easiest
  relocation model any backend has ever had.
- Immediates cannot be encoded in instructions — a block moves memory to
  memory — so **every constant is a literal-pool entry**. The assembler
  interns constants into a mergeable section (`.dmacpu.lit`,
  `SHF_MERGE|4`), and the linker deduplicates. "Load immediate" is a move
  whose `READ_ADDR` relocates to the literal.
- **Alignment constraints the linker must enforce:** program sections
  16-byte aligned (block size; also the unit the conditional-jump
  `ADDR`/`ADDR+16` arithmetic assumes), any increment/jump lookup tables
  256-byte aligned, ring-buffer-addressed data naturally aligned.

### 4.4 Static linking vs. load-time relocation

Two tiers, both worth having:

1. **Tier 1 (first):** fully static link at a fixed SRAM layout via linker
   script. The loader is `memcpy` + machine start. Right answer for
   bare-metal tests and the emulator loop.
2. **Tier 2 (for the loader project and xv6 exec()):** keep the relocation
   table in the loadable image (a trimmed `.rela.dmacpu`). The loader adds
   the chosen program base to every text-address fixup and the register/data
   base to every data fixup. Because all relocations are ABS32, the loader
   is a ~50-line fixup loop — this is the DMA machine's answer to position
   independence (there is no PC-relative addressing to lean on).

### 4.5 LLVM backend shape

The pitfall to avoid is modeling this as an accumulator machine in
SelectionDAG (pure single-accumulator targets fight the register allocator).
Instead:

- Define a **pseudo 3-address ISA over 16 virtual "registers"** that are
  really the SRAM symbols of §4.1. The register allocator runs normally;
  "spills" are just more SRAM words (cheap — same cost as a register!).
- Lower each pseudo-instruction to its block sequence late (AsmPrinter/MC):
  `ADD rd, rs1, rs2` → 3 blocks (load sniffer / add-pass / store), etc.,
  mirroring the DMAasm macro table in `doc/ece4760.pdf` pp. 4–5.
- MC emits 16-byte blocks with ABS32 fixups; the "encoder" writes 4 words.
- Target triple `dmacpu-unknown-none`; ILP32; no FP (softfloat or none);
  `char` = 8-bit but note sub-word stores use the DMA width field.

**De-risking order:** do *not* start with LLVM. Build a standalone assembler
(`dmaasm`) + linker semantics first (§5, phase 2) to lock the ABI, then the
LLVM backend targets that assembler's object format. If the SelectionDAG port
stalls, a custom LLVM-IR-to-dmaasm translator is a viable interim compiler.

### 4.6 Text is data (and that's load-bearing)

Indirect jumps, the DDS-style computed addressing, and approach B's
dispatcher all *write into program text or into other instructions' fields*.
Consequences:

- `.dmacpu.text` must be writable (no W^X — document this as a security
  property, or rather the absence of one).
- The assembler needs syntax for addressing a field of a labeled
  instruction (e.g. `label.read_addr`) so self-modifying idioms get proper
  relocations instead of hand-counted offsets — the paper's "had to count
  the blocks" comment is exactly what the toolchain must eliminate.

---

## 5. Development plan

Each phase produces a CLI-testable artifact so a coding agent can iterate
autonomously (emulator-first, hardware-in-the-loop as a later CI stage).

**Language policy: every tool we build ourselves is written in Go** — the
`dmaemu` emulator, the `dmaasm` assembler and linker, the image
packer/relocation tooling, host-side HIL/test harnesses. One language, one
module, `go build` and no dependency management beyond `go.mod`. The only
exceptions are code that cannot be Go: the LLVM/Clang backend itself (C++,
upstream requirement, Phase 4) and target-side code that runs on the Pico
(the ARM-side loader stub in C with the Pico SDK, and DMA programs
themselves).

### Phase 0 — Ground truth (foundation for the agent loop)

1. Fetch the reference test programs (code ZIPs referenced in
   `doc/ece4760.pdf`) into a git-ignored local directory — they are
   copyrighted and must not be committed (see Coding rules) — and get them
   running on a real Pico with the C-macro "assembler"; capture GPIO/UART
   golden outputs.
2. **Write `dmaemu`, a DMA-machine-level emulator (Go)**: control-block
   interpreter + sniffer (add/CRC32, bswap, bit-reverse, inversion) + atomic
   aliases + chain/TREQ/DREQ model + a bus-transaction trace. Deliberately
   *not* a full-chip emulator — model exactly the semantics the machine
   uses, at block granularity, deterministically. Validate against the
   golden outputs from step 1. (Full-chip emulators like rp2040js/Wokwi can
   serve as a cross-check, but a purpose-built emulator gives the
   determinism, speed, and introspection the compiler test loop needs.)
3. CI skeleton: `make test` runs assembler+emulator golden tests; optional
   `make test-hw` flashes via picotool/OpenOCD and diffs UART/GPIO capture.

### Phase 1 — Loader

4. Define the Tier-1 image format (flat blocks + entry + data init) and the
   ARM-side loader: copy sections, initialize the register file, configure
   channels 0–2, start the machine. Test in `dmaemu` and on hardware.
5. Add Tier-2 relocatable images + the fixup loop (§4.4).

### Phase 2 — Toolchain v0 (pre-LLVM)

6. `dmaasm`: standalone assembler (Go) implementing the DMAasm
   instruction set, labels, instruction-field addressing (§4.6), literal
   pools, and the ELF/relocation model of §4.3, plus a minimal linker.
   Re-express the reference tests in it; byte-identical block output is the
   acceptance test.
7. Freeze ABI v0: register file, channel assignment, calling convention
   (args in `r0..r3`, SRAM stack via `__dma_sp`, LR word), safepoint rules.

### Phase 3 — Interrupts

8. Implement approach D (ARM-assisted) to validate the ISR ABI and add
   interrupt support to `dmaemu` (DREQ event injection with controllable
   timing — including adversarial timing to hunt races).
9. Implement approach B: dispatcher word, injector channel, PWM/pacing-timer
   tick, PIO GPIO-edge bridge. Acceptance: a scheduler-tick blinky and a
   GPIO-echo program, running with zero ARM involvement after load, in
   emulator and on hardware. Measure delivery latency distribution.
10. (Stretch) Explore approach C freeze/thaw in the emulator; document the
    trigger-loss races precisely.

### Phase 4 — LLVM

11. LLVM backend per §4.5 (pseudo-ISA, late block expansion, MC + ELF
    emission), lld support (trivial: ABS32 + alignment), clang driver bits
    (`--target=dmacpu-unknown-none`, linker scripts, crt0 that sets up
    `__dma_sp` and calls `main`).
12. Compiler test loop for the agent: llvm-lit + csmith-style differential
    testing — compile, run in `dmaemu`, compare against host execution.
    This is where the emulator investment pays off.

### Phase 5 — Toward xv6

13. Runtime: memcpy/memset (native talent!), software mul/div/shift
    library, minimal libc subset.
14. **Honest xv6 assessment — two hard problems beyond interrupts:**
    - *No MMU:* xv6 fundamentally assumes paging. Target an MMU-less
      derivative (xv6 semantics with single address space + cooperative or
      tick-preemptive scheduling — closer to xv6-on-uclinux than a port).
      Process isolation is by convention (or by loader-time relocation,
      §4.4 Tier 2, giving each process its own register bank and text —
      the memory-register model makes per-process register banks free).
    - *Code density:* full blocks are 16 B and an average instruction is
      ~3–5 blocks ≈ 48–80 B/instruction; a multi-thousand-line kernel will
      not fit in 264 KB SRAM. Mitigations to evaluate in order: compact
      control-block formats via the register aliases (datasheet §2.5.2.1
      allows blocks as small as one word for restricted instruction
      shapes — a "compressed instruction set"); streaming overlays from
      flash (`DREQ_XIP_STREAM` can feed block images from XIP); or a
      DMA-hosted bytecode interpreter trading ~10× speed for ~10× density.
      RP2350 relieves pressure (520 KB SRAM, 16 channels) and should be the
      xv6 target; RP2040 remains the toolchain reference target.
15. Milestone ladder: timer-preemptive round-robin of two DMA "processes" →
    syscall via software-interrupt idiom (a block that patches
    `dispatch_target` itself) → UART console shell → xv6-derived kernel.

### Risks (ranked)

1. **Code density vs. SRAM** — the existential risk for goal 3; measure
   early (phase 2 gives bytes/instruction for real programs).
2. **Approach C races** — mitigated by making B the architecture.
3. **LLVM accumulator-machine friction** — mitigated by the pseudo-ISA
   design and the dmaasm fallback path.
4. **Emulator fidelity** (DREQ credit timing, alias write ordering) —
   mitigated by golden-model HIL diffing from phase 0.
5. **Channel budget** — machine (3) + injector (1) leaves 8 on RP2040 for
   peripherals/video; fine unless approach C or VGA-class output is added.

### Coding rules

1. The reference docs and code (`doc/ece4760.pdf` and the code ZIPs it
   links) are copyrighted by their author and not OSS.
   Do not commit the files in the Git repo.
2. Write the code, comments, and docs in English.

### Immediate next steps

1. Fetch the reference code ZIPs linked from `doc/ece4760.pdf` (local,
   git-ignored — see Coding rules).
2. Start Phase 0: golden tests on hardware + `dmaemu` (Go) core loop.
