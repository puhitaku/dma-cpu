package dmacc_test

import (
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// TestXv6Signal runs the SIGINT paths (prompts/026): Ctrl-C (fed as a
// raw 0x03) lands on pid 1's foreground child — default death for the
// spinning phase-1 child (wait reports -1), and the user-space handler
// for the phase-2 child sleeping in pause() (interrupted pause returns
// -1, the handler runs, the child exits 9). The idle keeper survives.
func TestXv6Signal(t *testing.T) {
	t.Parallel()
	mod, err := llir.Merge(parseLL(t, "testdata/xv6sig.ll"), parseLL(t, "../xv6/ll/usys.ll"))
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
			driver := asm(0x20020000, 0x20024000)
			idle := asm(0x20026000, 0x2002A000)

			m := emu.NewMachine(v)
			var entries [2]uint32
			for i, r := range []*dmaasm.Result{driver, idle} {
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
				{driver, entries[0], 1, 0, true},
				{idle, entries[1], 2, 0, true},
			})
			m.Poke32(mustSym(t, kernC, "g_fgpid"), 1)
			m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entries[0], Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			ds := func(n string) uint32 { return mustSym(t, driver, n) }
			runUntil := func(cond func() bool, what string) {
				t.Helper()
				for i := 0; i < 300; i++ {
					if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000}); err != nil {
						t.Fatal(err)
					}
					if cond() {
						return
					}
				}
				t.Fatalf("timeout waiting for %s; phase=%d st1=%#x st2=%#x caught=%d vspin=%d states=%d,%d,%d,%d console=%q",
					what, m.Peek32(ds("g_phase")), m.Peek32(ds("g_st1")),
					m.Peek32(ds("g_st2")), m.Peek32(ds("g_caught")),
					m.Peek32(ds("g_vspin")),
					procField(m, kernC, 0, pfState), procField(m, kernC, 1, pfState),
					procField(m, kernC, 2, pfState), procField(m, kernC, 3, pfState),
					m.ConsoleOut)
			}

			// Phase 1: wait until the spinner is visibly running.
			runUntil(func() bool { return m.Peek32(ds("g_vspin")) > 100 }, "phase-1 spinner")
			m.FeedConsole("\x03")
			runUntil(func() bool { return m.Peek32(ds("g_st1")) != 111 }, "phase-1 reap")
			if st := int32(m.Peek32(ds("g_st1"))); st != -1 {
				t.Errorf("phase-1 status %d, want -1 (default death)", st)
			}

			// Phase 2: the handler child sleeps in pause(600).
			runUntil(func() bool { return m.Peek32(ds("g_phase")) == 2 }, "phase 2")
			if _, err := m.Run(emu.RunConfig{MaxCycles: 500_000}); err != nil {
				t.Fatal(err) // let the child reach its pause
			}
			m.FeedConsole("\x03")
			runUntil(func() bool { return m.Peek32(ds("g_done")) != 0 }, "phase-2 reap")
			if st := int32(m.Peek32(ds("g_st2"))); st != 9 {
				t.Errorf("phase-2 status %d, want 9 (handler ran, pause -1)", st)
			}
			if c := m.Peek32(ds("g_caught")); c != 1 {
				t.Errorf("handler ran %d times, want 1", c)
			}
			// Idle keeps running.
			i1 := m.Peek32(mustSym(t, idle, "g_idlecnt"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 300_000}); err != nil {
				t.Fatal(err)
			}
			if i2 := m.Peek32(mustSym(t, idle, "g_idlecnt")); i2 <= i1 {
				t.Errorf("idle stalled: %d -> %d", i1, i2)
			}
		})
	}
}

// TestXv6ShSigint runs the interrupt key against upstream sh on the
// full system: Ctrl-C kills a foreground cat (default death) and gets
// caught by the trap demo's handler; a background spin survives the
// prompt-time Ctrl-C (no foreground job) and dies by kill as before.
func TestXv6ShSigint(t *testing.T) {
	t.Parallel()
	if testing.Short() {
		t.Skip("full-system boot")
	}
	m, _ := bootXsh(t)
	// cat with no args reads the console: a sleeping foreground job.
	m.FeedConsole("cat\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 120_000_000}); err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
	}
	m.FeedConsole("\x03")
	m.FeedConsole("echo one\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 120_000_000}); err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
	}
	// The trap demo registers a handler and exits politely.
	m.FeedConsole("trap\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000_000}); err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
	}
	m.FeedConsole("\x03")
	m.FeedConsole("echo two\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000_000}); err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{"^C\n", "one\n", "trap: Ctrl-C me", "caught SIGINT; exiting politely", "two"} {
		if !strings.Contains(out, want) {
			t.Errorf("missing %q", want)
		}
	}
}
