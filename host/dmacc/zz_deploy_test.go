package dmacc_test

import (
	"fmt"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/pgo"
)

// TestDeploySizes: every payload at its deployment shape — the feather
// kernel, shell and vi, plus the gamepico image — each with the
// profiled pool split (host/pgo) it ships with, and the SRAM window it
// has to fit. This is the table the PGO settings move.
func TestDeploySizes(t *testing.T) {
	bd := boards.Feather
	v, _ := emu.VariantByName(bd.SKU)
	kc := compileKernelXsh(t, true)
	kern, err := dmaasm.Assemble(kc, dmaasm.Options{Variant: v, Compact: true,
		TextBase: bd.KernTextXIP, DataBase: bd.KernCData, RAMTextBase: bd.KernCRText,
		PoolText: true, HotLits: pgo.KernelLits})
	if err != nil {
		t.Fatal(err)
	}
	fmt.Printf("DEP kernel: text=%d data=%d rtext=%d  (data window %d)\n",
		len(kern.Image.Segments[0].Data), len(kern.Image.Segments[1].Data),
		len(kern.Image.Segments[2].Data), bd.ShRText-bd.KernCData)
	sh, err := dmaasm.Assemble(compileShDasm(t, bd), dmaasm.Options{Variant: v, Compact: true,
		TextBase: bd.ShTextXIP, DataBase: bd.ShData, RAMTextBase: bd.ShRText, PoolText: true, HotLits: pgo.ShLits})
	if err != nil {
		t.Fatal(err)
	}
	fmt.Printf("DEP sh:     text=%d data=%d rtext=%d  (data window %d)\n",
		len(sh.Image.Segments[0].Data), len(sh.Image.Segments[1].Data),
		len(sh.Image.Segments[2].Data), bd.IdleText-bd.ShData)
	res, text, rt, data, _ := buildUserResident(t, v, bd, bd.ViHome, "vi", "umalloc")
	_ = res
	claim := ((len(rt)+len(data))+255)&^255 + 0x100
	fmt.Printf("DEP vi:     text=%d data=%d rtext=%d  (arena claim %d of %d)\n",
		len(text), len(data), len(rt), claim, bd.ArenaEnd-bd.Arena)
	// The game: bare metal on the gamepico, data growing toward fx.c's
	// fixed audio ring at 0x20038000.
	gb := boards.GamePico
	gv, _ := emu.VariantByName(gb.SKU)
	game, err := dmaasm.Assemble(compileGameDasm(t), dmaasm.Options{
		Variant: gv, Compact: true, TextBase: gb.GameTextXIP,
		DataBase: gb.GameData, RAMTextBase: gb.GameRAMText,
		PoolText: true, HotLits: pgo.GameLits})
	if err != nil {
		t.Fatal(err)
	}
	fmt.Printf("DEP game:   text=%d data=%d rtext=%d  (data window %d)\n",
		len(game.Image.Segments[0].Data), len(game.Image.Segments[1].Data),
		len(game.Image.Segments[2].Data), 0x20038000-gb.GameData)
}
