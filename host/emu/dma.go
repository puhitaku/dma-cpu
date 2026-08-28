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
	wedged    bool  // RP2040 self-TRANS_COUNT write: dead until block reset
	credit    uint8 // DREQ credit counter (saturating; credit-based scheme)

	// Decoded-CTRL cache (ctrlChanged is the single writer): the
	// transfer loop touches these every word, and re-extracting the
	// bit fields per word was ~9% of the suite. Pure accelerators,
	// like ready/hp below — CTRL stays the source of truth.
	treq      uint32 // ctrlTreqSel(ctrl)
	sizeLog   uint32 // ctrlDataSize(ctrl); 3 = reserved (checked in transfer)
	chainTo   int
	strideR   uint32 // 0 when INCR_READ clear; else +size or -size (wrapping)
	strideW   uint32
	ringMaskR uint32 // nonzero when RING_SIZE set and RING_SEL picks this side
	ringMaskW uint32
	bswap     bool
	sniffEn   bool
	irqQuiet  bool

	// Resolved memory windows for the read and write side (B3 fast
	// path): while an address stays inside its window, the transfer
	// loop bypasses the full bus decode with a direct slice access.
	// A window with a nil buf but a nonzero range is a NEGATIVE
	// window — the region (DMA regs, MMIO) must take the slow path,
	// cached so it is not re-resolved every word. Zero value means
	// "resolve on next use". Invalidated wholesale on QMI-mode
	// changes (winsInvalidate).
	rwin memWin
	wwin memWin
}

// memWin is a resolved span of bus addresses served by one backing
// slice (buf[a-lo] for a in [lo,hi)), or a negative span (buf nil).
type memWin struct {
	buf    []byte
	lo, hi uint32
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
	zeroDepth int // guards zero-length-sequence chain cascades

	// Scheduling caches (pure accelerators — recomputed from channel
	// state at every mutation, never a source of truth). ready caches
	// runnable() per channel; hp caches the CTRL high-priority bit;
	// timerActive marks pacing timers with X and Y nonzero; timerListen
	// holds the channels whose TREQ_SEL targets each timer.
	ready        uint32
	hp           uint32
	timerActive  uint32
	timerListen  [4]uint32
	spiListen    uint32    // channels whose TREQ_SEL is the SPI0 TX DREQ
	uartTxListen uint32    // channels on the UART0 TX DREQ (console drain)
	uartRxListen uint32    // channels on the UART0 RX DREQ (console fill)
	spiRxListen  uint32    // channels on the SPI0 RX DREQ (the SD drain)
	hstxListen   uint32    // channels on the HSTX DREQ (the scanout)
	pioTx        [4]uint32 // channels on PIO0 TX0..3 (DREQ 0..3)
	pioListen    uint32    // union of pioTx, the fast gate

	// Timer next-fire schedule: ticking four fractional accumulators
	// every cycle was ~8% of the suite, so each active timer instead
	// records the absolute cycle of its next pulse batch (closed-form
	// from the accumulator), and step() consults only the minimum.
	// Exact: pulses land on the same cycles the per-cycle loop
	// produced. nowp points at the machine's cycle counter.
	nowp         *uint64
	timerLast    [4]uint64 // cycle at which acc was last materialized
	timerNext    [4]uint64 // absolute cycle of the next pulse batch
	timerNextMin uint64
}

// timerRecalc rematerializes timer i's accumulator at the current
// cycle and schedules its next fire.
func (d *dma) timerRecalc(i int) {
	t := &d.timers[i]
	now := *d.nowp
	d.timerLast[i] = now
	x := uint64(t.reg >> 16)
	y := uint64(t.reg & 0xFFFF)
	if x == 0 || y == 0 {
		d.timerNext[i] = ^uint64(0)
		d.timerMin()
		return
	}
	// smallest n >= 1 with acc + n*x >= y
	n := uint64(1)
	if uint64(t.acc) < y {
		n = (y - uint64(t.acc) + x - 1) / x
		if n == 0 {
			n = 1
		}
	}
	d.timerNext[i] = now + n
	d.timerMin()
}

