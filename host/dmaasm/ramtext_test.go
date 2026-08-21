package dmaasm_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
)

// ramtextSrc executes its main text from the flash XIP window and keeps
// its one self-modifying stub (an indirect load, patched via .read) in
// the RAM-resident .ramtext region.
const ramtextSrc = `
.entry main
.data
.regs
ptr:  .word src
src:  .word 0x1234ABCD
v:    .word 0
v2:   .word 0
a:    .word 5
b:    .word 7
done: .word 0

.text
main:
    move ptr, LD.read
    jump LD
back:
    add a, b, v2
    move $1, done
    halt

.ramtext
LD:
    move @0, v
    jump back
`

func TestRAMTextFlashExec(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		for _, compact := range []bool{false, true} {
			name := "classic"
			cfg := img.DefaultMachine()
			if compact {
				name = "compact"
				cfg = img.CompactMachine()
			}
			t.Run(name, func(t *testing.T) {
				res, err := dmaasm.Assemble(ramtextSrc, dmaasm.Options{
					Variant:     v,
					TextBase:    0x10080000,
					DataBase:    0x20010000,
					RAMTextBase: 0x20018000,
					Compact:     compact,
				})
				if err != nil {
					t.Fatal(err)
				}
				if n := len(res.Image.Segments); n != 3 {
					t.Fatalf("got %d segments, want 3", n)
				}
				if a := res.Symbols["LD"]; a < 0x20018000 {
					t.Fatalf("LD not in ramtext: %#x", a)
				}
				if a := res.Symbols["back"]; a < 0x10080000 || a >= 0x20000000 {
					t.Fatalf("back not in flash text: %#x", a)
				}
				m := emu.NewMachine(v)
				m.Flash = make([]byte, 1<<20)
				if err := res.Image.LoadAndStart(m, nil, cfg); err != nil {
					t.Fatal(err)
				}
				done, _ := res.Symbol("done")
				rr, err := m.Run(emu.RunConfig{MaxCycles: 100_000, WatchWrites: []uint32{done}})
				if err != nil {
					t.Fatal(err)
				}
				if rr.Reason != emu.StopWatch {
					t.Fatalf("did not reach done: %+v", rr)
				}
				if got := peekSym(t, m, res, "v"); got != 0x1234ABCD {
					t.Errorf("v = %#x, want 0x1234abcd", got)
				}
				if got := peekSym(t, m, res, "v2"); got != 12 {
					t.Errorf("v2 = %d, want 12", got)
				}
			})
		}
	})
}
