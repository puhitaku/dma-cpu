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
	GPIOPins      int

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

// RP2040: datasheet §2.5 (doc/rp2040-datasheet.pdf).
var RP2040 = &Variant{
	Name:          "rp2040",
	NChannels:     12,
	NIRQs:         2,
	SRAMSize:      0x42000, // 256 KiB striped + 2 × 4 KiB scratch
	IOBank0Base:   0x40014000,
	PadsBank0Base: 0x4001C000,
	PIO0Base:      0x50200000,
	UART0Base:     0x40034000, // RP2040 datasheet §4.2
	GPIOPins:      30,

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

// RP2350: datasheet §12.6 (doc/rp2350-datasheet.pdf). SECCFG/MPU
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
	GPIOPins:      48,

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

func (v *Variant) SniffCtrlAddr() uint32 { return DMABase + v.offSniffCtrl }

// UART0 data and flag registers (PL011: DR at +0x00, FR at +0x18). The
// emulator models DR writes as console output; FR reads back 0, so the
// TX-full poll a real-hardware putc needs falls straight through.
func (v *Variant) UARTDRAddr() uint32 { return v.UART0Base + 0x00 }
func (v *Variant) UARTFRAddr() uint32 { return v.UART0Base + 0x18 }

func (v *Variant) SniffDataAddr() uint32    { return DMABase + v.offSniffData }
func (v *Variant) SniffDataXORAddr() uint32 { return DMABase + AliasXOR + v.offSniffData }
func (v *Variant) SniffDataSetAddr() uint32 { return DMABase + AliasSet + v.offSniffData }
func (v *Variant) SniffDataClrAddr() uint32 { return DMABase + AliasClr + v.offSniffData }

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