func (d *dma) timerMin() {
	min := ^uint64(0)
	for act := d.timerActive; act != 0; act &= act - 1 {
		i := bits.TrailingZeros32(act)
		if d.timerNext[i] < min {
			min = d.timerNext[i]
		}
	}
	d.timerNextMin = min
}

// fireDue advances every timer whose fire cycle has arrived, emitting
// exactly the pulses the per-cycle accumulator loop would have.
func (d *dma) fireDue(now uint64) {
	for act := d.timerActive; act != 0; act &= act - 1 {
		i := bits.TrailingZeros32(act)
		if d.timerNext[i] > now {
			continue
		}
		t := &d.timers[i]
		x := uint64(t.reg >> 16)
		y := uint64(t.reg & 0xFFFF)
		total := uint64(t.acc) + x*(now-d.timerLast[i])
		for p := total / y; p > 0; p-- {
			d.pulseTimer(i)
		}
		t.acc = uint32(total % y)
		d.timerLast[i] = now
		n := (y - uint64(t.acc) + x - 1) / x
		if n == 0 {
			n = 1
		}
		d.timerNext[i] = now + n
	}
	d.timerMin()
}

// updateReady recomputes one channel's bit of the ready cache.
func (d *dma) updateReady(chIdx int) {
	if d.runnable(chIdx) {
		d.ready |= 1 << chIdx
	} else {
		d.ready &^= 1 << chIdx
	}
}

// ctrlChanged refreshes every cache derived from a channel's CTRL.
func (d *dma) ctrlChanged(chIdx int) {
	bit := uint32(1) << chIdx
	c := &d.ch[chIdx]
	v := d.v
	if c.ctrl&CtrlHighPriority != 0 {
		d.hp |= bit
	} else {
		d.hp &^= bit
	}
	c.treq = v.ctrlTreqSel(c.ctrl)
	c.sizeLog = ctrlDataSize(c.ctrl)
	c.chainTo = v.ctrlChainTo(c.ctrl)
	c.bswap = c.ctrl&v.CtrlBswap != 0
	c.sniffEn = c.ctrl&v.CtrlSniffEn != 0
	c.irqQuiet = c.ctrl&v.CtrlIRQQuiet != 0
	size := uint32(1) << (c.sizeLog & 3)
	c.strideR, c.strideW = 0, 0
	if c.ctrl&CtrlIncrRead != 0 {
		c.strideR = size
		if v.CtrlIncrReadRev != 0 && c.ctrl&v.CtrlIncrReadRev != 0 {
			c.strideR = -size
		}
	}
	if c.ctrl&v.CtrlIncrWrite != 0 {
		c.strideW = size
		if v.CtrlIncrWriteRev != 0 && c.ctrl&v.CtrlIncrWriteRev != 0 {
			c.strideW = -size
		}
	}
	c.ringMaskR, c.ringMaskW = 0, 0
	if ring := v.ctrlRingSize(c.ctrl); ring != 0 {
		mask := uint32(1)<<ring - 1
		if c.ctrl&v.CtrlRingSel != 0 {
			c.ringMaskW = mask
		} else {
			c.ringMaskR = mask
		}
	}
	for i := range d.timerListen {
		if c.treq == TreqTimer0+uint32(i) {
			d.timerListen[i] |= bit
		} else {
			d.timerListen[i] &^= bit
		}
	}
	if v.DreqSPI0TX != 0 && c.treq == v.DreqSPI0TX {
		d.spiListen |= bit
	} else {
		d.spiListen &^= bit
	}
	if v.DreqSPI0RX != 0 && c.treq == v.DreqSPI0RX {
		d.spiRxListen |= bit
	} else {
		d.spiRxListen &^= bit
	}
	if v.DreqUART0TX != 0 && c.treq == v.DreqUART0TX {
		d.uartTxListen |= bit
	} else {
		d.uartTxListen &^= bit
	}
	if v.DreqUART0RX != 0 && c.treq == v.DreqUART0RX {
		d.uartRxListen |= bit
	} else {
		d.uartRxListen &^= bit
	}
	if v.DreqHSTX != 0 && c.treq == v.DreqHSTX {
		d.hstxListen |= bit
	} else {
		d.hstxListen &^= bit
	}
	// PIO0 TX DREQs are 0..3 on both SKUs. A zeroed CTRL decodes to
	// TREQ_SEL 0 too, so require EN — otherwise every idle channel
	// would land in pioTx[0] and defeat the pioListen fast gate.
	d.pioListen = 0
	for i := range d.pioTx {
		if c.ctrl&CtrlEN != 0 && c.treq == uint32(i) {
			d.pioTx[i] |= bit
		} else {
			d.pioTx[i] &^= bit
		}
		d.pioListen |= d.pioTx[i]
	}
	d.updateReady(chIdx)
}

