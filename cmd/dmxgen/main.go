// Command dmxgen generates the HIL (hardware-in-the-loop) test images and
// the C header the target firmware embeds (target/firmware/generated/).
//
// The images are assembled from the .dasm sources in prog/hil/ — the
// firmware therefore runs assembler-produced binaries, so a hardware pass
// validates dmaasm end to end. Every image is executed in the emulator
// and the emulator's results become the expected values baked into the
// header: a FAIL on the UART log means silicon and emulator disagree.
//
// Usage:
//
//	go run ./cmd/dmxgen -sku rp2350 -o target/firmware/generated/images.h
//	go run ./cmd/dmxgen -sku rp2350 -dmxdir out/   # also dump .dmx files
package main

import (
	"encoding/binary"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// layout is the SRAM region reserved for the DMA machine on the HIL
// firmware. It must not collide with the firmware's own .data/.bss (low
// SRAM) or stacks (top of SRAM); the firmware asserts this at boot.
type layout struct {
	text, data, scratch uint32
}

var layouts = map[string]layout{
	// rp2350: 128 KiB text + ~64 KiB data — the libc-linked programs
	// need the room; stacks live above 0x20070000.
	"rp2350": {text: 0x20040000, data: 0x20060000, scratch: 0x2006FF00},
	"rp2040": {text: 0x20010000, data: 0x20018000, scratch: 0x2001FF00},
}

const calCh = 8 // channel used by the C-side calibration experiments

// check kinds, mirrored by the firmware.
const (
	checkMem  = 0 // read 32-bit word at Addr, compare to Want
	checkGPIO = 1 // read pin Addr level, compare to Want (0/1)
)

type check struct {
	Kind int
	Addr uint32 // address (mem) or pin number (gpio)
	Want uint32 // design intent; verified against the emulator run
	Name string
}

type test struct {
	Name string
	Image *img.Image
	Compact bool   // Tier-C encoding: loader uses the compact machine
	Console []byte // expected console bytes (emulator verification)
	Done  uint32 // absolute done-flag address; 0 = perf test (no done)
	PerfCounter uint32
	BlocksPerIt uint32
	Checks      []check
	EmuCycles   uint64
	Exports     []export // symbol macros for firmware experiments
}

type export struct {
	Name string
	Addr uint32
}

// hilSpec declares one HIL test in terms of assembly symbols.
type hilSpec struct {
	name    string
	file    string            // prog/hil/<file>.dasm
	ll      string            // OR: compile this IR golden with dmacc (Phase 4)
	compactEnc bool           // assemble with the Tier-C 8-byte encoding
	libc    bool              // link the picolibc goldens (libc/ll) into the ll build
	console string            // expected console file (emulator check; prints on the UART on hardware)
	skus    []string          // restrict to these SKUs (nil: all)
	patch   map[string]uint32 // data words poked before encoding
	mem     map[string]uint32 // symbol -> intended value (done=1 implied)
	gpio    *check            // optional pin-level check
	export  []string          // symbols emitted as HIL_SYM_<name>_<sym> macros
	perf    *struct {
		counterSym  string
		blocksPerIt uint32
	}
}

func perfInfo(counterSym string, bpi uint32) *struct {
	counterSym  string
	blocksPerIt uint32
} {
	return &struct {
		counterSym  string
		blocksPerIt uint32
	}{counterSym, bpi}
}

var hilSpecs = []hilSpec{
	{name: "add", file: "add", mem: map[string]uint32{"r": 0x3333}},
	{name: "logic", file: "logic",
		mem: map[string]uint32{"rOr": 0x0FFF3FF5, "rAnd": 0x000F0350, "rXor": 0x0FF03CA5}},
	{name: "condjump_pos", file: "condjump", mem: map[string]uint32{"r": 0x505}},
	{name: "condjump_neg", file: "condjump",
		patch: map[string]uint32{"vin": ^uint32(5) + 1},
		mem:   map[string]uint32{"r": 0x909}},
	{name: "gpio", file: "gpio", gpio: &check{checkGPIO, 2, 1, "gpio2 level"}},
	{name: "perf", file: "perf", perf: perfInfo("counter", 4)},
	// Phase 3 interrupt programs: endless loops driven by the firmware's
	// approach experiments (prompts/006).
	{name: "irq", file: "irq", perf: perfInfo("counter", 7),
		export: []string{"isrvec", "dispatch", "irqresume", "isrcount", "counter"}},
	{name: "poll", file: "poll", perf: perfInfo("counter", 9),
		export: []string{"pending", "isrcount", "counter"}},
	// Phase 4 compiled-C programs (clang IR goldens -> dmacc -> dmaasm).
	// The exitcode check value is the host execution recorded in
	// dmacc/testdata/expected.txt, so a silicon PASS closes the loop
	// host C == emulator == hardware.
	{name: "cc_arith", ll: "arith"},
	{name: "cc_control", ll: "control"},
	{name: "cc_memory", ll: "memory"},
	{name: "cc_func", ll: "func"},
	{name: "cc_bits", ll: "bits"},
	{name: "cc_collatz", ll: "collatz"},
	// Phase 4.5: picolibc printf on silicon. The program's console bytes
	// are verified in the emulator and appear live on the shared UART
	// during the hardware run; the exit checksum makes the silicon pass
	// machine-checked. Needs the wide rp2350 layout.
	{name: "cc_stdio", ll: "stdio", libc: true,
		console: "dmacc/testdata/stdio.console", skus: []string{"rp2350"}},
	// Tier-C compact-encoding twins (prompts/010/011): same programs,
	// 8-byte records, silicon-checked against the same host truth.
	{name: "ccc_memory", ll: "memory", compactEnc: true},
	{name: "ccc_collatz", ll: "collatz", compactEnc: true},
	{name: "ccc_stdio", ll: "stdio", libc: true, compactEnc: true,
		console: "dmacc/testdata/stdio.console", skus: []string{"rp2350"}},
}

// ccExpected reads the host-truth exit codes for the compiled programs.
func ccExpected() (map[string]uint32, error) {
	raw, err := os.ReadFile("dmacc/testdata/expected.txt")
	if err != nil {
		return nil, fmt.Errorf("compiled HIL specs need dmacc/testdata/expected.txt (make llgen): %w", err)
	}
	out := map[string]uint32{}
	// The stdio tests keep their expectation in per-test .expected files.
	if extra, err := filepath.Glob("dmacc/testdata/*.expected"); err == nil {
		for _, p := range extra {
			b, err := os.ReadFile(p)
			if err != nil {
				return nil, err
			}
			raw = append(raw, '\n')
			raw = append(raw, b...)
		}
	}
	for _, line := range strings.Split(string(raw), "\n") {
		f := strings.Fields(line)
		if len(f) != 2 {
			continue
		}
		var v int64
		if _, err := fmt.Sscan(f[1], &v); err != nil {
			return nil, fmt.Errorf("expected.txt: bad line %q", line)
		}
		out[f[0]] = uint32(int32(v))
	}
	return out, nil
}

// buildCC compiles an IR golden with dmacc and assembles it.
func buildCC(spec hilSpec, v *emu.Variant, lay layout) (*dmaasm.Result, error) {
	paths := []string{"dmacc/testdata/" + spec.ll + ".ll"}
	if spec.libc {
		entries, err := os.ReadDir("libc/ll")
		if err != nil {
			return nil, fmt.Errorf("libc goldens missing (make libc): %w", err)
		}
		for _, e := range entries {
			if strings.HasSuffix(e.Name(), ".ll") {
				paths = append(paths, "libc/ll/"+e.Name())
			}
		}
	}
	var mods []*llir.Module
	for _, path := range paths {
		src, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		mod, err := llir.Parse(string(src))
		if err != nil {
			return nil, fmt.Errorf("%s: %w", path, err)
		}
		mods = append(mods, mod)
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		return nil, err
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		return nil, fmt.Errorf("%s: %w", spec.ll, err)
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, TextBase: lay.text, DataBase: lay.data, Compact: spec.compactEnc,
	})
	if err != nil {
		return nil, fmt.Errorf("%s: assembling dmacc output: %w", spec.ll, err)
	}
	return res, nil
}

