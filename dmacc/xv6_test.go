package dmacc_test

import (
	"os"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
	"github.com/puhitaku/dma-cpu/llir"
)

// TestXv6Malloc runs the first upstream xv6 code on the DMA machine:
// user/umalloc.c (unmodified) and kernel/string.c, backed by a
// test-local static-arena sbrk (kernel-less machine), driven by a self-checking allocator exercise
// (testdata/xv6malloc.c). Goldens regenerate with `make xv6-ll`.
func TestXv6Malloc(t *testing.T) {
	paths := []string{"testdata/xv6malloc.ll",
		"../xv6/ll/string.ll", "../xv6/ll/umalloc.ll"}
	var mods []*llir.Module
	for _, p := range paths {
		src, err := os.ReadFile(p)
		if err != nil {
			t.Fatal(err)
		}
		m, err := llir.Parse(string(src))
		if err != nil {
			t.Fatalf("%s: %v", p, err)
		}
		mods = append(mods, m)
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatalf("compile: %v", err)
	}
	for _, v := range emu.Variants {
		for _, compact := range []bool{false, true} {
			name := v.Name
			if compact {
				name += "-compact"
			}
			t.Run(name, func(t *testing.T) {
				res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v, Compact: compact})
				if err != nil {
					t.Fatalf("assemble: %v", err)
				}
				cfg := img.DefaultMachine()
				if compact {
					cfg = img.CompactMachine()
				}
				m := emu.NewMachine(v)
				if err := res.Image.LoadAndStart(m, nil, cfg); err != nil {
					t.Fatal(err)
				}
				rr, err := m.Run(emu.RunConfig{MaxCycles: 100_000_000})
				if err != nil {
					t.Fatal(err)
				}
				if rr.Reason != emu.StopIdle {
					t.Fatalf("did not halt: %+v", rr)
				}
				ec, _ := res.Symbol("exitcode")
				if got := m.Peek32(ec); got != 0xC0FFEE {
					t.Errorf("xv6 umalloc exercise failed: exit %#x (want 0xC0FFEE)", got)
				}
				t.Logf("cycles: %d", rr.Cycles)
			})
		}
	}
}
