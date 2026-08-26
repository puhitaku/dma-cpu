package dmacc_test

import (
	"os"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// TestSwitchNarrowCase: switch on i8/i16 with sign-bit case values
// (testdata/swcase.ll, hand-written). The case constants parse
// sign-extended while the scrutinee is a zero-extended truncation;
// without emitSwitch's width masking no high case ever matched —
// every sub-32-bit switch ever compiled carried the bug, found on
// silicon as the SD data token (0xFE) falling through its dispatch.
func TestSwitchNarrowCase(t *testing.T) {
	t.Parallel()
	src, err := os.ReadFile("testdata/swcase.ll")
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	// sw8: 254->1 128->2 7->3 9->default(0); sw16: 65534->4 258->5.
	const want = 123045
	for _, v := range emu.Variants {
		res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
		}
		m := emu.NewMachine(v)
		if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
			t.Fatal(err)
		}
		rr, err := m.Run(emu.RunConfig{MaxCycles: 50_000_000})
		if err != nil {
			t.Fatal(err)
		}
		if rr.Reason != emu.StopIdle {
			t.Fatalf("%s: did not halt: %v", v.Name, rr.Reason)
		}
		ec, _ := res.Symbol("exitcode")
		if got := m.Peek32(ec); got != want {
			t.Errorf("%s: exitcode = %d, want %d", v.Name, got, want)
		}
	}
}