// levelDreqMask is levelDreq over a cached listener set.
func (d *dma) levelDreqMask(mask uint32) {
	for m := mask; m != 0; m &= m - 1 {
		i := bits.TrailingZeros32(m)
		if d.ch[i].busy && d.ch[i].credit == 0 {
			d.ch[i].credit = 1
			d.updateReady(i)
		}
	}
}

// starved reports whether any channel in the mask is armed and out of
// credit — i.e. waiting for its level DREQ to be re-granted.
func (d *dma) starved(mask uint32) bool {
	for m := mask; m != 0; m &= m - 1 {
		i := bits.TrailingZeros32(m)
		if d.ch[i].busy && d.ch[i].credit == 0 {
			return true
		}
	}
	return false
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
		// The quiet-mode null-trigger IRQ is judged on the CTRL value in
		// effect *before* the write: a null CTRL_TRIG write zeroes CTRL
		// yet still raises the IRQ if the channel was quiet (verified on
		// RP2350, prompts/004-hw-calibration.md).
		prevCtrl := c.ctrl
		switch reg {
		case OffReadAddr, OffAl1ReadAddr, OffAl2ReadAddr, OffAl3ReadAddrTrig:
			c.readAddr = val
		case OffWriteAddr, OffAl1WriteAddr, OffAl2WriteAddrTrig, OffAl3WriteAddr:
			c.writeAddr = val
		case OffTransCount, OffAl1TransCountTrig, OffAl2TransCount, OffAl3TransCount:
			c.reload = val
		case OffCtrlTrig, OffAl1Ctrl, OffAl2Ctrl, OffAl3Ctrl:
			c.ctrl = val &^ d.v.CtrlBusy
			d.ctrlChanged(chIdx)
		}
		switch reg {
		case OffCtrlTrig, OffAl1TransCountTrig, OffAl2WriteAddrTrig, OffAl3ReadAddrTrig:
			d.trigger(chIdx, rawNonZero, prevCtrl)
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
		i := (off - d.v.offTimer0) / 4
		d.timers[i].reg = val
		if val>>16 != 0 && val&0xFFFF != 0 {
			d.timerActive |= 1 << i
		} else {
			d.timerActive &^= 1 << i
		}
		d.timerRecalc(int(i))
	case d.v.offMultiChanTrigger:
		for i := 0; i < d.v.NChannels; i++ {
			if val&(1<<i) != 0 {
				d.trigger(i, true, d.ch[i].ctrl)
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
				d.updateReady(i)
			}
		}
	}
}