// --- Phase 5a: the preemptive-scheduler bundle (prompts/012) ---
// Three images at fixed offsets in the machine region: the kernel
// (prog/hil/kernel.dasm) and two relocated instances of the compiled
// proc.c. Kernel cross-image pointers are patched at generation time;
// the firmware only loads, arms the injector chain, and starts A.
type schedBundle struct {
	kernel, procA, procB []byte
	entryA               uint32
	counterA, counterB   uint32
	ticks, vecA, vecB    uint32
	dispA, dispB         uint32
	inj1Ctrl, inj2Ctrl   uint32
}

func buildSched(v *emu.Variant, lay layout) (*schedBundle, error) {
	kText, kData := lay.text, lay.text+0x2000
	aText, aData := lay.text+0x4000, lay.text+0x6000
	bText, bData := lay.text+0x8000, lay.text+0xA000

	ksrc, err := prog.HIL("kernel")
	if err != nil {
		return nil, err
	}
	kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{Variant: v, TextBase: kText, DataBase: kData})
	if err != nil {
		return nil, fmt.Errorf("kernel: %w", err)
	}
	psrc, err := os.ReadFile("dmacc/testdata/proc.ll")
	if err != nil {
		return nil, err
	}
	pmod, err := llir.Parse(string(psrc))
	if err != nil {
		return nil, err
	}
	pdasm, err := dmacc.Compile(pmod, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	procA, err := dmaasm.Assemble(pdasm, dmaasm.Options{Variant: v, TextBase: aText, DataBase: aData})
	if err != nil {
		return nil, err
	}
	procB, err := dmaasm.Assemble(pdasm, dmaasm.Options{Variant: v, TextBase: bText, DataBase: bData})
	if err != nil {
		return nil, err
	}

	sym := func(r *dmaasm.Result, n string) (uint32, error) { return r.Symbol(n) }
	entryA := aText + procA.Image.EntryOff

	// Patch the kernel's cross-image pointers at generation time.
	type wire struct {
		kernSym string
		res     *dmaasm.Result
		procSym string
	}
	for _, w := range []wire{
		{"pAdisp", procA, "dispatch"}, {"pBdisp", procB, "dispatch"},
		{"pAresume", procA, "irqresume"}, {"pBresume", procB, "irqresume"},
		{"thunkA", procA, "crtthunk"}, {"thunkB", procB, "crtthunk"},
	} {
		kaddr, err := sym(kern, w.kernSym)
		if err != nil {
			return nil, err
		}
		val, err := sym(w.res, w.procSym)
		if err != nil {
			return nil, err
		}
		if err := patchData(kern.Image, kData, kaddr, val); err != nil {
			return nil, err
		}
	}
	kaddr, err := sym(kern, "savedB")
	if err != nil {
		return nil, err
	}
	if err := patchData(kern.Image, kData, kaddr, bText+procB.Image.EntryOff); err != nil {
		return nil, err
	}

	b := &schedBundle{entryA: entryA}
	get := func(dst *uint32, r *dmaasm.Result, n string) {
		if err == nil {
			*dst, err = sym(r, n)
		}
	}
	get(&b.counterA, procA, "g_counter")
	get(&b.counterB, procB, "g_counter")
	get(&b.ticks, kern, "ticks")
	get(&b.vecA, kern, "vecA")
	get(&b.vecB, kern, "vecB")
	get(&b.dispA, procA, "dispatch")
	get(&b.dispB, procB, "dispatch")
	if err != nil {
		return nil, err
	}
	const inj1, inj2 = 3, 4
	b.inj1Ctrl = emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		v.CtrlTreq(emu.TreqTimer1) | v.CtrlChainTo(inj2) | v.CtrlIRQQuiet
	b.inj2Ctrl = emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(inj2) | v.CtrlIRQQuiet

	// Emulator verification of the whole scenario before it ships.
	if err := verifySched(v, lay, kern, procA, procB, b); err != nil {
		return nil, err
	}

	for _, im := range []*img.Image{kern.Image, procA.Image, procB.Image} {
		im.Relocs = nil // fixed placement: bake
	}
	if b.kernel, err = kern.Image.Encode(); err != nil {
		return nil, err
	}
	if b.procA, err = procA.Image.Encode(); err != nil {
		return nil, err
	}
	if b.procB, err = procB.Image.Encode(); err != nil {
		return nil, err
	}
	return b, nil
}

