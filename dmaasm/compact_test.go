package dmaasm_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
	"github.com/puhitaku/dma-cpu/prog"
)

// assembleRunCompact assembles src in compact (8-byte record) mode,
// loads it on the compact machine, and runs to the done-write or cap.
func assembleRunCompact(t *testing.T, v *emu.Variant, src string, maxCycles uint64) (*emu.Machine, *dmaasm.Result, emu.RunResult) {
	t.Helper()
	res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v, Compact: true})
	if err != nil {
		t.Fatal(err)
	}
	m := emu.NewMachine(v)
	if err := res.Image.LoadAndStart(m, nil, img.CompactMachine()); err != nil {
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

// TestCompactHILPrograms: the classic golden programs must behave
// identically under the compact encoding (results, not cycles).
func TestCompactHILPrograms(t *testing.T) {
	cases := []struct {
		file   string
		checks map[string]uint32
	}{
		{"add", map[string]uint32{"r": 0x3333, "done": 1}},
		{"logic", map[string]uint32{"rOr": 0x0FFF3FF5, "rAnd": 0x000F0350, "rXor": 0x0FF03CA5, "done": 1}},
		{"condjump", map[string]uint32{"r": 0x505, "done": 1}},
		{"gpio", map[string]uint32{"done": 1}},
	}
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		for _, tc := range cases {
			t.Run(tc.file, func(t *testing.T) {
				src, err := prog.HIL(tc.file)
				if err != nil {
					t.Fatal(err)
				}
				m, res, rr := assembleRunCompact(t, v, src, 200_000)
				if rr.Reason != emu.StopWatch {
					t.Fatalf("did not reach done: %+v", rr)
				}
				for sym, want := range tc.checks {
					if got := peekSym(t, m, res, sym); got != want {
						t.Errorf("%s = %#x, want %#x", sym, got, want)
					}
				}
			})
		}
	})
}

// TestCompactComparisons: the full-range comparison sweep, compact.
func TestCompactComparisons(t *testing.T) {
	vals := []uint32{
		0, 1, 5, 0x80, 0x0FFFFFFF, 0x10000000, 0x7FFFFFFF,
		0x80000000, 0x80000001, 0xF0000000, 0xFFFFFFFF,
	}
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		res, err := dmaasm.Assemble(cmpSweepSrc, dmaasm.Options{Variant: v, Compact: true})
		if err != nil {
			t.Fatal(err)
		}
		for _, av := range vals {
			for _, bv := range vals {
				m := emu.NewMachine(v)
				if err := res.Image.LoadAndStart(m, nil, img.CompactMachine()); err != nil {
					t.Fatal(err)
				}
				aAddr, _ := res.Symbol("a")
				bAddr, _ := res.Symbol("b")
				done, _ := res.Symbol("done")
				m.Poke32(aAddr, av)
				m.Poke32(bAddr, bv)
				rr, err := m.Run(emu.RunConfig{MaxCycles: 200_000, WatchWrites: []uint32{done}})
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

// TestCompactMacros: sub/shl/mulc/nop, call/ret, and .read/.write field
// patching under the record layout (word 0 / word 1).
func TestCompactMacros(t *testing.T) {
	src := `
.data
.regs
a:    .word 1000
b:    .word 250
rsub: .word 0
rshl: .word 0
rmul: .word 0
rfn:  .word 0
oldv: .word 0xDEAD
newv: .word 0xC0DE
rpat: .word 0
done: .word 0
.text
.entry start
start:
    sub a, b, rsub
    shl a, rshl
    mulc a, 7, rmul
    nop
    call fn
    move $newv, tgt.read
tgt:
    move oldv, rpat
    move $1, done
    halt
fn:
    add a, b, rfn
    ret
`
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m, res, rr := assembleRunCompact(t, v, src, 200_000)
		if rr.Reason != emu.StopWatch {
			t.Fatalf("did not finish: %+v", rr)
		}
		for sym, want := range map[string]uint32{
			"rsub": 750, "rshl": 2000, "rmul": 7000, "rfn": 1250, "rpat": 0xC0DE,
		} {
			if got := peekSym(t, m, res, sym); got != want {
				t.Errorf("%s = %d, want %d", sym, got, want)
			}
		}
	})
}

// TestCompactDensity pins that compact text is materially smaller.
func TestCompactDensity(t *testing.T) {
	src, err := prog.HIL("logic")
	if err != nil {
		t.Fatal(err)
	}
	size := func(compact bool) int {
		res, err := dmaasm.Assemble(src, dmaasm.Options{Variant: emu.RP2350, Compact: compact})
		if err != nil {
			t.Fatal(err)
		}
		return len(res.Image.Segments[0].Data)
	}
	classic, compact := size(false), size(true)
	t.Logf("logic text: classic %d B, compact %d B (%.2fx)", classic, compact, float64(classic)/float64(compact))
	if compact >= classic {
		t.Errorf("compact text (%d) not smaller than classic (%d)", compact, classic)
	}
}
