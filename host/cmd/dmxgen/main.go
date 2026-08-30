// Command dmxgen generates the HIL (hardware-in-the-loop) test images and
// the C header the target firmware embeds (target/firmware/generated/).
//
// The images are assembled from the .dasm sources in host/prog/hil/ — the
// firmware therefore runs assembler-produced binaries, so a hardware pass
// validates dmaasm end to end. Every image is executed in the emulator
// and the emulator's results become the expected values baked into the
// header: a FAIL on the UART log means silicon and emulator disagree.
//
// Usage:
//
//	go run ./host/cmd/dmxgen -board pico2 -o target/firmware/generated/images.h
//	go run ./host/cmd/dmxgen -board pico2 -dmxdir out/   # also dump .dmx files
//
// The header is board-specific, so -board is what the Makefile passes;
// -sku picks that SKU's default board instead.
package main

import (
	"encoding/binary"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/fsimg"
	"github.com/puhitaku/dma-cpu/host/gameassets"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/pgo"
	"github.com/puhitaku/dma-cpu/host/prog"
)

// layout is the SRAM region reserved for the DMA machine on the HIL
// firmware. It must not collide with the firmware's own .data/.bss (low
// SRAM) or stacks (top of SRAM); the firmware asserts this at boot.
type layout struct {
	text, data, scratch uint32
}

// layouts is keyed by SKU, NOT by board, and that is deliberate: these
// bases home the standalone HIL images (the cc_* checks, the registry
// probes) that BOTH boards of a SKU run. So the rp2040 entry has to
// clear the plain pico's live firmware RAM as well as the gamepico's,
// and the rp2350 entry the plain pico2's as well as the feather's.
//
// DO NOT "unify" these with the per-BOARD windows in host/boards. The
// feather and the gamepico link their firmware RAM into the scratch
// banks, so THEIR machine windows start at 0x20000000; the pico and
// pico2 firmwares still live in low SRAM, so a shared image placed at
// 0x20000000 would land on top of a running firmware's .data on those
// two. The 8 KiB below is a per-board reclaim, and the map here is the
// per-SKU floor that stays.
var layouts = map[string]layout{
	// rp2350: nearly all of main SRAM (firmware .data/.bss end low,
	// core stacks live in the scratch banks above 0x20080000) — the
	// xv6 sh image with its recursion clones needs the room.
	// text starts just above the firmware's own RAM (bss ends near
	// 0x20000DD0; the boot check FATALs if it ever grows past this).
	"rp2350": {text: 0x20002000, data: 0x20050000, scratch: 0x2007FE00},
	"rp2040": {text: 0x20002000, data: 0x20030000, scratch: 0x2003FE00},
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
	Name        string
	Image       *img.Image
	Compact     bool   // Tier-C encoding: loader uses the compact machine
	Console     []byte // expected console bytes (emulator verification)
	Done        uint32 // absolute done-flag address; 0 = perf test (no done)
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
	name       string
	file       string            // host/prog/hil/<file>.dasm
	ll         string            // OR: compile this IR golden with dmacc (Phase 4)
	extrall    []string          // additional IR modules linked into the ll build
	compactEnc bool              // assemble with the Tier-C 8-byte encoding
	libc       bool              // link the picolibc goldens (libc/ll) into the ll build
	console    string            // expected console file (emulator check; prints on the UART on hardware)
	skus       []string          // restrict to these SKUs (nil: all)
	patch      map[string]uint32 // data words poked before encoding
	mem        map[string]uint32 // symbol -> intended value (done=1 implied)
	gpio       *check            // optional pin-level check
	export     []string          // symbols emitted as HIL_SYM_<name>_<sym> macros
	perf       *struct {
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
		console: "host/dmacc/testdata/stdio.console", skus: []string{"rp2350"}},
	// Tier-C compact-encoding twins (prompts/010/011): same programs,
	// 8-byte records, silicon-checked against the same host truth.
	{name: "ccc_memory", ll: "memory", compactEnc: true},
	{name: "ccc_collatz", ll: "collatz", compactEnc: true},
	// The machine-only flash probe (prompts/028; ACCESSCTRL opened by
	// the firmware): the full bit-banged exit-XIP dance + JEDEC/RDSR/
	// erase/program/XIP checks. The emulator's NOR model verifies the
	// driver logic; the numbers that matter come from the silicon
	// printout (the firmware dumps the calres words after the pass).
	{name: "cal_flash", ll: "target/xv6/ll/calflash.ll", extrall: []string{"target/xv6/ll/kflash.ll"},
		skus:   []string{"rp2350"},
		mem:    map[string]uint32{"exitcode": 0},
		export: []string{"g_calres"}},
	{name: "ccc_stdio", ll: "stdio", libc: true, compactEnc: true,
		console: "host/dmacc/testdata/stdio.console", skus: []string{"rp2350"}},
}

