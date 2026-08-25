package dmacc_test

import (
	"fmt"
	"sort"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestKernSize maps the full fb-kernel's RAM residents: data-segment
// and ramtext symbol extents, largest first.
func TestKernSize(t *testing.T) {
	v, _ := emu.VariantByName("rp2350")
	kc := compileKernelXsh(t, true)
	res, err := dmaasm.Assemble(kc, dmaasm.Options{
		Variant: v, Compact: true, TextBase: 0x10460000, DataBase: 0x2000C000, RAMTextBase: 0x20004000})
	if err != nil {
		t.Fatal(err)
	}
	for i, s := range res.Image.Segments {
		fmt.Printf("KERN seg%d link=%08x len=%#x (%d)\n", i, s.LinkAddr, len(s.Data), len(s.Data))
	}
	report := func(tag string, lo, hi uint32) {
		type sym struct {
			name string
			off  uint32
		}
		var syms []sym
		for n, a := range res.Symbols {
			if a >= lo && a < hi {
				syms = append(syms, sym{n, a})
			}
		}
		sort.Slice(syms, func(i, j int) bool { return syms[i].off < syms[j].off })
		type span struct {
			name string
			sz   uint32
		}
		var spans []span
		for i := range syms {
			end := hi
			if i+1 < len(syms) {
				end = syms[i+1].off
			}
			spans = append(spans, span{syms[i].name, end - syms[i].off})
		}
		sort.Slice(spans, func(i, j int) bool { return spans[i].sz > spans[j].sz })
		for i := 0; i < len(spans) && i < 18; i++ {
			fmt.Printf("KERN %s %-30s %6d\n", tag, spans[i].name, spans[i].sz)
		}
	}
	report("data ", 0x2000C000, 0x2000C000+uint32(len(res.Image.Segments[1].Data)))
	report("rtext", 0x20004000, 0x20004000+uint32(len(res.Image.Segments[2].Data)))
}