func verifySched(v *emu.Variant, lay layout, kern, procA, procB *dmaasm.Result, b *schedBundle) error {
	m := emu.NewMachine(v)
	for _, r := range []*dmaasm.Result{kern, procA, procB} {
		if _, err := r.Image.Load(m, nil); err != nil {
			return err
		}
	}
	const inj1, inj2 = 3, 4
	m.Poke32(v.TimerAddr(1), 1<<16|15000)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1ReadAddr), b.vecB)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1WriteAddr), b.dispB)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl2TransCount), 1)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1Ctrl), b.inj2Ctrl)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1ReadAddr), b.vecA)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1WriteAddr), b.dispA)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffTransCount), 1)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffCtrlTrig), b.inj1Ctrl)
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Fetch: 0, Exec: 1, Fix: 2, Entry: b.entryA, Scratch: lay.scratch,
	}); err != nil {
		return err
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 500_000}); err != nil {
		return err
	}
	a, bb, tk := m.Peek32(b.counterA), m.Peek32(b.counterB), m.Peek32(b.ticks)
	if tk < 2 || a == 0 || bb == 0 {
		return fmt.Errorf("sched: emulator verification failed: ticks=%d a=%d b=%d", tk, a, bb)
	}
	return nil
}

// --- Phase 5b: the interactive-shell bundle (prompts/013) ---
// kernel + dma-sh (with libc, as process A) + the counter program (as
// process B). Needs the wide rp2350 layout; pointers pre-patched,
// scripted session verified in the emulator before shipping.
type shellBundle struct {
	kernel, shell, procB []byte
	entryShell           uint32
	vecA, vecB           uint32
	dispShell, dispB     uint32
	inj1Ctrl, inj2Ctrl   uint32
	ticks, counterB      uint32
}