// ccExpected reads the host-truth exit codes for the compiled programs.
func ccExpected() (map[string]uint32, error) {
	raw, err := os.ReadFile("host/dmacc/testdata/expected.txt")
	if err != nil {
		return nil, fmt.Errorf("compiled HIL specs need dmacc/testdata/expected.txt (make llgen): %w", err)
	}
	out := map[string]uint32{}
	// The stdio tests keep their expectation in per-test .expected files.
	if extra, err := filepath.Glob("host/dmacc/testdata/*.expected"); err == nil {
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
	main := "host/dmacc/testdata/" + spec.ll + ".ll"
	if strings.HasPrefix(spec.ll, "target/xv6/") {
		main = spec.ll // repo-relative module
	}
	paths := []string{main}
	paths = append(paths, spec.extrall...)
	if spec.libc {
		entries, err := os.ReadDir("target/libc/ll")
		if err != nil {
			return nil, fmt.Errorf("libc goldens missing (make libc): %w", err)
		}
		for _, e := range entries {
			if strings.HasSuffix(e.Name(), ".ll") {
				paths = append(paths, "target/libc/ll/"+e.Name())
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

// --- Phase 5d kernel bundles (prompts/015) ---
// Every bundle is the same four-image shape: kernel.dasm (entry
// stubs), the C kernel core (xv6/dma/kproc.c: proc table, scheduler,
// syscalls), and process images. All cross-image pointers and the
// proc table are patched at generation time; the firmware only loads
// the images, starts slot 0, and arms the single one-shot tick
// injector (ABI ch3, no chain).

// struct proc field word offsets (kproc.c all-uint layout).
const (
	pfState = iota
	pfPid
	pfPpid
	pfChan
	pfWakeTick
	pfXstate
	pfPdispatch
	pfPirqresume
	pfPlr
	pfThunk
	pfResume
	pfPmail
	pfKilled
	pfHeapbase
	pfHeapmax
	pfBrk
	pfSigctx
	pfSigpend
	procWords // 18
)

const (
	stRunnable = 3
	stRunning  = 4
)

type kprocSpec struct {
	res       *dmaasm.Result
	data      uint32 // image data base (for patchData)
	entry     uint32
	pid, ppid uint32
	syscall   bool // image links usys (mailbox + syscall vector)
}

// buildKernelPair assembles kernel.dasm and the compiled kproc.c.
func buildKernelPair(v *emu.Variant, kText, kData, cText, cData uint32) (*dmaasm.Result, *dmaasm.Result, error) {
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		return nil, nil, err
	}
	kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{Variant: v, TextBase: kText, DataBase: kData})
	if err != nil {
		return nil, nil, fmt.Errorf("kernel: %w", err)
	}
	dasm, err := compileLL([]string{"target/xv6/ll/kproc.ll", "target/xv6/ll/kgpio.ll",
		"target/xv6/ll/kdma.ll", "target/xv6/ll/kfbstub.ll", "target/xv6/ll/kfsstub.ll",
		"target/xv6/ll/kconsstub.ll"},
		dmacc.Options{Entry: "kmain", NoSafepoints: true})
	if err != nil {
		return nil, nil, err
	}
	kernC, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v, TextBase: cText, DataBase: cData})
	if err != nil {
		return nil, nil, fmt.Errorf("kproc: %w", err)
	}
	return kern, kernC, nil
}

// wireKernel patches (at generation time) the kernel.dasm words, the
// kproc.c proc table and each syscalling process's vector. Slot 0 is
// the machine's entry and must be always-runnable.
func wireKernel(kern *dmaasm.Result, kData uint32, kernC *dmaasm.Result, cData uint32, procs []kprocSpec) error {
	type patch struct {
		img     *img.Image
		imgData uint32
		addr    uint32
		val     uint32
	}
	var ps []patch
	var err error
	sy := func(r *dmaasm.Result, n string) uint32 {
		if err != nil {
			return 0
		}
		var a uint32
		a, err = r.Symbol(n)
		return a
	}
	// kernel.dasm -> kernel-C entries.
	ps = append(ps,
		patch{kern.Image, kData, sy(kern, "pKlr"), sy(kernC, "lr")},
		patch{kern.Image, kData, sy(kern, "ktickv"), sy(kernC, "f_dma_ktick")},
		patch{kern.Image, kData, sy(kern, "ksysv"), sy(kernC, "f_dma_ksyscall")},
		// cur* seeds for slot 0.
		patch{kern.Image, kData, sy(kern, "pCurDisp"), sy(procs[0].res, "dispatch")},
		patch{kern.Image, kData, sy(kern, "curThunk"), sy(procs[0].res, "crtthunk")},
		patch{kern.Image, kData, sy(kern, "pCurResume"), sy(procs[0].res, "irqresume")},
		// kernel-C -> kernel.dasm words.
		patch{kernC.Image, cData, sy(kernC, "g_kw_pcurdisp"), sy(kern, "pCurDisp")},
		patch{kernC.Image, cData, sy(kernC, "g_kw_curthunk"), sy(kern, "curThunk")},
		patch{kernC.Image, cData, sy(kernC, "g_kw_pcurresume"), sy(kern, "pCurResume")},
		patch{kernC.Image, cData, sy(kernC, "g_kw_curresume"), sy(kern, "curResume")},
		patch{kernC.Image, cData, sy(kernC, "g_kw_nextresume"), sy(kern, "nextResume")},
		patch{kernC.Image, cData, sy(kernC, "g_kw_park"), sy(kern, "parkloop")},
		patch{kernC.Image, cData, sy(kernC, "g_kw_parkvec"), sy(kern, "parkvec")},
	)
	base := sy(kernC, "g_proc")
	pf := func(slot, field int, val uint32) {
		ps = append(ps, patch{kernC.Image, cData,
			base + uint32(slot*procWords+field)*4, val})
	}
	for i, p := range procs {
		state := uint32(stRunnable)
		if i == 0 {
			state = stRunning
		}
		pf(i, pfState, state)
		pf(i, pfPid, p.pid)
		pf(i, pfPpid, p.ppid)
		pf(i, pfPdispatch, sy(p.res, "dispatch"))
		pf(i, pfPirqresume, sy(p.res, "irqresume"))
		pf(i, pfPlr, sy(p.res, "lr"))
		pf(i, pfThunk, sy(p.res, "crtthunk"))
		// First schedule enters at warmstart with dispatch preset here
		// (as exec does): a cold-entry resume would let crt0's dispatch
		// write clobber a tick that fired during the switch to this
		// proc, killing the timer (prompts/024).
		pf(i, pfResume, sy(p.res, "warmstart"))
		ps = append(ps, patch{p.res.Image, p.data,
			sy(p.res, "dispatch"), sy(p.res, "crtthunk")})
		if p.syscall {
			pf(i, pfPmail, sy(p.res, "g___dma_sysmail"))
			ps = append(ps, patch{p.res.Image, p.data,
				sy(p.res, "g___dma_syscall_entry"), sy(kern, "sys_entry")})
		}
	}
	if err != nil {
		return err
	}
	for _, p := range ps {
		if err := patchData(p.img, p.imgData, p.addr, p.val); err != nil {
			return err
		}
	}
	return nil
}

// xshKdmaCtrl: on the video board the pixel pair is the machine's ONLY
// high-priority consumer (the display is the one hard-real-time load);
// the bulk copier runs at normal priority there so an exec's flash
// copy can never crowd the scanout out of the priority tier. Other
// boards keep the copier's HP (the gamepico tuning is deliberate).
func xshKdmaCtrl(v *emu.Variant, bd *boards.Board) uint32 {
	ctrl := v.KDMACopyCtrl()
	if bd.DTab != 0 {
		ctrl &^= emu.CtrlHighPriority
	}
	return ctrl
}

// xshKdmaStreamCtrl: the flash-source copy CTRL — paced by the XIP
// streamer's DREQ, reading the fixed drain port (no INCR_READ), so
// flash latency never parks the shared read master (kdma.c). Video
// boards only; 0 keeps the memory-mapped path.
func xshKdmaStreamCtrl(v *emu.Variant, bd *boards.Board) uint32 {
	if bd.DTab == 0 || v.DreqXIPStream == 0 {
		return 0
	}
	return emu.CtrlEN | emu.CtrlSize32 | v.CtrlIncrWrite |
		v.CtrlTreq(v.DreqXIPStream) | v.CtrlChainTo(11) | v.CtrlIRQQuiet
}

func kernInjCtrlCh(v *emu.Variant, inj int) uint32 {
	return emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		v.CtrlTreq(emu.TreqTimer1) | v.CtrlChainTo(inj) | v.CtrlIRQQuiet
}

func kernInjCtrl(v *emu.Variant) uint32 { return kernInjCtrlCh(v, 3) }

// armKernel pokes the runtime tick setup into an emulator machine for
// bundle verification (mirrors what the firmware does). The injector
// channel is 3 (classic) or emu.CompactInjector.
func armKernelCh(m *emu.Machine, v *emu.Variant, kern *dmaasm.Result, disp0 uint32, inj int) error {
	vec, err := kern.Symbol("vecSched")
	if err != nil {
		return err
	}
	m.Poke32(v.TimerAddr(1), 1<<16|15000)
	m.Poke32(emu.ChanRegAddr(inj, emu.OffAl1ReadAddr), vec)
	m.Poke32(emu.ChanRegAddr(inj, emu.OffAl1WriteAddr), disp0)
	m.Poke32(emu.ChanRegAddr(inj, emu.OffTransCount), 1)
	m.Poke32(emu.ChanRegAddr(inj, emu.OffCtrlTrig), kernInjCtrlCh(v, inj))
	return nil
}

func armKernel(m *emu.Machine, v *emu.Variant, kern *dmaasm.Result, disp0 uint32) error {
	return armKernelCh(m, v, kern, disp0, 3)
}

// kernBundle is the common emitted form of every Phase 5d bundle.
type kernBundle struct {
	images [][]byte // kernel, kernC, then the processes
	names  []string
	entry0 uint32 // slot 0's crt0 (the machine entry)
	vec    uint32 // kernel.dasm vecSched (injector READ source)
	disp0  uint32 // slot 0's dispatch (initial injector target)
	inj    uint32 // injector CTRL value
	ticks  uint32 // &kernC.ticks
	sym    map[string]uint32
	// Raw payloads the firmware stages into fixed RAM homes before
	// starting (exec-image blobs); homes are in sym as <NAME>_HOME.
	// A non-empty blobSects entry instead LINKS the blob at its flash
	// home (an ELF section the firmware CMake pins with
	// --section-start), so it is flashed in place by the UF2 and
	// never exists twice — the game console's text and PCM used to be
	// embedded AND staged, wasting ~740 KiB of the firmware half.
	blobs     [][]byte
	blobNames []string
	blobSects []string
}

// finishBundle verifies nothing (callers verify first), bakes the
// relocations and encodes the images.
func finishBundle(b *kernBundle, results []*dmaasm.Result) error {
	for _, r := range results {
		r.Image.Relocs = nil // fixed placement: bake
		raw, err := r.Image.Encode()
		if err != nil {
			return err
		}
		b.images = append(b.images, raw)
	}
	return nil
}

func compileLL(paths []string, opts dmacc.Options) (string, error) {
	var mods []*llir.Module
	for _, path := range paths {
		src, err := os.ReadFile(path)
		if err != nil {
			return "", err
		}
		mod, err := llir.Parse(string(src))
		if err != nil {
			return "", fmt.Errorf("%s: %w", path, err)
		}
		mods = append(mods, mod)
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		return "", err
	}
	return dmacc.Compile(mod, opts)
}

func libcPaths(first ...string) ([]string, error) {
	entries, err := os.ReadDir("target/libc/ll")
	if err != nil {
		return nil, fmt.Errorf("libc goldens missing (make libc): %w", err)
	}
	for _, e := range entries {
		if strings.HasSuffix(e.Name(), ".ll") {
			first = append(first, "target/libc/ll/"+e.Name())
		}
	}
	return first, nil
}

// buildSched: the scheduler-only bundle (two counter processes, no
// syscalls). Fits the narrow rp2040 layout.
func buildSched(v *emu.Variant, lay layout) (*kernBundle, error) {
	kern, kernC, err := buildKernelPair(v, lay.text, lay.text+0x800, lay.text+0x1000, lay.text+0x1E000)
	if err != nil {
		return nil, err
	}
	pdasm, err := compileLL([]string{"host/dmacc/testdata/proc.ll"}, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	procA, err := dmaasm.Assemble(pdasm, dmaasm.Options{Variant: v, TextBase: lay.text + 0x21000, DataBase: lay.text + 0x22000})
	if err != nil {
		return nil, err
	}
	procB, err := dmaasm.Assemble(pdasm, dmaasm.Options{Variant: v, TextBase: lay.text + 0x23000, DataBase: lay.text + 0x24000})
	if err != nil {
		return nil, err
	}
	b := &kernBundle{names: []string{"kernel", "kernc", "proca", "procb"}, sym: map[string]uint32{}}
	b.entry0 = lay.text + 0x21000 + procA.Image.EntryOff
	entryB := lay.text + 0x23000 + procB.Image.EntryOff
	if err := wireKernel(kern, lay.text+0x800, kernC, lay.text+0x1E000, []kprocSpec{
		{procA, lay.text + 0x22000, b.entry0, 1, 0, false},
		{procB, lay.text + 0x24000, entryB, 2, 0, false},
	}); err != nil {
		return nil, err
	}
	var errs error
	sy := func(r *dmaasm.Result, n string) uint32 {
		a, e := r.Symbol(n)
		if e != nil && errs == nil {
			errs = e
		}
		return a
	}
	b.vec, b.disp0, b.inj = sy(kern, "vecSched"), sy(procA, "dispatch"), kernInjCtrl(v)
	b.ticks = sy(kernC, "g_ticks")
	b.sym["COUNTER_A"] = sy(procA, "g_counter")
	b.sym["COUNTER_B"] = sy(procB, "g_counter")
	if errs != nil {
		return nil, errs
	}

	// Emulator verification before shipping.
	m := emu.NewMachine(v)
	m.TXPace = 13000 // ~115200 baud vs the 15000-cycle tick, as on silicon
	results := []*dmaasm.Result{kern, kernC, procA, procB}
	for _, r := range results {
		if _, err := r.Image.Load(m, nil); err != nil {
			return nil, err
		}
	}
	if err := armKernel(m, v, kern, b.disp0); err != nil {
		return nil, err
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Fetch: 0, Exec: 1, Fix: 2, Entry: b.entry0, Scratch: lay.scratch,
	}); err != nil {
		return nil, err
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 500_000}); err != nil {
		return nil, err
	}
	a, bb, tk := m.Peek32(b.sym["COUNTER_A"]), m.Peek32(b.sym["COUNTER_B"]), m.Peek32(b.ticks)
	if tk < 2 || a == 0 || bb == 0 {
		return nil, fmt.Errorf("sched: emulator verification failed: ticks=%d a=%d b=%d", tk, a, bb)
	}
	if err := finishBundle(b, results); err != nil {
		return nil, err
	}
	return b, nil
}

