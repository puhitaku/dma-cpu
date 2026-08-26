package dmacc_test

import (
	"fmt"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// TestArenaNeeds prints, per feather disk app, the exec-time arena
// claim: kalloc(text) + kalloc(data) + the argv area, using the
// allocator's real rounding (256B units + one 256B header each).
func TestArenaNeeds(t *testing.T) {
	bd := boards.Feather
	v, _ := emu.VariantByName(bd.SKU)
	r := func(n int) int { return (n+0xFF)&^0xFF + 0x100 }
	for _, name := range bd.DiskApps {
		mods := []*llir.Module{parseLL(t, "../../target/xv6/ll/" + name + ".ll"),
			parseLL(t, "../../target/xv6/ll/ulib.ll"), parseLL(t, "../../target/xv6/ll/usys.ll")}
		mod, err := llir.Merge(mods...)
		if err != nil {
			t.Fatal(err)
		}
		dasm, err := dmacc.Compile(mod, dmacc.Options{OptSize: boards.SizeApps[name],
			RuntimeExtern: &dmacc.ExternRT{Vec: bd.KernCRText, Regs: bd.KernCData}})
		if err != nil {
			t.Fatal(err)
		}
		res, err := dmaasm.Assemble(dasm, dmaasm.Options{
			Variant: v, Compact: true, TextBase: 0x10000000, DataBase: 0x10040000})
		if err != nil {
			t.Fatal(err)
		}
		text, data := len(res.Image.Segments[0].Data), len(res.Image.Segments[1].Data)
		need := r(text) + r(data) + 0x200
		fmt.Printf("ARENA %-8s text=%6d data=%6d  claim=%6d (0x%x)\n", name, text, data, need, need)
	}
}
