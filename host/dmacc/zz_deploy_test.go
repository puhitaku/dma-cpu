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

// TestDeploySizes: the feather images at their deployment shapes
// (kernel: profiled pool split; sh: all-cold; vi: resident all-cold).
func TestDeploySizes(t *testing.T) {
	bd := boards.Feather
	v, _ := emu.VariantByName(bd.SKU)
	kc := compileKernelXsh(t, true)
	kern, err := dmaasm.Assemble(kc, dmaasm.Options{Variant: v, Compact: true,
		TextBase: bd.KernTextXIP, DataBase: bd.KernCData, RAMTextBase: bd.KernCRText,
		PoolText: true, HotLits: dmaasm.XSHHotLits})
	if err != nil {
		t.Fatal(err)
	}
	fmt.Printf("DEP kernel: text=%d data=%d rtext=%d\n",
		len(kern.Image.Segments[0].Data), len(kern.Image.Segments[1].Data), len(kern.Image.Segments[2].Data))
	shMod, err := llir.Merge(parseLL(t, "../../target/xv6/ll/sh.ll"), parseLL(t, "../../target/xv6/ll/ulib.ll"),
		parseLL(t, "../../target/xv6/ll/umalloc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	shDasm, err := dmacc.Compile(shMod, dmacc.Options{RecursionDepth: 8, XIPText: true,
		RuntimeExtern: &dmacc.ExternRT{Vec: bd.KernCRText, Regs: bd.KernCData}})
	if err != nil {
		t.Fatal(err)
	}
	sh, err := dmaasm.Assemble(shDasm, dmaasm.Options{Variant: v, Compact: true,
		TextBase: bd.ShTextXIP, DataBase: bd.ShData, RAMTextBase: bd.ShRText, PoolText: true})
	if err != nil {
		t.Fatal(err)
	}
	fmt.Printf("DEP sh:     text=%d data=%d rtext=%d\n",
		len(sh.Image.Segments[0].Data), len(sh.Image.Segments[1].Data), len(sh.Image.Segments[2].Data))
	res, text, rt, data, _ := buildUserResident(t, v, bd, bd.ViHome, "vi", "umalloc")
	_ = res
	claim := ((len(rt)+len(data))+255)&^255 + 0x100
	fmt.Printf("DEP vi:     text=%d data=%d rtext=%d  claim=%d\n", len(text), len(data), len(rt), claim)
}