// buildShell: dma-sh (slot 0, always runnable) + the counter process.
// Needs the wide rp2350 layout.
func buildShell(v *emu.Variant, lay layout) (*kernBundle, error) {
	kText, kData := lay.text, lay.text+0x2000
	cText, cData := lay.text+0x4000, lay.text+0x21800
	sText, sData := lay.text+0x24800, lay.text+0x37000
	pText, pData := lay.text+0x33000, lay.text+0x34000
	blobHome := lay.text + 0x3F000
	arena, arenaEnd := lay.text+0x41000, lay.text+0x57000
	kern, kernC, err := buildKernelPair(v, kText, kData, cText, cData)
	if err != nil {
		return nil, err
	}
	paths, err := libcPaths("host/dmacc/testdata/shell.ll", "target/xv6/ll/usys.ll")
	if err != nil {
		return nil, err
	}
	sdasm, err := compileLL(paths, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	shell, err := dmaasm.Assemble(sdasm, dmaasm.Options{Variant: v, TextBase: sText, DataBase: sData})
	if err != nil {
		return nil, fmt.Errorf("shell: %w", err)
	}
	pdasm, err := compileLL([]string{"host/dmacc/testdata/proc.ll"}, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	procB, err := dmaasm.Assemble(pdasm, dmaasm.Options{Variant: v, TextBase: pText, DataBase: pData})
	if err != nil {
		return nil, err
	}
	b := &kernBundle{names: []string{"kernel", "kernc", "sh", "procb"}, sym: map[string]uint32{}}
	b.entry0 = sText + shell.Image.EntryOff
	entryB := pText + procB.Image.EntryOff
	if err := wireKernel(kern, kData, kernC, cData, []kprocSpec{
		{shell, sData, b.entry0, 1, 0, true},
		{procB, pData, entryB, 2, 0, false},
	}); err != nil {
		return nil, err
	}
	// The exec registry behind dma-sh's `run`: upstream echo + hello.
	echoDasm, err := compileLL([]string{"target/xv6/ll/echo.ll", "target/xv6/ll/ulib.ll", "target/xv6/ll/usys.ll"}, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	echoImg, err := dmaasm.Assemble(echoDasm, dmaasm.Options{Variant: v, TextBase: 0x10000000, DataBase: 0x10020000})
	if err != nil {
		return nil, err
	}
	helloDasm, err := compileLL([]string{"host/dmacc/testdata/xv6hello.ll", "target/xv6/ll/usys.ll"}, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	helloImg, err := dmaasm.Assemble(helloDasm, dmaasm.Options{Variant: v, TextBase: 0x10000000, DataBase: 0x10020000})
	if err != nil {
		return nil, err
	}
	var errs error
	sy := func(r *dmaasm.Result, n string) uint32 {
		a, e := r.Symbol(n)
		if e != nil && errs == nil {
			errs = e
		}
		return a
	}
	// The shell's live stat pointers.
	for _, w := range []struct {
		symName string
		val     uint32
	}{
		{"g_stat_ticks", sy(kernC, "g_ticks")},
		{"g_stat_counter", sy(procB, "g_counter")},
	} {
		if errs == nil {
			if err := patchData(shell.Image, sData, sy(shell, w.symName), w.val); err != nil {
				return nil, err
			}
		}
	}
	b.vec, b.disp0, b.inj = sy(kern, "vecSched"), sy(shell, "dispatch"), kernInjCtrl(v)
	b.ticks = sy(kernC, "g_ticks")
	b.sym["COUNTER_B"] = sy(procB, "g_counter")
	if errs != nil {
		return nil, errs
	}
	regs := []regEntry{{"echo", echoImg}, {"hello", helloImg}}
	blobs, blobNames, regSyms, err := stageRegistry(kernC, cData, blobHome,
		arena, arenaEnd, sy(kern, "sys_entry"), 3, regs)
	if err != nil {
		return nil, err
	}
	b.blobs, b.blobNames = blobs, blobNames
	for k, v2 := range regSyms {
		b.sym[k] = v2
	}

	// Emulator session verification.
	m := emu.NewMachine(v)
	m.TXPace = 13000 // ~115200 baud vs the 15000-cycle tick, as on silicon
	results := []*dmaasm.Result{kern, kernC, shell, procB}
	for _, r := range results {
		if _, err := r.Image.Load(m, nil); err != nil {
			return nil, err
		}
	}
	if err := armKernel(m, v, kern, b.disp0); err != nil {
		return nil, err
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Fetch: 0, Exec: 1, Fix: 2, Entry: b.entry0, Scratch: lay.scratch,
	}); err != nil {
		return nil, err
	}
	stageBlobsEmu(m, b.blobs, b.blobNames, b.sym, regs)
	m.FeedConsole("stat\rrun echo booom from xv6\rrun hello\rstat\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 120_000_000}); err != nil {
		return nil, err
	}
	out := string(m.ConsoleOut)
	if !strings.Contains(out, "dma-sh") || strings.Count(out, "ticks=") != 2 ||
		!strings.Contains(out, "booom from xv6") ||
		!strings.Contains(out, "hello from exec") {
		return nil, fmt.Errorf("shell bundle: emulator session unexpected:\n%s", out)
	}
	if err := finishBundle(b, results); err != nil {
		return nil, err
	}
	return b, nil
}

// PinJoyAUp is the first of the ten joystick pins (GP2..GP11, two
// sticks of five, pulled up on the real board).
const PinJoyAUp = 2

// gameSFXHome is the flash home the PCM+asset blob is LINKED at
// (.gamesfx section), well past the firmware image and clear of the
// game text window. It also SIZES that window: text runs from
// boards.GamePico.GameTextXIP up to here, and the check below is a
// hard error.
//
// The home moved up from 0x10140000 when the radiosity grid grew: at
// 256 KiB the text window had 296 bytes left in it, which is not a
// margin, it is a coincidence.
//
// It moved as far as it can. The console owns exactly the upper 1 MiB
// of a 2 MiB part (GameTextXIP..flash end) and the asset blob — the
// two PCM clips, the drum kit and the Boing ball's precomputed frames
// — is 773776 bytes of it. Pinning the blob at 0x10143000 puts its
// tail 368 bytes below the top of flash and hands the text window
// everything else: 274432 bytes against the 268496 the image measures
// at (ratchet deploy/gamepico-game/text). Both walls are
// now real, so growth on either side is a decision, not a surprise;
// dmxgen fails the build at whichever one is hit first. Both halves of
// the address are pinned by hand — this constant and the
// --section-start in target/firmware/CMakeLists.txt — with images.h's
// HIL_GAME_SFX_HOME and main.c's blob-link check standing between a
// half-edit and a silent misflash.
const gameSFXHome = 0x10143000

// checkGameFree is the link-time pin under the gamepico's
// scene-exclusive SRAM span: the game's data segment must END at or
// below boards.GameFreeBase, so that everything from there up to the
// machine's scratch word — the 40 KiB pinned free block, fx.c's audio
// ring, bench.c's buffers — stays one CONTIGUOUS 73216-byte region a
// scene can claim whole. radio.c is what makes that contiguity worth
// enforcing: its per-patch arrays run 64680 bytes from the pin
// upward, straight through the ring, which is why they arrive with a
// borrow protocol. The old audio-overlap check below only
// catches a segment that has already grown into the ring; this one
// fires 40 KiB earlier, while there is still a choice to make.
//
// A failure here is not a bug to code around. It means the data
// segment genuinely outgrew its home, and the answer is to move the
// pin on purpose (and re-price the span in boards.GameFreeBase's
// table) rather than to shave whatever scene happened to grow last.
func checkGameFree(bd *boards.Board, dataLen int) error {
	end := bd.GameData + uint32(dataLen)
	if end > boards.GameFreeBase {
		return fmt.Errorf("game data ends at %#x, %d bytes past the pinned "+
			"free base %#x — the scene-exclusive span %#x..%#x is no longer "+
			"contiguous; move the pin deliberately (host/boards GameFreeBase)",
			end, end-boards.GameFreeBase, uint32(boards.GameFreeBase),
			uint32(boards.GameFreeBase), bd.Scratch)
	}
	return nil
}

// gameSFX lists the clips baked into the blob, in sfx_tab order.
var gameSFX = []string{"target/game/sfx/dino_fail.wav", "target/game/sfx/lanwalk_success.wav"}

// wavSamples extracts the raw sample bytes of a mono 16-bit WAV.
func wavSamples(path string) ([]byte, error) {
	raw, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	if len(raw) < 44 || string(raw[0:4]) != "RIFF" || string(raw[8:12]) != "WAVE" {
		return nil, fmt.Errorf("%s: not a RIFF/WAVE file", path)
	}
	var data []byte
	for off := 12; off+8 <= len(raw); {
		id := string(raw[off : off+4])
		sz := int(binary.LittleEndian.Uint32(raw[off+4 : off+8]))
		body := raw[off+8:]
		if sz > len(body) {
			sz = len(body)
		}
		switch id {
		case "fmt ":
			if binary.LittleEndian.Uint16(body[0:2]) != 1 || // PCM
				binary.LittleEndian.Uint16(body[2:4]) != 1 || // mono
				binary.LittleEndian.Uint32(body[4:8]) != 44100 ||
				binary.LittleEndian.Uint16(body[14:16]) != 16 {
				return nil, fmt.Errorf("%s: want mono 16-bit 44.1 kHz PCM", path)
			}
		case "data":
			data = body[:sz]
		}
		off += 8 + sz + (sz & 1)
	}
	if data == nil {
		return nil, fmt.Errorf("%s: no data chunk", path)
	}
	return data, nil
}

// buildGame: the gamepico bare-metal image (prompts/040) — one
// dmacc-compiled program, no xv6: text executes from flash, .ramtext
// and data (framebuffer included) in SRAM, entry straight into
// gmain's crt0. The helper-channel CTRL words (the kdma pattern,
// channel 11) are baked into the data segment at generation time.
// Verified end to end in the emulator: boot to the test card, then
// the LCD decoder's preconditions (SPI init + DISPON + a full-frame
// CASET/RASET window) checked from the captured SPI stream.
func buildGame(v *emu.Variant, bd *boards.Board) (*kernBundle, error) {
	dasm, err := compileLL([]string{"target/game/ll/gmain.ll", "target/game/ll/menu.ll",
		"target/game/ll/dino.ll", "target/game/ll/lanwalk.ll", "target/game/ll/yacht.ll",
		"target/game/ll/input.ll", "target/game/ll/fx.ll", "target/game/ll/seq.ll",
		"target/game/ll/grad.ll",
		"target/game/ll/cpumon.ll", "target/game/ll/bench.ll", "target/game/ll/radio.ll", "target/game/ll/gfx.ll",
		"target/game/ll/boing.ll", "target/game/ll/chute.ll", "target/game/ll/puni.ll",
		"target/game/ll/lcd.ll", "target/game/ll/grt.ll"},
		dmacc.Options{Entry: "gmain", NoSafepoints: true, XIPText: true,
			/* the radiosity shooter is the one workload that wants the
			 * machine's full speed: its inner loop visits every one of
			 * the scene's ~3000 patches per shot, and XIP misses are the
			 * bottleneck — placement-only residency (no closure),
			 * feather-style. normal_of left the list by ceasing to
			 * exist: the per-patch group byte turned it into two loads
			 * that inline into shoot. */
			ResidentFuncs: []string{"shoot", "clearance", "in_box"},
			/* size everywhere, speed on the measured hot paths (host/pgo):
			 * HotSites decides the compare form one site at a time,
			 * HotFuncs gates the outliner */
			OptSize: true, HotFuncs: pgo.GameHotFuncs, HotSites: pgo.GameHotSites,
			/* and the top of that same ranking skips the helpers
			 * altogether for the inline compare macro */
			InlineSites: pgo.GameInlineSites,
			/* and the blocks the profile never reached sink out of the
			 * prefetch path, per function (host/pgo) */
			ColdBlocks: pgo.GameColdBlocks})
	if err != nil {
		return nil, err
	}
	prog, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, Compact: true,
		TextBase: bd.GameTextXIP, DataBase: bd.GameData,
		RAMTextBase: bd.GameRAMText,
		/* the pool split buys SRAM here: data grows toward the fixed
		 * audio ring, and the cold literals ride the flash text tail */
		PoolText: true, HotLits: pgo.GameLits})
	if err != nil {
		return nil, err
	}
	// Text (cold pool literals included) must stop short of the asset
	// blob's flash home.
	if n := bd.GameTextXIP + uint32(len(prog.Image.Segments[0].Data)); n > gameSFXHome {
		return nil, fmt.Errorf("game text ends at %#x, past the asset home %#x", n, gameSFXHome)
	}
	sy := func(name string) (uint32, error) { return prog.Symbol(name) }
	memctrl := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		emu.CtrlIncrRead | v.CtrlIncrWrite | v.CtrlChainTo(11) |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlIRQQuiet
	spictrl := emu.CtrlEN | emu.CtrlSize16 | emu.CtrlIncrRead |
		v.CtrlChainTo(11) | v.CtrlTreq(v.DreqSPI0TX) | v.CtrlIRQQuiet
	// The audio streamer (fx.c): ch9 reads the 16 KiB ring (RING on the
	// read side) into PIO0 TXF0, paced by DREQ 0 = PIO0 TX0.
	sndctrl := emu.CtrlEN | emu.CtrlSize32 | emu.CtrlIncrRead |
		v.CtrlRingSize(14) | v.CtrlChainTo(9) | v.CtrlTreq(0) |
		v.CtrlIRQQuiet
	for _, g := range []struct {
		name string
		val  uint32
	}{{"g_memctrl", memctrl}, {"g_spictrl", spictrl}, {"g_sndctrl", sndctrl}} {
		addr, err := sy(g.name)
		if err != nil {
			return nil, err
		}
		if err := patchData(prog.Image, bd.GameData, addr, g.val); err != nil {
			return nil, err
		}
	}
	// The PCM blob: clips concatenated 4-aligned; sfx_tab gets
	// {flash address, sample count} per clip.
	var sfxBlob []byte
	sfxTabAddr, err := sy("g_sfx_tab")
	if err != nil {
		return nil, err
	}
	for i, path := range gameSFX {
		pcm, err := wavSamples(path)
		if err != nil {
			return nil, err
		}
		addr := uint32(gameSFXHome + len(sfxBlob))
		if err := patchData(prog.Image, bd.GameData, sfxTabAddr+uint32(i*8), addr); err != nil {
			return nil, err
		}
		if err := patchData(prog.Image, bd.GameData, sfxTabAddr+uint32(i*8+4),
			uint32(len(pcm)/2)); err != nil {
			return nil, err
		}
		sfxBlob = append(sfxBlob, pcm...)
		for len(sfxBlob)%4 != 0 {
			sfxBlob = append(sfxBlob, 0)
		}
	}
	// The sequencer's drum kit rides the blob too (synthesized at
	// build time — gameassets.DrumPCM — instead of into a 40 KiB SRAM
	// arena by the machine); g_daddr[1..5] get the flash addresses.
	daddrSym, err := sy("g_daddr")
	if err != nil {
		return nil, err
	}
	for i, clip := range gameassets.DrumPCM() {
		addr := uint32(gameSFXHome + len(sfxBlob))
		if err := patchData(prog.Image, bd.GameData, daddrSym+uint32(4+4*i), addr); err != nil {
			return nil, err
		}
		sfxBlob = append(sfxBlob, clip...)
	}
	// The Boing ball rides the same blob: patch its flash home into
	// the demo's pointer and keep the whole thing under the window.
	ballHome := uint32(gameSFXHome + len(sfxBlob))
	ballAddr, err := sy("g_ball_home")
	if err != nil {
		return nil, err
	}
	if err := patchData(prog.Image, bd.GameData, ballAddr, ballHome); err != nil {
		return nil, err
	}
	sfxBlob = append(sfxBlob, gameassets.BallBlob()...)
	if top := 0x10000000 + int(bd.FlashSize); gameSFXHome+len(sfxBlob) > top {
		return nil, fmt.Errorf("game asset blob ends at %#x, %d bytes past "+
			"the top of flash (%#x) — the blob and the text window share the "+
			"upper %d KiB and both are full; move gameSFXHome down only by "+
			"first making the text fit",
			gameSFXHome+len(sfxBlob), gameSFXHome+len(sfxBlob)-top, top,
			(top-int(bd.GameTextXIP))/1024)
	}
	// Fixed audio region (fx.c): the 16 KiB ring at 0x20038000 (the
	// drum PCM moved to flash). Nothing LINKED may grow in — a scene
	// that wants those bytes at runtime borrows them instead, with
	// ch9 quiesced (fx.c's aud_borrow; radio.c is the one user).
	const auBase, auEnd = 0x20038000, 0x2003C000
	for _, seg := range prog.Image.Segments {
		end := seg.LinkAddr + uint32(len(seg.Data))
		if seg.LinkAddr < auEnd && end > auBase {
			return nil, fmt.Errorf("game segment %#x..%#x overlaps the audio region %#x..%#x",
				seg.LinkAddr, end, auBase, auEnd)
		}
	}
	// And the pin above the data segment: the scene-exclusive span
	// starts at boards.GameFreeBase and must stay whole.
	if err := checkGameFree(bd, len(prog.Image.Segments[1].Data)); err != nil {
		return nil, err
	}
	// Emulator verification: boot to the menu. Image.Load also
	// applies the init Writes (register banks, dispatch presets) —
	// exactly what the firmware's dmx_load replays.
	m := emu.NewMachine(v)
	m.Flash = make([]byte, bd.FlashSize)
	copy(m.Flash[gameSFXHome-0x10000000:], sfxBlob)
	for pin := PinJoyAUp; pin < PinJoyAUp+10; pin++ {
		m.SetPadIn(pin, true) // pulled-up joysticks read released
	}
	entry, err := prog.Image.Load(m, nil)
	if err != nil {
		return nil, err
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entry, Scratch: bd.Scratch,
	}); err != nil {
		return nil, err
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000_000}); err != nil {
		return nil, fmt.Errorf("game boot: %w\nconsole:\n%s", err, m.ConsoleOut)
	}
	out := string(m.ConsoleOut)
	if !strings.Contains(out, "menu up") {
		return nil, fmt.Errorf("game boot: no menu; console:\n%s", out)
	}
	if len(m.SPIOut) < 100 {
		return nil, fmt.Errorf("game boot: only %d SPI writes", len(m.SPIOut))
	}

	b := &kernBundle{sym: map[string]uint32{}}
	b.entry0 = entry
	segs := prog.Image.Segments
	textBlob := pad4(segs[0].Data)
	prog.Image.Segments = segs[1:]
	for i := range prog.Image.Writes {
		prog.Image.Writes[i].Ref = img.RefAbs
	}
	prog.Image.EntrySeg, prog.Image.EntryOff = 0, 0
	b.blobs = append(b.blobs, textBlob)
	b.blobNames = append(b.blobNames, "text")
	b.blobSects = append(b.blobSects, ".gametext")
	b.sym["TEXT_HOME"] = bd.GameTextXIP
	b.blobs = append(b.blobs, pad4(sfxBlob))
	b.blobNames = append(b.blobNames, "sfx")
	b.blobSects = append(b.blobSects, ".gamesfx")
	b.sym["SFX_HOME"] = gameSFXHome
	if err := finishBundle(b, []*dmaasm.Result{prog}); err != nil {
		return nil, err
	}
	b.names = []string{"prog"}
	return b, nil
}

