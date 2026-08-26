package emu_test

import (
	"fmt"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
)

// The silicon-vs-emulator SD divergence, reduced: does an eq-compare
// of 0xFE against the unmasked case constant 0xFFFFFFFE take the
// equal branch anywhere?
func TestEqWidth(t *testing.T) {
	v, _ := emu.VariantByName("rp2350")
	src := `
.data
.regs
res: .word 0
a: .word 0xfe
.text
.entry start
start:
    andn a, $0xffffff00, a
    jeq a, $0xfffffffe, isequal, notequal
isequal:
    move $1, res
    halt
notequal:
    move $2, res
    halt
`
	r, err := dmaasm.Assemble(src, dmaasm.Options{Variant: v, Compact: true,
		TextBase: 0x20002000, DataBase: 0x20010000})
	if err != nil {
		t.Fatal(err)
	}
	m := emu.NewMachine(v)
	if err := r.Image.LoadAndStart(m, nil, img.CompactMachine()); err != nil {
		t.Fatal(err)
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 100000}); err != nil {
		t.Fatal(err)
	}
	resAddr, _ := r.Symbol("res")
	aAddr, _ := r.Symbol("a")
	fmt.Printf("EQW res=%d (1=equal!? 2=not) a=%#x\n", m.Peek32(resAddr), m.Peek32(aAddr))
}
