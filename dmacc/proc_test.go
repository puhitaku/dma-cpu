package dmacc_test

import (
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

func parseLL(t *testing.T, path string) *llir.Module {
	t.Helper()
	src, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	m, err := llir.Parse(string(src))
	if err != nil {
		t.Fatalf("%s: %v", path, err)
	}
	return m
}

// buildKernelC compiles the Phase 5d C kernel core (xv6/dma/kproc.c).
func buildKernelC(t *testing.T, v *emu.Variant, text, data uint32) *dmaasm.Result {
	t.Helper()
	dasm, err := dmacc.Compile(parseLL(t, "../xv6/ll/kproc.ll"),
		dmacc.Options{Entry: "kmain", NoSafepoints: true})
	if err != nil {
		t.Fatal(err)
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v, TextBase: text, DataBase: data})
	if err != nil {
		t.Fatal(err)
	}
	return res
}

// TestXv6Proc runs the Phase 5d process lifecycle end to end: three
// instances of testdata/xv6proc.c under the C kernel — an idle
// counter, a parent blocking in wait(), and a child that sleeps 5
// ticks and exits 42. The exiting child deposits pid+status into the
// sleeping parent's mailbox; the child's slot is reaped to UNUSED and
// the parent ends ZOMBIE (nobody waits for it).
func TestXv6Proc(t *testing.T) {
	pmod, err := llir.Merge(parseLL(t, "testdata/xv6proc.ll"), parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	pdasm, err := dmacc.Compile(pmod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	const wantConsole = "parent: waiting\nchild: exiting\nparent: reaped\n"

	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) {
			kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{
				Variant: v, TextBase: 0x20000000, DataBase: 0x20002000})
			if err != nil {
				t.Fatal(err)
			}
			kernC := buildKernelC(t, v, 0x20004000, 0x20008000)
			asm := func(text, data uint32) *dmaasm.Result {
				res, err := dmaasm.Assemble(pdasm, dmaasm.Options{
					Variant: v, TextBase: text, DataBase: data})
				if err != nil {
					t.Fatal(err)
				}
				return res
			}
			idle := asm(0x2000C000, 0x20010000)
			parent := asm(0x20014000, 0x20018000)
			child := asm(0x2001C000, 0x20020000)

			m := emu.NewMachine(v)
			var entries [3]uint32
			for i, r := range []*dmaasm.Result{idle, parent, child} {
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
				{idle, entries[0], 1, 0, true},
				{parent, entries[1], 2, 1, true},
				{child, entries[2], 3, 2, true},
			})
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entries[0], Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			done := false
			for i := 0; i < 100; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
					t.Fatal(err)
				}
				if strings.Contains(string(m.ConsoleOut), "parent: reaped\n") {
					done = true
					break
				}
			}
			if !done {
				t.Fatalf("lifecycle did not complete; console %q, states %d/%d/%d, kticks=%d",
					m.ConsoleOut,
					procField(m, kernC, 0, pfState),
					procField(m, kernC, 1, pfState),
					procField(m, kernC, 2, pfState),
					m.Peek32(mustSym(t, kernC, "g_ticks")))
			}
			if got := string(m.ConsoleOut); got != wantConsole {
				t.Errorf("console:\n got %q\nwant %q", got, wantConsole)
			}
			psym := func(name string) uint32 { return mustSym(t, parent, name) }
			if rp := m.Peek32(psym("g_reap_pid")); rp != 3 {
				t.Errorf("wait() returned pid %d, want 3", rp)
			}
			if rs := int32(m.Peek32(psym("g_reap_status"))); rs != 42 {
				t.Errorf("wait() status %d, want 42", rs)
			}
			// Run on: idle must keep counting; parent ends ZOMBIE
			// (its exit precedes; nobody reaps it), child slot UNUSED.
			id1 := m.Peek32(mustSym(t, idle, "g_idlecount"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000}); err != nil {
				t.Fatal(err)
			}
			id2 := m.Peek32(mustSym(t, idle, "g_idlecount"))
			if id2 <= id1 {
				t.Errorf("idle stalled after the lifecycle: %d -> %d", id1, id2)
			}
			if st := procField(m, kernC, 1, pfState); st != stZombie {
				t.Errorf("parent slot state %d, want ZOMBIE(%d)", st, stZombie)
			}
			if st := procField(m, kernC, 2, pfState); st != stUnused {
				t.Errorf("child slot state %d, want UNUSED(%d)", st, stUnused)
			}
			if xs := int32(procField(m, kernC, 2, pfXstate)); xs != 0 && xs != 42 {
				t.Errorf("child xstate %d", xs)
			}
			t.Logf("ticks=%d idle=%d parent_done_at=%d",
				m.Peek32(mustSym(t, kernC, "g_ticks")), id2,
				m.Peek32(psym("g_parent_done")))
		})
	}
}

func mustSym(t *testing.T, res *dmaasm.Result, name string) uint32 {
	t.Helper()
	a, err := res.Symbol(name)
	if err != nil {
		t.Fatal(err)
	}
	return a
}