// kernResident is the kernel's .ramtext residency list (placement
// only, no closure): the code that must not read flash while the
// display scans, because every machine flash read parks the shared DMA
// read master against the HSTX FIFO's ~1.26 us of slack (prompts/036).
//
// The 10 kHz tick/fire path and the console ring hooks keep an idle
// machine at ZERO flash reads and a keypress storm short; they were
// ranked by TestProfileEnter as 95% of prompt-path reads, and the PGO
// driver's .ramtext histogram still puts them at 100M+ reads over a
// shell + vi session.
//
// cursor_xor and kfbcon_putc join on framebuffer boards — the display
// half of the console tee, which every console byte runs through. The
// ranking behind that pair is host/trace's, re-taken on the current
// tree over the fbcon workload (`cat README` + 12x `ls /dev`, the
// shapes TestZZBenchFbcon prices), as XIP-text reads by owner:
//
//	dma_ksyscall  26.6%  35480 B   117 reads/B   (does not fit, ever)
//	kfbcon_putc   22.7%  10496 B   337 reads/B   <- resident
//	kdmacpy       11.0%   2416 B   713 reads/B
//	memmove        5.0%   2576 B   303 reads/B
//	bread          4.3%   1496 B   444 reads/B
//	kconswrite     1.2%    336 B   581 reads/B
//
// The reads-per-byte column is NOT the decision. Residency is worth
// cycles as well as flash reads — a resident body keeps its
// self-modifying records instead of reaching for the .ramtext stub
// XIPText splits out — and those two do not rank the same way. On the
// feather fbcon bench, against the 2a22fe0 baseline:
//
//	kfbcon_putc alone       (+10.7K)  -2.0/-1.7/-3.6/-1.0%
//	+ kdmacpy               (+12.6K)  -1.0/-1.7/-3.6/-0.8%
//	+ the six cheap names   (+17.1K)  -1.0/-1.6/-1.8/-0.8%
//	the six cheap names ALONE (+6.4K) +1.0/+0.4/-0.6/-0.6%
//
// So kfbcon_putc is the whole win and every further name measured
// NEGATIVE against it: each one drags its literal references into the
// resident pool half, and the profiled hot keys they displace cost
// more than the parking they save. The honest reading is that the
// window has one tenant left worth having, and it is in it.
//
// cell_addr, the other candidate the old ranking named, no longer
// exists: -Oz inlined it into kfbcon_putc, which is why that body is
// 10.5 KiB now rather than 8.9.
func kernResident(bd *boards.Board) []string {
	fs := []string{"dma_ktick", "kenter", "kexit", "swtch",
		"fire_income", "tick_income", "kcons_aim", "kcons_kick",
		"kcons_on", "kcons_rx", "kcons_tx", "kcons_pending"}
	if bd.FbBuf != 0 {
		fs = append(fs, "cursor_xor", "kfbcon_putc")
	}
	return fs
}

// nimgRows is the kernel's flash-image registry capacity and MUST
// track NIMG in target/xv6/dma/kproc.c, which declares the array this
// generator fills (struct kimg kimages[NIMG]). Every kernel-side
// lookup loop is bounded by NIMG, so a row written past it would land
// in flash and stay invisible forever.
const nimgRows = 20

