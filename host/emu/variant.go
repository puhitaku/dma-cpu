package emu

import "fmt"

// Variant describes one RP2 SKU. The DMA programming model is shared
// across the family, but the encodings are not: RP2350 moves most CTRL
// bit fields (wider CHAIN_TO/TREQ_SEL, new reverse-increment bits),
// relocates the global DMA registers, adds a TRANS_COUNT mode nibble, and
// changes the SRAM size, channel/IRQ counts, IO_BANK0 base, and GPIO
// override bit positions. Control words and register addresses are
// therefore SKU-specific: programs must be assembled for a Variant, and a
// Machine emulates exactly one.
type Variant struct {
	Name          string
	NChannels     int
	NIRQs         int
	SRAMSize      uint32
	IOBank0Base   uint32
	PadsBank0Base uint32
	PIO0Base      uint32 // PIO1/PIO2 follow at +0x100000 strides
	UART0Base     uint32
	TimerRawL     uint32 // TIMERAWL: the free-running us counter (low word)
	SPI0Base      uint32 // PL022; DR captured into Machine.SPIOut
	DreqSPI0TX    uint32 // level-modeled while SSPDMACR.TXDMAE is set
	DreqSPI0RX    uint32 // level-modeled while the SD model holds RX bytes
	DreqUART0TX   uint32 // level-modeled: paced by Machine.TXPace
	DreqUART0RX   uint32 // level-modeled: asserted while ConsoleIn holds bytes
	GPIOPins      int

	// SelfCountWedge: a channel writing its own TRANS_COUNT (any alias)
	// mid-transfer wedges permanently after that beat (RP2040, measured
	// on silicon; RP2350 latches the write as reload only).
	SelfCountWedge bool

	gpioOutoverLSB uint
	gpioOeoverLSB  uint

	// Global DMA register offsets (channel registers and the INTR/INTE0
	// block are common; everything from the pacing timers on moved).
	offTimer0           uint32
	offMultiChanTrigger uint32
	offSniffCtrl        uint32
	offSniffData        uint32
	offFifoLevels       uint32
	offChanAbort        uint32
	offNChannels        uint32

	// CTRL bit layout. Single-bit fields are exposed as masks; a zero mask
	// means the SKU has no such bit (e.g. reverse increment on RP2040).
	CtrlIncrReadRev  uint32
	CtrlIncrWrite    uint32
	CtrlIncrWriteRev uint32
	CtrlRingSel      uint32
	CtrlIRQQuiet     uint32
	CtrlBswap        uint32
	CtrlSniffEn      uint32
	CtrlBusy         uint32
	ctrlRingSizeLSB  uint
	ctrlChainToLSB   uint
	ctrlTreqSelLSB   uint

	// transCountMode: TRANS_COUNT holds a mode nibble in bits 31:28
	// (NORMAL/TRIGGER_SELF/ENDLESS) and a 28-bit count.
	transCountMode bool

	// SKU-specific System DREQ numbers (subset the project uses).
	DreqPIO0RX0  uint32
	DreqPWMWrap0 uint32
	DreqADC      uint32

	// HSTX (RP2350 only; zero on SKUs without it): the FIFO the video
	// scanout channel streams into, and its pacing DREQ.
	HSTXFifoBase uint32
	DreqHSTX     uint32

	// XIP streamer (RP2350 values; the scanout's line copier drains
	// it): STREAM_ADDR/STREAM_CTR in the XIP_CTRL block, the
	// high-bandwidth drain port in XIP_AUX, and its DREQ.
	XIPStreamAddr uint32 // STREAM_ADDR; STREAM_CTR at +4
	XIPAuxBase    uint32
	DreqXIPStream uint32
}