// trigger starts a channel's transfer sequence. A trigger is ignored if
// the channel is disabled or already running; a null (zero-value) trigger
// does not start the channel but raises the IRQ if the channel was in
// quiet mode (quietCtrl is the CTRL in effect when the trigger arrived —
// for CTRL_TRIG writes, the pre-write value).
//
// Semantics below verified on RP2350 silicon (prompts/004):
//   - a zero-length (TRANS_COUNT == 0) sequence completes immediately,
//     raising the completion IRQ and firing the chain;
//   - banked DREQ credit does not survive into a new trigger.
func (d *dma) trigger(chIdx int, rawNonZero bool, quietCtrl uint32) {
	c := &d.ch[chIdx]
	if !rawNonZero {
		if quietCtrl&d.v.CtrlIRQQuiet != 0 {
			d.intr |= 1 << chIdx
		}
		return
	}
	if c.ctrl&CtrlEN == 0 || c.busy {
		return
	}
	c.mode = d.v.transMode(c.reload)
	c.credit = 0
	count := d.v.transCount(c.reload)
	if count == 0 && c.mode != transModeEndless {
		// Immediate completion. A cycle of zero-length chains would
		// livelock real hardware; the emulator truncates the cascade.
		d.zeroDepth++
		if d.zeroDepth <= 2*maxChannels {
			d.complete(chIdx)
		}
		d.zeroDepth--
		return
	}
	c.busy = true
	c.remaining = count
	d.updateReady(chIdx)
}

// complete finishes a channel's sequence: raise IRQ (unless quiet), fire
// the chain trigger, and (RP2350 TRIGGER_SELF mode) re-trigger itself.
func (d *dma) complete(chIdx int) {
	c := &d.ch[chIdx]
	c.busy = false
	d.updateReady(chIdx)
	if !c.irqQuiet {
		d.intr |= 1 << chIdx
	}
	if to := c.chainTo; to != chIdx && to < d.v.NChannels {
		d.trigger(to, true, d.ch[to].ctrl)
	}
	if c.mode == transModeTriggerSelf {
		d.trigger(chIdx, true, c.ctrl)
	}
}

// runnable reports whether the channel can issue a transfer this cycle.
func (d *dma) runnable(chIdx int) bool {
	c := &d.ch[chIdx]
	if c.wedged {
		return false // survives CHAN_ABORT and re-trigger (silicon-measured)
	}
	if !c.busy || c.ctrl&CtrlEN == 0 {
		return false
	}
	if c.treq == TreqPermanent {
		return true
	}
	return c.credit > 0
}

// pulseDreq delivers one DREQ pulse from source dreq to every channel
// listening on it. Pulses are counted (credit-based scheme) and accumulate
// even while a channel is idle or paused.
func (d *dma) pulseDreq(dreq uint32) {
	for i := 0; i < d.v.NChannels; i++ {
		if d.ch[i].treq == dreq && d.ch[i].credit < maxCredit {
			d.ch[i].credit++
			d.updateReady(i)
		}
	}
}

// levelDreq models a level-type request: any listening channel with no
// banked credit gets exactly one, so a post-trigger clear self-heals
// the way a re-asserting hardware request line does.
func (d *dma) levelDreq(dreq uint32) {
	for i := 0; i < d.v.NChannels; i++ {
		if d.ch[i].treq == dreq && d.ch[i].busy && d.ch[i].credit == 0 {
			d.ch[i].credit = 1
			d.updateReady(i)
		}
	}
}

// pulseTimer is pulseDreq for a pacing timer, over the cached listener
// set (fireDue calls it per due pulse; the generic scan was the hot path).
func (d *dma) pulseTimer(i int) {
	for m := d.timerListen[i]; m != 0; m &= m - 1 {
		j := bits.TrailingZeros32(m)
		if d.ch[j].credit < maxCredit {
			d.ch[j].credit++
			d.updateReady(j)
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
	sel := c.treq
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
// The CRC32 bit/byte ordering is silicon-confirmed (the HIL calibration
// experiment's HIL_CAL_EXPECT_CRC32 matched, prompts/004-hw-calibration.md);
// the CRC16 and reflected variants stay unprobed, and only SUM is
// load-bearing for the machine ABI.
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
