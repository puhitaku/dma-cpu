package dmacc_test

import (
	"encoding/binary"
	"strings"
	"sync"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/fsimg"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// The exam: upstream user/usertests.c grading the port, one curated
// test per boot (usertests <name> prints "ALL TESTS PASSED" on
// success). The curation reflects the machine honestly: fs and
// process tests run; tests that need an MMU (bad-pointer copyin
// probes, stack guard pages), true concurrent fork (pipe pumps,
// killstatus/preempt's spinning children), fork-divergent memory
// (sbrkbasic under the shared vfork image), or a large virtual
// address space (sbrkmuch, the lazy tests) stay out — the reasons
// live in prompts/021 and prompts/025.
var examTests = []string{
	// fs: files, directories, links, truncation
	"opentest", "writetest", "createtest", "dirtest", "createdelete",
	"unlinkread", "linktest", "linkunlink", "concreate", "subdir",
	// ("fourteen" left the roster with DIRSIZ grown to 62 for vfat
	// long names: it hardcodes truncation at exactly 14.)
	"bigfile", "bigwrite", "dirfile", "rmdot", "iref",
	"truncate1", "truncate2", "truncate3", "unlinkcwd",
	// process + fd inheritance under the vfork discipline
	"exectest", "sharedfd", "fourfiles", "openiput", "exitiput", "iput",
	"exitwait", "twochildren", "forkfork", "bsstest",
	// the kernel heap (prompts/025): sbrk semantics + buffer refusal
	"rwsbrk", "sbrkarg", "sbrklast", "sbrk8000",
	// init-style adoption under kill()/exit (prompts/024)
	"reparent", "reparent2",
}

// utCache memoizes the exam binary: 35 subtests boot it, the compile
// is deterministic, and under parallel subtests the redundant work
// would race for CPU (the kernelCache pattern).
var utCache sync.Map

func examUtDasm(t *testing.T) string {
	t.Helper()
	if v, ok := utCache.Load("ut"); ok {
		return v.(string)
	}
	utMod, err := llir.Merge(
		parseLL(t, "../xv6/ll/usertests.ll"), parseLL(t, "../xv6/ll/ulib.ll"),
		parseLL(t, "../xv6/ll/printf.ll"), parseLL(t, "../xv6/ll/umalloc.ll"),
		parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(utMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	utCache.Store("ut", dasm)
	return dasm
}

func bootExam(t *testing.T, arg string) *emu.Machine {
	t.Helper()
	v, err := emu.VariantByName("rp2350")
	if err != nil {
		t.Fatal(err)
	}
	utDasm := examUtDasm(t)
	// The XIP fs kernel (the deployable shape): its text executes from
	// the flash model, freeing ~100 KiB of SRAM the RAM-resident
	// variant burned — the usertests image, a 72-block disk and a
	// roomy arena all fit without window tetris.
	kcDasm := compileKernelXsh(t, false)
	idleDasm, err := dmacc.Compile(parseLL(t, "testdata/proc.ll"), dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	casm := func(src string, text, data uint32) *dmaasm.Result {
		res, err := dmaasm.Assemble(src, dmaasm.Options{
			Variant: v, Compact: true, CompactScratch: 0x2007FE00,
			TextBase: text, DataBase: data})
		if err != nil {
			t.Fatal(err)
		}
		return res
	}
	kern := casm(ksrc, 0x20002000, 0x20003000)
	kernC, err := dmaasm.Assemble(kcDasm, dmaasm.Options{
		Variant: v, Compact: true, CompactScratch: 0x2007FE00,
		TextBase: 0x10260000, DataBase: 0x2000C000, RAMTextBase: 0x20004000})
	if err != nil {
		t.Fatal(err)
	}
	ut := casm(utDasm, 0x2001A000, 0x20035000)
	idle := casm(idleDasm, 0x20044000, 0x20045000)

	m := emu.NewMachine(v)
	m.TXPace = 0                     // the exam prints a lot; run the console at full speed
	m.Flash = make([]byte, 0x400000) // XIP kernel text lives here
	entryU, err := ut.Image.Load(m, nil)
	if err != nil {
		t.Fatal(err)
	}
	entryI, err := idle.Image.Load(m, nil)
	if err != nil {
		t.Fatal(err)
	}
	for _, r := range []*dmaasm.Result{kern, kernC} {
		if _, err := r.Image.Load(m, nil); err != nil {
			t.Fatal(err)
		}
	}
	wireKernelEnc(t, m, v, kern, kernC, []kproc{
		{ut, entryU, 1, 0, true},
		{idle, entryI, 2, 0, false},
	}, true)

	// Small disk: exectest execs echo.
	echoMod, err := llir.Merge(parseLL(t, "../xv6/ll/echo.ll"),
		parseLL(t, "../xv6/ll/ulib.ll"), parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	echoDasm, err := dmacc.Compile(echoMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	echoImg := casm(echoDasm, 0x10000000, 0x10040000)
	blob, err := fsimg.DMXExec(echoImg.Image, echoImg.Symbol)
	if err != nil {
		t.Fatal(err)
	}
	fb := fsimg.New(72, 64)
	fb.AddDevice("console", 1, 0)
	fb.AddFile("README", []byte("exam disk\n"))
	fb.AddFile("echo", blob)
	disk := fb.Bytes()
	const diskBase = 0x20046000
	for i := 0; i < len(disk); i += 4 {
		m.Poke32(uint32(diskBase+i), binary.LittleEndian.Uint32(disk[i:]))
	}
	m.Poke32(mustSym(t, kernC, "g_dma_disk"), diskBase)
	m.Poke32(mustSym(t, kernC, "g_dma_disksize"), uint32(len(disk)))
	m.Poke32(mustSym(t, kernC, "g_arena"), 0x20058000)
	m.Poke32(mustSym(t, kernC, "g_arena_end"), 0x2007F000)
	m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
	m.Poke32(mustSym(t, kernC, "g_initpid"), 2)
	m.Poke32(mustSym(t, kernC, "g_k_sysentry"), mustSym(t, kern, "sys_entry"))
	m.Poke32(mustSym(t, kernC, "g_inj_wreg"), emu.ChanRegAddr(emu.CompactInjector, emu.OffWriteAddr))
	m.Poke32(mustSym(t, kernC, "g_inj_treg"), emu.ChanRegAddr(emu.CompactInjector, emu.OffAl1TransCountTrig))

	// argv for the preloaded exam: usertests <arg>.
	const argvBase = 0x2007F000 /* between arena_end and the machine scratch */
	pokeStr := func(addr uint32, s string) uint32 {
		b := append([]byte(s), 0)
		for len(b)%4 != 0 {
			b = append(b, 0)
		}
		for i := 0; i < len(b); i += 4 {
			m.Poke32(addr+uint32(i), binary.LittleEndian.Uint32(b[i:]))
		}
		return addr + uint32(len(b))
	}
	s0 := uint32(argvBase + 16)
	s1 := pokeStr(s0, "usertests")
	pokeStr(s1, arg)
	m.Poke32(argvBase, s0)
	m.Poke32(argvBase+4, s1)
	m.Poke32(argvBase+8, 0)
	m.Poke32(mustSym(t, ut, "r0"), 2)
	m.Poke32(mustSym(t, ut, "r1"), argvBase)

	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entryU, Scratch: 0x2007FE00,
	}); err != nil {
		t.Fatal(err)
	}
	return m
}

func TestXv6Usertests(t *testing.T) {
	t.Parallel()
	if testing.Short() {
		t.Skip("the exam boots once per test")
	}
	for _, name := range examTests {
		t.Run(name, func(t *testing.T) {
			t.Parallel() // one machine per exam name; fully independent
			m := bootExam(t, name)
			done := false
			for i := 0; i < 600 && !done; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 10_000_000}); err != nil {
					t.Fatalf("machine error: %v\nconsole:\n%s", err, m.ConsoleOut)
				}
				out := string(m.ConsoleOut)
				done = strings.Contains(out, "ALL TESTS PASSED") ||
					strings.Contains(out, "FAILED") ||
					strings.Contains(out, "NO TESTS EXECUTED") ||
					strings.Contains(out, "panic")
			}
			out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
			if !strings.Contains(out, "ALL TESTS PASSED") {
				t.Errorf("console:\n%s", out)
			}
		})
	}
}
