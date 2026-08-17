package dmacc_test

import (
	"os"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// TestPreemptiveScheduler runs the proto-kernel's preemption path in
// isolation: two relocated instances of the compiled counter program
// (testdata/proc.c — no syscalls at all) round-robin scheduled by the
// Phase 5d proc-table kernel under a pacing-timer tick. Both processes
// must make progress over the same window — true preemptive
// interleaving with zero host involvement after setup.
func TestPreemptiveScheduler(t *testing.T) {
	src, err := os.ReadFile("testdata/proc.ll")
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
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) {
			kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{
				Variant: v, TextBase: 0x20000000, DataBase: 0x20002000})
			if err != nil {
				t.Fatal(err)
			}
			kernC := buildKernelC(t, v, 0x20004000, 0x20016000)
			procA, err := dmaasm.Assemble(dasm, dmaasm.Options{
				Variant: v, TextBase: 0x2001C000, DataBase: 0x2001F000})
			if err != nil {
				t.Fatal(err)
			}
			procB, err := dmaasm.Assemble(dasm, dmaasm.Options{
				Variant: v, TextBase: 0x20020000, DataBase: 0x20023000})
			if err != nil {
				t.Fatal(err)
			}

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
			wireKernel(t, m, v, kern, kernC, []kproc{
				{procA, entryA, 1, 0, false},
				{procB, entryB, 2, 0, false},
			})
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entryA, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			cA := mustSym(t, procA, "g_counter")
			cB := mustSym(t, procB, "g_counter")
			tk := mustSym(t, kernC, "g_ticks")
			if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000}); err != nil {
				t.Fatal(err)
			}
			a1, b1, t1 := m.Peek32(cA), m.Peek32(cB), m.Peek32(tk)
			if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000}); err != nil {
				t.Fatal(err)
			}
			a2, b2, t2 := m.Peek32(cA), m.Peek32(cB), m.Peek32(tk)

			t.Logf("ticks %d -> %d, counterA %d -> %d, counterB %d -> %d",
				t1, t2, a1, a2, b1, b2)
			if t1 < 1 || t2 <= t1 {
				t.Errorf("scheduler ticks did not advance: %d -> %d", t1, t2)
			}
			if a2 <= a1 {
				t.Errorf("process A starved: counter %d -> %d", a1, a2)
			}
			if b2 <= b1 {
				t.Errorf("process B starved: counter %d -> %d", b1, b2)
			}
		})
	}
}
