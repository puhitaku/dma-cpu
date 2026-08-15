package emu

import "math/bits"

// channel holds the architectural and internal state of one DMA channel.
type channel struct {
	readAddr  uint32
	writeAddr uint32
	ctrl      uint32
	reload    uint32 // TRANS_COUNT as last written; loaded into remaining on trigger
	remaining uint32 // transfers left in the current sequence
	busy      bool
	credit    uint8 // DREQ credit counter (saturating; datasheet §2.5.3.2)
}

const nChannels = 12
const maxCredit = 63

// dma models the DMA register block at 0x50000000.
type dma struct {
	ch     [nChannels]channel
	timers [4]struct {
		reg uint32 // X (dividend) in 31:16, Y (divisor) in 15:0
		acc uint32 // fractional accumulator
	}
	sniffCtrl uint32
	sniffData uint32
	intr      uint32 // raw interrupt status
	inte0     uint32
	intf0     uint32
	inte1     uint32
	intf1     uint32
}

// regRead returns the value of the register at offset (alias-op already
// stripped by the bus).
func (d *dma) regRead(off uint32) uint32 {
	if off < uint32(nChannels)*ChanStride {
		c := &d.ch[off/ChanStride]
		switch off % ChanStride {
		case OffReadAddr, OffAl1ReadAddr, OffAl2ReadAddr, OffAl3ReadAddrTrig:
			return c.readAddr
		case OffWriteAddr, OffAl1WriteAddr, OffAl2WriteAddrTrig, OffAl3WriteAddr:
			return c.writeAddr
		case OffTransCount, OffAl1TransCountTrig, OffAl2TransCount, OffAl3TransCount:
			return c.remaining
		case OffCtrlTrig, OffAl1Ctrl, OffAl2Ctrl, OffAl3Ctrl:
			v := c.ctrl
			if c.busy {
				v |= CtrlBusy
			}
			return v
		}
	}
	switch off {
	case OffIntr:
		return d.intr
	case OffInte0:
		return d.inte0
	case OffIntf0:
		return d.intf0
	case OffInts0:
		return (d.intr | d.intf0) & d.inte0
	case OffInte1:
		return d.inte1
	case OffIntf1:
		return d.intf1
	case OffInts1:
		return (d.intr | d.intf1) & d.inte1
	case OffTimer0, OffTimer0 + 4, OffTimer0 + 8, OffTimer0 + 12:
		return d.timers[(off-OffTimer0)/4].reg
	case OffMultiChanTrigger:
		return 0
	case OffSniffCtrl:
		return d.sniffCtrl
	case OffSniffData:
		// OUT_REV/OUT_INV transform the value between the accumulator and
		// the bus; the accumulator itself is unaffected.
		v := d.sniffData
		if d.sniffCtrl&SniffCtrlOutRev != 0 {
			v = bits.Reverse32(v)
		}
		if d.sniffCtrl&SniffCtrlOutInv != 0 {
			v = ^v
		}
		return v
	case OffFifoLevels:
		return 0
	case OffChanAbort:
		return 0
	case OffNChannels:
		return nChannels
	}
	return 0
}