func buildShell(v *emu.Variant, lay layout) (*shellBundle, error) {
	kText, kData := lay.text, lay.text+0x2000
	sText, sData := lay.text+0x4000, lay.text+0x1C000
	pText, pData := lay.text+0x20000, lay.text+0x22000

	ksrc, err := prog.HIL("kernel")
	if err != nil {
		return nil, err
	}
	kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{Variant: v, TextBase: kText, DataBase: kData})
	if err != nil {
		return nil, err
	}
	// Shell: testdata/shell.ll linked against the libc goldens.
	paths := []string{"dmacc/testdata/shell.ll"}
	entries, err := os.ReadDir("libc/ll")
	if err != nil {
		return nil, fmt.Errorf("libc goldens missing (make libc): %w", err)
	}
	for _, e := range entries {
		if strings.HasSuffix(e.Name(), ".ll") {
			paths = append(paths, "libc/ll/"+e.Name())
		}
	}
	var mods []*llir.Module
	for _, path := range paths {
		src, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		mod, err := llir.Parse(string(src))
		if err != nil {
			return nil, fmt.Errorf("%s: %w", path, err)
		}
		mods = append(mods, mod)
	}
	smod, err := llir.Merge(mods...)
	if err != nil {
		return nil, err
	}
	sdasm, err := dmacc.Compile(smod, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	shell, err := dmaasm.Assemble(sdasm, dmaasm.Options{Variant: v, TextBase: sText, DataBase: sData})
	if err != nil {
		return nil, fmt.Errorf("shell: %w", err)
	}
	psrc, err := os.ReadFile("dmacc/testdata/proc.ll")
	if err != nil {
		return nil, err
	}
	pmod, err := llir.Parse(string(psrc))
	if err != nil {
		return nil, err
	}
	pdasm, err := dmacc.Compile(pmod, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	procB, err := dmaasm.Assemble(pdasm, dmaasm.Options{Variant: v, TextBase: pText, DataBase: pData})
	if err != nil {
		return nil, err
	}

	b := &shellBundle{entryShell: sText + shell.Image.EntryOff}
	get := func(dst *uint32, r *dmaasm.Result, n string) {
		if err == nil {
			*dst, err = r.Symbol(n)
		}
	}
	get(&b.vecA, kern, "vecA")
	get(&b.vecB, kern, "vecB")
	get(&b.dispShell, shell, "dispatch")
	get(&b.dispB, procB, "dispatch")
	get(&b.ticks, kern, "ticks")
	get(&b.counterB, procB, "g_counter")
	if err != nil {
		return nil, err
	}
	// Kernel cross-image pointers (shell plays the A role) + the
	// shell's stat pointers.
	type patch struct {
		img     *img.Image
		imgData uint32
		res     *dmaasm.Result
		sym     string
		valRes  *dmaasm.Result
		valSym  string
	}
	for _, p := range []patch{
		{kern.Image, kData, kern, "pAdisp", shell, "dispatch"},
		{kern.Image, kData, kern, "pBdisp", procB, "dispatch"},
		{kern.Image, kData, kern, "pAresume", shell, "irqresume"},
		{kern.Image, kData, kern, "pBresume", procB, "irqresume"},
		{kern.Image, kData, kern, "thunkA", shell, "crtthunk"},
		{kern.Image, kData, kern, "thunkB", procB, "crtthunk"},
		{shell.Image, sData, shell, "g_stat_ticks", kern, "ticks"},
		{shell.Image, sData, shell, "g_stat_counter", procB, "g_counter"},
	} {
		addr, err := p.res.Symbol(p.sym)
		if err != nil {
			return nil, err
		}
		val, err := p.valRes.Symbol(p.valSym)
		if err != nil {
			return nil, err
		}
		if err := patchData(p.img, p.imgData, addr, val); err != nil {
			return nil, fmt.Errorf("%s: %w", p.sym, err)
		}
	}
	kaddr, err := kern.Symbol("savedB")
	if err != nil {
		return nil, err
	}
	if err := patchData(kern.Image, kData, kaddr, pText+procB.Image.EntryOff); err != nil {
		return nil, err
	}

	const inj2 = 4
	b.inj1Ctrl = emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		v.CtrlTreq(emu.TreqTimer1) | v.CtrlChainTo(inj2) | v.CtrlIRQQuiet
	b.inj2Ctrl = emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(inj2) | v.CtrlIRQQuiet

	if err := verifyShell(v, lay, kern, shell, procB, b); err != nil {
		return nil, err
	}
	for _, im := range []*img.Image{kern.Image, shell.Image, procB.Image} {
		im.Relocs = nil // fixed placement: bake
	}
	if b.kernel, err = kern.Image.Encode(); err != nil {
		return nil, err
	}
	if b.shell, err = shell.Image.Encode(); err != nil {
		return nil, err
	}
	if b.procB, err = procB.Image.Encode(); err != nil {
		return nil, err
	}
	return b, nil
}

func verifyShell(v *emu.Variant, lay layout, kern, shell, procB *dmaasm.Result, b *shellBundle) error {
	m := emu.NewMachine(v)
	for _, r := range []*dmaasm.Result{kern, shell, procB} {
		if _, err := r.Image.Load(m, nil); err != nil {
			return err
		}
	}
	const inj1, inj2 = 3, 4
	m.Poke32(v.TimerAddr(1), 1<<16|15000)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1ReadAddr), b.vecB)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1WriteAddr), b.dispB)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl2TransCount), 1)
	m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1Ctrl), b.inj2Ctrl)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1ReadAddr), b.vecA)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1WriteAddr), b.dispShell)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffTransCount), 1)
	m.Poke32(emu.ChanRegAddr(inj1, emu.OffCtrlTrig), b.inj1Ctrl)
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Fetch: 0, Exec: 1, Fix: 2, Entry: b.entryShell, Scratch: lay.scratch,
	}); err != nil {
		return err
	}
	m.FeedConsole("stat\rstat\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 60_000_000}); err != nil {
		return err
	}
	out := string(m.ConsoleOut)
	if !strings.Contains(out, "dma-sh") || strings.Count(out, "ticks=") != 2 {
		return fmt.Errorf("shell bundle: emulator session unexpected:\n%s", out)
	}
	return nil
}