// RP2040: datasheet §2.5 (references/datasheets/rp2040-datasheet.pdf).
var RP2040 = &Variant{
	Name:           "rp2040",
	SelfCountWedge: true,
	NChannels:      12,
	NIRQs:          2,
	SRAMSize:       0x42000, // 256 KiB striped + 2 × 4 KiB scratch
	IOBank0Base:    0x40014000,
	PadsBank0Base:  0x4001C000,
	PIO0Base:       0x50200000,
	UART0Base:      0x40034000, // RP2040 datasheet §4.2
	TimerRawL:      0x40054028,
	SPI0Base:       0x4003C000,
	DreqSPI0TX:     16,
	DreqSPI0RX:     17,
	DreqUART0TX:    20,
	DreqUART0RX:    21,
	GPIOPins:       30,

	gpioOutoverLSB: 8,
	gpioOeoverLSB:  12,

	offTimer0:           0x420,
	offMultiChanTrigger: 0x430,
	offSniffCtrl:        0x434,
	offSniffData:        0x438,
	offFifoLevels:       0x440,
	offChanAbort:        0x444,
	offNChannels:        0x448,

	CtrlIncrWrite:   1 << 5,
	CtrlRingSel:     1 << 10,
	CtrlIRQQuiet:    1 << 21,
	CtrlBswap:       1 << 22,
	CtrlSniffEn:     1 << 23,
	CtrlBusy:        1 << 24,
	ctrlRingSizeLSB: 6,
	ctrlChainToLSB:  11,
	ctrlTreqSelLSB:  15,

	DreqPIO0RX0:  4,
	DreqPWMWrap0: 24,
	DreqADC:      36,
}

// RP2350: datasheet §12.6 (references/datasheets/rp2350-datasheet.pdf). SECCFG/MPU
// registers (0x480+) are not modelled; they read as zero.
var RP2350 = &Variant{
	Name:          "rp2350",
	NChannels:     16,
	NIRQs:         4,
	SRAMSize:      0x82000, // 520 KiB
	IOBank0Base:   0x40028000,
	PadsBank0Base: 0x40038000,
	PIO0Base:      0x50200000,
	UART0Base:     0x40070000, // RP2350 datasheet §12.1
	TimerRawL:     0x400B0028, // TIMER0
	SPI0Base:      0x40080000,
	// 24, not 26: the RP2350 table runs PIO2_RX0..3 = 20..23, then
	// SPI0_TX = 24 (26 is SPI1_TX; the old value was a dormant slip —
	// only the RP2040 game console paces on SPI0).
	DreqSPI0TX:  24,
	DreqSPI0RX:  25,
	DreqUART0TX: 28,
	DreqUART0RX: 29,
	GPIOPins:    48,

	gpioOutoverLSB: 12,
	gpioOeoverLSB:  14,

	offTimer0:           0x440,
	offMultiChanTrigger: 0x450,
	offSniffCtrl:        0x454,
	offSniffData:        0x458,
	offFifoLevels:       0x460,
	offChanAbort:        0x464,
	offNChannels:        0x468,

	CtrlIncrReadRev:  1 << 5,
	CtrlIncrWrite:    1 << 6,
	CtrlIncrWriteRev: 1 << 7,
	CtrlRingSel:      1 << 12,
	CtrlIRQQuiet:     1 << 23,
	CtrlBswap:        1 << 24,
	CtrlSniffEn:      1 << 25,
	CtrlBusy:         1 << 26,
	ctrlRingSizeLSB:  8,
	ctrlChainToLSB:   13,
	ctrlTreqSelLSB:   17,

	transCountMode: true,

	DreqPIO0RX0:  4,
	DreqPWMWrap0: 32,
	DreqADC:      48,

	// The FIFO's WRITE port (base 0x50600000 is the read-only STAT
	// register; the data port sits at +4 — RP2350 datasheet §12.11).
	// Streaming at +0 discards every word, so the FIFO never fills
	// and its DREQ never deasserts: the scanout free-runs and
	// saturates the bus (a real silicon episode, prompts/036).
	HSTXFifoBase: 0x50600004,
	DreqHSTX:     52,

	XIPStreamAddr: 0x400C8014, // RP2350 datasheet §4.4 (XIP_CTRL)
	XIPAuxBase:    0x50500000,
	DreqXIPStream: 49,
}

// Variants lists all supported SKUs.
var Variants = []*Variant{RP2040, RP2350}

