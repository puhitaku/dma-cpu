package dmaasm_test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
	"github.com/puhitaku/dma-cpu/prog"
)

func forEachVariant(t *testing.T, fn func(t *testing.T, v *emu.Variant)) {
	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) { fn(t, v) })
	}
}

// assembleRun assembles src for v, loads it, runs until `done` is written
// (or idle if the program has no done symbol), and returns machine+result.
func assembleRun(t *testing.T, v *emu.Variant, src string, maxCycles uint64) (*emu.Machine, *dmaasm.Result, emu.RunResult) {
	t.Helper()
	res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v})
	if err != nil {
		t.Fatal(err)
	}
	m := emu.NewMachine(v)
	if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
		t.Fatal(err)
	}
	rc := emu.RunConfig{MaxCycles: maxCycles}
	if done, ok := res.Symbols["done"]; ok {
		rc.WatchWrites = []uint32{done}
	}
	rr, err := m.Run(rc)
	if err != nil {
		t.Fatal(err)
	}
	return m, res, rr
}

func peekSym(t *testing.T, m *emu.Machine, res *dmaasm.Result, name string) uint32 {
	t.Helper()
	addr, err := res.Symbol(name)
	if err != nil {
		t.Fatal(err)
	}
	return m.Peek32(addr)
}

// TestHILPrograms runs every embedded HIL program on both SKUs and pins
// results and cycle counts (cycle counts are the block-sequence acceptance
// test: a lowering change shows up as a cycle diff).
func TestHILPrograms(t *testing.T) {
	cases := []struct {
		file   string
		checks map[string]uint32
		cycles uint64
	}{
		{"add", map[string]uint32{"r": 0x3333, "done": 1}, 23},
		{"logic", map[string]uint32{"rOr": 0x0FFF3FF5, "rAnd": 0x000F0350, "rXor": 0x0FF03CA5, "done": 1}, 59},
		{"condjump", map[string]uint32{"r": 0x505, "done": 1}, 47},
		{"gpio", map[string]uint32{"done": 1}, 23},
	}
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		for _, tc := range cases {
			t.Run(tc.file, func(t *testing.T) {
				src, err := prog.HIL(tc.file)
				if err != nil {
					t.Fatal(err)
				}
				m, res, rr := assembleRun(t, v, src, 100_000)
				if rr.Reason != emu.StopWatch {
					t.Fatalf("did not reach done: %+v", rr)
				}
				for sym, want := range tc.checks {
					if got := peekSym(t, m, res, sym); got != want {
						t.Errorf("%s = %#x, want %#x", sym, got, want)
					}
				}
				if rr.Cycles != tc.cycles {
					t.Errorf("cycles = %d, want %d (block lowering changed?)", rr.Cycles, tc.cycles)
				}
			})
		}
	})
}

// TestCondJumpNegative patches the input via the symbol table and checks
// the negative path.
func TestCondJumpNegative(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		src, err := prog.HIL("condjump")
		if err != nil {
			t.Fatal(err)
		}
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
		}
		m := emu.NewMachine(v)
		if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
			t.Fatal(err)
		}
		vin, _ := res.Symbol("vin")
		m.Poke32(vin, ^uint32(5)+1) // -5
		done, _ := res.Symbol("done")
		rr, err := m.Run(emu.RunConfig{MaxCycles: 100_000, WatchWrites: []uint32{done}})
		if err != nil || rr.Reason != emu.StopWatch {
			t.Fatalf("run: %+v %v", rr, err)
		}
		if got := peekSym(t, m, res, "r"); got != 0x909 {
			t.Errorf("r = %#x, want 0x909", got)
		}
	})
}

func TestPerfLoops(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		src, err := prog.HIL("perf")
		if err != nil {
			t.Fatal(err)
		}
		m, res, rr := assembleRun(t, v, src, 10_000)
		if rr.Reason != emu.StopMaxCycles {
			t.Fatalf("perf loop stopped: %+v", rr)
		}
		if peekSym(t, m, res, "counter") == 0 {
			t.Error("counter did not advance")
		}
	})
}

// TestMacros exercises sub/shl/mulc/nop and pins their results.
func TestMacros(t *testing.T) {
	src := `
.data
.regs
a:    .word 1000
b:    .word 250
rsub: .word 0
rshl: .word 0
rmul: .word 0
done: .word 0
.text
.entry start
start:
    sub a, b, rsub
    shl a, rshl
    mulc a, 7, rmul
    nop
    move $1, done
    halt
`
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m, res, rr := assembleRun(t, v, src, 100_000)
		if rr.Reason != emu.StopWatch {
			t.Fatalf("did not finish: %+v", rr)
		}
		for sym, want := range map[string]uint32{"rsub": 750, "rshl": 2000, "rmul": 7000} {
			if got := peekSym(t, m, res, sym); got != want {
				t.Errorf("%s = %d, want %d", sym, got, want)
			}
		}
	})
}