// buildXsh: UPSTREAM user/sh.c as the boot shell on the FULL
// filesystem kernel, the WHOLE SYSTEM in Tier-C compact encoding
// (Phase 8, prompts/020): 8-byte records halve text, the tick
// injector rides channel 9 of the board pool, and every image's
// mode-switch records target fetch's own WRITE_ADDR register, so
// images share the machine with no coordination word. The board's
// app set (boards.stdApps) ships as DMX-exec images: RAM-disk files,
// or flash-registry rows where the board has an apps section.
func buildXsh(v *emu.Variant, bd *boards.Board) (*kernBundle, error) {
	// Everything positional comes from the board definition — the RAM
	// partition, the flash sections, and the app set (boards/boards.go
	// is the single source of truth, shared with the test harness).
	fatVolXIP, cTextXIP, sTextXIP := bd.FatVol, bd.KernTextXIP, bd.ShTextXIP
	viHome, viEnd := bd.ViHome, bd.ViEnd
	kText, kData := bd.KernText, bd.KernData
	cRText, cData := bd.KernCRText, bd.KernCData
	sRText, sData := bd.ShRText, bd.ShData
	iText, iData := bd.IdleText, bd.IdleData
	diskHome := bd.DiskHome
	diskMax := bd.DiskMax
	arena, arenaEnd := bd.Arena, bd.ArenaEnd
	if bd.DTabRAM != 0 && bd.DTabRAM > arena && bd.DTabRAM < arenaEnd {
		arenaEnd = bd.DTabRAM /* the SRAM scanout-table experiment */
	}

	casm := func(src string, text, data, rtext uint32) (*dmaasm.Result, error) {
		return dmaasm.Assemble(src, dmaasm.Options{
			Variant: v, Compact: true,
			TextBase: text, DataBase: data, RAMTextBase: rtext})
	}
	// Flash literal-pool split: every image keeps its own profiled hot
	// set resident (host/pgo, generated by `make pgo`) and pays flash
	// reads for the rest.
	casmPool := func(src string, text, data, rtext uint32, hot map[string]bool) (*dmaasm.Result, error) {
		return dmaasm.Assemble(src, dmaasm.Options{
			Variant: v, Compact: true,
			TextBase: text, DataBase: data, RAMTextBase: rtext,
			PoolText: true, HotLits: hot})
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		return nil, err
	}
	kern, err := casm(ksrc, kText, kData, 0)
	if err != nil {
		return nil, err
	}
	// Boards without a framebuffer take the no-op fb stub, keeping
	// ~25 KiB of fbcon machine text out of their kernels (the RP2040
	// has no HSTX at all).
	fbMods := []string{"target/xv6/ll/kfbstub.ll"}
	if bd.FbBuf != 0 {
		fbMods = []string{"target/xv6/ll/kfb.ll", "target/xv6/ll/kfbcon.ll"}
	}
	kcDasm, err := compileLL(append(append([]string{"target/xv6/ll/kproc.ll", "target/xv6/ll/kcons.ll", "target/xv6/ll/kgpio.ll"},
		fbMods...), "target/xv6/ll/kfs.ll", "target/xv6/ll/kfile.ll",
		"target/xv6/ll/kbio.ll", "target/xv6/ll/kfsglue.ll", "target/xv6/ll/kpipe.ll", "target/xv6/ll/kflash.ll",
		"target/xv6/ll/kfat.ll", "target/xv6/ll/kdev.ll", "target/xv6/ll/kdma.ll", "target/xv6/ll/ksd.ll", "target/xv6/ll/string.ll"),
		dmacc.Options{Entry: "kmain", NoSafepoints: true, XIPText: true,
			/* the QMI sync session tears down XIP: it must run from SRAM */
			RAMTextFuncs:  []string{"kflash_sync"},
			ResidentFuncs: kernResident(bd),
			/* host the shared runtime for every guest image below */
			RuntimeHost: true,
			/* size everywhere, speed on the measured hot paths: every
			 * compare site outside pgo.KernelHotSites takes the
			 * two-record descriptor form, and pgo.KernelHotFuncs keeps
			 * the outliner off the hot functions (host/pgo) */
			OptSize: true, HotFuncs: pgo.KernelHotFuncs, HotSites: pgo.KernelHotSites,
			/* and the top of that same ranking skips the helpers
			 * altogether for the inline compare macro */
			InlineSites: pgo.KernelInlineSites,
			/* never-executed blocks sink to the end of their function,
			 * so the hot ones lie back to back in the XIP window */
			ColdBlocks: pgo.KernelColdBlocks})
	if err != nil {
		return nil, err
	}
	kernC, err := casmPool(kcDasm, cTextXIP, cData, cRText, pgo.KernelLits)
	if err != nil {
		return nil, fmt.Errorf("fs kernel: %w", err)
	}
	shDasm, err := compileLL([]string{"target/xv6/ll/sh.ll", "target/xv6/ll/ulib.ll",
		"target/xv6/ll/umalloc.ll", "target/xv6/ll/usys.ll"},
		dmacc.Options{RecursionDepth: 2, XIPText: true,
			RuntimeExtern: &dmacc.ExternRT{Vec: cRText, Regs: cData},
			ColdBlocks:    pgo.ShColdBlocks})
	if err != nil {
		return nil, err
	}
	sh, err := casmPool(shDasm, sTextXIP, sData, sRText, pgo.ShLits)
	if err != nil {
		return nil, fmt.Errorf("xv6 sh: %w", err)
	}
	idasm, err := compileLL([]string{"host/dmacc/testdata/proc.ll"}, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	idle, err := casm(idasm, iText, iData, 0)
	if err != nil {
		return nil, err
	}
	// The SRAM map above is windowed: fail loudly if a region outgrew
	// its window instead of letting images silently overlap.
	for _, ck := range []struct {
		name      string
		res       *dmaasm.Result
		seg       int
		base, end uint32
	}{
		{"kernC ramtext", kernC, 2, cRText, cData},
		{"kernC data", kernC, 1, cData, sRText},
		{"sh ramtext", sh, 2, sRText, sData},
		{"sh data", sh, 1, sData, iText},
	} {
		if n := ck.base + uint32(len(ck.res.Image.Segments[ck.seg].Data)); n > ck.end {
			return nil, fmt.Errorf("xsh: %s ends at %#x, past %#x", ck.name, n, ck.end)
		}
	}

	// The disk: upstream user programs as compact DMX-exec files.
	fb := fsimg.New(uint32(bd.DiskBlocks), bd.Inodes())
	fb.AddFile("README", []byte("the DMA machine runs upstream xv6.\n"))
	// Apps: either DMX-exec files on the RAM disk, or (small-RAM
	// boards) flash-resident registry images — the kernel's exec
	// falls back to the registry by name, and toolbox's multi-call
	// aliases each get a row over the same blob.
	appRes := map[string]*dmaasm.Result{}
	for _, name := range bd.DiskApps {
		udasm, err := compileLL([]string{"target/xv6/ll/" + name + ".ll", "target/xv6/ll/ulib.ll", "target/xv6/ll/usys.ll"},
			dmacc.Options{OptSize: boards.SizeApps[name],
				RuntimeExtern: &dmacc.ExternRT{Vec: cRText, Regs: cData}})
		if err != nil {
			return nil, err
		}
		ures, err := casm(udasm, 0x10000000, 0x10040000, 0)
		if err != nil {
			return nil, err
		}
		if bd.AppsHome != 0 {
			appRes[name] = ures
			continue
		}
		blob, err := fsimg.DMXExec(ures.Image, ures.Symbol)
		if err != nil {
			return nil, err
		}
		fb.AddFile(name, blob)
		/* the multi-call names: hard links onto the one blob */
		for _, l := range bd.LinksFor(name) {
			fb.AddLink(l)
		}
	}
	disk := fb.Bytes()
	if uint32(len(disk)) > diskMax {
		return nil, fmt.Errorf("xsh disk too large: %d", len(disk))
	}

	// vi (BusyBox port, prompts/033): boards with the flash budget
	// carry it as a kernel-registry image whose blobs stay in flash —
	// exec copies text+data to the arena and applies the relocs from
	// XIP directly.
	// casmResident assembles a pre-relocated image at its final homes:
	// text at tHome (executes in place from XIP), [ramtext][data] at
	// the arena's first allocation. Pass 1 at scratch bases measures
	// the ramtext. Returns padded segment blobs and the SRAM home.
	casmResident := func(dasm string, tHome uint32, hot map[string]bool) (*dmaasm.Result, []byte, []byte, []byte, uint32, error) {
		probe, err := casm(dasm, 0x10000000, 0x10040000, 0x10080000)
		if err != nil {
			return nil, nil, nil, nil, 0, err
		}
		rt := pad8(probe.Image.Segments[2].Data)
		sram := bd.Arena + 0x100 /* first-fit kalloc's first block */
		res, err := casmPool(dasm, tHome, sram+uint32(len(rt)), sram, hot)
		if err != nil {
			return nil, nil, nil, nil, 0, err
		}
		if len(pad8(res.Image.Segments[2].Data)) != len(rt) {
			return nil, nil, nil, nil, 0, fmt.Errorf("ramtext length moved between passes")
		}
		text := pad4(res.Image.Segments[0].Data)
		rt = pad8(res.Image.Segments[2].Data)
		data := pad4(res.Image.Segments[1].Data)
		need := (uint32(len(rt))+uint32(len(data))+255)&^255 + 0x100
		if bd.Arena+need > bd.ArenaEnd {
			return nil, nil, nil, nil, 0, fmt.Errorf("SRAM half (%d bytes) overflows the arena", need)
		}
		return res, text, rt, data, sram, nil
	}
	var viRes *dmaasm.Result
	var viText, viData, viBlob []byte
	if viHome != 0 {
		viDasm, err := compileLL([]string{"target/xv6/ll/vi.ll", "target/xv6/ll/ulib.ll",
			"target/xv6/ll/umalloc.ll", "target/xv6/ll/usys.ll"},
			dmacc.Options{XIPText: true, /* pre-relocated: text runs from flash */
				RuntimeExtern: &dmacc.ExternRT{Vec: cRText, Regs: cData},
				ColdBlocks:    pgo.ViColdBlocks}) /* balanced: editor latency over bytes */
		if err != nil {
			return nil, fmt.Errorf("vi: %w", err)
		}
		// Pre-relocated (prompts/041 follow-up): no relocs — exec
		// claims only the SRAM half and text executes where it lies.
		var viRT []byte
		var err2 error
		viRes, viText, viRT, viData, _, err2 = casmResident(viDasm, viHome, pgo.ViLits)
		if err2 != nil {
			return nil, fmt.Errorf("vi: %w", err2)
		}
		viBlob = append(append(append([]byte(nil), viText...), viRT...), viData...)
		if viHome+uint32(len(viBlob)) > viEnd {
			return nil, fmt.Errorf("vi blob %d bytes overflows its flash budget", len(viBlob))
		}
	}

	b := &kernBundle{names: []string{"kernel", "kernc", "sh", "idle"}, sym: map[string]uint32{}}
	b.entry0 = sTextXIP + sh.Image.EntryOff
	entryI := iText + idle.Image.EntryOff
	if err := wireKernel(kern, kData, kernC, cData, []kprocSpec{
		{sh, sData, b.entry0, 1, 0, true},
		{idle, iData, entryI, 2, 0, false},
	}); err != nil {
		return nil, err
	}
	var errs error
	sy := func(r *dmaasm.Result, n string) uint32 {
		a, e := r.Symbol(n)
		if e != nil && errs == nil {
			errs = e
		}
		return a
	}
	const inj = emu.CompactInjector
	for _, g := range []struct {
		name string
		val  uint32
	}{
		{"g_dma_disk", diskHome}, {"g_dma_disksize", uint32(len(disk))},
		{"g_arena", arena}, {"g_arena_end", arenaEnd},
		{"g_nextpid", 3}, {"g_k_sysentry", sy(kern, "sys_entry")},
		{"g_inj_wreg", emu.ChanRegAddr(inj, emu.OffWriteAddr)},
		{"g_inj_treg", emu.ChanRegAddr(inj, emu.OffAl1TransCountTrig)},
		{"g_fsslot", roFSSlot(bd)},
		{"g_initpid", 2},        /* idle adopts orphans (prompts/024) */
		{"g_fgpid", 1},          /* Ctrl-C interrupts sh's foreground job */
		{"g_fatvol", fatVolXIP}, /* the vfat volume (prompts/029) */
		/* Machine-driven SD (ksd.c): zero-off unless the board arms it. */
		{"g_sd_spi", sdSpi(v, bd)},
		{"g_sd_csreg", sdCsReg(v, bd)},
		{"g_sd_cs_hi", sdCsVal(v, bd, true)},
		{"g_sd_cs_lo", sdCsVal(v, bd, false)},
		{"g_sd_rxctrl", sdRxCtrl(v, bd)},
		{"g_sd_txch", sdTxCh(v, bd)},
		{"g_sd_txctrl", sdTxCtrl(v, bd)},
		{"g_goldsum", checksum32(disk)},
		{"g_xv6_commit", gitCommit7()},
		{"g_iobank0", v.IOBank0Base}, {"g_padsbank0", v.PadsBank0Base},
		{"g_pio0base", v.PIO0Base}, {"g_gpiopins", uint32(v.GPIOPins)},
		{"g_gpio_hi", v.GPIOOutCtrl(true)}, {"g_gpio_lo", v.GPIOOutCtrl(false)},
		{"g_kflash_arm", flashArm(bd)}, /* 0: the MACHINE drives the
		 * flash itself (RP2350 QMI, prompts/028); KFLASH_NOEXEC (1):
		 * no executor at all, sync answers -ENODEV; else the parked
		 * ARM's mailbox loop at scratch+0x10 executes for it */
		{"g_dmacpy_ctrl", xshKdmaCtrl(v, bd)}, /* kdma.c bulk channel */
		{"g_dmacpy_sctrl", xshKdmaStreamCtrl(v, bd)},
		{"g_xip_stream", v.XIPStreamAddr},
		{"g_xip_aux", v.XIPAuxBase},
	} {
		if errs == nil {
			if err := patchData(kernC.Image, cData, sy(kernC, g.name), g.val); err != nil {
				return nil, err
			}
		}
	}
	// Console DMA (kproc.c cons_dma_init): boards with the ring block
	// get the three-channel UART engine; g_ctx_ctrl = 0 keeps the
	// polling paths elsewhere.
	if bd.ConsRings != 0 {
		for _, g := range []struct {
			name string
			val  uint32
		}{
			{"g_ctx_base", emu.ChanRegAddr(emu.ConsTxCh, 0)},
			{"g_ctx_ring", bd.ConsRings + emu.ConsRxRingSize},
			{"g_ctx_ctrl", v.ConsTxCtrl()},
			{"g_crx_base", emu.ChanRegAddr(emu.ConsRxCh, 0)},
			{"g_crx_ring", bd.ConsRings},
			{"g_crx_ctrl", v.ConsRxCtrl()},
			{"g_cwk_base", emu.ChanRegAddr(emu.ConsWakeCh, 0)},
			{"g_cwk_ctrl", v.ConsWakeCtrl()},
			{"g_cuart_dr", v.UARTDRAddr()},
		} {
			if errs == nil {
				if err := patchData(kernC.Image, cData, sy(kernC, g.name), g.val); err != nil {
					return nil, err
				}
			}
		}
	}
	// HDMI framebuffer driver globals (kfb.c, prompts/036) — only on
	// boards with a framebuffer; the others link the stub.
	var fbGlobals []struct {
		name string
		val  uint32
	}
	if bd.FbBuf != 0 {
		fbGlobals = []struct {
			name string
			val  uint32
		}{
			{"g_fb_base", bd.FbBuf},
			{"g_fb_ctl", bd.FbHome},
		}
	}
	for _, g := range fbGlobals {
		if errs == nil {
			if err := patchData(kernC.Image, cData, sy(kernC, g.name), g.val); err != nil {
				return nil, err
			}
		}
	}
	// Registry rows: exec's by-name fallback for flash-resident
	// images (kproc.c lookup()) — vi when installed, and the whole
	// app set on flash-apps boards (aliases share one blob).
	rowIdx := 0
	// linkT/linkD are the image's link bases (the canonical scratch
	// bases for relocatable rows, the real homes for pre-relocated
	// ones); sramhome/rtHome/rtLen describe a pre-relocated row's
	// [ramtext][data] placement (sramhome 0 = classic relocatable).
	patchRow := func(name string, res *dmaasm.Result, tHome, tLen, dHome, dLen,
		rHome, nrel, linkT, linkD, sramhome, rtHome, rtLen uint32) error {
		vy := func(n string) uint32 {
			a, e := res.Symbol(n)
			if e != nil && errs == nil {
				errs = e
			}
			return a
		}
		var nb [12]byte
		copy(nb[:], name)
		rowVals := []uint32{
			binary.LittleEndian.Uint32(nb[0:]), binary.LittleEndian.Uint32(nb[4:]),
			binary.LittleEndian.Uint32(nb[8:]),
			tHome, tLen,
			dHome, dLen,
			linkT, linkD,
			rHome, nrel,
			vy("warmstart") - linkT, vy("crtthunk") - linkT,
			vy("dispatch") - linkD, vy("irqresume") - linkD, vy("lr") - linkD,
			vy("g___dma_sysmail") - linkD, vy("g___dma_syscall_entry") - linkD,
			sramhome, rtHome, rtLen,
		}
		row := sy(kernC, "g_kimages") + uint32(rowIdx)*84
		rowIdx++
		for i, val := range rowVals {
			if errs == nil {
				if err := patchData(kernC.Image, cData, row+uint32(i)*4, val); err != nil {
					return err
				}
			}
		}
		return nil
	}
	if viHome != 0 {
		rtHome := viHome + uint32(len(viText))
		dHome := rtHome + uint32(len(viBlob)) - uint32(len(viText)) - uint32(len(viData))
		viSRAM := bd.Arena + 0x100
		rtLen := dHome - rtHome
		if err := patchRow("vi", viRes, viHome, uint32(len(viText)),
			dHome, uint32(len(viData)), 0, 0,
			viHome, viSRAM+rtLen, viSRAM, rtHome, rtLen); err != nil {
			return nil, err
		}
	}
	var appsBlob []byte
	if bd.AppsHome != 0 {
		cursor := bd.AppsHome
		for _, name := range bd.DiskApps {
			if boards.XIPApps[name] {
				// Pre-relocated registry app: same scheme as vi.
				udasm, err := compileLL([]string{"target/xv6/ll/" + name + ".ll",
					"target/xv6/ll/ulib.ll", "target/xv6/ll/usys.ll"},
					dmacc.Options{OptSize: boards.SizeApps[name], XIPText: true,
						RuntimeExtern: &dmacc.ExternRT{Vec: cRText, Regs: cData},
						ColdBlocks:    pgo.ColdBlocksFor(name)})
				if err != nil {
					return nil, err
				}
				res, text, rt, data, sram, err := casmResident(udasm, cursor, pgo.LitsFor(name))
				if err != nil {
					return nil, fmt.Errorf("%s: %w", name, err)
				}
				tHome := cursor
				rtHome := tHome + uint32(len(text))
				dHome := rtHome + uint32(len(rt))
				cursor = dHome + uint32(len(data))
				appsBlob = append(append(append(appsBlob, text...), rt...), data...)
				names := append([]string{name}, bd.LinksFor(name)...)
				for _, n := range names {
					if err := patchRow(n, res, tHome, uint32(len(text)),
						dHome, uint32(len(data)), 0, 0,
						tHome, sram+uint32(len(rt)), sram, rtHome, uint32(len(rt))); err != nil {
						return nil, err
					}
				}
				continue
			}
			res := appRes[name]
			text := pad4(res.Image.Segments[0].Data)
			data := pad4(res.Image.Segments[1].Data)
			var rel []byte
			for _, r := range res.Image.Relocs {
				var w [4]byte
				binary.LittleEndian.PutUint32(w[:], packReloc(r))
				rel = append(rel, w[:]...)
			}
			tHome, dHome := cursor, cursor+uint32(len(text))
			rHome := dHome + uint32(len(data))
			cursor = rHome + uint32(len(rel))
			appsBlob = append(append(append(appsBlob, text...), data...), rel...)
			names := append([]string{name}, bd.LinksFor(name)...)
			for _, n := range names {
				if err := patchRow(n, res, tHome, uint32(len(text)),
					dHome, uint32(len(data)), rHome, uint32(len(res.Image.Relocs)),
					0x10000000, 0x10040000, 0, 0, 0); err != nil {
					return nil, err
				}
			}
		}
		if cursor > bd.AppsEnd {
			return nil, fmt.Errorf("apps blob overflows its flash budget by %d bytes", cursor-bd.AppsEnd)
		}
		// rowIdx is the row COUNT here (patchRow post-increments), so the
		// last legal index is nimgRows-1 and a count of nimgRows fits.
		if rowIdx > nimgRows {
			return nil, fmt.Errorf("registry rows exhausted: %d rows > NIMG (%d, kproc.c)", rowIdx, nimgRows)
		}
	}

	// Golden vfat volume (prompts/029): the firmware stages it into
	// flash at fatVolXIP when no valid BPB is present, so `mount fat0`
	// works on silicon out of the box.
	fatb := fsimg.NewFAT32(128) // 64 KiB
	fatb.AddFile("HELLO.TXT", []byte("hello from vfat on real flash\n"))
	fatb.AddFile("presentation-notes.txt",
		[]byte("the DMA CPU mounts FAT32 now\n"))
	fatb.AddDir("SUB")
	fatb.AddFile("SUB/NESTED.TXT", []byte("nested vfat read\n"))
	b.blobs = [][]byte{pad4(disk), fatb.Bytes()}
	b.blobNames = []string{"disk", "fat"}
	if viHome != 0 {
		b.blobs = append(b.blobs, viBlob)
		b.blobNames = append(b.blobNames, "vib")
		b.sym["VI_HOME"] = viHome
		b.sym["VI_LEN"] = uint32(len(viBlob))
	}
	if bd.AppsHome != 0 {
		b.blobs = append(b.blobs, appsBlob)
		b.blobNames = append(b.blobNames, "apps")
		b.sym["APPS_HOME"] = bd.AppsHome
	}
	b.sym["FATVOL"] = fatVolXIP
	b.sym["BLOB_DISK_HOME"] = diskHome
	b.sym["INJ_CH"] = uint32(inj)
	b.sym["FSSLOT"] = roFSSlot(bd)
	b.sym["DISK_LEN"] = uint32(len(disk))
	b.sym["FLASHREQ"] = bd.Scratch + 0x10
	b.sym["ARENA"] = arena /* the firmware's boot-staging bounce home */
	b.sym["FBBUF"] = bd.FbBuf
	b.sym["FBCTL"] = bd.FbHome
	if bd.DTab != 0 {
		// Pure-DMA scanout (boards/scanout.go): the descriptor program
		// staged to flash; the firmware arms the walker/executor pair
		// and never touches the display again.
		b.blobs = append(b.blobs, pad4(boards.ScanoutTable(bd, v)))
		b.blobNames = append(b.blobNames, "dtab")
		b.sym["DTAB_HOME"] = bd.DTab
		b.sym["DTAB_RAM"] = bd.DTabRAM /* 0 = run from flash */
		b.sym["DTAB_BLOCKS"] = boards.ScanoutBlocks(bd)
		b.sym["SCAN_WALKER"] = emu.ChanRegAddr(boards.ScanWalkerCh, 0)
		b.sym["SCAN_EXEC"] = emu.ChanRegAddr(boards.ScanExecCh, 0)
		b.sym["SCAN_WALKER_CTRL"] = boards.ScanoutWalkerCtrl(v)
	}
	b.sym["GOLDSUM"] = checksum32(disk)
	b.vec, b.disp0, b.inj = sy(kern, "vecSched"), sy(sh, "dispatch"), kernInjCtrlCh(v, inj)
	if bd.DTab != 0 {
		b.inj &^= emu.CtrlHighPriority /* pixel pair only (see xshKdmaCtrl) */
	}
	b.ticks = sy(kernC, "g_ticks")
	if errs != nil {
		return nil, errs
	}

	// Emulator session verification: ls, files, redirection, a pipe.
	m := emu.NewMachine(v)
	m.TXPace = 13000 // ~115200 baud vs the 15000-cycle tick, as on silicon
	m.Flash = make([]byte, bd.FlashSize)
	for i := range m.Flash {
		m.Flash[i] = 0xFF
	}
	if bd.PSRAMSize != 0 {
		// The fb driver comes up during this boot and renders into
		// PSRAM; give the verification machine the board's part.
		m.PSRAM = make([]byte, bd.PSRAMSize)
	}
	results := []*dmaasm.Result{kern, kernC, sh, idle}
	for _, r := range results {
		if _, err := r.Image.Load(m, nil); err != nil {
			return nil, err
		}
	}
	if viHome != 0 {
		copy(m.Flash[viHome-0x10000000:], viBlob) /* firmware-staged */
	}
	if bd.AppsHome != 0 {
		copy(m.Flash[bd.AppsHome-0x10000000:], appsBlob)
	}
	for o := 0; o < len(disk); o += 4 {
		m.Poke32(diskHome+uint32(o), binary.LittleEndian.Uint32(disk[o:]))
	}
	if err := armKernelCh(m, v, kern, b.disp0, inj); err != nil {
		return nil, err
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: b.entry0, Scratch: bd.Scratch,
	}); err != nil {
		return nil, err
	}
	m.FeedConsole("ls\rcat README\recho booom > note\rcat note\recho pipeflow | cat\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 900_000_000}); err != nil {
		return nil, err
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	for _, want := range []string{"$ ", "README", "the DMA machine runs upstream xv6.",
		"booom", "\npipeflow"} {
		if !strings.Contains(out, want) {
			return nil, fmt.Errorf("xsh bundle: session missing %q:\n%s", want, out)
		}
	}
	// XIP text leaves the DMX container: dmx_load only copies SRAM, so
	// the flash-resident text segment ships as a blob the firmware
	// stages (content-compared, like the fat golden) before dmx_start.
	stripXIP := func(r *dmaasm.Result) []byte {
		segs := r.Image.Segments
		blob := pad4(segs[0].Data)
		r.Image.Segments = segs[1:]
		for i := range r.Image.Writes {
			r.Image.Writes[i].Ref = img.RefAbs // fixed placement: values are final
		}
		r.Image.EntrySeg, r.Image.EntryOff = 0, 0 // real entry: HIL_XSH_ENTRY
		return blob
	}
	b.blobs = append(b.blobs, stripXIP(kernC), stripXIP(sh))
	b.blobNames = append(b.blobNames, "ktext", "stext")
	b.sym["KTEXT_HOME"] = cTextXIP
	b.sym["STEXT_HOME"] = sTextXIP
	if err := finishBundle(b, results); err != nil {
		return nil, err
	}
	return b, nil
}

const sysWantConsole = "hello from pid 1 via SYS_write\n" +
	"pid 1 saw the clock advance\n" +
	"pid 1 exiting\n"

// buildSyscall: two instances of the xv6 syscall exerciser
// (dmacc/testdata/xv6sys.c + xv6/dma/usys.c). Wide layout.
func buildSyscall(v *emu.Variant, lay layout) (*kernBundle, error) {
	kText, kData := lay.text, lay.text+0x2000
	cText, cData := lay.text+0x4000, lay.text+0x21800
	aText, aData := lay.text+0x24800, lay.text+0x28800
	bText, bData := lay.text+0x2C800, lay.text+0x30800
	kern, kernC, err := buildKernelPair(v, kText, kData, cText, cData)
	if err != nil {
		return nil, err
	}
	pdasm, err := compileLL([]string{"host/dmacc/testdata/xv6sys.ll", "target/xv6/ll/usys.ll"}, dmacc.Options{})
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
	b := &kernBundle{names: []string{"kernel", "kernc", "proca", "procb"}, sym: map[string]uint32{}}
	b.entry0 = aText + procA.Image.EntryOff
	entryB := bText + procB.Image.EntryOff
	if err := wireKernel(kern, kData, kernC, cData, []kprocSpec{
		{procA, aData, b.entry0, 1, 0, true},
		{procB, bData, entryB, 2, 0, true},
	}); err != nil {
		return nil, err
	}
	var errs error
	sy := func(r *dmaasm.Result, n string) uint32 {
		a, e := r.Symbol(n)
		if e != nil && errs == nil {
			errs = e
		}
		return a
	}
	b.vec, b.disp0, b.inj = sy(kern, "vecSched"), sy(procA, "dispatch"), kernInjCtrl(v)
	b.ticks = sy(kernC, "g_ticks")
	b.sym["BGCOUNT_B"] = sy(procB, "g_bgcount")
	b.sym["DONETICK_A"] = sy(procA, "g_donetick")
	b.sym["EXITSTATUS_A"] = sy(kernC, "g_proc") + pfXstate*4 // slot 0
	if errs != nil {
		return nil, errs
	}

	// Emulator verification: the full pid-1 lifecycle plus survivor.
	m := emu.NewMachine(v)
	m.TXPace = 13000 // ~115200 baud vs the 15000-cycle tick, as on silicon
	results := []*dmaasm.Result{kern, kernC, procA, procB}
	for _, r := range results {
		if _, err := r.Image.Load(m, nil); err != nil {
			return nil, err
		}
	}
	if err := armKernel(m, v, kern, b.disp0); err != nil {
		return nil, err
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Fetch: 0, Exec: 1, Fix: 2, Entry: b.entry0, Scratch: lay.scratch,
	}); err != nil {
		return nil, err
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000_000}); err != nil {
		return nil, err
	}
	if got := strings.ReplaceAll(string(m.ConsoleOut), "\r", ""); got != sysWantConsole {
		return nil, fmt.Errorf("syscall bundle: console mismatch:\n got %q\nwant %q", got, sysWantConsole)
	}
	bg1 := m.Peek32(b.sym["BGCOUNT_B"])
	if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000}); err != nil {
		return nil, err
	}
	if bg2 := m.Peek32(b.sym["BGCOUNT_B"]); bg2 <= bg1 {
		return nil, fmt.Errorf("syscall bundle: pid 2 stalled after pid 1 exit (%d -> %d)", bg1, bg2)
	}
	if st := m.Peek32(b.sym["EXITSTATUS_A"]); st != 0 {
		return nil, fmt.Errorf("syscall bundle: pid 1 exit status %d", st)
	}
	if err := finishBundle(b, results); err != nil {
		return nil, err
	}
	return b, nil
}

