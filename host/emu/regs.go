// Package emu implements dmaemu, a DMA-machine-level emulator for the
// RP2 DMA subsystem (see prompts/overview.md, Phase 0). It models
// exactly the semantics the DMA computing machine relies on — channels,
// triggers, chaining, DREQ credits, pacing timers, the sniffer, and the
// atomic register aliases — deterministically and at bus-transfer
// granularity. It is deliberately not a full-chip emulator.
//
// This file holds the definitions shared across the RP2 family; every
// SKU-specific encoding (CTRL bit layout, global register offsets, sizes)
// lives in Variant (variant.go). Sources: RP2040 datasheet §2.5 and
// RP2350 datasheet §12.6 (doc/).
package emu

// Address map (common to RP2040 and RP2350).
const (
	SRAMBase uint32 = 0x20000000

	DMABase uint32 = 0x50000000

	// Atomic register access aliases (RP2040 §2.1.2, RP2350 §2.1.3),
	// applied within each peripheral's 16 KiB window.
	AliasXOR uint32 = 0x1000
	AliasSet uint32 = 0x2000
	AliasClr uint32 = 0x3000
)

// Per-channel register offsets (stride 0x40; identical on both SKUs).
// Each 32-bit control/status register (CSR) appears in four aliases with
// different orderings; the last register of each alias row is a trigger.
const (
	ChanStride uint32 = 0x40

	OffReadAddr          uint32 = 0x00
	OffWriteAddr         uint32 = 0x04
	OffTransCount        uint32 = 0x08
	OffCtrlTrig          uint32 = 0x0C
	OffAl1Ctrl           uint32 = 0x10
	OffAl1ReadAddr       uint32 = 0x14
	OffAl1WriteAddr      uint32 = 0x18
	OffAl1TransCountTrig uint32 = 0x1C
	OffAl2Ctrl           uint32 = 0x20
	OffAl2TransCount     uint32 = 0x24
	OffAl2ReadAddr       uint32 = 0x28
	OffAl2WriteAddrTrig  uint32 = 0x2C
	OffAl3Ctrl           uint32 = 0x30
	OffAl3WriteAddr      uint32 = 0x34
	OffAl3TransCount     uint32 = 0x38
	OffAl3ReadAddrTrig   uint32 = 0x3C
)

// The interrupt block start is common (INTR at 0x400, then per-IRQ
// {INTE, INTF, INTS} groups every 0x10); everything after it moved on
// RP2350 and lives in Variant.
const (
	offIntr     uint32 = 0x400
	offIrqBlock uint32 = 0x404
)

// ChanRegAddr returns the absolute address of a channel register.
func ChanRegAddr(ch int, off uint32) uint32 { return DMABase + uint32(ch)*ChanStride + off }

// CTRL register bits common to both SKUs (the low bits; everything from
// INCR_WRITE up is SKU-specific — see Variant).
const (
	CtrlEN           uint32 = 1 << 0
	CtrlHighPriority uint32 = 1 << 1
	ctrlDataSizeLSB         = 2
	CtrlSize8        uint32 = 0 << ctrlDataSizeLSB
	CtrlSize16       uint32 = 1 << ctrlDataSizeLSB
	CtrlSize32       uint32 = 2 << ctrlDataSizeLSB
	CtrlIncrRead     uint32 = 1 << 4
)

func ctrlDataSize(ctrl uint32) uint32 { return (ctrl >> ctrlDataSizeLSB) & 0x3 }

// TREQ_SEL special values (identical on both SKUs).
const (
	TreqTimer0    uint32 = 0x3B
	TreqTimer1    uint32 = 0x3C
	TreqTimer2    uint32 = 0x3D
	TreqTimer3    uint32 = 0x3E
	TreqPermanent uint32 = 0x3F
)

// SNIFF_CTRL bit fields (identical on both SKUs; only the register's
// offset moved — see Variant.SniffCtrlAddr).
const (
	SniffCtrlEN     uint32 = 1 << 0
	sniffDmachLSB          = 1 // 4:1
	sniffCalcLSB           = 5 // 8:5
	SniffCtrlBswap  uint32 = 1 << 9
	SniffCtrlOutRev uint32 = 1 << 10
	SniffCtrlOutInv uint32 = 1 << 11

	SniffCalcCRC32  uint32 = 0x0
	SniffCalcCRC32R uint32 = 0x1
	SniffCalcCRC16  uint32 = 0x2
	SniffCalcCRC16R uint32 = 0x3
	SniffCalcEven   uint32 = 0xE
	SniffCalcSum    uint32 = 0xF
)

func SniffCtrlDmach(ch int) uint32  { return (uint32(ch) & 0xF) << sniffDmachLSB }
func SniffCtrlCalc(c uint32) uint32 { return (c & 0xF) << sniffCalcLSB }
func sniffDmach(ctrl uint32) int    { return int((ctrl >> sniffDmachLSB) & 0xF) }
func sniffCalc(ctrl uint32) uint32  { return (ctrl >> sniffCalcLSB) & 0xF }

// Block is one 16-byte DMA control block as fetched by the fetch channel:
// the alias-0 register order (READ_ADDR, WRITE_ADDR, TRANS_COUNT,
// CTRL_TRIG). An all-zero Block is a null trigger, i.e. HALT. The CTRL
// word encoding is SKU-specific: blocks are assembled for one Variant.
type Block [4]uint32

func BuildBlock(readAddr, writeAddr, count, ctrl uint32) Block {
	return Block{readAddr, writeAddr, count, ctrl}
}