// build assembles a spec's program for the SKU and applies patches.
func build(spec hilSpec, v *emu.Variant, lay layout) (*test, error) {
	var res *dmaasm.Result
	var err error
	if spec.ll != "" {
		res, err = buildCC(spec, v, lay)
		if err != nil {
			return nil, err
		}
	} else {
		src, err := prog.HIL(spec.file)
		if err != nil {
			return nil, err
		}
		res, err = dmaasm.Assemble(src, dmaasm.Options{
			Variant: v, TextBase: lay.text, DataBase: lay.data,
		})
		if err != nil {
			return nil, fmt.Errorf("%s: %w", spec.file, err)
		}
	}
	for sym, val := range spec.patch {
		addr, err := res.Symbol(sym)
		if err != nil {
			return nil, fmt.Errorf("%s: patch: %w", spec.name, err)
		}
		if err := patchData(res.Image, lay.data, addr, val); err != nil {
			return nil, fmt.Errorf("%s: %w", spec.name, err)
		}
	}
	t := &test{Name: spec.name, Image: res.Image, Compact: spec.compactEnc}
	for _, sym := range spec.export {
		addr, err := res.Symbol(sym)
		if err != nil {
			return nil, fmt.Errorf("%s: export: %w", spec.name, err)
		}
		t.Exports = append(t.Exports, export{sym, addr})
	}
	if spec.perf != nil {
		addr, err := res.Symbol(spec.perf.counterSym)
		if err != nil {
			return nil, err
		}
		t.PerfCounter = addr
		t.BlocksPerIt = spec.perf.blocksPerIt
		return t, nil
	}
	done, err := res.Symbol("done")
	if err != nil {
		return nil, fmt.Errorf("%s: HIL programs need a done symbol: %w", spec.name, err)
	}
	t.Done = done
	for sym, want := range spec.mem {
		addr, err := res.Symbol(sym)
		if err != nil {
			return nil, err
		}
		t.Checks = append(t.Checks, check{checkMem, addr, want, sym})
	}
	if spec.gpio != nil {
		t.Checks = append(t.Checks, *spec.gpio)
	}
	t.Checks = append(t.Checks, check{checkMem, done, 1, "done"})
	return t, nil
}

// patchData rewrites one word of the image's data segment (identified by
// its link address) prior to encoding.
func patchData(im *img.Image, dataBase, addr, val uint32) error {
	for i := range im.Segments {
		s := &im.Segments[i]
		if s.LinkAddr != dataBase {
			continue
		}
		off := addr - s.LinkAddr
		if off+4 > uint32(len(s.Data)) {
			return fmt.Errorf("patch address %#x outside data segment", addr)
		}
		binary.LittleEndian.PutUint32(s.Data[off:], val)
		return nil
	}
	return fmt.Errorf("no data segment at %#x", dataBase)
}

// verify runs the image in the emulator; the intended values must match.
func verify(v *emu.Variant, lay layout, t *test) error {
	m := emu.NewMachine(v)
	cfg := emu.FetchExecConfig{Fetch: 0, Exec: 1, Fix: 2, Scratch: lay.scratch}
	if t.Compact {
		cfg = emu.FetchExecConfig{Compact: true}
	}
	if err := t.Image.LoadAndStart(m, nil, cfg); err != nil {
		return fmt.Errorf("%s: %w", t.Name, err)
	}
	if t.Done == 0 { // perf: just prove it keeps running
		res, err := m.Run(emu.RunConfig{MaxCycles: 10_000})
		if err != nil {
			return fmt.Errorf("%s: %w", t.Name, err)
		}
		if res.Reason != emu.StopMaxCycles {
			return fmt.Errorf("%s: stopped unexpectedly: %+v", t.Name, res)
		}
		if m.Peek32(t.PerfCounter) == 0 {
			return fmt.Errorf("%s: counter did not advance", t.Name)
		}
		return nil
	}
	res, err := m.Run(emu.RunConfig{MaxCycles: 50_000_000, WatchWrites: []uint32{t.Done}})
	if err != nil {
		return fmt.Errorf("%s: %w", t.Name, err)
	}
	if res.Reason != emu.StopWatch {
		return fmt.Errorf("%s: did not reach done: %+v", t.Name, res)
	}
	t.EmuCycles = res.Cycles
	if len(t.Console) > 0 && strings.ReplaceAll(string(m.ConsoleOut), "\r", "") != string(t.Console) {
		return fmt.Errorf("%s: emulator console mismatch:\n--- got ---\n%s\n--- want ---\n%s",
			t.Name, m.ConsoleOut, t.Console)
	}
	for _, c := range t.Checks {
		switch c.Kind {
		case checkMem:
			if got := m.Peek32(c.Addr); got != c.Want {
				return fmt.Errorf("%s/%s: emulator got %#x, intent %#x", t.Name, c.Name, got, c.Want)
			}
		case checkGPIO:
			evs := m.GPIOEvents
			if len(evs) == 0 {
				return fmt.Errorf("%s/%s: no GPIO events in emulator", t.Name, c.Name)
			}
			level := uint32(0)
			if evs[len(evs)-1].High {
				level = 1
			}
			if level != c.Want {
				return fmt.Errorf("%s/%s: emulator final level %d, intent %d", t.Name, c.Name, level, c.Want)
			}
		}
	}
	return nil
}