// roFSSlot is the slot address a board's kernel sees: 0 on read-only
// boards (sync disabled, no slot staging at boot).
func roFSSlot(bd *boards.Board) uint32 {
	if bd.ReadOnlyFS {
		return 0
	}
	return bd.FSSlot
}

// kflashNoExec is kflash.c's KFLASH_NOEXEC sentinel: not zero (which
// means "the machine drives the QMI itself") and not a mailbox address
// either — no executor exists, so sync answers -ENODEV. Kept in step
// with the #define in target/xv6/dma/kflash.c.
const kflashNoExec = 1

// flashArm picks the flash executor the kernel uses for sync, in the
// three states the kernel knows: 0 for the machine-driven QMI driver,
// the sentinel for a board that ships NO executor, else the address of
// the parked ARM's mailbox. The sentinel is what keeps a mailbox-less
// board from hanging: kflash.c's arm_request spins on an ack, so a
// baked mailbox address that nobody services is worse than an error.
func flashArm(bd *boards.Board) uint32 {
	switch {
	case bd.MachineFlashExec:
		return 0
	case bd.NoFlashExec:
		return kflashNoExec
	}
	return bd.Scratch + 0x10
}

// checksum32 is the kernel's disk_checksum: a word sum.
func checksum32(b []byte) uint32 {
	var sum uint32
	for i := 0; i+4 <= len(b); i += 4 {
		sum += binary.LittleEndian.Uint32(b[i:])
	}
	return sum
}