func VariantByName(name string) (*Variant, error) {
	for _, v := range Variants {
		if v.Name == name {
			return v, nil
		}
	}
	return nil, fmt.Errorf("unknown SKU %q (supported: rp2040, rp2350)", name)
}

// --- CTRL word encode/decode ---

func (v *Variant) CtrlRingSize(n uint32) uint32 { return (n & 0xF) << v.ctrlRingSizeLSB }
func (v *Variant) CtrlChainTo(ch int) uint32    { return (uint32(ch) & 0xF) << v.ctrlChainToLSB }
func (v *Variant) CtrlTreq(sel uint32) uint32   { return (sel & 0x3F) << v.ctrlTreqSelLSB }

func (v *Variant) ctrlRingSize(ctrl uint32) uint32 { return (ctrl >> v.ctrlRingSizeLSB) & 0xF }
func (v *Variant) ctrlChainTo(ctrl uint32) int     { return int((ctrl >> v.ctrlChainToLSB) & 0xF) }
func (v *Variant) ctrlTreqSel(ctrl uint32) uint32  { return (ctrl >> v.ctrlTreqSelLSB) & 0x3F }

// TRANS_COUNT modes (RP2350; NORMAL-only on RP2040).
const (
	transModeNormal      uint32 = 0x0
	transModeTriggerSelf uint32 = 0x1
	transModeEndless     uint32 = 0xF
)

func (v *Variant) transCount(reload uint32) uint32 {
	if v.transCountMode {
		return reload & 0x0FFFFFFF
	}
	return reload
}

func (v *Variant) transMode(reload uint32) uint32 {
	if v.transCountMode {
		return reload >> 28
	}
	return transModeNormal
}

// --- SKU-specific addresses ---

// KDMACopyCtrl is the CTRL encoding for the kernel's bulk-copy
// channel (kdma.c): enabled, high-priority, word-size, both sides
// incrementing, unpaced, quiet, and CHAIN_TO = self — the no-chain
// encoding (a zero CHAIN_TO field means "trigger channel 0 on
// completion", which re-armed a machine bank and sent the copier
// marching through SRAM). Poked into g_dmacpy_ctrl by the loader;
// the SKUs disagree on the INCR_WRITE and TREQ/QUIET bit positions.
func (v *Variant) KDMACopyCtrl() uint32 {
	return CtrlEN | CtrlHighPriority | CtrlSize32 | CtrlIncrRead |
		v.CtrlIncrWrite | v.CtrlChainTo(11) |
		v.CtrlTreq(TreqPermanent) | v.CtrlIRQQuiet
}

// SDRxCtrl is the SD sector-drain CTRL for the borrowed kdma channel
// (ch11): byte-size reads of SSPDR paced by the SPI0 RX DREQ, writes
// incrementing through the sector buffer. Chained to itself = no
// chain; the kernel driver (ksd.c) waits on TRANS_COUNT.
func (v *Variant) SDRxCtrl() uint32 {
	return CtrlEN | CtrlSize8 | v.CtrlIncrWrite |
		v.CtrlTreq(v.DreqSPI0RX) | v.CtrlChainTo(11) | v.CtrlIRQQuiet
}

// SDTxCtrl is the borrowed console-TX channel's CTRL while it feeds
// the SD payload's 512 idle clocks: byte reads of one fixed source
// word into SSPDR at the SPI0 TX DREQ's pace (ksd.c saves/restores
// the console configuration around the borrow).
func (v *Variant) SDTxCtrl() uint32 {
	return CtrlEN | CtrlSize8 | v.CtrlTreq(v.DreqSPI0TX) |
		v.CtrlChainTo(ConsTxCh) | v.CtrlIRQQuiet
}

// Console-DMA channel convention for xsh systems on 16-channel SKUs
// (boards with Board.ConsRings set): three board-pool channels take the
// UART off the kernel's hands. TX drains a 512-byte ring into the DR at
// the wire's pace; RX copies each received byte into a 1 KiB ring; the
// wake channel, chained off every RX byte, patches the scheduler
// dispatch word exactly like the tick injector — input becomes an
// interrupt. kproc.c owns the software side (cons_dma_init and the
// ring cursors); these words are poked into its g_c??_ctrl globals, and
// a zero g_ctx_ctrl means "no console DMA" (the RP2040's 12 channels
// have no room — its xsh keeps the polling paths).
const (
	ConsTxCh       = 10
	ConsRxCh       = 12
	ConsWakeCh     = 13
	ConsRxRingSize = 1024 // at Board.ConsRings (1 KiB aligned)
	ConsTxRingSize = 512  // at Board.ConsRings + ConsRxRingSize
)