// calExpect computes the emulator's sniffer result for the C-side CRC/SUM
// calibration experiments: seed, then pass one 32-bit word through a
// sniffed copy on calCh.
func calExpect(v *emu.Variant, sniffCtrl, seed, word uint32) uint32 {
	m := emu.NewMachine(v)
	src, dst := uint32(0x20001000), uint32(0x20001100)
	m.Poke32(src, word)
	m.Poke32(v.SniffCtrlAddr(), sniffCtrl)
	m.Poke32(v.SniffDataAddr(), seed)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffReadAddr), src)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffWriteAddr), dst)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffTransCount), 1)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffCtrlTrig),
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(calCh)|v.CtrlIRQQuiet|v.CtrlSniffEn)
	if res, err := m.Run(emu.RunConfig{MaxCycles: 1000}); err != nil || res.Reason != emu.StopIdle {
		panic(fmt.Sprintf("calExpect: %+v %v", res, err))
	}
	return m.Peek32(v.SniffDataAddr())
}

// --- C header emission ---

func emitHeader(v *emu.Variant, lay layout, tests []*test, sched *schedBundle, shl *shellBundle) string {
	var b strings.Builder
	p := func(format string, args ...any) { fmt.Fprintf(&b, format+"\n", args...) }

	p("/* Generated by cmd/dmxgen — DO NOT EDIT. Regenerate with:")
	p(" *   go run ./cmd/dmxgen -sku %s -o target/firmware/generated/images.h", v.Name)
	p(" * Images are assembled from prog/hil/*.dasm; expected values are")
	p(" * the emulator's results — a FAIL on hardware means silicon and")
	p(" * emulator disagree, which is the finding. */")
	p("#ifndef DMX_HIL_IMAGES_H")
	p("#define DMX_HIL_IMAGES_H")
	p("")
	p("#include <stddef.h>")
	p("#include <stdint.h>")
	p("")
	p("#define HIL_SKU \"%s\"", v.Name)
	p("#define HIL_SCRATCH 0x%08Xu", lay.scratch)
	p("#define HIL_MACHINE_RAM_START 0x%08Xu", lay.text)
	p("#define HIL_MACHINE_RAM_END 0x%08Xu", lay.scratch+4)
	p("")
	p("/* Calibration experiment constants (channel %d). */", calCh)
	p("#define HIL_CAL_CH %d", calCh)
	p("#define HIL_CAL_CH_BASE 0x%08Xu", emu.ChanRegAddr(calCh, 0))
	p("#define HIL_INTR_ADDR 0x%08Xu", v.IntrAddr())
	p("#define HIL_CHAN_ABORT_ADDR 0x%08Xu", v.ChanAbortAddr())
	p("#define HIL_TIMER0_ADDR 0x%08Xu", v.TimerAddr(0))
	p("#define HIL_SNIFF_CTRL_ADDR 0x%08Xu", v.SniffCtrlAddr())
	p("#define HIL_SNIFF_DATA_ADDR 0x%08Xu", v.SniffDataAddr())
	p("#define HIL_NCHANNELS %d", v.NChannels)
	p("#define HIL_CTRL_BUSY_MASK 0x%08Xu", v.CtrlBusy)
	base := emu.CtrlEN | emu.CtrlSize32 | v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(calCh) | v.CtrlIRQQuiet
	p("#define HIL_CAL_CTRL_BASIC 0x%08Xu", base)
	p("#define HIL_CAL_CTRL_BASIC_NOEN 0x%08Xu", base&^emu.CtrlEN)
	p("#define HIL_CAL_CTRL_BASIC_LOUD 0x%08Xu", base&^v.CtrlIRQQuiet)
	p("#define HIL_CAL_CTRL_TIMER0 0x%08Xu",
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqTimer0)|v.CtrlChainTo(calCh)|v.CtrlIRQQuiet)
	p("#define HIL_CAL_CTRL_SNIFF 0x%08Xu", base|v.CtrlSniffEn)
	crcCtrl := emu.SniffCtrlEN | emu.SniffCtrlDmach(calCh) | emu.SniffCtrlCalc(emu.SniffCalcCRC32)
	sumCtrl := emu.SniffCtrlEN | emu.SniffCtrlDmach(calCh) | emu.SniffCtrlCalc(emu.SniffCalcSum)
	p("#define HIL_CAL_SNIFF_CRC32 0x%08Xu", crcCtrl)
	p("#define HIL_CAL_SNIFF_SUM 0x%08Xu", sumCtrl)
	p("#define HIL_CAL_EXPECT_CRC32 0x%08Xu /* silicon-verified */", calExpect(v, crcCtrl, 0xFFFFFFFF, 0x12345678))
	p("#define HIL_CAL_EXPECT_SUM 0x%08Xu", calExpect(v, sumCtrl, 0x1000, 0x234))
	p("")
	p("/* Interrupt injector (ABI channel 3, HIGH_PRIORITY). */")
	injBase := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 | v.CtrlChainTo(3) | v.CtrlIRQQuiet
	p("#define HIL_INJ_CH_BASE 0x%08Xu", emu.ChanRegAddr(3, 0))
	p("#define HIL_INJ_CTRL_TIMER1 0x%08Xu", injBase|v.CtrlTreq(emu.TreqTimer1))
	p("#define HIL_INJ_CTRL_PIO0RX0 0x%08Xu", injBase|v.CtrlTreq(v.DreqPIO0RX0))
	p("")
	p("/* Tier-C compact-machine calibration: 8-byte records into a")
	p(" * channel bank with static CTRLs (prompts/010). */")
	const cmpP, cmpS, cmpB, cmpF, cmpX = 6, 7, 8, 9, 10
	p("#define HIL_CMP_EPLAIN %d", cmpP)
	p("#define HIL_CMP_ESNIFF %d", cmpS)
	p("#define HIL_CMP_EBSWAP %d", cmpB)
	p("#define HIL_CMP_FETCH %d", cmpF)
	p("#define HIL_CMP_FIX %d", cmpX)
	cmpExec := emu.CtrlEN | emu.CtrlSize32 | v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(cmpX) | v.CtrlIRQQuiet
	p("#define HIL_CMP_CTRL_PLAIN 0x%08Xu", cmpExec)
	p("#define HIL_CMP_CTRL_SNIFF 0x%08Xu", cmpExec|v.CtrlSniffEn)
	p("#define HIL_CMP_CTRL_BSWAP 0x%08Xu", cmpExec|v.CtrlBswap)
	p("#define HIL_CMP_CTRL_FIX 0x%08Xu",
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(cmpX)|v.CtrlIRQQuiet)
	p("#define HIL_CMP_FETCH_CTRL 0x%08Xu",
		emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|v.CtrlIncrWrite|
			v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(cmpF)|v.CtrlIRQQuiet)
	p("#define HIL_CMP_SNIFF_CTRL 0x%08Xu",
		emu.SniffCtrlEN|emu.SniffCtrlDmach(cmpS)|emu.SniffCtrlCalc(emu.SniffCalcSum))
	p("")
	p("/* Machine restart constants (approach-D experiment). */")
	p("#define HIL_FETCH_CTRL 0x%08Xu",
		emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|v.CtrlIncrWrite|
			v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(0)|v.CtrlIRQQuiet)
	p("#define HIL_EXEC_REGS 0x%08Xu", emu.ChanRegAddr(1, 0))
	p("")
	p("/* Program symbols for the interrupt experiments. */")
	for _, t := range tests {
		for _, e := range t.Exports {
			p("#define HIL_SYM_%s_%s 0x%08Xu", t.Name, e.Name, e.Addr)
		}
	}
	p("")
	p("typedef struct { int kind; uint32_t addr; uint32_t want; const char *what; } hil_check;")
	p("typedef struct {")
	p("    const char *name;")
	p("    const uint8_t *dmx; size_t dmx_len;")
	p("    int compact;                      /* Tier-C 8-byte encoding */")
	p("    uint32_t done_addr;               /* 0: perf test */")
	p("    uint32_t perf_counter_addr, blocks_per_iter;")
	p("    int n_checks; hil_check checks[8];")
	p("} hil_test;")
	p("")
	for _, t := range tests {
		raw, err := t.Image.Encode()
		if err != nil {
			panic(err)
		}
		p("static const uint8_t hil_%s_dmx[] = {", t.Name)
		for i := 0; i < len(raw); i += 16 {
			end := min(i+16, len(raw))
			var line []string
			for _, by := range raw[i:end] {
				line = append(line, fmt.Sprintf("0x%02x", by))
			}
			p("    %s,", strings.Join(line, ", "))
		}
		p("};")
	}
	p("")
	p("static const hil_test hil_tests[] = {")
	for _, t := range tests {
		compact := 0
		if t.Compact {
			compact = 1
		}
		p("    {\"%s\", hil_%s_dmx, sizeof hil_%s_dmx, %d, 0x%08Xu, 0x%08Xu, %d, %d, {",
			t.Name, t.Name, t.Name, compact, t.Done, t.PerfCounter, t.BlocksPerIt, len(t.Checks))
		for _, c := range t.Checks {
			p("        {%d, 0x%08Xu, 0x%08Xu, \"%s\"},", c.Kind, c.Addr, c.Want, c.Name)
		}
		p("    }},")
	}
	p("};")
	p("#define HIL_N_TESTS %d", len(tests))
	p("")
	p("/* Phase 5a scheduler bundle (prompts/012): kernel + two relocated")
	p(" * process instances, cross-image pointers pre-patched, emulator-")
	p(" * verified. The firmware loads all three, arms the injector chain,")
	p(" * and starts process A. */")
	dump := func(name string, raw []byte) {
		p("static const uint8_t %s[] = {", name)
		for i := 0; i < len(raw); i += 16 {
			end := min(i+16, len(raw))
			var line []string
			for _, by := range raw[i:end] {
				line = append(line, fmt.Sprintf("0x%02x", by))
			}
			p("    %s,", strings.Join(line, ", "))
		}
		p("};")
	}
	dump("hil_sched_kernel_dmx", sched.kernel)
	dump("hil_sched_proca_dmx", sched.procA)
	dump("hil_sched_procb_dmx", sched.procB)
	p("#define HIL_SCHED_ENTRY_A 0x%08Xu", sched.entryA)
	p("#define HIL_SCHED_COUNTER_A 0x%08Xu", sched.counterA)
	p("#define HIL_SCHED_COUNTER_B 0x%08Xu", sched.counterB)
	p("#define HIL_SCHED_TICKS 0x%08Xu", sched.ticks)
	p("#define HIL_SCHED_VEC_A 0x%08Xu", sched.vecA)
	p("#define HIL_SCHED_VEC_B 0x%08Xu", sched.vecB)
	p("#define HIL_SCHED_DISP_A 0x%08Xu", sched.dispA)
	p("#define HIL_SCHED_DISP_B 0x%08Xu", sched.dispB)
	p("#define HIL_SCHED_INJ1_CTRL 0x%08Xu", sched.inj1Ctrl)
	p("#define HIL_SCHED_INJ2_CTRL 0x%08Xu", sched.inj2Ctrl)
	if shl != nil {
		p("")
		p("/* Phase 5b shell bundle (prompts/013): kernel + dma-sh (+libc) +")
		p(" * counter process, pre-wired, emulator session verified. */")
		p("#define HIL_HAS_SHELL 1")
		dump("hil_shell_kernel_dmx", shl.kernel)
		dump("hil_shell_sh_dmx", shl.shell)
		dump("hil_shell_procb_dmx", shl.procB)
		p("#define HIL_SHELL_ENTRY 0x%08Xu", shl.entryShell)
		p("#define HIL_SHELL_VEC_A 0x%08Xu", shl.vecA)
		p("#define HIL_SHELL_VEC_B 0x%08Xu", shl.vecB)
		p("#define HIL_SHELL_DISP_A 0x%08Xu", shl.dispShell)
		p("#define HIL_SHELL_DISP_B 0x%08Xu", shl.dispB)
		p("#define HIL_SHELL_INJ1_CTRL 0x%08Xu", shl.inj1Ctrl)
		p("#define HIL_SHELL_INJ2_CTRL 0x%08Xu", shl.inj2Ctrl)
		p("#define HIL_SHELL_TICKS 0x%08Xu", shl.ticks)
		p("#define HIL_SHELL_COUNTER_B 0x%08Xu", shl.counterB)
	}
	p("")
	p("#endif /* DMX_HIL_IMAGES_H */")
	return b.String()
}

