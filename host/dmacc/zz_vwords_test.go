package dmacc_test

import (
	"fmt"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"

	"github.com/puhitaku/dma-cpu/host/dmacc"
)

// TestValueWords classifies each image's data words by prefix: the
// sizing pass for SSA value-word coalescing.
func TestValueWords(t *testing.T) {
	v, _ := emu.VariantByName("rp2350")
	type build struct {
		name string
		mods []string
		xip  bool
	}
	builds := []build{
		{"ls", []string{"ls", "ulib", "usys"}, false},
		{"toolbox", []string{"toolbox", "ulib", "usys"}, false},
		{"show", []string{"show", "ulib", "usys"}, false},
	}
	{ // the fb kernel, pool split at its true boundary
		kc := compileKernelXsh(t, true)
		res, err := dmaasm.Assemble(kc, dmaasm.Options{
			Variant: v, Compact: true, TextBase: 0x10460000, DataBase: 0x2000C000, RAMTextBase: 0x20004000})
		if err != nil {
			t.Fatal(err)
		}
		dlen := uint32(len(res.Image.Segments[1].Data))
		classes := map[string]uint32{}
		type sym struct {
			n string
			a uint32
		}
		var syms []sym
		for n, a := range res.Symbols {
			if a >= 0x2000C000 && a < 0x2000C000+dlen {
				syms = append(syms, sym{n, a})
			}
		}
		sort.Slice(syms, func(i, j int) bool { return syms[i].a < syms[j].a })
		for i, s := range syms {
			end := 0x2000C000 + dlen
			if i+1 < len(syms) {
				end = syms[i+1].a
			}
			sz := end - s.a
			n := s.n
			if i == len(syms)-1 {
				classes["(literal pool)"] += sz - 4
				sz = 4
			}
			switch {
			case strings.HasPrefix(n, "vs_"):
				classes["vs_"] += sz
			case strings.HasPrefix(n, "v_"):
				classes["v_"] += sz
			case strings.HasPrefix(n, "pl_"):
				classes["pl_"] += sz
			case strings.HasPrefix(n, "lrs_"):
				classes["lrs_"] += sz
			case strings.HasPrefix(n, "a_"):
				classes["a_"] += sz
			case strings.HasPrefix(n, "g_"):
				classes["g_"] += sz
			default:
				classes["other"] += sz
			}
		}
		fmt.Printf("VW kernel   data=%d\n", dlen)
		keys := make([]string, 0, len(classes))
		for k := range classes {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			fmt.Printf("VW   %-14s %6d\n", k, classes[k])
		}
	}
	for _, b := range builds {
		var mods []*llir.Module
		for _, p := range b.mods {
			mods = append(mods, parseLL(t, "../../target/xv6/ll/"+p+".ll"))
		}
		mod, err := llir.Merge(mods...)
		if err != nil {
			t.Fatal(err)
		}
		dasm, err := dmacc.Compile(mod, dmacc.Options{})
		if err != nil {
			t.Fatal(err)
		}
		res, err := dmaasm.Assemble(dasm, dmaasm.Options{
			Variant: v, Compact: true, TextBase: 0x10000000, DataBase: 0x10040000})
		if err != nil {
			t.Fatal(err)
		}
		dlen := uint32(len(res.Image.Segments[1].Data))
		classes := map[string]uint32{}
		type sym struct {
			n string
			a uint32
		}
		var syms []sym
		for n, a := range res.Symbols {
			if a >= 0x10040000 && a < 0x10040000+dlen {
				syms = append(syms, sym{n, a})
			}
		}
		sort.Slice(syms, func(i, j int) bool { return syms[i].a < syms[j].a })
		for i, s := range syms {
			end := 0x10040000 + dlen
			if i+1 < len(syms) {
				end = syms[i+1].a
			}
			sz := end - s.a
			switch {
			case strings.HasPrefix(s.n, "v_"):
				classes["v_ (ssa results)"] += sz
			case strings.HasPrefix(s.n, "pl_"):
				classes["pl_ (temps)"] += sz
			case strings.HasPrefix(s.n, "lrs_"):
				classes["lrs_ (lr saves)"] += sz
			case strings.HasPrefix(s.n, "a_"):
				classes["a_ (allocas)"] += sz
			case strings.HasPrefix(s.n, "g_"):
				classes["g_ (globals)"] += sz
			case strings.HasPrefix(s.n, "cw_"):
				classes["cw_ (millicode)"] += sz
			default:
				classes["other-named"] += sz
			}
		}
		var named uint32
		for _, x := range classes {
			named += x
		}
		fmt.Printf("VW %-8s data=%6d named=%6d pool~=%6d\n", b.name, dlen, named, dlen-named)
		keys := make([]string, 0, len(classes))
		for k := range classes {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			fmt.Printf("VW   %-18s %6d\n", k, classes[k])
		}
	}
}