func TestCallRet(t *testing.T) {
	src := `
.data
.regs
x:    .word 20
y:    .word 22
r:    .word 0
done: .word 0
.text
.entry start
start:
    call fn
    move $1, done
    halt
fn:
    add x, y, r
    ret
`
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m, res, rr := assembleRun(t, v, src, 100_000)
		if rr.Reason != emu.StopWatch {
			t.Fatalf("did not finish: %+v", rr)
		}
		if got := peekSym(t, m, res, "r"); got != 42 {
			t.Errorf("r = %d, want 42", got)
		}
	})
}

// TestFieldAddressing rewrites another instruction's READ_ADDR field
// (self-modifying code, the machine's core idiom).
func TestFieldAddressing(t *testing.T) {
	src := `
.data
.regs
oldv: .word 0xDEAD
newv: .word 0xC0DE
r:    .word 0
done: .word 0
.text
.entry start
start:
    move $newv, tgt.read    ; patch the next instruction's source
tgt:
    move oldv, r
    move $1, done
    halt
`
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m, res, rr := assembleRun(t, v, src, 100_000)
		if rr.Reason != emu.StopWatch {
			t.Fatalf("did not finish: %+v", rr)
		}
		if got := peekSym(t, m, res, "r"); got != 0xC0DE {
			t.Errorf("r = %#x, want 0xc0de (patch did not land)", got)
		}
	})
}

// TestSKUPortability: identical source must assemble for both SKUs, run
// identically, and produce different binaries.
func TestSKUPortability(t *testing.T) {
	src, err := prog.HIL("add")
	if err != nil {
		t.Fatal(err)
	}
	bins := map[string][]byte{}
	for _, v := range emu.Variants {
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
		}
		raw, err := res.Image.Encode()
		if err != nil {
			t.Fatal(err)
		}
		bins[v.Name] = raw
	}
	if string(bins["rp2040"]) == string(bins["rp2350"]) {
		t.Error("binaries identical across SKUs — ctrl words not SKU-resolved?")
	}
}

// TestDeterminism: assembling twice yields identical bytes.
func TestDeterminism(t *testing.T) {
	src, _ := prog.HIL("logic")
	enc := func() string {
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: emu.RP2350})
		if err != nil {
			t.Fatal(err)
		}
		raw, err := res.Image.Encode()
		if err != nil {
			t.Fatal(err)
		}
		return string(raw)
	}
	if enc() != enc() {
		t.Error("assembly is not deterministic")
	}
}

func TestErrors(t *testing.T) {
	cases := map[string]string{
		"unknown instruction": ".text\n.entry s\ns: frobnicate a, b\n",
		"undefined symbol":    ".text\n.entry s\ns: move a, b\nhalt\n",
		"duplicate label":     ".data\nx: .word 1\nx: .word 2\n.text\n.entry s\ns: halt\n",
		"missing entry":       ".text\ns: halt\n",
		"regs required":       ".data\na: .word 1\nb: .word 2\nr: .word 0\n.text\n.entry s\ns: add a, b, r\n",
		"bad field":           ".data\n.regs\n.text\n.entry s\ns: move $1, s.bogus\nhalt\n",
		"entry not in text":   ".data\nx: .word 1\n.text\n.entry x\ns: halt\n",
		"instr in data":       ".data\nhalt\n.text\n.entry s\ns: halt\n",
	}
	for name, src := range cases {
		t.Run(name, func(t *testing.T) {
			if _, err := dmaasm.Assemble(src, dmaasm.Options{Variant: emu.RP2040}); err == nil {
				t.Error("expected error")
			} else if !strings.Contains(err.Error(), "line") && name != "missing entry" && name != "entry not in text" {
				t.Errorf("error lacks line info: %v", err)
			}
		})
	}
}

