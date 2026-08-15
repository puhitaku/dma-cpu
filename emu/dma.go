package emu

import "math/bits"

// channel holds the architectural and internal state of one DMA channel.
type channel struct {
	readAddr  uint32
	writeAddr uint32
	ctrl      uint32
	reload    uint32 // TRANS_COUNT as last written; loaded on trigger
	remaining uint32 // transfers left in the current sequence
	mode      uint32 // TRANS_COUNT mode latched at trigger (RP2350)
	busy      bool
	credit    uint8 // DREQ credit counter (saturating; credit-based scheme)
}

const maxChannels = 16 // RP2350; RP2040 uses the first 12
const maxIRQs = 4
const maxCredit = 63

// dma models the DMA register block at 0x50000000 for one Variant.
type dma struct {
	v      *Variant
	ch     [maxChannels]channel
	timers [4]struct {
		reg uint32 // X (dividend) in 31:16, Y (divisor) in 15:0
		acc uint32 // fractional accumulator
	}
	sniffCtrl uint32
	sniffData uint32
	intr      uint32 // raw interrupt status
	inte      [maxIRQs]uint32
	intf      [maxIRQs]uint32
}

// regRead returns the value of the register at offset (alias-op already
// stripped by the bus). Unmodelled registers (e.g. RP2350 SECCFG/MPU)
// read as zero.
func (d *dma) regRead(off uint32) uint32 {
	if off < uint32(d.v.NChannels)*ChanStride {
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
				v |= d.v.CtrlBusy
			}
			return v
		}
	}
	// Per-IRQ {INTE, INTF, INTS} blocks at 0x404 + 0x10*i. The fourth slot
	// of each stride is not an IRQ register (0x420/0x440 are TIMER0), so
	// only offsets 0x0/0x4/0x8 within a stride match here.
	if off >= offIrqBlock && off < offIrqBlock+uint32(d.v.NIRQs)*0x10 &&
		(off-offIrqBlock)%0x10 <= 0x8 {
		i := (off - offIrqBlock) / 0x10
		switch (off - offIrqBlock) % 0x10 {
		case 0x0:
			return d.inte[i]
		case 0x4:
			return d.intf[i]
		default:
			return (d.intr | d.intf[i]) & d.inte[i]
		}
	}
	switch off {
	case offIntr:
		return d.intr
	case d.v.offTimer0, d.v.offTimer0 + 4, d.v.offTimer0 + 8, d.v.offTimer0 + 12:
		return d.timers[(off-d.v.offTimer0)/4].reg
	case d.v.offSniffCtrl:
		return d.sniffCtrl
	case d.v.offSniffData:
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
	case d.v.offNChannels:
		return uint32(d.v.NChannels)
	}
	return 0
}

// regWrite stores val into the register at offset and applies trigger
// semantics. The bus has already applied any atomic-alias operation, so
// val is the final register value; rawNonZero reports whether the value
// actually written on the bus was non-zero (null-trigger detection uses
// the written value, not the resulting register content).
func (d *dma) regWrite(off, val uint32, rawNonZero bool) {
	if off < uint32(d.v.NChannels)*ChanStride {
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
			c.ctrl = val &^ d.v.CtrlBusy
		}
		switch reg {
		case OffCtrlTrig, OffAl1TransCountTrig, OffAl2WriteAddrTrig, OffAl3ReadAddrTrig:
			d.trigger(chIdx, rawNonZero)
		}
		return
	}
	if off >= offIrqBlock && off < offIrqBlock+uint32(d.v.NIRQs)*0x10 &&
		(off-offIrqBlock)%0x10 <= 0x8 {
		i := (off - offIrqBlock) / 0x10
		switch (off - offIrqBlock) % 0x10 {
		case 0x0:
			d.inte[i] = val
		case 0x4:
			d.intf[i] = val
		default:
			d.intr &^= val // writing INTS clears raw bits, like INTR
		}
		return
	}
	switch off {
	case offIntr:
		d.intr &^= val // write-1-to-clear
	case d.v.offTimer0, d.v.offTimer0 + 4, d.v.offTimer0 + 8, d.v.offTimer0 + 12:
		d.timers[(off-d.v.offTimer0)/4].reg = val
	case d.v.offMultiChanTrigger:
		for i := 0; i < d.v.NChannels; i++ {
			if val&(1<<i) != 0 {
				d.trigger(i, true)
			}
		}
	case d.v.offSniffCtrl:
		d.sniffCtrl = val
	case d.v.offSniffData:
		d.sniffData = val
	case d.v.offChanAbort:
		for i := 0; i < d.v.NChannels; i++ {
			if val&(1<<i) != 0 {
				d.ch[i].busy = false
				d.ch[i].remaining = 0
			}
		}
	}
}

