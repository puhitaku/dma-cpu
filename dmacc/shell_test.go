package dmacc_test

import (
	"os"
	"regexp"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// compileWithLibc links an IR golden against the picolibc goldens.
func compileWithLibc(t *testing.T, name string) string {
	t.Helper()
	src, err := os.ReadFile("testdata/" + name + ".ll")
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		t.Fatal(err)
	}
	all := append([]*llir.Module{mod}, loadLibc(t)...)
	merged, err := llir.Merge(all...)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(merged, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	return dasm
}

// TestShellSystem runs Phase 5b end to end: dma-sh as process A under
// the preemptive kernel, the counter program as process B. The scripted
// session must show the background counter advancing between two `stat`
// commands — multitasking observable from inside the shell.
func TestShellSystem(t *testing.T) {
	shellDasm := compileWithLibc(t, "shell")
	procSrc, err := os.ReadFile("testdata/proc.ll")
	if err != nil {
		t.Fatal(err)
	}
	procMod, err := llir.Parse(string(procSrc))
	if err != nil {
		t.Fatal(err)
	}
	procDasm, err := dmacc.Compile(procMod, dmacc.Options{})
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
			shell, err := dmaasm.Assemble(shellDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20008000, DataBase: 0x20028000})
			if err != nil {
				t.Fatal(err)
			}
			procB, err := dmaasm.Assemble(procDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20030000, DataBase: 0x20034000})
			if err != nil {
				t.Fatal(err)
			}

			m := emu.NewMachine(v)
			if _, err := kern.Image.Load(m, nil); err != nil {
				t.Fatal(err)
			}
			entryA, err := shell.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			entryB, err := procB.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}

			sym := func(r *dmaasm.Result, n string) uint32 {
				a, err := r.Symbol(n)
				if err != nil {
					t.Fatal(err)
				}
				return a
			}
			// Kernel cross-image wiring (shell plays the A role).
			m.Poke32(sym(kern, "pAdisp"), sym(shell, "dispatch"))
			m.Poke32(sym(kern, "pBdisp"), sym(procB, "dispatch"))
			m.Poke32(sym(kern, "pAresume"), sym(shell, "irqresume"))
			m.Poke32(sym(kern, "pBresume"), sym(procB, "irqresume"))
			m.Poke32(sym(kern, "thunkA"), sym(shell, "crtthunk"))
			m.Poke32(sym(kern, "thunkB"), sym(procB, "crtthunk"))
			m.Poke32(sym(kern, "savedB"), entryB)
			// Shell stat pointers.
			m.Poke32(sym(shell, "g_stat_ticks"), sym(kern, "ticks"))
			m.Poke32(sym(shell, "g_stat_counter"), sym(procB, "g_counter"))

			// Injector chain + tick timer (as in TestPreemptiveScheduler).
			const inj1, inj2 = 3, 4
			m.Poke32(v.TimerAddr(1), 1<<16|15000)
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1ReadAddr), sym(kern, "vecB"))
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1WriteAddr), sym(procB, "dispatch"))
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl2TransCount), 1)
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1Ctrl),
				emu.CtrlEN|emu.CtrlHighPriority|emu.CtrlSize32|
					v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(inj2)|v.CtrlIRQQuiet)
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1ReadAddr), sym(kern, "vecA"))
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1WriteAddr), sym(shell, "dispatch"))
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffTransCount), 1)
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffCtrlTrig),
				emu.CtrlEN|emu.CtrlHighPriority|emu.CtrlSize32|
					v.CtrlTreq(emu.TreqTimer1)|v.CtrlChainTo(inj2)|v.CtrlIRQQuiet)

			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entryA, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			m.FeedConsole("stat\rprimes 30\rstat\r")
			if _, err := m.Run(emu.RunConfig{MaxCycles: 80_000_000}); err != nil {
				t.Fatal(err)
			}
			out := string(m.ConsoleOut)
			t.Logf("console:\n%s", out)
			for _, want := range []string{"dma-sh", "dma> ", "(10 primes <= 30)"} {
				if !strings.Contains(out, want) {
					t.Errorf("console missing %q", want)
				}
			}
			// The background counter must advance between the two stats.
			re := regexp.MustCompile(`ticks=(\d+) bgcounter=(\d+)`)
			ms := re.FindAllStringSubmatch(out, -1)
			if len(ms) != 2 {
				t.Fatalf("expected two stat lines, got %d", len(ms))
			}
			t1, _ := strconv.Atoi(ms[0][1])
			c1, _ := strconv.Atoi(ms[0][2])
			t2, _ := strconv.Atoi(ms[1][1])
			c2, _ := strconv.Atoi(ms[1][2])
			if t2 <= t1 {
				t.Errorf("ticks did not advance between stats: %d -> %d", t1, t2)
			}
			if c2 <= c1 {
				t.Errorf("background counter did not advance: %d -> %d", c1, c2)
			}
		})
	}
}
