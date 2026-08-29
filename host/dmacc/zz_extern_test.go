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

func TestExternSizes(t *testing.T) {
	v, _ := emu.VariantByName("rp2350")
	bd := boards.Pico2
	for _, name := range []string{"echo", "cat", "ls", "toolbox", "hwtools", "fbtest", "show", "usertests", "vi"} {
		for _, ext := range []bool{false, true} {
			paths := []string{name, "ulib", "usys"}
			if name == "vi" {
				paths = []string{name, "ulib", "umalloc", "usys"}
			}
			if name == "usertests" {
				paths = []string{name, "ulib", "printf", "umalloc", "usys"}
			}
			var mods []*llir.Module
			for _, p := range paths {
				mods = append(mods, parseLL(t, "../../target/xv6/ll/"+p+".ll"))
			}
			mod, err := llir.Merge(mods...)
			if err != nil {
				t.Fatal(err)
			}
			o := dmacc.Options{OptSize: boards.SizeApps[name]}
			if ext {
				o.RuntimeExtern = &dmacc.ExternRT{Vec: bd.KernCRText, Regs: bd.KernCData}
			}
			dasm, err := dmacc.Compile(mod, o)
			if err != nil {
				t.Fatal(err)
			}
			res, err := dmaasm.Assemble(dasm, dmaasm.Options{
				Variant: v, Compact: true, TextBase: 0x10000000, DataBase: 0x10040000})
			if err != nil {
				t.Fatal(err)
			}
			text, data := len(res.Image.Segments[0].Data), len(res.Image.Segments[1].Data)
			fmt.Printf("EXT %-9s extern=%-5v text=%6d data=%6d total=%6d\n", name, ext, text, data, text+data)
		}
	}
	// sh at its real deployment shape
	for _, ext := range []bool{false, true} {
		mod, err := llir.Merge(parseLL(t, "../../target/xv6/ll/sh.ll"), parseLL(t, "../../target/xv6/ll/ulib.ll"),
			parseLL(t, "../../target/xv6/ll/umalloc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
		if err != nil {
			t.Fatal(err)
		}
		o := dmacc.Options{RecursionDepth: 2, XIPText: true}
		if ext {
			o.RuntimeExtern = &dmacc.ExternRT{Vec: bd.KernCRText, Regs: bd.KernCData}
		}
		dasm, err := dmacc.Compile(mod, o)
		if err != nil {
			t.Fatal(err)
		}
		res, err := dmaasm.Assemble(dasm, dmaasm.Options{
			Variant: v, Compact: true, TextBase: bd.ShTextXIP, DataBase: bd.ShData, RAMTextBase: bd.ShRText})
		if err != nil {
			t.Fatal(err)
		}
		fmt.Printf("EXT sh(xip)   extern=%-5v xiptext=%6d data=%6d rtext=%6d  SRAM=%6d\n", ext,
			len(res.Image.Segments[0].Data), len(res.Image.Segments[1].Data), len(res.Image.Segments[2].Data),
			len(res.Image.Segments[1].Data)+len(res.Image.Segments[2].Data))
	}
}
