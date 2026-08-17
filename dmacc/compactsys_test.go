package dmacc_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/prog"
)

// TestCompactSched runs the previously-untested combo: the preemptive
// proc-table kernel with the WHOLE system in Tier-C compact encoding —
// tick injector on the compact machine's channel 9, safepoint detours
// through 8-byte records, C kernel scheduling. Two counter processes
// must both make progress.
func TestCompactSched(t *testing.T) {
	dasm, err := dmacc.Compile(parseLL(t, "testdata/proc.ll"), dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	kcDasm := compileKernel(t, false)
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) {
			asm := func(src string, text, data uint32) *dmaasm.Result {
				res, err := dmaasm.Assemble(src, dmaasm.Options{
					Variant: v, Compact: true, CompactScratch: 0x2003FF00,
					TextBase: text, DataBase: data})
				if err != nil {
					t.Fatal(err)
				}
				return res
			}
			kern := asm(ksrc, 0x20000000, 0x20002000)
			kernC := asm(kcDasm, 0x20004000, 0x20018000)
			procA := asm(dasm, 0x2001C000, 0x2001F000)
			procB := asm(dasm, 0x20020000, 0x20023000)

			m := emu.NewMachine(v)
			for _, r := range []*dmaasm.Result{kern, kernC} {
				if _, err := r.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
			}
			entryA, err := procA.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			entryB, err := procB.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			wireKernelEnc(t, m, v, kern, kernC, []kproc{
				{procA, entryA, 1, 0, false},
				{procB, entryB, 2, 0, false},
			}, true)
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Compact: true, Entry: entryA, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			cA := mustSym(t, procA, "g_counter")
			cB := mustSym(t, procB, "g_counter")
			tk := mustSym(t, kernC, "g_ticks")
			if _, err := m.Run(emu.RunConfig{MaxCycles: 10_000}); err != nil {
				t.Fatalf("pre-tick: %v (counterA=%d)", err, m.Peek32(cA))
			}
			t.Logf("pre-tick counterA=%d", m.Peek32(cA))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 190_000}); err != nil {
				t.Fatalf("post-tick: %v (ticks=%d counterA=%d)", err, m.Peek32(tk), m.Peek32(cA))
			}
			a1, b1, t1 := m.Peek32(cA), m.Peek32(cB), m.Peek32(tk)
			if _, err := m.Run(emu.RunConfig{MaxCycles: 600_000}); err != nil {
				t.Fatal(err)
			}
			a2, b2, t2 := m.Peek32(cA), m.Peek32(cB), m.Peek32(tk)
			t.Logf("ticks %d -> %d, counterA %d -> %d, counterB %d -> %d",
				t1, t2, a1, a2, b1, b2)
			if t1 < 1 || t2 <= t1 {
				t.Errorf("ticks did not advance: %d -> %d", t1, t2)
			}
			if a2 <= a1 || b2 <= b1 {
				t.Errorf("a process starved: A %d->%d B %d->%d", a1, a2, b1, b2)
			}
		})
	}
}
