package dmacc_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// TestXv6Kill runs kill() + init-style reparenting (prompts/024):
// pid 1 kills the spinning pid 3 (a running victim, so the kill lands
// at its next tick entry) and reaps it with status -1; pid 3's child
// (pid 4) is orphaned, adopted by init (pid 2, the idle counter, which
// never waits) and freed without a zombie when it later exits.
func TestXv6Kill(t *testing.T) {
	t.Parallel()
	mod, err := llir.Merge(parseLL(t, "testdata/xv6kill.ll"), parseLL(t, "../xv6/ll/usys.ll"))
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
			kernC := buildKernelC(t, v, 0x20004000, 0x2001D000)
			asm := func(text, data uint32) *dmaasm.Result {
				res, err := dmaasm.Assemble(dasm, dmaasm.Options{
					Variant: v, TextBase: text, DataBase: data})
				if err != nil {
					t.Fatal(err)
				}
				return res
			}
			killer := asm(0x20020000, 0x20024000)
			idle := asm(0x20026000, 0x2002A000)
			victim := asm(0x2002C000, 0x20030000)
			orphan := asm(0x20032000, 0x20036000)

			m := emu.NewMachine(v)
			var entries [4]uint32
			for i, r := range []*dmaasm.Result{killer, idle, victim, orphan} {
				e, err := r.Image.Load(m, nil)
				if err != nil {
					t.Fatal(err)
				}
				entries[i] = e
			}
			for _, r := range []*dmaasm.Result{kern, kernC} {
				if _, err := r.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
			}
			wireKernel(t, m, v, kern, kernC, []kproc{
				{killer, entries[0], 1, 0, true},
				{idle, entries[1], 2, 0, true},
				{victim, entries[2], 3, 1, true},
				{orphan, entries[3], 4, 3, true},
			})
			m.Poke32(mustSym(t, kernC, "g_initpid"), 2)
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entries[0], Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			ks := func(n string) uint32 { return mustSym(t, killer, n) }
			done := false
			for i := 0; i < 200 && !done; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000}); err != nil {
					t.Fatal(err)
				}
				done = m.Peek32(ks("g_done_at")) != 0
			}
			if !done {
				t.Fatalf("killer never reaped; states %d/%d/%d/%d",
					procField(m, kernC, 0, pfState), procField(m, kernC, 1, pfState),
					procField(m, kernC, 2, pfState), procField(m, kernC, 3, pfState))
			}
			if rp := m.Peek32(ks("g_reap_pid")); rp != 3 {
				t.Errorf("wait() returned pid %d, want 3", rp)
			}
			if rs := int32(m.Peek32(ks("g_reap_status"))); rs != -1 {
				t.Errorf("killed status %d, want -1", rs)
			}
			if st := procField(m, kernC, 2, pfState); st != stUnused {
				t.Errorf("victim slot state %d, want UNUSED(%d)", st, stUnused)
			}
			// The victim's counter must stop advancing.
			v1 := m.Peek32(mustSym(t, victim, "g_vcount"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 300_000}); err != nil {
				t.Fatal(err)
			}
			if v2 := m.Peek32(mustSym(t, victim, "g_vcount")); v2 != v1 {
				t.Errorf("victim still running after kill: %d -> %d", v1, v2)
			}
			// The orphan (ppid 3 -> adopted by 2) exits at ~tick 30:
			// run on until its slot frees without a zombie.
			freed := false
			for i := 0; i < 200 && !freed; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000}); err != nil {
					t.Fatal(err)
				}
				freed = procField(m, kernC, 3, pfState) == stUnused
			}
			if !freed {
				t.Errorf("orphan never freed: state %d ppid %d",
					procField(m, kernC, 3, pfState), procField(m, kernC, 3, pfPpid))
			}
			if pp := procField(m, kernC, 3, pfPpid); pp != 2 {
				t.Errorf("orphan ppid %d, want 2 (init)", pp)
			}
			// Idle survives everything.
			i1 := m.Peek32(mustSym(t, idle, "g_idlecount"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 300_000}); err != nil {
				t.Fatal(err)
			}
			if i2 := m.Peek32(mustSym(t, idle, "g_idlecount")); i2 <= i1 {
				t.Errorf("idle stalled: %d -> %d", i1, i2)
			}
		})
	}
}