// regWrite stores val into the register at offset and applies trigger
// semantics. The bus has already applied any atomic-alias operation, so val
// is the final register value; rawNonZero reports whether the value actually
// written on the bus was non-zero (null-trigger detection uses the written
// value, not the resulting register content).
func (d *dma) regWrite(off, val uint32, rawNonZero bool) {
	if off < uint32(nChannels)*ChanStride {
		chIdx := int(off / ChanStride)
		c := &d.ch[chIdx]
		reg := off % ChanStride
		switch reg {
		case OffReadAddr, OffAl1ReadAddr, OffAl2ReadAddr, OffAl3ReadAddrTrig:
			c.readAddr = val
		case OffWriteAddr, OffAl1WriteAddr, OffAl2WriteAddrTrig, OffAl3WriteAddr:
			c.writeAddr = val
		case OffTransCount, OffAl1TransCountTrig, OffAl2TransCount, OffAl3TransCount:
			c.reload = val
		case OffCtrlTrig, OffAl1Ctrl, OffAl2Ctrl, OffAl3Ctrl:
			c.ctrl = val &^ CtrlBusy
		}
		switch reg {
		case OffCtrlTrig, OffAl1TransCountTrig, OffAl2WriteAddrTrig, OffAl3ReadAddrTrig:
			d.trigger(chIdx, rawNonZero)
		}
		return
	}
	switch off {
	case OffIntr:
		d.intr &^= val // write-1-to-clear
	case OffInte0:
		d.inte0 = val
	case OffIntf0:
		d.intf0 = val
	case OffInts0:
		d.intr &^= val // writing INTS0 clears raw bits, like INTR
	case OffInte1:
		d.inte1 = val
	case OffIntf1:
		d.intf1 = val
	case OffTimer0, OffTimer0 + 4, OffTimer0 + 8, OffTimer0 + 12:
		d.timers[(off-OffTimer0)/4].reg = val
	case OffMultiChanTrigger:
		for i := 0; i < nChannels; i++ {
			if val&(1<<i) != 0 {
				d.trigger(i, true)
			}
		}
	case OffSniffCtrl:
		d.sniffCtrl = val
	case OffSniffData:
		d.sniffData = val
	case OffChanAbort:
		for i := 0; i < nChannels; i++ {
			if val&(1<<i) != 0 {
				d.ch[i].busy = false
				d.ch[i].remaining = 0
			}
		}
	}
}

// trigger starts a channel's transfer sequence. Per datasheet §2.5.2.1 a
// trigger is ignored if the channel is disabled, already running, or the
// written value was zero (null trigger). A quiet channel raises its IRQ flag
// on receiving a null trigger.
func (d *dma) trigger(chIdx int, rawNonZero bool) {
	c := &d.ch[chIdx]
	if !rawNonZero {
		if c.ctrl&CtrlIRQQuiet != 0 {
			d.intr |= 1 << chIdx
		}
		return
	}
	if c.ctrl&CtrlEN == 0 || c.busy {
		return
	}
	if c.reload == 0 {
		// Zero-length sequence: nothing to transfer. Treated as a no-op to
		// avoid unbounded zero-cycle chain loops.
		// TODO(hw-calibration): check what real silicon does here.
		return
	}
	c.busy = true
	c.remaining = c.reload
}

// complete finishes a channel's sequence: raise IRQ (unless quiet) and fire
// the chain trigger.
func (d *dma) complete(chIdx int) {
	c := &d.ch[chIdx]
	c.busy = false
	if c.ctrl&CtrlIRQQuiet == 0 {
		d.intr |= 1 << chIdx
	}
	if to := ctrlChainTo(c.ctrl); to != chIdx {
		d.trigger(to, true)
	}
}

// runnable reports whether the channel can issue a transfer this cycle.
func (d *dma) runnable(chIdx int) bool {
	c := &d.ch[chIdx]
	if !c.busy || c.ctrl&CtrlEN == 0 {
		return false
	}
	if ctrlTreqSel(c.ctrl) == TreqPermanent {
		return true
	}
	return c.credit > 0
}

// pulseDreq delivers one DREQ pulse from source dreq to every channel
// listening on it. Pulses are counted (credit-based scheme, §2.5.3.2) and
// accumulate even while a channel is idle or paused.
func (d *dma) pulseDreq(dreq uint32) {
	for i := range d.ch {
		if ctrlTreqSel(d.ch[i].ctrl) == dreq && d.ch[i].credit < maxCredit {
			d.ch[i].credit++
		}
	}
}

