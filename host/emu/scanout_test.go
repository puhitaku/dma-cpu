package emu_test

import (
	"encoding/binary"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestHSTXScanout runs the pure-DMA display pipeline exactly as the
// feather deploys it: the descriptor program in flash at DTab, the
// walker/executor pair on the board-pool channels, fb rows in SRAM.
// The emulator's HSTX FIFO always accepts, so the scanout free-runs;
// the capture must show the full 640x480@60 frame structure, correct
// pixels, and two identical consecutive frames (the tail block's wrap).
func TestHSTXScanout(t *testing.T) {
	bd := boards.Feather
	v, err := emu.VariantByName(bd.SKU)
	if err != nil {
		t.Fatal(err)
	}
	m := emu.NewMachine(v)
	m.Flash = make([]byte, bd.FlashSize)

	tab := boards.ScanoutTable(bd, v)
	if base := boards.ScanoutBase(bd); base >= 0x20000000 {
		for i := 0; i < len(tab); i += 4 {
			m.Poke32(base+uint32(i), binary.LittleEndian.Uint32(tab[i:]))
		}
	} else {
		copy(m.Flash[base-0x10000000:], tab)
	}

	// A recognizable fb: row-dependent pattern.
	for row := uint32(0); row < 480; row++ {
		for x := uint32(0); x < 640; x += 4 {
			w := row<<24 | row<<16 | row<<8 | x/4&0xFF
			m.Poke32(bd.FbBuf+row*640+x, w)
		}
	}

	// Arm the walker as target/firmware main.c does.
	walker := emu.ChanRegAddr(boards.ScanWalkerCh, 0)
	m.Poke32(walker+emu.OffReadAddr, boards.ScanoutBlocks(bd))
	m.Poke32(walker+emu.OffWriteAddr, emu.ChanRegAddr(boards.ScanExecCh, 0))
	m.Poke32(walker+emu.OffTransCount, 4)
	m.Poke32(walker+emu.OffCtrlTrig, boards.ScanoutWalkerCtrl(v))

	const frame = 480*(9+160) + 45*7 // words per frame
	for i := 0; i < 400 && len(m.HSTXOut) < 2*frame+9; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000}); err != nil {
			t.Fatal(err)
		}
	}
	if len(m.HSTXOut) < 2*frame+9 {
		t.Fatalf("scanout stalled: %d words (want >= %d)", len(m.HSTXOut), 2*frame+9)
	}

	// Frame structure: line 0 = 9 command words then row 0's pixels.
	want9 := []uint32{0x1010, 0x2AB | boards.ScanL12(), 0xF000,
		0x1060, 0x154 | boards.ScanL12(), 0xF000,
		0x1030, 0x2AB | boards.ScanL12(), 0x2000 | 640}
	for i, w := range want9 {
		if m.HSTXOut[i] != w {
			t.Fatalf("cmd[%d] = %#x, want %#x", i, m.HSTXOut[i], w)
		}
	}
	for x := 0; x < 160; x++ {
		want := binary.LittleEndian.Uint32(fbWord(m, bd, 0, uint32(x*4)))
		if m.HSTXOut[9+x] != want {
			t.Fatalf("line0 px[%d] = %#x, want %#x", x, m.HSTXOut[9+x], want)
		}
	}
	// Line 250 lands at 250*(169) into the frame.
	off := 250 * 169
	for x := 0; x < 160; x++ {
		want := binary.LittleEndian.Uint32(fbWord(m, bd, 250, uint32(x*4)))
		if m.HSTXOut[off+9+x] != want {
			t.Fatalf("line250 px[%d] = %#x, want %#x", x, m.HSTXOut[off+9+x], want)
		}
	}
	// Two identical consecutive frames.
	for i := 0; i < frame; i++ {
		if m.HSTXOut[i] != m.HSTXOut[frame+i] {
			t.Fatalf("frame mismatch at word %d: %#x vs %#x", i, m.HSTXOut[i], m.HSTXOut[frame+i])
		}
	}
}

func fbWord(m *emu.Machine, bd *boards.Board, row, x uint32) []byte {
	var b [4]byte
	binary.LittleEndian.PutUint32(b[:], m.Peek32(bd.FbBuf+row*640+x))
	return b[:]
}
