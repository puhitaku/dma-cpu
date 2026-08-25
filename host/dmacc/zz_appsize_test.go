package dmacc_test

import (
	"fmt"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// TestAppSizes reports each user app's segment sizes and its largest
// text spans (function-level, by symbol extent) — the measurement side
// of the size-optimization pass.
func TestAppSizes(t *testing.T) {
	v, _ := emu.VariantByName("rp2350")
	for _, name := range []string{"echo", "cat", "ls", "toolbox", "hwtools", "fbtest", "show", "sh"} {
		for _, sized := range []bool{false, true} {
			mods := []*llir.Module{parseLL(t, "../../target/xv6/ll/" + name + ".ll"),
				parseLL(t, "../../target/xv6/ll/ulib.ll"), parseLL(t, "../../target/xv6/ll/usys.ll")}
			if name == "sh" {
				mods = append(mods, parseLL(t, "../../target/xv6/ll/umalloc.ll"))
			}
			mod, err := llir.Merge(mods...)
			if err != nil {
				t.Fatal(err)
			}
			dasm, err := dmacc.Compile(mod, dmacc.Options{OptSize: sized})
			if err != nil {
				t.Fatal(err)
			}
			res, err := dmaasm.Assemble(dasm, dmaasm.Options{
				Variant: v, Compact: true, TextBase: 0x10000000, DataBase: 0x10040000})
			if err != nil {
				t.Fatal(err)
			}
			text, data := len(res.Image.Segments[0].Data), len(res.Image.Segments[1].Data)
			fmt.Printf("SIZE %-8s optsize=%-5v text=%6d data=%6d total=%6d\n",
				name, sized, text, data, text+data)
			if sized {
				continue
			}
			// top text spans by symbol extent (plain-named text symbols)
			type sym struct {
				name string
				off  uint32
			}
			var syms []sym
			for n, a := range res.Symbols {
				if a >= 0x10000000 && a < 0x10040000 {
					syms = append(syms, sym{n, a})
				}
			}
			sort.Slice(syms, func(i, j int) bool { return syms[i].off < syms[j].off })
			type span struct {
				name string
				sz   uint32
			}
			var spans []span
			for i := 0; i < len(syms); i++ {
				end := uint32(0x10000000 + uint32(text))
				if i+1 < len(syms) {
					end = syms[i+1].off
				}
				spans = append(spans, span{syms[i].name, end - syms[i].off})
			}
			// aggregate block spans to their owning function; internal
			// labels (millicode, literals, jump pairs) get their own
			// buckets so they stop polluting neighbors
			agg := map[string]uint32{}
			for _, sp := range spans {
				n := sp.name
				if strings.HasPrefix(n, "__cw") {
					agg["(millicode __cw_*)"] += sp.sz
					continue
				}
				if strings.HasPrefix(n, "__JP") || strings.HasPrefix(n, "__L") {
					agg["(jump pairs/labels)"] += sp.sz
					continue
				}
				if strings.HasPrefix(n, "rt_") || strings.HasPrefix(n, "__rt") {
					agg["(runtime rt_*)"] += sp.sz
					continue
				}
				if strings.HasPrefix(n, "__dmacc_fpush") || strings.HasPrefix(n, "__dmacc_fpop") {
					agg["(frame push/pop)"] += sp.sz
					continue
				}
				for _, pre := range []string{"B_", "Ld", "Ri", "Pe", "Xr", "Ct", "Sd", "pl_"} {
					if strings.HasPrefix(n, pre) {
						if pre == "B_" || pre == "pl_" {
							n = n[len(pre):]
						} else if i := strings.Index(n, "_"); i > 0 && n[:len(pre)] == pre {
							rest := n[len(pre):i]
							digits := true
							for _, c := range rest {
								if c < '0' || c > '9' {
									digits = false
								}
							}
							if digits {
								n = n[i+1:]
							}
						}
						break
					}
				}
				if i := strings.LastIndex(n, "_"); i > 0 {
					digits := len(n[i+1:]) > 0
					for _, c := range n[i+1:] {
						if c < '0' || c > '9' {
							digits = false
						}
					}
					if digits {
						n = n[:i]
					}
				}
				agg[n] += sp.sz
			}
			var fns []span
			for n, sz := range agg {
				fns = append(fns, span{n, sz})
			}
			sort.Slice(fns, func(i, j int) bool { return fns[i].sz > fns[j].sz })
			for i := 0; i < len(fns) && i < 8; i++ {
				fmt.Printf("SIZE   fn %-26s %6d\n", fns[i].name, fns[i].sz)
			}
		}
	}
}