// packReloc encodes an img.Reloc for the kernel loader: bit31 target
// segment (0 text, 1 data), bit30 referenced segment, low 30 bits off.
func packReloc(r img.Reloc) uint32 {
	w := r.Off & 0x3FFFFFFF
	if r.Seg == 1 {
		w |= 1 << 31
	}
	if r.Ref == 1 {
		w |= 1 << 30
	}
	return w
}

// Machine-SD loader values: all zero when the board keeps the ARM
// executor (ksd.c's zero-config-off seam).
func sdSpi(v *emu.Variant, bd *boards.Board) uint32 {
	if !bd.MachineSDExec {
		return 0
	}
	return v.SPI0Base
}

func sdCsReg(v *emu.Variant, bd *boards.Board) uint32 {
	if !bd.MachineSDExec {
		return 0
	}
	return v.IOBank0Base + uint32(bd.SDCSPin)*8 + 4
}

func sdCsVal(v *emu.Variant, bd *boards.Board, high bool) uint32 {
	if !bd.MachineSDExec {
		return 0
	}
	return v.GPIOOutCtrl(high)
}

func sdRxCtrl(v *emu.Variant, bd *boards.Board) uint32 {
	if !bd.MachineSDExec {
		return 0
	}
	return v.SDRxCtrl()
}

func sdTxCh(v *emu.Variant, bd *boards.Board) uint32 {
	if !bd.MachineSDExec || bd.ConsRings == 0 {
		return 0
	}
	return 0x50000000 + uint32(emu.ConsTxCh)*0x40
}

func sdTxCtrl(v *emu.Variant, bd *boards.Board) uint32 {
	if !bd.MachineSDExec || bd.ConsRings == 0 {
		return 0
	}
	return v.SDTxCtrl()
}

// gitCommit7 returns the repo's HEAD as 7 hex digits in the low 28
// bits — the kernel boot banner's version stamp. 0 when git is
// unavailable (the banner then reads 0000000).
func gitCommit7() uint32 {
	out, err := exec.Command("git", "rev-parse", "--short=7", "HEAD").Output()
	if err != nil {
		return 0
	}
	h := strings.TrimSpace(string(out))
	if len(h) < 7 {
		return 0
	}
	v, err := strconv.ParseUint(h[:7], 16, 32)
	if err != nil {
		return 0
	}
	return uint32(v)
}

func pad8(b []byte) []byte {
	out := append([]byte(nil), b...)
	for len(out)%8 != 0 {
		out = append(out, 0)
	}
	return out
}

func pad4(b []byte) []byte {
	for len(b)%4 != 0 {
		b = append(b, 0)
	}
	return b
}

// regEntry names one image for the kernel's exec registry.
type regEntry struct {
	name string
	res  *dmaasm.Result // assembled with relocs intact (not baked)
}

// stageRegistry patches kimages rows + loader globals into the kproc
// image and returns the blob payloads (text/data/relocs per entry) the
// firmware must stage at their registered homes, plus <NAME>_HOME
// symbol macros. Blobs are placed consecutively from home.
func stageRegistry(kernC *dmaasm.Result, cData uint32, home, arena, arenaEnd,
	sysentry, nextpid uint32, entries []regEntry) ([][]byte, []string, map[string]uint32, error) {
	var blobs [][]byte
	var names []string
	syms := map[string]uint32{}
	rowBase, err := kernC.Symbol("g_kimages")
	if err != nil {
		return nil, nil, nil, err
	}
	cursor := home
	for slot, e := range entries {
		hText := pad4(e.res.Image.Segments[0].Data)
		hData := pad4(e.res.Image.Segments[1].Data)
		var hRel []byte
		for _, r := range e.res.Image.Relocs {
			var w [4]byte
			binary.LittleEndian.PutUint32(w[:], packReloc(r))
			hRel = append(hRel, w[:]...)
		}
		textHome := cursor
		dataHome := textHome + uint32(len(hText))
		relHome := dataHome + uint32(len(hData))
		cursor = relHome + uint32(len(hRel))
		if cursor > arena {
			return nil, nil, nil, fmt.Errorf("registry: blobs overflow the home window at %q", e.name)
		}
		up := strings.ToUpper(e.name)
		blobs = append(blobs, hText, hData, hRel)
		names = append(names, e.name+"_text", e.name+"_data", e.name+"_relocs")
		syms["BLOB_"+up+"_TEXT_HOME"] = textHome
		syms["BLOB_"+up+"_DATA_HOME"] = dataHome
		syms["BLOB_"+up+"_RELOCS_HOME"] = relHome

		var errs error
		sy := func(n string) uint32 {
			a, e2 := e.res.Symbol(n)
			if e2 != nil && errs == nil {
				errs = e2
			}
			return a
		}
		tl, dl := e.res.Image.Segments[0].LinkAddr, e.res.Image.Segments[1].LinkAddr
		var name [12]byte
		copy(name[:], e.name)
		rowVals := []uint32{
			binary.LittleEndian.Uint32(name[0:]), binary.LittleEndian.Uint32(name[4:]),
			binary.LittleEndian.Uint32(name[8:]),
			textHome, uint32(len(hText)),
			dataHome, uint32(len(hData)),
			tl, dl,
			relHome, uint32(len(e.res.Image.Relocs)),
			sy("warmstart") - tl, sy("crtthunk") - tl,
			sy("dispatch") - dl, sy("irqresume") - dl, sy("lr") - dl,
			sy("g___dma_sysmail") - dl, sy("g___dma_syscall_entry") - dl,
		}
		if errs != nil {
			return nil, nil, nil, errs
		}
		row := rowBase + uint32(slot)*84
		for i, val := range rowVals {
			if err := patchData(kernC.Image, cData, row+uint32(i)*4, val); err != nil {
				return nil, nil, nil, err
			}
		}
	}
	for _, g := range []struct {
		name string
		val  uint32
	}{
		{"g_arena", arena}, {"g_arena_end", arenaEnd},
		{"g_nextpid", nextpid}, {"g_k_sysentry", sysentry},
	} {
		addr, err := kernC.Symbol(g.name)
		if err != nil {
			return nil, nil, nil, err
		}
		if err := patchData(kernC.Image, cData, addr, g.val); err != nil {
			return nil, nil, nil, err
		}
	}
	return blobs, names, syms, nil
}

// stageBlobsEmu pokes staged blobs into an emulator machine at their
// homes (mirrors the firmware's stage_blob) for bundle verification.
func stageBlobsEmu(m *emu.Machine, blobs [][]byte, names []string, syms map[string]uint32, entries []regEntry) {
	i := 0
	for _, e := range entries {
		up := strings.ToUpper(e.name)
		for _, part := range []string{"TEXT", "DATA", "RELOCS"} {
			home := syms["BLOB_"+up+"_"+part+"_HOME"]
			blob := blobs[i]
			i++
			for o := 0; o < len(blob); o += 4 {
				m.Poke32(home+uint32(o), binary.LittleEndian.Uint32(blob[o:]))
			}
		}
	}
}

