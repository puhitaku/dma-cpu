package dmacc_test

import (
	"os"
	"regexp"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/prog"
)

// compileWithLibc links an IR golden against the picolibc goldens,
// plus any extra modules (paths relative to the dmacc dir).
func compileWithLibc(t *testing.T, name string, extra ...string) string {
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
	for _, p := range extra {
		all = append(all, parseLL(t, p))
	}
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
	t.Parallel()
	shellDasm := compileWithLibc(t, "shell", "../../target/xv6/ll/usys.ll")
	echoMod, err := llir.Merge(parseLL(t, "../../target/xv6/ll/echo.ll"),
		parseLL(t, "../../target/xv6/ll/ulib.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	echoDasm, err := dmacc.Compile(echoMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	helloMod, err := llir.Merge(parseLL(t, "testdata/xv6hello.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	helloDasm, err := dmacc.Compile(helloMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
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
			kernC := buildKernelC(t, v, 0x2001E000, 0x20018800) // text ~99 KiB since kdma
			shell, err := dmaasm.Assemble(shellDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20006000, DataBase: 0x20016000})
			if err != nil {
				t.Fatal(err)
			}
			procB, err := dmaasm.Assemble(procDasm, dmaasm.Options{
				Variant: v, TextBase: 0x2001C000, DataBase: 0x2001D000})
			if err != nil {
				t.Fatal(err)
			}

			m := emu.NewMachine(v)
			m.TXPace = 13000 // ~115200 baud: ~0.87 tick periods per byte, as on silicon
			for _, r := range []*dmaasm.Result{kern, kernC} {
				if _, err := r.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
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
			// Phase 5d proc-table wiring: shell is slot 0 (always
			// runnable — it never syscalls), counter is slot 1.
			wireKernel(t, m, v, kern, kernC, []kproc{
				{shell, entryA, 1, 0, true},
				{procB, entryB, 2, 0, false},
			})
			// Registry for `run`: upstream echo, linked at arbitrary
			// bases (the kernel places it).
			echoImg, err := dmaasm.Assemble(echoDasm, dmaasm.Options{
				Variant: v, TextBase: 0x10000000, DataBase: 0x10020000})
			if err != nil {
				t.Fatal(err)
			}
			helloImg, err := dmaasm.Assemble(helloDasm, dmaasm.Options{
				Variant: v, TextBase: 0x10000000, DataBase: 0x10020000})
			if err != nil {
				t.Fatal(err)
			}
			end := registerImage(t, m, kernC, 0, "echo", echoImg, 0x2003A000)
			end = registerImage(t, m, kernC, 1, "hello", helloImg, end)
			if end > 0x2003C000 {
				t.Fatalf("blob storage overflow: %#x", end)
			}
			m.Poke32(mustSym(t, kernC, "g_arena"), 0x2003C000)
			m.Poke32(mustSym(t, kernC, "g_arena_end"), 0x2003FE00)
			m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
			m.Poke32(mustSym(t, kernC, "g_k_sysentry"), mustSym(t, kern, "sys_entry"))
			// Shell stat pointers (ticks live in the C kernel now).
			m.Poke32(sym(shell, "g_stat_ticks"), sym(kernC, "g_ticks"))
			m.Poke32(sym(shell, "g_stat_counter"), sym(procB, "g_counter"))

			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entryA, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			m.FeedConsole("stat\rprimes 30\rrun echo booom from real silicon\rrun hello\rstat\r")
			if _, err := m.Run(emu.RunConfig{MaxCycles: 80_000_000}); err != nil {
				t.Fatal(err)
			}
			out := string(m.ConsoleOut)
			t.Logf("console:\n%s", out)
			for _, want := range []string{"dma-sh", "dma> ", "(10 primes <= 30)",
				"booom from real silicon", "hello from exec", "[pid 3 exited, status 0]",
				"[pid 4 exited, status 7]"} {
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
