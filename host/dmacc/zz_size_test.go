package dmacc_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
)

func TestZZAllSizes(t *testing.T) {
	t.Parallel()
	v, _ := emu.VariantByName("rp2350")
	meas := func(name, dasm string, compact bool) {
		res, err := dmaasm.Assemble(dasm, dmaasm.Options{
			Variant: v, Compact: compact, CompactScratch: 0x2007FE00,
			TextBase: 0x40000000, DataBase: 0x50000000, RAMTextBase: 0x60000000})
		if err != nil {
			t.Fatalf("%s: %v", name, err)
		}
		tl, dl := len(res.Image.Segments[0].Data), len(res.Image.Segments[1].Data)
		rl := 0
		if len(res.Image.Segments) > 2 {
			rl = len(res.Image.Segments[2].Data)
		}
		if rl > 0 {
			t.Logf("%-12s text %6d (%3d KB)  data %6d (%2d KB)  ramtext %6d (%2d KB)  [SRAM %d KB]",
				name, tl, tl/1024, dl, dl/1024, rl, rl/1024, (dl+rl)/1024)
		} else {
			t.Logf("%-12s text %6d (%3d KB)  data %6d (%2d KB)", name, tl, tl/1024, dl, dl/1024)
		}
	}
	meas("lean", compileKernel(t, false), false)
	meas("fs-kernel", compileKernel(t, true), true)
	meas("fs-kern-xip", compileKernelOpts(t, true, true), true)
	meas("fs-xip-Os", compileKernelSized(t), true)
	shMod, err := llir.Merge(
		parseLL(t, "../../target/xv6/ll/sh.ll"), parseLL(t, "../../target/xv6/ll/ulib.ll"),
		parseLL(t, "../../target/xv6/ll/umalloc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	shDasm, err := dmacc.Compile(shMod, dmacc.Options{RecursionDepth: 12})
	if err != nil {
		t.Fatal(err)
	}
	meas("sh(K12)", shDasm, true)
	shXDasm, err := dmacc.Compile(shMod, dmacc.Options{RecursionDepth: 12, XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	meas("sh-xip", shXDasm, true)
	lsMod, err := llir.Merge(parseLL(t, "../../target/xv6/ll/ls.ll"),
		parseLL(t, "../../target/xv6/ll/ulib.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	lsDasm, err := dmacc.Compile(lsMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	meas("ls", lsDasm, true)
}