// TestFullRangeComparisons sweeps jlt/jltu/jeq/jsign/jbool/and/andn over
// operand pairs covering the full 32-bit range — including magnitudes
// >= 2^28 where jneg's byte-swap trick breaks down — and checks every
// result against Go's semantics.
var cmpSweepSrc = `
.data
.regs
a:     .word 0
b:     .word 0
rlt:   .word 7
rltu:  .word 7
req:   .word 7
rsign: .word 7
rbool: .word 7
rand:  .word 7
randn: .word 7
done:  .word 0
.text
.entry start
start:
    jlt a, b, lt_t, lt_f
lt_t: move $1, rlt
      jump c2
lt_f: move $0, rlt
c2:
    jltu a, b, ltu_t, ltu_f
ltu_t: move $1, rltu
       jump c3
ltu_f: move $0, rltu
c3:
    jeq a, b, eq_t, eq_f
eq_t: move $1, req
      jump c4
eq_f: move $0, req
c4:
    jsign a, sg_t, sg_f
sg_t: move $1, rsign
      jump c5
sg_f: move $0, rsign
c5:
    jbool req, jb_z, jb_o
jb_z: move $100, rbool
      jump c6
jb_o: move $200, rbool
c6:
    and a, b, rand
    andn a, b, randn
    move $1, done
    halt
`

func TestFullRangeComparisons(t *testing.T) {
	src := cmpSweepSrc
	vals := []uint32{
		0, 1, 2, 5, 0x7F, 0x80, 0x100,
		0x0FFFFFFF, 0x10000000, 0x7FFFFFFF,
		0x80000000, 0x80000001, 0xF0000000,
		0xFFFFFFFE, 0xFFFFFFFF,
	}
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
		}
		for _, av := range vals {
			for _, bv := range vals {
				m := emu.NewMachine(v)
				if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
					t.Fatal(err)
				}
				aAddr, _ := res.Symbol("a")
				bAddr, _ := res.Symbol("b")
				done, _ := res.Symbol("done")
				m.Poke32(aAddr, av)
				m.Poke32(bAddr, bv)
				rr, err := m.Run(emu.RunConfig{MaxCycles: 100_000, WatchWrites: []uint32{done}})
				if err != nil || rr.Reason != emu.StopWatch {
					t.Fatalf("a=%#x b=%#x: did not finish: %+v %v", av, bv, rr, err)
				}
				b2u := func(x bool) uint32 {
					if x {
						return 1
					}
					return 0
				}
				eq := b2u(av == bv)
				want := map[string]uint32{
					"rlt":   b2u(int32(av) < int32(bv)),
					"rltu":  b2u(av < bv),
					"req":   eq,
					"rsign": b2u(int32(av) < 0),
					"rbool": 100 + 100*eq,
					"rand":  av & bv,
					"randn": av &^ bv,
				}
				for sym, w := range want {
					if got := peekSym(t, m, res, sym); got != w {
						t.Errorf("a=%#x b=%#x: %s = %#x, want %#x", av, bv, sym, got, w)
					}
				}
			}
		}
	})
}

// TestArenaPacking: more than 8 comparisons forces a second trampoline
// bank; all must still dispatch correctly.
func TestArenaPacking(t *testing.T) {
	var sb strings.Builder
	sb.WriteString(".data\n.regs\nx: .word 5\nr: .word 0\ndone: .word 0\n.text\n.entry start\nstart:\n")
	for i := 0; i < 10; i++ {
		fmt.Fprintf(&sb, "  jeq x, $%d, hit%d, miss%d\nhit%d: add r, $1, r\nmiss%d:\n", i, i, i, i, i)
	}
	sb.WriteString("  move $1, done\n  halt\n")
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m, res, rr := assembleRun(t, v, sb.String(), 100_000)
		if rr.Reason != emu.StopWatch {
			t.Fatalf("did not finish: %+v", rr)
		}
		if got := peekSym(t, m, res, "r"); got != 1 {
			t.Errorf("r = %d, want 1 (exactly the x==5 case)", got)
		}
	})
}

