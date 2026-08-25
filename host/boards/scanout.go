package boards

import (
	"encoding/binary"

	"github.com/puhitaku/dma-cpu/host/emu"
)

// The pure-DMA HSTX scanout (the 036 ring, third act): two board-pool
// channels run a descriptor program from flash and the display never
// touches a CPU.
//
//   - The WALKER (ch14) copies one 16-byte block {READ, WRITE, COUNT,
//     CTRL_TRIG} from the table into the executor's alias-0 registers;
//     an 8→16-byte write ring snaps its write pointer back per block
//     (the compact fetch's trick, one size up).
//   - The EXECUTOR (ch15) is fully reprogrammed per block. Stream
//     blocks move command words or one fb row into the HSTX FIFO,
//     paced by the HSTX DREQ, and chain back to the walker. The tail
//     block instead writes the table's start address into the walker's
//     AL3_READ_ADDR_TRIG — the frame loops forever.
//
// Per frame: 480 active lines (a 9-word command sequence + 160 pixel
// words) and 45 blanking lines (7 words; lines 10-11 carry vsync).
// The table is immutable — fb rows sit at fixed addresses (kfbcon
// scrolls by moving pixels) — and it RUNS FROM SRAM (Board.DTabRAM):
// flash homes were tried twice and broke the display both times, the
// walker's own reads stalling behind the XIP window. 16 KiB of SRAM
// is the price of the display being the one hard-real-time consumer.
const (
	ScanWalkerCh = 14
	ScanExecCh   = 15

	HSTXFifo = 0x50600004 // RP2350 HSTX_FIFO_BASE + FIFO

	scanW     = 640
	scanRows  = 480
	scanVBL   = 45
	cmdRawRep = 0x1 << 12
	cmdTMDS   = 0x2 << 12
	cmdNOP    = 0xF << 12
	ctl00     = 0x354
	ctl01     = 0x0AB
	ctl10     = 0x154
	ctl11     = 0x2AB
	l12       = ctl00<<10 | ctl00<<20

	scanBlocksOff = 0x80 // blocks follow the command buffers
)

// ScanoutStreamCtrl is the executor CTRL for FIFO stream blocks.
// HIGH_PRIORITY: the display is the machine's only hard-real-time
// consumer — the pixel path joins the priority round-robin so exec's
// bulk copies (ch11, also HP) share slots with it instead of starving
// it. Nothing else on this system needs latency guarantees.
func ScanoutStreamCtrl(v *emu.Variant) uint32 {
	return emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 | emu.CtrlIncrRead |
		v.CtrlTreq(v.DreqHSTX) | v.CtrlChainTo(ScanWalkerCh) | v.CtrlIRQQuiet
}

// ScanoutTailCtrl is the executor CTRL for the wrap block: one plain
// word into the walker's READ_ADDR_TRIG, no chain (the trigger IS the
// transfer).
func ScanoutTailCtrl(v *emu.Variant) uint32 {
	return emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(ScanExecCh) | v.CtrlIRQQuiet
}

// ScanoutWalkerCtrl is the walker's static CTRL: 4-word blocks into
// the executor's alias-0, write pointer held by a 16-byte ring.
func ScanoutWalkerCtrl(v *emu.Variant) uint32 {
	return emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 | emu.CtrlIncrRead |
		v.CtrlIncrWrite | v.CtrlRingSel | v.CtrlRingSize(4) |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(ScanWalkerCh) | v.CtrlIRQQuiet
}

// ScanL12 exposes the shared low-1.5-lane sync pattern for tests.
func ScanL12() uint32 { return l12 }

// ScanoutBase is where the program RUNS from: the SRAM experiment
// home when set, else the flash home.
func ScanoutBase(bd *Board) uint32 {
	if bd.DTabRAM != 0 {
		return bd.DTabRAM
	}
	return bd.DTab
}

// ScanoutBlocks returns the absolute address of the first block (the
// walker's initial and wrap-around READ_ADDR).
func ScanoutBlocks(bd *Board) uint32 { return ScanoutBase(bd) + scanBlocksOff }

// ScanoutTable builds the descriptor program for bd (DTab and FbBuf
// must be set). Layout, offsets from bd.DTab:
//
//	+0x00 vactive[9]    +0x24 vblank_off[7]   +0x40 vblank_on[7]
//	+0x5C tabstart word (the tail block's source)
//	+0x80 blocks: (480 active × 2 + 45 blank + 1 tail) × 16 B
func ScanoutTable(bd *Board, v *emu.Variant) []byte {
	stream := ScanoutStreamCtrl(v)
	base := ScanoutBase(bd)
	var b []byte
	w := func(x uint32) { b = binary.LittleEndian.AppendUint32(b, x) }

	vactive := [9]uint32{
		cmdRawRep | 16, ctl11 | l12, cmdNOP,
		cmdRawRep | 96, ctl10 | l12, cmdNOP,
		cmdRawRep | 48, ctl11 | l12, cmdTMDS | scanW,
	}
	vblankOff := [7]uint32{
		cmdRawRep | 16, ctl11 | l12,
		cmdRawRep | 96, ctl10 | l12,
		cmdRawRep | (48 + scanW), ctl11 | l12, cmdNOP,
	}
	vblankOn := [7]uint32{
		cmdRawRep | 16, ctl01 | l12,
		cmdRawRep | 96, ctl00 | l12,
		cmdRawRep | (48 + scanW), ctl01 | l12, cmdNOP,
	}
	for _, x := range vactive {
		w(x)
	}
	for _, x := range vblankOff {
		w(x)
	}
	for _, x := range vblankOn {
		w(x)
	}
	w(base + scanBlocksOff) // +0x5C: the tail block reads this word
	for len(b) < scanBlocksOff {
		w(0)
	}

	blk := func(read, write, count, ctrl uint32) { w(read); w(write); w(count); w(ctrl) }
	aVact, aBoff, aBon := base+0x00, base+0x24, base+0x40
	for l := 0; l < scanRows; l++ {
		blk(aVact, HSTXFifo, 9, stream)
		blk(bd.FbBuf+uint32(l)*scanW, HSTXFifo, scanW/4, stream)
	}
	for bl := 0; bl < scanVBL; bl++ {
		src := aBoff
		if bl >= 10 && bl < 12 {
			src = aBon
		}
		blk(src, HSTXFifo, 7, stream)
	}
	// Tail: retrigger the walker at the table start.
	blk(base+0x5C, emu.ChanRegAddr(ScanWalkerCh, emu.OffAl3ReadAddrTrig),
		1, ScanoutTailCtrl(v))
	return b
}
