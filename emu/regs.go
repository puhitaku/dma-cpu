// Package emu implements dmaemu, a DMA-machine-level emulator for the
// RP2 DMA subsystem (see prompts/overview.md, Phase 0). It models
// exactly the semantics the DMA computing machine relies on — channels,
// triggers, chaining, DREQ credits, pacing timers, the sniffer, and the
// atomic register aliases — deterministically and at bus-transfer
// granularity. It is deliberately not a full-chip emulator.
//
// Register offsets and bit positions follow the RP2040 datasheet §2.5
// (doc/rp2040-datasheet.pdf); the layout is shared across the RP2 family.
// SKU-specific parameters (SRAM size, channel count) currently use RP2040
// values and are marked at their definitions.
package emu

// Address map.
const (
	SRAMBase uint32 = 0x20000000
	// SKU-specific: RP2040 value (256 KiB striped + 2 × 4 KiB scratch).
	// RP2350 has 520 KiB; parametrize when RP2350 support lands.
	SRAMSize uint32 = 0x42000

	DMABase uint32 = 0x50000000

	IOBank0Base uint32 = 0x40014000

	// Atomic register access aliases (datasheet §2.1.2), applied within
	// each peripheral's 16 KiB window.
	AliasXOR uint32 = 0x1000
	AliasSet uint32 = 0x2000
	AliasClr uint32 = 0x3000
)

// Per-channel register offsets (stride 0x40). Each 32-bit control/status
// register (CSR) appears in four aliases with different orderings; the last
// register of each alias row is a trigger (datasheet §2.5.2.1).
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

// Global DMA register offsets.
const (
	OffIntr             uint32 = 0x400
	OffInte0            uint32 = 0x404
	OffIntf0            uint32 = 0x408
	OffInts0            uint32 = 0x40C
	OffInte1            uint32 = 0x414
	OffIntf1            uint32 = 0x418
	OffInts1            uint32 = 0x41C
	OffTimer0           uint32 = 0x420
	OffMultiChanTrigger uint32 = 0x430
	OffSniffCtrl        uint32 = 0x434
	OffSniffData        uint32 = 0x438
	OffFifoLevels       uint32 = 0x440
	OffChanAbort        uint32 = 0x444
	OffNChannels        uint32 = 0x448
)

// Convenience absolute addresses.
func ChanRegAddr(ch int, off uint32) uint32 { return DMABase + uint32(ch)*ChanStride + off }

var (
	SniffCtrlAddr    = DMABase + OffSniffCtrl
	SniffDataAddr    = DMABase + OffSniffData
	SniffDataXORAddr = DMABase + AliasXOR + OffSniffData
	SniffDataSetAddr = DMABase + AliasSet + OffSniffData
	SniffDataClrAddr = DMABase + AliasClr + OffSniffData
)

// CTRL register bit fields (CHx_CTRL_TRIG).
const (
	CtrlEN           uint32 = 1 << 0
	CtrlHighPriority uint32 = 1 << 1
	ctrlDataSizeLSB         = 2
	CtrlSize8        uint32 = 0 << ctrlDataSizeLSB
	CtrlSize16       uint32 = 1 << ctrlDataSizeLSB
	CtrlSize32       uint32 = 2 << ctrlDataSizeLSB
	CtrlIncrRead     uint32 = 1 << 4
	CtrlIncrWrite    uint32 = 1 << 5
	ctrlRingSizeLSB         = 6 // 9:6
	CtrlRingSel      uint32 = 1 << 10
	ctrlChainToLSB          = 11 // 14:11
	ctrlTreqSelLSB          = 15 // 20:15
	CtrlIRQQuiet     uint32 = 1 << 21
	CtrlBswap        uint32 = 1 << 22
	CtrlSniffEn      uint32 = 1 << 23
	CtrlBusy         uint32 = 1 << 24 // read-only
)

func CtrlRingSize(n uint32) uint32 { return (n & 0xF) << ctrlRingSizeLSB }
func CtrlChainTo(ch int) uint32    { return (uint32(ch) & 0xF) << ctrlChainToLSB }
func CtrlTreq(sel uint32) uint32   { return (sel & 0x3F) << ctrlTreqSelLSB }

func ctrlDataSize(ctrl uint32) uint32 { return (ctrl >> ctrlDataSizeLSB) & 0x3 }
func ctrlRingSize(ctrl uint32) uint32 { return (ctrl >> ctrlRingSizeLSB) & 0xF }
func ctrlChainTo(ctrl uint32) int     { return int((ctrl >> ctrlChainToLSB) & 0xF) }
func ctrlTreqSel(ctrl uint32) uint32  { return (ctrl >> ctrlTreqSelLSB) & 0x3F }

// TREQ_SEL special values.
const (
	TreqTimer0    uint32 = 0x3B
	TreqTimer1    uint32 = 0x3C
	TreqTimer2    uint32 = 0x3D
	TreqTimer3    uint32 = 0x3E
	TreqPermanent uint32 = 0x3F
)

// System DREQ numbers (datasheet Table 119). Only the ones the project uses
// are named; any value 0–0x3A is accepted by PulseDREQ.
const (
	DreqPIO0RX0  uint32 = 4
	DreqPIO0RX1  uint32 = 5
	DreqPWMWrap0 uint32 = 24
	DreqADC      uint32 = 36
)

// SNIFF_CTRL bit fields.
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

func SniffCtrlDmach(ch int) uint32   { return (uint32(ch) & 0xF) << sniffDmachLSB }
func SniffCtrlCalc(c uint32) uint32  { return (c & 0xF) << sniffCalcLSB }
func sniffDmach(ctrl uint32) int     { return int((ctrl >> sniffDmachLSB) & 0xF) }
func sniffCalc(ctrl uint32) uint32   { return (ctrl >> sniffCalcLSB) & 0xF }

// Block is one 16-byte DMA control block as fetched by the fetch channel:
// the alias-0 register order (READ_ADDR, WRITE_ADDR, TRANS_COUNT,
// CTRL_TRIG). An all-zero Block is a null trigger, i.e. HALT.
type Block [4]uint32

func BuildBlock(readAddr, writeAddr, count, ctrl uint32) Block {
	return Block{readAddr, writeAddr, count, ctrl}
}
