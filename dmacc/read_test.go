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

// TestXv6Read runs SYS_read end to end with upstream user code:
// xv6readline.c uses ulib.c's gets() and printf.c, the kernel cooks
// the console (echo, backspace editing, CR->NL). The fed input types
// "bob", erases the trailing 'b' with a backspace, and finishes
// "om\r" — the cooked line must be "boom".
func TestXv6Read(t *testing.T) {
	mod, err := llir.Merge(
		parseLL(t, "testdata/xv6readline.ll"),
		parseLL(t, "../xv6/ll/ulib.ll"),
		parseLL(t, "../xv6/ll/printf.ll"),
		parseLL(t, "../xv6/ll/usys.ll"),
	)
	if err != nil {
		t.Fatal(err)
	}
	rdasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	// idle keeps the machine alive while the reader sleeps between
	// polls (testdata/proc.c counter).
	idasm, err := dmacc.Compile(parseLL(t, "testdata/proc.ll"), dmacc.Options{})
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
			kernC := buildKernelC(t, v, 0x20004000, 0x2001A000)
			idle, err := dmaasm.Assemble(idasm, dmaasm.Options{
				Variant: v, TextBase: 0x20020000, DataBase: 0x20024000})
			if err != nil {
				t.Fatal(err)
			}
			reader, err := dmaasm.Assemble(rdasm, dmaasm.Options{
				Variant: v, TextBase: 0x20026000, DataBase: 0x2002C000})
			if err != nil {
				t.Fatal(err)
			}

			m := emu.NewMachine(v)
			entryI, err := idle.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			entryR, err := reader.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			for _, r := range []*dmaasm.Result{kern, kernC} {
				if _, err := r.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
			}
			wireKernel(t, m, v, kern, kernC, []kproc{
				{idle, entryI, 1, 0, false},
				{reader, entryR, 2, 0, true},
			})
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entryI, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			m.FeedConsole("bob\x7fom\r")
			done := false
			for i := 0; i < 200; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
					t.Fatal(err)
				}
				if strings.Contains(string(m.ConsoleOut), "!") {
					done = true
					break
				}
			}
			out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
			if !done {
				t.Fatalf("reader never finished; console %q ticks=%d",
					out, m.Peek32(mustSym(t, kernC, "g_ticks")))
			}
			// Echo shows the typed keys incl. the backspace erase;
			// the cooked result must be "boom".
			if !strings.Contains(out, "hi boom!") {
				t.Errorf("cooked line wrong; console %q", out)
			}
			if !strings.Contains(out, "\b \b") {
				t.Errorf("no backspace echo; console %q", out)
			}
			if st := procField(m, kernC, 1, pfState); st != stZombie {
				t.Errorf("reader state %d, want ZOMBIE(%d)", st, stZombie)
			}
			t.Logf("console: %q", out)
		})
	}
}
