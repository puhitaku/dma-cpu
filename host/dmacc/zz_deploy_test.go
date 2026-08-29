package dmacc_test

import (
	"fmt"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/pgo"
)

// TestDeploySizes: every payload at its deployment shape — the feather
// kernel, shell and vi, plus the gamepico image — each with the
// profiled pool split (host/pgo) it ships with, and the SRAM window it
// has to fit. This is the table the PGO settings move.
//
// The figures are ratcheted (ratchet_test.go) under `deploy/`, which
// is where a residency change shows up as what it costs: TestZZAllSizes
// measures the kernel WITHOUT a display, so the .ramtext a framebuffer
// board carries — cursor_xor, kfbcon_putc — moves no figure there at
// all. Here it does, beside the flash text it came out of.
//
// The windows are also CHECKED here, not just printed. dmxgen refuses a
// bundle that crosses one, but dmxgen does not run under `make test`,
// so a setting that overruns a window used to fail at deploy time
// instead of at test time — which is a long way from the edit. Two of
// those bounds are what limit the profile's inline-compare sets
// (host/pgo InlineSites, prompts/042 §1): the kernel's .ramtext window,
// where dmaasm's sign-dispatch arena lands, and the game's flash text,
// which runs at the asset blob's home.
func TestDeploySizes(t *testing.T) {
	bd := boards.Feather
	v, _ := emu.VariantByName(bd.SKU)
	sizes := map[string]uint64{}
	rec := func(name string, segs []img.Segment) {
		sizes["deploy/"+name+"/text"] = uint64(len(segs[0].Data))
		sizes["deploy/"+name+"/data"] = uint64(len(segs[1].Data))
		sizes["deploy/"+name+"/ramtext"] = uint64(len(segs[2].Data))
	}
	kc := compileKernelXsh(t, true)
	kern, err := dmaasm.Assemble(kc, dmaasm.Options{Variant: v, Compact: true,
		TextBase: bd.KernTextXIP, DataBase: bd.KernCData, RAMTextBase: bd.KernCRText,
		PoolText: true, HotLits: pgo.KernelLits})
	if err != nil {
		t.Fatal(err)
	}
	rec("feather-kernel", kern.Image.Segments)
	fmt.Printf("DEP kernel: text=%d data=%d rtext=%d  (data window %d)\n",
		len(kern.Image.Segments[0].Data), len(kern.Image.Segments[1].Data),
		len(kern.Image.Segments[2].Data), bd.ShRText-bd.KernCData)
	fits(t, "kernel .ramtext", bd.KernCRText, kern, 2, bd.KernCData)
	fits(t, "kernel data", bd.KernCData, kern, 1, bd.ShRText)
	sh, err := dmaasm.Assemble(compileShDasm(t, bd), dmaasm.Options{Variant: v, Compact: true,
		TextBase: bd.ShTextXIP, DataBase: bd.ShData, RAMTextBase: bd.ShRText, PoolText: true, HotLits: pgo.ShLits})
	if err != nil {
		t.Fatal(err)
	}
	rec("feather-sh", sh.Image.Segments)
	fmt.Printf("DEP sh:     text=%d data=%d rtext=%d  (data window %d)\n",
		len(sh.Image.Segments[0].Data), len(sh.Image.Segments[1].Data),
		len(sh.Image.Segments[2].Data), bd.IdleText-bd.ShData)
	res, text, rt, data, _ := buildUserResident(t, v, bd, bd.ViHome, "vi", "umalloc")
	_ = res
	claim := ((len(rt)+len(data))+255)&^255 + 0x100
	sizes["deploy/feather-vi/text"] = uint64(len(text))
	sizes["deploy/feather-vi/data"] = uint64(len(data))
	sizes["deploy/feather-vi/ramtext"] = uint64(len(rt))
	sizes["deploy/feather-vi/arenaclaim"] = uint64(claim)
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
	rec("gamepico-game", game.Image.Segments)
	fmt.Printf("DEP game:   text=%d data=%d rtext=%d  (data window %d)\n",
		len(game.Image.Segments[0].Data), len(game.Image.Segments[1].Data),
		len(game.Image.Segments[2].Data), 0x20038000-gb.GameData)
	fits(t, "game .ramtext", gb.GameRAMText, game, 2, gb.GameData)
	fits(t, "game data", gb.GameData, game, 1, gameAudioBase)
	fits(t, "game text", gb.GameTextXIP, game, 0, gameSFXHome)
	pinSet(t, "deploy/", sizes)
}

// fits checks that one segment of a deployed image stops short of
// whatever the map puts next to it, and says by how much it did not.
func fits(t *testing.T, what string, base uint32, res *dmaasm.Result, seg int, limit uint32) {
	t.Helper()
	end := base + uint32(len(res.Image.Segments[seg].Data))
	if end > limit {
		t.Errorf("%s ends at %#x, %d bytes past %#x", what, end, end-limit, limit)
		return
	}
	fmt.Printf("DEP   %-16s %#x..%#x, %d bytes to spare\n", what, base, end, limit-end)
}