func (v *Variant) ConsTxCtrl() uint32 {
	return CtrlEN | CtrlSize8 | CtrlIncrRead |
		v.CtrlRingSize(9) | // 512-byte read ring (RING_SEL=0)
		v.CtrlTreq(v.DreqUART0TX) | v.CtrlChainTo(ConsTxCh) | v.CtrlIRQQuiet
}

func (v *Variant) ConsRxCtrl() uint32 {
	return CtrlEN | CtrlSize8 | v.CtrlIncrWrite |
		v.CtrlRingSel | v.CtrlRingSize(10) | // 1 KiB write ring
		v.CtrlTreq(v.DreqUART0RX) | v.CtrlChainTo(ConsWakeCh) | v.CtrlIRQQuiet
}

func (v *Variant) ConsWakeCtrl() uint32 {
	return CtrlEN | CtrlSize32 | v.CtrlTreq(TreqPermanent) |
		v.CtrlChainTo(ConsRxCh) | v.CtrlIRQQuiet
}

func (v *Variant) SniffCtrlAddr() uint32 { return DMABase + v.offSniffCtrl }

// UART0 data and flag registers (PL011: DR at +0x00, FR at +0x18). The
// emulator models DR writes as console output and DR reads as console
// input; FR carries RXFE (bit 4) for the input queue and TXFF (bit 5)
// only while Machine.TXPace throttles the transmitter, so an unpaced
// machine's TX-full poll falls straight through.
func (v *Variant) UARTDRAddr() uint32 { return v.UART0Base + 0x00 }
func (v *Variant) UARTFRAddr() uint32 { return v.UART0Base + 0x18 }

func (v *Variant) SniffDataAddr() uint32    { return DMABase + v.offSniffData }
func (v *Variant) SniffDataXORAddr() uint32 { return DMABase + AliasXOR + v.offSniffData }
func (v *Variant) SniffDataSetAddr() uint32 { return DMABase + AliasSet + v.offSniffData }
func (v *Variant) SniffDataClrAddr() uint32 { return DMABase + AliasClr + v.offSniffData }

// TimerRawH returns TIMERAWH, the free-running counter's high word.
// The TIMER block puts it at +0x24, four bytes BELOW TIMERAWL (+0x28)
// on both SKUs — +0x2C is DBGPAUSE, and reading it for the high word
// would hand a driver a debug-control register instead of time.
func (v *Variant) TimerRawH() uint32 { return v.TimerRawL - 4 }

// TimerAddr returns the address of pacing timer i (0–3).
func (v *Variant) TimerAddr(i int) uint32 { return DMABase + v.offTimer0 + uint32(i)*4 }

// IntrAddr returns the address of the raw interrupt status register.
func (v *Variant) IntrAddr() uint32 { return DMABase + offIntr }

// ChanAbortAddr returns the address of the CHAN_ABORT register.
func (v *Variant) ChanAbortAddr() uint32 { return DMABase + v.offChanAbort }

// GPIOCtrlAddr returns the IO_BANK0 GPIOx_CTRL address for a pin.
func (v *Variant) GPIOCtrlAddr(pin int) uint32 {
	return v.IOBank0Base + uint32(pin)*8 + 4
}

// GPIOOutCtrl returns the GPIOx_CTRL word that force-enables the output
// and drives it high or low (OEOVER = 3, OUTOVER = 3 or 2). On RP2040
// this yields the classic 0x3300/0x3200 values.
func (v *Variant) GPIOOutCtrl(high bool) uint32 {
	out := uint32(2)
	if high {
		out = 3
	}
	return 3<<v.gpioOeoverLSB | out<<v.gpioOutoverLSB
}
