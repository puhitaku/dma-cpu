package dmaasm_test

import (
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