// TestIRQProgram runs the approach-B interrupt program end to end in the
// emulator: injector armed on an external DREQ, delivery at a safepoint,
// ISR, EOI, re-arm, resume — twice.
func TestIRQProgram(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		src, err := prog.HIL("irq")
		if err != nil {
			t.Fatal(err)
		}
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
		}
		m := emu.NewMachine(v)
		if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
			t.Fatal(err)
		}
		// Arm the injector: ch3 copies *isrvec over dispatch on DREQ.
		isrvec, _ := res.Symbol("isrvec")
		dispatch, _ := res.Symbol("dispatch")
		isrcount, _ := res.Symbol("isrcount")
		counter, _ := res.Symbol("counter")
		const injCh = 3
		injCtrl := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
			v.CtrlTreq(v.DreqPIO0RX0) | v.CtrlChainTo(injCh) | v.CtrlIRQQuiet
		m.Poke32(emu.ChanRegAddr(injCh, emu.OffAl1ReadAddr), isrvec)
		m.Poke32(emu.ChanRegAddr(injCh, emu.OffAl1WriteAddr), dispatch)
		m.Poke32(emu.ChanRegAddr(injCh, emu.OffTransCount), 1)
		m.Poke32(emu.ChanRegAddr(injCh, emu.OffCtrlTrig), injCtrl)

		if _, err := m.Run(emu.RunConfig{MaxCycles: 2000}); err != nil {
			t.Fatal(err)
		}
		if got := m.Peek32(isrcount); got != 0 {
			t.Fatalf("spurious ISR: %d", got)
		}
		c1 := m.Peek32(counter)

		for i := uint32(1); i <= 2; i++ {
			m.PulseDREQ(v.DreqPIO0RX0)
			rr, err := m.Run(emu.RunConfig{MaxCycles: 2000, WatchWrites: []uint32{isrcount}})
			if err != nil || rr.Reason != emu.StopWatch {
				t.Fatalf("delivery %d: %+v %v", i, rr, err)
			}
			if got := m.Peek32(isrcount); got != i {
				t.Fatalf("isrcount = %d, want %d", got, i)
			}
			if _, err := m.Run(emu.RunConfig{MaxCycles: 2000}); err != nil {
				t.Fatal(err)
			}
		}
		if c2 := m.Peek32(counter); c2 <= c1 {
			t.Fatalf("main loop did not resume: %d -> %d", c1, c2)
		}
	})
}

// TestPollProgram runs the approach-A polling program: raising is a
// memory write of a negative value; the handler acknowledges.
func TestPollProgram(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		src, err := prog.HIL("poll")
		if err != nil {
			t.Fatal(err)
		}
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
		}
		m := emu.NewMachine(v)
		if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
			t.Fatal(err)
		}
		pending, _ := res.Symbol("pending")
		isrcount, _ := res.Symbol("isrcount")
		counter, _ := res.Symbol("counter")

		if _, err := m.Run(emu.RunConfig{MaxCycles: 2000}); err != nil {
			t.Fatal(err)
		}
		if got := m.Peek32(isrcount); got != 0 {
			t.Fatalf("spurious ISR: %d", got)
		}
		// Raise with -1: jneg's byte-swap trick needs |value| < 2^28, so
		// 0x80000000 would NOT be seen as negative (doc/abi.md).
		m.Poke32(pending, 0xFFFFFFFF)
		rr, err := m.Run(emu.RunConfig{MaxCycles: 2000, WatchWrites: []uint32{isrcount}})
		if err != nil || rr.Reason != emu.StopWatch {
			t.Fatalf("delivery: %+v %v", rr, err)
		}
		if got := m.Peek32(pending); got != 0 {
			t.Errorf("pending not acknowledged: %#x", got)
		}
		c1 := m.Peek32(counter)
		if _, err := m.Run(emu.RunConfig{MaxCycles: 2000}); err != nil {
			t.Fatal(err)
		}
		if c2 := m.Peek32(counter); c2 <= c1 {
			t.Fatalf("main loop did not resume: %d -> %d", c1, c2)
		}
	})
}

// TestLoopOverhead pins the steady-state cost per loop iteration of the
// two delivery mechanisms: approach B's safepoint vs approach A's poll.
func TestLoopOverhead(t *testing.T) {
	v := emu.RP2350
	measure := func(file, counterSym string) uint64 {
		src, err := prog.HIL(file)
		if err != nil {
			t.Fatal(err)
		}
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
		}
		m := emu.NewMachine(v)
		if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
			t.Fatal(err)
		}
		const cycles = 6000
		if _, err := m.Run(emu.RunConfig{MaxCycles: cycles}); err != nil {
			t.Fatal(err)
		}
		addr, _ := res.Symbol(counterSym)
		iters := m.Peek32(addr)
		if iters == 0 {
			t.Fatalf("%s: no iterations", file)
		}
		return cycles / uint64(iters)
	}
	irq := measure("irq", "counter")
	poll := measure("poll", "counter")
	t.Logf("cycles/iteration: irq (safepoint) = %d, poll (jneg) = %d", irq, poll)
	// B's safepoint loop: add(3)+safepoint(2)+jump(1)+thunk(1) = 7 blocks;
	// A's poll loop: add(3)+jneg-not-taken(5)+jump(1) = 9 blocks.
	if irq >= poll {
		t.Errorf("safepoint loop should be cheaper than polling loop (%d vs %d)", irq, poll)
	}
}