func run() error {
	sku := flag.String("sku", "rp2350", "target SKU (rp2040 or rp2350)")
	out := flag.String("o", "target/firmware/generated/images.h", "output C header path")
	dmxDir := flag.String("dmxdir", "", "also write raw .dmx files into this directory")
	flag.Parse()

	v, err := emu.VariantByName(*sku)
	if err != nil {
		return err
	}
	lay, ok := layouts[v.Name]
	if !ok {
		return fmt.Errorf("no HIL layout for %s", v.Name)
	}

	ccExp, err := ccExpected()
	if err != nil {
		return err
	}
	var tests []*test
	for _, spec := range hilSpecs {
		if len(spec.skus) > 0 {
			match := false
			for _, s := range spec.skus {
				match = match || s == v.Name
			}
			if !match {
				continue
			}
		}
		if spec.ll != "" {
			want, ok := ccExp[spec.ll]
			if !ok {
				return fmt.Errorf("%s: no host expectation in dmacc/testdata/expected.txt", spec.ll)
			}
			spec.mem = map[string]uint32{"exitcode": want}
		}
		t, err := build(spec, v, lay)
		if err != nil {
			return err
		}
		if spec.console != "" {
			t.Console, err = os.ReadFile(spec.console)
			if err != nil {
				return err
			}
		}
		if err := verify(v, lay, t); err != nil {
			return fmt.Errorf("emulator verification failed: %w", err)
		}
		// The firmware always loads at the link addresses, where every
		// placement delta is zero — the relocation table is dead weight
		// in flash. Bake: drop it after verification. (Such an image
		// must not be loaded anywhere else.)
		t.Image.Relocs = nil
		tests = append(tests, t)
	}

	if *dmxDir != "" {
		if err := os.MkdirAll(*dmxDir, 0o755); err != nil {
			return err
		}
		for _, t := range tests {
			raw, err := t.Image.Encode()
			if err != nil {
				return err
			}
			if err := os.WriteFile(filepath.Join(*dmxDir, t.Name+".dmx"), raw, 0o644); err != nil {
				return err
			}
		}
	}
	sched, err := buildSched(v, lay)
	if err != nil {
		return fmt.Errorf("sched bundle: %w", err)
	}
	var shl *shellBundle
	if v.Name == "rp2350" { // needs the wide layout
		if shl, err = buildShell(v, lay); err != nil {
			return fmt.Errorf("shell bundle: %w", err)
		}
	}
	if err := os.MkdirAll(filepath.Dir(*out), 0o755); err != nil {
		return err
	}
	if err := os.WriteFile(*out, []byte(emitHeader(v, lay, tests, sched, shl)), 0o644); err != nil {
		return err
	}
	for _, t := range tests {
		raw, _ := t.Image.Encode()
		resident := 0
		for _, s := range t.Image.Segments {
			resident += len(s.Data)
		}
		fmt.Printf("%-14s %6d B flash  %6d B resident  emu cycles: %d\n",
			t.Name, len(raw), resident, t.EmuCycles)
	}
	fmt.Printf("wrote %s (sku %s)\n", *out, v.Name)
	return nil
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "dmxgen:", err)
		os.Exit(1)
	}
}
