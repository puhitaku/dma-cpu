package emu_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/emu"
)

// TestCompactMachineRaw hand-builds the Tier-C compact machine
// (channel-bank design): the fetch channel copies 8-byte records
// (READ_ADDR, WRITE_ADDR) into the alias-2 tail of one of several exec
// channels — one per mode, each with a static CTRL (plain / always-
// sniffed / bswap / ...). TRANS_COUNT reloads from its preset value on
// every WRITE_ADDR trigger. Switching modes is one record that rewrites
// the fix channel's scratch word with the new window address; no CTRL
// register is ever written by the machine. The all-zero record is HALT:
// a null WRITE_ADDR trigger drops the transfer and raises the quiet
// null-trigger IRQ (the silicon-verified classic HALT semantics).
//
// Mode-domain rules encoded here (the assembler must follow them):
//   - a switch-out-of-bswap record's window-pointer literal is
//     pre-swapped (the record's data passes through the byte-swapper);
//   - sniffer results are read while still on the sniff channel (the
//     delivered data is exact; self-accumulation only pollutes the dead
//     accumulator), and the accumulator is seeded from an unsniffed
//     channel.
func TestCompactMachineRaw(t *testing.T) {
	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) {
			m := emu.NewMachine(v)
			const (
				ePlain, eSniff, eBswap = 0, 1, 2
				fetch, fix             = 4, 5
				text                   = uint32(0x20000000)
				data                   = uint32(0x20010000)
				scratch                = uint32(0x2003FF00)
			)
			window := func(ch int) uint32 { return emu.ChanRegAddr(ch, emu.OffAl2ReadAddr) }
			bswap32 := func(x uint32) uint32 {
				return x<<24 | x>>24 | x<<8&0x00FF0000 | x>>8&0x0000FF00
			}

			// Data.
			const (
				litA = 0x11223344
				litB = 0xAABBCCDD
			)
			d := data
			addr := func(val uint32) uint32 { m.Poke32(d, val); a := d; d += 4; return a }
			aA := addr(litA)
			aB := addr(litB)
			aSeed := addr(0x1000)
			aAddend := addr(0x0000F00D)
			aWinSniff := addr(window(eSniff))
			aWinBswap := addr(window(eBswap))
			aWinPlain := addr(window(ePlain))
			aWinPlainSwapped := addr(bswap32(window(ePlain)))
			dst0, dst1, dst2, null, sum := d, d+4, d+8, d+12, d+16
			d += 20

			// Program.
			recs := [][2]uint32{
				{aA, dst0},                  // E0: dst0 = A
				{aWinBswap, scratch},        // E0: switch -> bswap bank
				{aB, dst1},                  // E2: dst1 = bswap(B)
				{aWinPlainSwapped, scratch}, // E2: switch -> plain (literal pre-swapped)
				{dst0, dst2},                // E0: dst2 = dst0
				{aSeed, v.SniffDataAddr()},  // E0: accumulator = 0x1000 (unsniffed, exact)
				{aWinSniff, scratch},        // E0: switch -> sniff bank
				{aAddend, null},             // E1: accumulator += 0xF00D
				{v.SniffDataAddr(), sum},    // E1: sum = 0x1F00D (read exact; self-add is dead)
				{aWinPlain, scratch},        // E1: switch -> plain (dead pollution)
				{0, 0},                      // E0: HALT (null trigger)
			}
			p := text
			for _, r := range recs {
				m.Poke32(p, r[0])
				m.Poke32(p+4, r[1])
				p += 8
			}

			// Sniffer: SUM over the always-sniffed exec channel.
			m.Poke32(v.SniffCtrlAddr(), emu.SniffCtrlEN|emu.SniffCtrlDmach(eSniff)|emu.SniffCtrlCalc(emu.SniffCalcSum))
			m.Poke32(v.SniffDataAddr(), 0)

			// Exec bank: static CTRL + reloading TRANS_COUNT=1 each.
			bank := map[int]uint32{
				ePlain: 0,
				eSniff: v.CtrlSniffEn,
				eBswap: v.CtrlBswap,
			}
			for ch, extra := range bank {
				regs := emu.ChanRegAddr(ch, 0)
				m.Poke32(regs+emu.OffAl1Ctrl,
					emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(fix)|v.CtrlIRQQuiet|extra)
				m.Poke32(regs+emu.OffAl2TransCount, 1)
			}

			// Fix: scratch (current window pointer) -> fetch AL2_WRITE_ADDR_TRIG.
			m.Poke32(scratch, window(ePlain))
			fixRegs := emu.ChanRegAddr(fix, 0)
			m.Poke32(fixRegs+emu.OffAl1ReadAddr, scratch)
			m.Poke32(fixRegs+emu.OffAl1WriteAddr, emu.ChanRegAddr(fetch, emu.OffAl2WriteAddrTrig))
			m.Poke32(fixRegs+emu.OffAl2TransCount, 1)
			m.Poke32(fixRegs+emu.OffAl1Ctrl,
				emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(fix)|v.CtrlIRQQuiet)

			// Fetch: two words per record into the current window.
			fetchRegs := emu.ChanRegAddr(fetch, 0)
			m.Poke32(fetchRegs+emu.OffReadAddr, text)
			m.Poke32(fetchRegs+emu.OffWriteAddr, window(ePlain))
			m.Poke32(fetchRegs+emu.OffTransCount, 2)
			m.Poke32(fetchRegs+emu.OffCtrlTrig,
				emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|v.CtrlIncrWrite|
					v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(fetch)|v.CtrlIRQQuiet)

			res, err := m.Run(emu.RunConfig{MaxCycles: 10_000})
			if err != nil {
				t.Fatal(err)
			}
			if res.Reason != emu.StopIdle {
				t.Fatalf("machine did not halt: %+v", res)
			}
			checks := map[string]struct{ addr, want uint32 }{
				"dst0 (plain move)":  {dst0, litA},
				"dst1 (bswap move)":  {dst1, 0xDDCCBBAA},
				"dst2 (post-switch)": {dst2, litA},
				"sum (sniffer add)":  {sum, 0x1000 + 0xF00D},
			}
			for name, c := range checks {
				if got := m.Peek32(c.addr); got != c.want {
					t.Errorf("%s = %#x, want %#x", name, got, c.want)
				}
			}
			// The all-zero record must raise the null-trigger IRQ on the
			// plain exec channel (end-of-chain notification).
			if intr := m.Peek32(v.IntrAddr()); intr&(1<<ePlain) == 0 {
				t.Errorf("halt did not raise INTR for the plain channel: %#x", intr)
			}
		})
	}
}
