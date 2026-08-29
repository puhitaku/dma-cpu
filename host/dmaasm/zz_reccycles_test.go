package dmaasm_test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestZZRecordCycles prices one compact record and the two 4-byte
// encodings prompts/043 considers, on the emulator's bus-transfer clock
// (one transfer per cycle, chaining free — the same clock every cycle
// figure in prompts/042 is quoted on).
//
// Measured 2026-08-29 (rp2350): 3.000 cycles for a plain 8-byte record
// (2 fetch transfers + 1 bank transfer), 4.000 for the same record
// reached through the candidate-B pointer indirection (1 fetch + 2
// expand + 1 bank) — +33.3%. The indirection machine below is not a
// sketch: it is built out of real DMA channels and it runs, which is
// what makes candidate B a feasibility question about bytes-per-cycle
// rather than about whether the hardware can do it at all.
//
//	RECCYC=1 go test ./host/dmaasm/ -run TestZZRecordCycles -v
func TestZZRecordCycles(t *testing.T) {
	if os.Getenv("RECCYC") == "" {
		t.Skip("set RECCYC=1 to price a compact record")
	}
	v, _ := emu.VariantByName("rp2350")

	// Baseline: the shipping 8-byte encoding.
	var c1, c2 uint64
	for i, n := range []int{100, 1100} {
		var b strings.Builder
		b.WriteString(".entry _start\n.text\n_start:\n")
		for j := 0; j < n; j++ {
			b.WriteString("    move $1, r0\n")
		}
		b.WriteString("    move $1, done\n    halt\n.data\n.regs\ndone: .word 0\n")
		_, _, rr := assembleRunCompact(t, v, b.String(), 200_000)
		if i == 0 {
			c1 = rr.Cycles
		} else {
			c2 = rr.Cycles
		}
	}
	fmt.Printf("RECCYC classic-compact  %.3f cycles/record\n", float64(c2-c1)/1000)

	d1 := runIndirect(t, v, 100)
	d2 := runIndirect(t, v, 1100)
	fmt.Printf("RECCYC pointer-indirect %.3f cycles/record\n", float64(d2-d1)/1000)
}

// runIndirect builds the candidate-B machine — fetch pulls a 4-byte
// POINTER into an expander channel, which copies the 8-byte dictionary
// entry it names into the plain bank's window — and runs n records
// through it. Channels: 0 = plain bank (chains to fetch), 7 = fetch
// (one 4-byte transfer, 4-byte write ring onto the expander's
// AL3_READ_ADDR_TRIG), 10 = expander (two 32-bit transfers, 8-byte
// write ring onto the bank window).
func runIndirect(t *testing.T, v *emu.Variant, n int) uint64 {
	t.Helper()
	const (
		expand = 10
		dict   = emu.SRAMBase + 0x1000 // 8-byte dictionary entries
		stream = emu.SRAMBase + 0x2000 // 4-byte pointer stream
		one    = emu.SRAMBase + 0x0800
		r0     = emu.SRAMBase + 0x0804
		done   = emu.SRAMBase + 0x0808
	)
	m := emu.NewMachine(v)
	m.Poke32(one, 1)
	// entry 0: move one -> r0. entry 1: move one -> done. entry 2: HALT
	// (the all-zero record: a null trigger, exactly as in the shipping
	// encoding).
	m.Poke32(dict+0, one)
	m.Poke32(dict+4, r0)
	m.Poke32(dict+8, one)
	m.Poke32(dict+12, done)
	m.Poke32(dict+16, 0)
	m.Poke32(dict+20, 0)
	for i := 0; i < n; i++ {
		m.Poke32(stream+uint32(4*i), dict+0)
	}
	m.Poke32(stream+uint32(4*n), dict+8)
	m.Poke32(stream+uint32(4*n+4), dict+16)

	win := emu.ChanRegAddr(emu.CompactPlain, emu.OffAl2ReadAddr)
	m.Poke32(emu.ChanRegAddr(emu.CompactPlain, emu.OffAl2TransCount), 1)
	m.Poke32(emu.ChanRegAddr(emu.CompactPlain, emu.OffAl1Ctrl),
		emu.CompactBankCtrl(v, emu.CompactPlain))

	m.Poke32(emu.ChanRegAddr(expand, emu.OffAl1WriteAddr), win)
	m.Poke32(emu.ChanRegAddr(expand, emu.OffAl2TransCount), 2)
	m.Poke32(emu.ChanRegAddr(expand, emu.OffAl1Ctrl),
		emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|v.CtrlIncrWrite|
			v.CtrlRingSel|v.CtrlRingSize(3)|
			v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(expand)|v.CtrlIRQQuiet)

	f := emu.ChanRegAddr(emu.CompactFetch, 0)
	m.Poke32(f+emu.OffReadAddr, stream)
	m.Poke32(f+emu.OffWriteAddr, emu.ChanRegAddr(expand, emu.OffAl3ReadAddrTrig))
	m.Poke32(f+emu.OffTransCount, 1)
	m.Poke32(f+emu.OffCtrlTrig,
		emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|v.CtrlIncrWrite|
			v.CtrlRingSel|v.CtrlRingSize(2)|
			v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(emu.CompactFetch)|v.CtrlIRQQuiet)

	rr, err := m.Run(emu.RunConfig{MaxCycles: 200_000, WatchWrites: []uint32{done}})
	if err != nil {
		t.Fatal(err)
	}
	if rr.Reason != emu.StopWatch {
		t.Fatalf("indirect machine did not reach done: %+v", rr)
	}
	if got := m.Peek32(r0); got != 1 {
		t.Fatalf("indirect machine wrote r0 = %#x, want 1", got)
	}
	return rr.Cycles
}
