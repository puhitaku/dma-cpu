package dmacc_test

// The SRAM window bounds, checked for every board that ships the xv6
// bundle. dmxgen makes the same check while it builds (buildXsh's
// "the SRAM map above is windowed" loop), but only for the board it
// was asked for, and nothing in `make test` ran it at all — so a
// residency or literal-pool change could overflow a window on a board
// nobody happened to generate, and the first sign of it was an image
// that quietly overlapped its neighbour.
//
// The margins are the map's own discipline (boards.go: "measured sizes
// + ~0x200-0x400 margins"), and the profile generator holds the data
// side to exactly one allocator page (zz_pgogen_test.go's
// windowMargin). Failing here means the map needs a MOVE — new
// addresses in boards.go with the arena or the data slack named as
// what paid — not a smaller margin.

import (
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/pgo"
)

func TestBoardWindows(t *testing.T) {
	t.Parallel()
	for _, bd := range []*boards.Board{boards.Pico2, boards.Pico, boards.Feather} {
		t.Run(bd.Name, func(t *testing.T) {
			t.Parallel()
			v, err := emu.VariantByName(bd.SKU)
			if err != nil {
				t.Fatal(err)
			}
			kern, err := dmaasm.Assemble(compileKernelXsh(t, bd.FbBuf != 0),
				dmaasm.Options{Variant: v, Compact: true,
					TextBase: bd.KernTextXIP, DataBase: bd.KernCData,
					RAMTextBase: bd.KernCRText, PoolText: true, HotLits: pgo.KernelLits})
			if err != nil {
				t.Fatal(err)
			}
			sh, err := dmaasm.Assemble(compileShDasm(t, bd),
				dmaasm.Options{Variant: v, Compact: true,
					TextBase: bd.ShTextXIP, DataBase: bd.ShData,
					RAMTextBase: bd.ShRText, PoolText: true, HotLits: pgo.ShLits})
			if err != nil {
				t.Fatal(err)
			}
			for _, w := range []struct {
				name      string
				seg       []byte
				base, end uint32
			}{
				{"kernel ramtext", kern.Image.Segments[2].Data, bd.KernCRText, bd.KernCData},
				{"kernel data", kern.Image.Segments[1].Data, bd.KernCData, bd.ShRText},
				{"kernel text (XIP)", kern.Image.Segments[0].Data, bd.KernTextXIP, bd.ShTextXIP},
				{"sh ramtext", sh.Image.Segments[2].Data, bd.ShRText, bd.ShData},
				{"sh data", sh.Image.Segments[1].Data, bd.ShData, bd.IdleText},
			} {
				used, size := uint32(len(w.seg)), w.end-w.base
				if used > size {
					t.Errorf("%s: %d bytes in a %d-byte window [%#x,%#x) — %d over",
						w.name, used, size, w.base, w.end, used-size)
					continue
				}
				t.Logf("%-18s %6d of %6d  (%d free)", w.name, used, size, size-used)
			}
			// The arena has to clear the heaviest resident image the
			// board installs: vi's exec claim is placed at the bottom
			// and its first heap chunk comes off the top, both out of
			// this one region (TestScratch-free measurements live in
			// TestXv6ViFeather, which runs the session for real).
			arenaEnd := bd.ArenaEnd
			if bd.DTabRAM != 0 && bd.DTabRAM > bd.Arena && bd.DTabRAM < arenaEnd {
				arenaEnd = bd.DTabRAM
			}
			t.Logf("%-18s %6d bytes", "arena", arenaEnd-bd.Arena)
		})
	}
}