// buildExec: Phase 5e — the kernel's own loader. Two instances of the
// spawner (fork/exec/wait) plus the "hello" image as a REGISTRY row:
// its segments and packed relocs are staged to fixed RAM homes and the
// kernel places, relocates and runs it at exec() time.
func buildExec(v *emu.Variant, lay layout) (*kernBundle, error) {
	kText, kData := lay.text, lay.text+0x2000
	cText, cData := lay.text+0x4000, lay.text+0x21800
	aText, aData := lay.text+0x24800, lay.text+0x28800
	bText, bData := lay.text+0x2C800, lay.text+0x30800
	blobHome := lay.text + 0x31000
	arena, arenaEnd := lay.text+0x35000, lay.text+0x3E000

	kern, kernC, err := buildKernelPair(v, kText, kData, cText, cData)
	if err != nil {
		return nil, err
	}
	sdasm, err := compileLL([]string{"host/dmacc/testdata/xv6spawn.ll", "target/xv6/ll/usys.ll"}, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	idle, err := dmaasm.Assemble(sdasm, dmaasm.Options{Variant: v, TextBase: aText, DataBase: aData})
	if err != nil {
		return nil, err
	}
	parent, err := dmaasm.Assemble(sdasm, dmaasm.Options{Variant: v, TextBase: bText, DataBase: bData})
	if err != nil {
		return nil, err
	}
	hdasm, err := compileLL([]string{"host/dmacc/testdata/xv6hello.ll", "target/xv6/ll/usys.ll"}, dmacc.Options{})
	if err != nil {
		return nil, err
	}
	// hello keeps its relocs: the kernel places it. Link bases are
	// arbitrary; only the deltas matter.
	hello, err := dmaasm.Assemble(hdasm, dmaasm.Options{Variant: v, TextBase: 0x10000000, DataBase: 0x10020000})
	if err != nil {
		return nil, err
	}

	b := &kernBundle{names: []string{"kernel", "kernc", "idle", "parent"}, sym: map[string]uint32{}}
	b.entry0 = aText + idle.Image.EntryOff
	entryP := bText + parent.Image.EntryOff
	if err := wireKernel(kern, kData, kernC, cData, []kprocSpec{
		{idle, aData, b.entry0, 1, 0, true},
		{parent, bData, entryP, 2, 0, true},
	}); err != nil {
		return nil, err
	}

	var errs error
	sy := func(r *dmaasm.Result, n string) uint32 {
		a, e := r.Symbol(n)
		if e != nil && errs == nil {
			errs = e
		}
		return a
	}
	regs := []regEntry{{"hello", hello}}
	blobs, blobNames, regSyms, err := stageRegistry(kernC, cData, blobHome,
		arena, arenaEnd, sy(kern, "sys_entry"), 3, regs)
	if err != nil {
		return nil, err
	}
	b.blobs, b.blobNames = blobs, blobNames
	for k, v2 := range regSyms {
		b.sym[k] = v2
	}
	b.vec, b.disp0, b.inj = sy(kern, "vecSched"), sy(idle, "dispatch"), kernInjCtrl(v)
	b.ticks = sy(kernC, "g_ticks")
	b.sym["SPAWN_PID"] = sy(parent, "g_spawn_pid")
	b.sym["REAP_PID"] = sy(parent, "g_reap_pid")
	b.sym["REAP_STATUS"] = sy(parent, "g_reap_status")
	b.sym["IDLECOUNT"] = sy(idle, "g_idlecount")
	if errs != nil {
		return nil, errs
	}

	// Emulator verification of the full spawn.
	m := emu.NewMachine(v)
	m.TXPace = 13000 // ~115200 baud vs the 15000-cycle tick, as on silicon
	results := []*dmaasm.Result{kern, kernC, idle, parent}
	for _, r := range results {
		if _, err := r.Image.Load(m, nil); err != nil {
			return nil, err
		}
	}
	stageBlobsEmu(m, b.blobs, b.blobNames, b.sym, regs)
	if err := armKernel(m, v, kern, b.disp0); err != nil {
		return nil, err
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Fetch: 0, Exec: 1, Fix: 2, Entry: b.entry0, Scratch: lay.scratch,
	}); err != nil {
		return nil, err
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000_000}); err != nil {
		return nil, err
	}
	const want = "parent: spawning\nhello from exec\nparent: reaped\n"
	if got := strings.ReplaceAll(string(m.ConsoleOut), "\r", ""); got != want {
		return nil, fmt.Errorf("exec bundle: console mismatch:\n got %q\nwant %q", got, want)
	}
	if sp, rp := m.Peek32(b.sym["SPAWN_PID"]), m.Peek32(b.sym["REAP_PID"]); sp != 3 || rp != 3 {
		return nil, fmt.Errorf("exec bundle: spawn=%d reap=%d, want 3/3", sp, rp)
	}
	if st := int32(m.Peek32(b.sym["REAP_STATUS"])); st != 7 {
		return nil, fmt.Errorf("exec bundle: status %d, want 7", st)
	}
	if err := finishBundle(b, results); err != nil {
		return nil, err
	}
	return b, nil
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
	// In symbol order: the checks go into a committed header, and a Go
	// map range would reorder them on every regeneration.
	syms := make([]string, 0, len(spec.mem))
	for sym := range spec.mem {
		syms = append(syms, sym)
	}
	sort.Strings(syms)
	for _, sym := range syms {
		addr, err := res.Symbol(sym)
		if err != nil {
			return nil, err
		}
		t.Checks = append(t.Checks, check{checkMem, addr, spec.mem[sym], sym})
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
	m.TXPace = 13000                 // ~115200 baud vs the 15000-cycle tick, as on silicon
	m.Flash = make([]byte, 0x400000) // cal_flash probes the NOR model (CAL_OFF at 0x3F0000)
	for i := range m.Flash {
		m.Flash[i] = 0xFF
	}
	cfg := emu.FetchExecConfig{Fetch: 0, Exec: 1, Fix: 2, Scratch: lay.scratch}
	if t.Compact {
		cfg = emu.FetchExecConfig{Compact: true}
	}
	if err := t.Image.LoadAndStart(m, nil, cfg); err != nil {
		return fmt.Errorf("%s: %w", t.Name, err)
	}
	for _, e := range t.Exports {
		if e.Name == "g_calres" {
			// The emulator has no parked ARM: grant the machine's
			// take-the-flash handshake immediately (calres[12]).
			m.Poke32(e.Addr+48, 0x600D600D)
		}
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
	m.TXPace = 13000 // ~115200 baud vs the 15000-cycle tick, as on silicon
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

// machineFloor is the lowest SRAM address anything this board's
// firmware loads links at: the per-SKU standalone-image base, or the
// board's own kernel/game window when that sits lower (the feather and
// the gamepico link their firmware RAM into the scratch banks, which
// hands the machine the 8 KiB below the family floor).
func machineFloor(bd *boards.Board, lay layout) uint32 {
	lo := lay.text
	for _, a := range []uint32{bd.KernText, bd.GameRAMText} {
		if a != 0 && a < lo {
			lo = a
		}
	}
	return lo
}

func emitHeader(bd *boards.Board, v *emu.Variant, lay layout, tests []*test, sched, shl, sys, exe, xsh, game *kernBundle) string {
	var b strings.Builder
	p := func(format string, args ...any) { fmt.Fprintf(&b, format+"\n", args...) }

	p("/* Generated by host/cmd/dmxgen — DO NOT EDIT. Regenerate with:")
	p(" *   go run ./host/cmd/dmxgen -board %s -o target/firmware/generated/images.h", bd.Name)
	p(" * Images are assembled from host/prog/hil/*.dasm; expected values are")
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
	p("/* The lowest address THIS BOARD's payload links at, which can be")
	p(" * below HIL_MACHINE_RAM_START: that one is the per-SKU floor the")
	p(" * standalone HIL images share (both boards of a SKU run them), while")
	p(" * a board whose firmware RAM moved into the scratch banks owns the")
	p(" * 8 KiB underneath it. Check firmware .bss against this. */")
	p("#define HIL_MACHINE_RAM_FLOOR 0x%08Xu", machineFloor(bd, lay))
	p("")
	p("/* Calibration experiment constants (channel %d). */", calCh)
	p("#define HIL_CAL_CH %d", calCh)
	p("#define HIL_CAL_CH_BASE 0x%08Xu", emu.ChanRegAddr(calCh, 0))
	p("#define HIL_INTR_ADDR 0x%08Xu", v.IntrAddr())
	p("#define HIL_CHAN_ABORT_ADDR 0x%08Xu", v.ChanAbortAddr())
	p("#define HIL_TIMER0_ADDR 0x%08Xu", v.TimerAddr(0))
	p("#define HIL_CLK_SYS_KHZ %du /* 0 = SDK default */", bd.ClkSysKHz)
	p("#define HIL_TICK_CYCLES %du /* 100 us of clk_sys */", bd.TickCycles())
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
	p(" * channel bank with static CTRLs (prompts/010). No fix channel:")
	p(" * fetch's 8-byte write ring holds the window and the banks chain")
	p(" * straight back to fetch; mode switches rewrite fetch's")
	p(" * WRITE_ADDR through the AL3 non-trigger alias. */")
	const cmpP, cmpS, cmpB, cmpF = 6, 7, 8, 9
	p("#define HIL_CMP_EPLAIN %d", cmpP)
	p("#define HIL_CMP_ESNIFF %d", cmpS)
	p("#define HIL_CMP_EBSWAP %d", cmpB)
	p("#define HIL_CMP_FETCH %d", cmpF)
	cmpExec := emu.CtrlEN | emu.CtrlSize32 | v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(cmpF) | v.CtrlIRQQuiet
	p("#define HIL_CMP_CTRL_PLAIN 0x%08Xu", cmpExec)
	p("#define HIL_CMP_CTRL_SNIFF 0x%08Xu", cmpExec|v.CtrlSniffEn)
	p("#define HIL_CMP_CTRL_BSWAP 0x%08Xu", cmpExec|v.CtrlBswap)
	p("#define HIL_CMP_FETCH_CTRL 0x%08Xu",
		emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|v.CtrlIncrWrite|
			v.CtrlRingSel|v.CtrlRingSize(3)|
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
	// dumpSect emits one byte array; a non-empty sect pins it into a
	// named ELF section the firmware link places at a fixed flash
	// address (game blobs: flashed in place, no staging copy).
	dumpSect := func(sect, name string, raw []byte) {
		attr := ""
		if sect != "" {
			attr = fmt.Sprintf("__attribute__((used, aligned(4), section(\"%s\"))) ", sect)
		}
		p("static const uint8_t %s%s[] = {", attr, name)
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
	dump := func(name string, raw []byte) { dumpSect("", name, raw) }
	// Phase 5d bundles share one emitted shape: the images plus the
	// entry/vec/disp0/injCtrl/ticks quintet and per-bundle symbols.
	emitBundle := func(prefix string, b *kernBundle) {
		for i, im := range b.images {
			dump(fmt.Sprintf("hil_%s_%s_dmx", strings.ToLower(prefix), b.names[i]), im)
		}
		for i, blob := range b.blobs {
			sect := ""
			if i < len(b.blobSects) {
				sect = b.blobSects[i]
			}
			dumpSect(sect, fmt.Sprintf("hil_%s_blob_%s", strings.ToLower(prefix), b.blobNames[i]), blob)
		}
		up := strings.ToUpper(prefix)
		p("#define HIL_%s_ENTRY 0x%08Xu", up, b.entry0)
		p("#define HIL_%s_VEC 0x%08Xu", up, b.vec)
		p("#define HIL_%s_DISP0 0x%08Xu", up, b.disp0)
		p("#define HIL_%s_INJ_CTRL 0x%08Xu", up, b.inj)
		p("#define HIL_%s_TICKS 0x%08Xu", up, b.ticks)
		syms := make([]string, 0, len(b.sym))
		for n := range b.sym {
			syms = append(syms, n)
		}
		sort.Strings(syms)
		for _, n := range syms {
			p("#define HIL_%s_%s 0x%08Xu", up, n, b.sym[n])
		}
	}
	p("/* Phase 5d scheduler bundle (prompts/012/015): kernel stubs + C")
	p(" * kernel core + two relocated counter processes, fully pre-wired")
	p(" * and emulator-verified. The firmware loads the images, starts")
	p(" * slot 0 and arms the single one-shot tick injector (ch3). */")
	emitBundle("sched", sched)
	if shl != nil {
		p("")
		p("/* Phase 5b/5d shell bundle (prompts/013): dma-sh as slot 0 +")
		p(" * counter process, emulator session verified. */")
		p("#define HIL_HAS_SHELL 1")
		emitBundle("shell", shl)
	}
	if sys != nil {
		p("")
		p("/* Phase 5c/5d syscall bundle (xv6/PORT.md): two instances of")
		p(" * the xv6 syscall exerciser on the proc-table kernel. pid 1's")
		p(" * SYS_write output appears directly on the UART. */")
		p("#define HIL_HAS_SYSCALL 1")
		emitBundle("sys", sys)
	}
	if exe != nil {
		p("")
		p("/* Phase 5e exec bundle (xv6/PORT.md): fork/exec/wait with the")
		p(" * loader IN the kernel. The firmware stages the hello blob at")
		p(" * its registered RAM homes, then the kernel places, relocates")
		p(" * and runs it at exec() time. */")
		p("#define HIL_HAS_EXEC 1")
		emitBundle("exec", exe)
	}
	if xsh != nil {
		p("")
		p("/* Phase 6 bundle (prompts/018): UPSTREAM xv6 sh.c as the boot")
		p(" * shell — recursion on depth-cloned frames, vfork-safe")
		p(" * frameless syscalls, kernel-registry exec. */")
		p("#define HIL_HAS_XSH 1")
		emitBundle("xsh", xsh)
	}
	if game != nil {
		p("")
		p("/* gamepico bundle (prompts/040): the bare-metal game console —")
		p(" * text staged to flash (XIP), data+ramtext via dmx_load, the")
		p(" * machine started at gmain and the ARM parked. */")
		p("#define HIL_HAS_GAME 1")
		emitBundle("game", game)
	}
	p("")
	p("#endif /* DMX_HIL_IMAGES_H */")
	return b.String()
}

func run() error {
	sku := flag.String("sku", "", "target SKU (rp2040 or rp2350); picks that SKU's default board")
	board := flag.String("board", "", "target board (pico2, pico, feather, gamepico); overrides -sku")
	out := flag.String("o", "target/firmware/generated/images.h", "output C header path")
	dmxDir := flag.String("dmxdir", "", "also write raw .dmx files into this directory")
	flag.Parse()

	var bd *boards.Board
	switch {
	case *board != "":
		var ok bool
		if bd, ok = boards.All[*board]; !ok {
			return fmt.Errorf("unknown board %q", *board)
		}
	case *sku != "":
		bd = boards.Default(*sku)
	default:
		bd = boards.Pico2
	}
	v, err := emu.VariantByName(bd.SKU)
	if err != nil {
		return err
	}
	lay, ok := layouts[v.Name]
	if !ok {
		return fmt.Errorf("no HIL layout for %s", v.Name)
	}
	// Boards whose firmware carries extra SDK runtime (the Feather
	// links hardware_psram) grow .bss past the family floor: their
	// machine RAM starts where boards.Board places the kernel.
	if bd.KernText > lay.text {
		lay.text = bd.KernText
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
		if spec.ll != "" && spec.mem == nil {
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
	var shl, sys, exe, xsh, game *kernBundle
	if bd.HasBundle("game") {
		if game, err = buildGame(v, bd); err != nil {
			return fmt.Errorf("game bundle: %w", err)
		}
	}
	if bd.HasBundle("shell") {
		if shl, err = buildShell(v, lay); err != nil {
			return fmt.Errorf("shell bundle: %w", err)
		}
	}
	if bd.HasBundle("syscall") {
		if sys, err = buildSyscall(v, lay); err != nil {
			return fmt.Errorf("syscall bundle: %w", err)
		}
	}
	if bd.HasBundle("exec") {
		if exe, err = buildExec(v, lay); err != nil {
			return fmt.Errorf("exec bundle: %w", err)
		}
	}
	if bd.HasBundle("xsh") {
		if xsh, err = buildXsh(v, bd); err != nil {
			return fmt.Errorf("xsh bundle: %w", err)
		}
	}
	if err := os.MkdirAll(filepath.Dir(*out), 0o755); err != nil {
		return err
	}
	if err := os.WriteFile(*out, []byte(emitHeader(bd, v, lay, tests, sched, shl, sys, exe, xsh, game)), 0o644); err != nil {
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