// tickTimers advances the four fractional pacing timers by one system-clock
// cycle. A timer with dividend X and divisor Y emits X DREQ pulses every Y
// cycles.
func (d *dma) tickTimers() {
	for i := range d.timers {
		t := &d.timers[i]
		x := t.reg >> 16
		y := t.reg & 0xFFFF
		if x == 0 || y == 0 {
			continue
		}
		t.acc += x
		for t.acc >= y {
			t.acc -= y
			d.pulseDreq(TreqTimer0 + uint32(i))
		}
	}
}

// waitsOnLiveTimer reports whether the channel is blocked on a pacing timer
// that will eventually produce credit (used for halt detection).
func (d *dma) waitsOnLiveTimer(chIdx int) bool {
	c := &d.ch[chIdx]
	if !c.busy || c.ctrl&CtrlEN == 0 {
		return false
	}
	sel := ctrlTreqSel(c.ctrl)
	if sel < TreqTimer0 || sel > TreqTimer3 {
		return false
	}
	t := d.timers[sel-TreqTimer0]
	return t.reg>>16 != 0 && t.reg&0xFFFF != 0
}

// sniff feeds one transferred datum into the sniffer if the given channel is
// being observed. datum is the value after the channel's BSWAP (the sniffer
// sits downstream of the read master, so channel and sniffer BSWAP cancel).
func (d *dma) sniff(chIdx int, datum uint32, sizeBytes int) {
	if d.sniffCtrl&SniffCtrlEN == 0 || sniffDmach(d.sniffCtrl) != chIdx {
		return
	}
	if d.sniffCtrl&SniffCtrlBswap != 0 {
		datum = bswap(datum, sizeBytes)
	}
	switch sniffCalc(d.sniffCtrl) {
	case SniffCalcSum:
		d.sniffData += datum
	case SniffCalcCRC32:
		d.sniffData = crcUpdate(d.sniffData, datum, sizeBytes, 32, 0x04C11DB7, false)
	case SniffCalcCRC32R:
		d.sniffData = crcUpdate(d.sniffData, datum, sizeBytes, 32, 0x04C11DB7, true)
	case SniffCalcCRC16:
		d.sniffData = crcUpdate(d.sniffData, datum, sizeBytes, 16, 0x1021, false)
	case SniffCalcCRC16R:
		d.sniffData = crcUpdate(d.sniffData, datum, sizeBytes, 16, 0x1021, true)
	case SniffCalcEven:
		// XOR reduction: parity of the total population count so far.
		d.sniffData = (d.sniffData ^ uint32(bits.OnesCount32(datum))) & 1
	default:
		// Reserved calc values: leave the accumulator unchanged.
	}
}

// crcUpdate runs a bitwise CRC over the datum's bytes (least-significant
// byte first, matching bus order). Non-reflected variants shift MSB-first.
//
// TODO(hw-calibration): the exact bit/byte ordering of the hardware sniffer
// CRC must be validated against a real RP2040 in the Phase 0 HIL tests; only
// SUM is load-bearing for the machine ABI.
func crcUpdate(crc, datum uint32, sizeBytes, width int, poly uint32, reflected bool) uint32 {
	mask := uint32(0xFFFFFFFF)
	if width < 32 {
		mask = uint32(1)<<width - 1
	}
	for i := 0; i < sizeBytes; i++ {
		b := byte(datum >> (8 * i))
		if reflected {
			b = bits.Reverse8(b)
		}
		for bit := 7; bit >= 0; bit-- {
			in := (uint32(b) >> bit) & 1
			fb := ((crc >> (width - 1)) & 1) ^ in
			crc = (crc << 1) & mask
			if fb != 0 {
				crc ^= poly
			}
		}
	}
	return crc & mask
}

// bswap reverses byte order within the transfer size.
func bswap(v uint32, sizeBytes int) uint32 {
	switch sizeBytes {
	case 2:
		return bits.ReverseBytes32(v<<16) & 0xFFFF
	case 4:
		return bits.ReverseBytes32(v)
	default:
		return v
	}
}
