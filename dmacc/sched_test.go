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

// TestPreemptiveScheduler runs the Phase 5a proto-kernel: two relocated
// instances of the same compiled C program (testdata/proc.c),
// round-robin scheduled by prog/hil/kernel.dasm under a pacing-timer
// tick delivered through a two-injector approach-B chain. Both
// processes must make progress over the same window — true preemptive
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
				Variant: v, TextBase: 0x20000000, DataBase: 0x20004000})
			if err != nil {
				t.Fatal(err)
			}
			procA, err := dmaasm.Assemble(dasm, dmaasm.Options{
				Variant: v, TextBase: 0x20008000, DataBase: 0x2000C000})
			if err != nil {
				t.Fatal(err)
			}
			procB, err := dmaasm.Assemble(dasm, dmaasm.Options{
				Variant: v, TextBase: 0x20010000, DataBase: 0x20014000})
			if err != nil {
				t.Fatal(err)
			}

			m := emu.NewMachine(v)
			if _, err := kern.Image.Load(m, nil); err != nil {
				t.Fatal(err)
			}
			entryA, err := procA.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			entryB, err := procB.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}

			ks := func(name string) uint32 {
				a, err := kern.Symbol(name)
				if err != nil {
					t.Fatal(err)
				}
				return a
			}
			ps := func(res *dmaasm.Result, name string) uint32 {
				a, err := res.Symbol(name)
				if err != nil {
					t.Fatal(err)
				}
				return a
			}
			// Wire the kernel's cross-image pointers.
			m.Poke32(ks("pAdisp"), ps(procA, "dispatch"))
			m.Poke32(ks("pBdisp"), ps(procB, "dispatch"))
			m.Poke32(ks("pAresume"), ps(procA, "irqresume"))
			m.Poke32(ks("pBresume"), ps(procB, "irqresume"))
			m.Poke32(ks("thunkA"), ps(procA, "crtthunk"))
			m.Poke32(ks("thunkB"), ps(procB, "crtthunk"))
			m.Poke32(ks("savedB"), entryB) // B starts at its crt0

			// Injector chain: inj1 (ch3, timer TREQ) vecA -> A.dispatch,
			// chains to inj2 (ch4, permanent) vecB -> B.dispatch.
			const inj1, inj2 = 3, 4
			m.Poke32(v.TimerAddr(1), 1<<16|15000)
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1ReadAddr), ks("vecB"))
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1WriteAddr), ps(procB, "dispatch"))
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl2TransCount), 1)
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1Ctrl),
				emu.CtrlEN|emu.CtrlHighPriority|emu.CtrlSize32|
					v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(inj2)|v.CtrlIRQQuiet)
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1ReadAddr), ks("vecA"))
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1WriteAddr), ps(procA, "dispatch"))
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffTransCount), 1)
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffCtrlTrig),
				emu.CtrlEN|emu.CtrlHighPriority|emu.CtrlSize32|
					v.CtrlTreq(emu.TreqTimer1)|v.CtrlChainTo(inj2)|v.CtrlIRQQuiet)

			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entryA, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			cA, cB, tk := ps(procA, "g_counter"), ps(procB, "g_counter"), ks("ticks")
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