// trigger starts a channel's transfer sequence. A trigger is ignored if
// the channel is disabled, already running, or the written value was zero
// (null trigger). A quiet channel raises its IRQ flag on receiving a null
// trigger.
func (d *dma) trigger(chIdx int, rawNonZero bool) {
	c := &d.ch[chIdx]
	if !rawNonZero {
		if c.ctrl&d.v.CtrlIRQQuiet != 0 {
			d.intr |= 1 << chIdx
		}
		return
	}
	if c.ctrl&CtrlEN == 0 || c.busy {
		return
	}
	c.mode = d.v.transMode(c.reload)
	count := d.v.transCount(c.reload)
	if count == 0 && c.mode != transModeEndless {
		// Zero-length sequence: nothing to transfer. Treated as a no-op to
		// avoid unbounded zero-cycle chain loops.
		// TODO(hw-calibration): check what real silicon does here.
		return
	}
	c.busy = true
	c.remaining = count
}

// complete finishes a channel's sequence: raise IRQ (unless quiet), fire
// the chain trigger, and (RP2350 TRIGGER_SELF mode) re-trigger itself.
func (d *dma) complete(chIdx int) {
	c := &d.ch[chIdx]
	c.busy = false
	if c.ctrl&d.v.CtrlIRQQuiet == 0 {
		d.intr |= 1 << chIdx
	}
	if to := d.v.ctrlChainTo(c.ctrl); to != chIdx && to < d.v.NChannels {
		d.trigger(to, true)
	}
	if c.mode == transModeTriggerSelf {
		d.trigger(chIdx, true)
	}
}

// runnable reports whether the channel can issue a transfer this cycle.
func (d *dma) runnable(chIdx int) bool {
	c := &d.ch[chIdx]
	if !c.busy || c.ctrl&CtrlEN == 0 {
		return false
	}
	if d.v.ctrlTreqSel(c.ctrl) == TreqPermanent {
		return true
	}
	return c.credit > 0
}

// pulseDreq delivers one DREQ pulse from source dreq to every channel
// listening on it. Pulses are counted (credit-based scheme) and accumulate
// even while a channel is idle or paused.
func (d *dma) pulseDreq(dreq uint32) {
	for i := 0; i < d.v.NChannels; i++ {
		if d.v.ctrlTreqSel(d.ch[i].ctrl) == dreq && d.ch[i].credit < maxCredit {
			d.ch[i].credit++
		}
	}
}

// tickTimers advances the four fractional pacing timers by one
// system-clock cycle. A timer with dividend X and divisor Y emits X DREQ
// pulses every Y cycles.
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

// waitsOnLiveTimer reports whether the channel is blocked on a pacing
// timer that will eventually produce credit (used for halt detection).
func (d *dma) waitsOnLiveTimer(chIdx int) bool {
	c := &d.ch[chIdx]
	if !c.busy || c.ctrl&CtrlEN == 0 {
		return false
	}
	sel := d.v.ctrlTreqSel(c.ctrl)
	if sel < TreqTimer0 || sel > TreqTimer3 {
		return false
	}
	t := d.timers[sel-TreqTimer0]
	return t.reg>>16 != 0 && t.reg&0xFFFF != 0
}

// sniff feeds one transferred datum into the sniffer if the given channel
// is being observed. datum is the value after the channel's BSWAP (the
// sniffer sits downstream of the read master, so channel and sniffer
// BSWAP cancel).
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
// CRC must be validated against real RP2 silicon in the Phase 0 HIL tests;
// only SUM is load-bearing for the machine ABI.
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
