package dmacc_test

import (
	"encoding/binary"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/fsimg"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// buildUser compiles an xv6 user program (name.ll + the userland
// modules) and assembles it reloc-intact at canonical link bases.
func buildUser(t *testing.T, v *emu.Variant, name string, extra ...string) *dmaasm.Result {
	t.Helper()
	paths := append([]string{name, "ulib", "usys"}, extra...)
	var mods []*llir.Module
	for _, p := range paths {
		mods = append(mods, parseLL(t, "../xv6/ll/"+p+".ll"))
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{OptSize: true})
	if err != nil {
		t.Fatal(err)
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, Compact: true, CompactScratch: 0x2007FE00,
		TextBase: 0x10000000, DataBase: 0x10040000})
	if err != nil {
		t.Fatal(err)
	}
	return res
}

// buildDisk assembles the user programs as DMX-exec files and packs
// them (plus README) into an xv6 filesystem image.
func buildDisk(t *testing.T, v *emu.Variant) []byte {
	t.Helper()
	b := fsimg.New(96, 64)
	b.AddDevice("console", 1, 0)
	b.AddFile("README", []byte("the DMA machine runs upstream xv6.\n"))
	for _, prog := range []struct {
		name  string
		extra []string
	}{
		{"echo", nil},
		{"cat", nil},
		{"ls", nil},
		{"toolbox", nil},
	} {
		res := buildUser(t, v, prog.name, prog.extra...)
		blob, err := fsimg.DMXExec(res.Image, res.Symbol)
		if err != nil {
			t.Fatal(err)
		}
		b.AddFile(prog.name, blob)
		if prog.name == "toolbox" {
			for _, l := range []string{"kill", "spin", "trap", "free",
				"sync", "mount", "umount", "wc", "mkdir", "rm"} {
				b.AddLink(l)
			}
		}
	}
	return b.Bytes()
}

// bootXsh boots UPSTREAM sh.c (slot 0) on the full fs kernel with the
// RAM disk mounted — exec resolves paths in the filesystem now.
func bootXsh(t *testing.T) (*emu.Machine, *dmaasm.Result) {
	return bootXshFlash(t, nil)
}

// flashMailbox is where emulator tests place the ARM-executor mailbox
// (op, off, src, seq, ack — kflash.c's struct flashreq).
const flashMailbox = 0x2007FE10

// serviceFlashMailbox plays the parked ARM: applies one pending
// erase/program request to the flash slice and acks it. Returns
// whether a request was served.
func serviceFlashMailbox(m *emu.Machine, flash []byte) bool {
	seq := m.Peek32(flashMailbox + 12)
	ack := m.Peek32(flashMailbox + 16)
	if seq == ack {
		return false
	}
	op := m.Peek32(flashMailbox)
	off := m.Peek32(flashMailbox + 4)
	src := m.Peek32(flashMailbox + 8)
	switch op {
	case 1: // erase 4K
		for i := uint32(0); i < 0x1000 && off+i < uint32(len(flash)); i++ {
			flash[off+i] = 0xFF
		}
	case 2: // program 256B from machine RAM
		for i := uint32(0); i < 256 && off+i < uint32(len(flash)); i++ {
			flash[off+i] &= byte(m.Peek32((src+i)&^3) >> (8 * ((src + i) % 4)))
		}
	}
	m.Poke32(flashMailbox+16, seq)
	return true
}

// bootXshFlash boots with a QSPI flash model attached. The disk is
// staged from the flash slot when its header is valid (as the ARM
// does at boot), else from the golden image; the kernel gets the slot
// address so SYS_sync can burn it.
func bootXshFlash(t *testing.T, flash []byte) (*emu.Machine, *dmaasm.Result) {
	t.Helper()
	v, err := emu.VariantByName("rp2350")
	if err != nil {
		t.Fatal(err)
	}
	shMod, err := llir.Merge(
		parseLL(t, "../xv6/ll/sh.ll"), parseLL(t, "../xv6/ll/ulib.ll"),
		parseLL(t, "../xv6/ll/umalloc.ll"), parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	shDasm, err := dmacc.Compile(shMod, dmacc.Options{RecursionDepth: 12, XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	kcDasm := compileKernelOpts(t, true, true)
	idleDasm, err := dmacc.Compile(parseLL(t, "testdata/proc.ll"), dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	casm := func(src string, text, data, rtext uint32) (*dmaasm.Result, error) {
		return dmaasm.Assemble(src, dmaasm.Options{
			Variant: v, Compact: true, CompactScratch: 0x2007FE00,
			TextBase: text, DataBase: data, RAMTextBase: rtext})
	}
	// XIP layout (prompts/030): kernC and sh text executes from the
	// flash window; only their .ramtext stubs and data live in SRAM.
	kern, err := casm(ksrc, 0x20002000, 0x20003000, 0)
	if err != nil {
		t.Fatal(err)
	}
	kernC, err := casm(kcDasm, 0x10260000, 0x2000C000, 0x20004000)
	if err != nil {
		t.Fatal(err)
	}
	sh, err := casm(shDasm, 0x102A0000, 0x2001C000, 0x20018000)
	if err != nil {
		t.Fatal(err)
	}
	idle, err := casm(idleDasm, 0x20024000, 0x20025000, 0)
	if err != nil {
		t.Fatal(err)
	}

	m := emu.NewMachine(v)
	m.TXPace = 13000
	// The flash model always exists: XIP text loads into it (the
	// emulator counterpart of the firmware staging the text blobs).
	// A caller-provided flash additionally carries slot + fat volume.
	persist := flash != nil
	if flash == nil {
		flash = make([]byte, 0x400000)
	}
	if len(flash) < 0x400000 {
		t.Fatalf("flash model too small for the 4 MiB map: %#x", len(flash))
	}
	m.Flash = flash
	entrySh, err := sh.Image.Load(m, nil)
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
		{sh, entrySh, 1, 0, true},
		{idle, entryI, 2, 0, false},
	}, true)
	// The RAM disk: staged from a valid flash slot, else golden.
	disk := buildDisk(t, v)
	const slotXIP = 0x10200000
	if persist {
		off := slotXIP - emu.XIPBase
		h := func(i int) uint32 { return binary.LittleEndian.Uint32(flash[off+4*i:]) }
		if h(0) == 0x32464D44 && h(2) == uint32(len(disk)) { /* 'DMF2' */
			var sum uint32
			img := flash[off+0x1000 : off+0x1000+len(disk)]
			for i := 0; i < len(img); i += 4 {
				sum += binary.LittleEndian.Uint32(img[i:])
			}
			if sum == h(3) {
				disk = append([]byte(nil), img...)
				t.Logf("staged disk from flash slot generation %d", h(1))
			}
		}
		m.Poke32(mustSym(t, kernC, "g_fsslot"), slotXIP)
		m.Poke32(mustSym(t, kernC, "g_fatvol"), 0x10240000)
		// The kernel posts erase/program requests to the ARM-executor
		// mailbox; emulator tests service it via serviceFlashMailbox,
		// playing the parked ARM (kflash.c explains why).
		/* g_kflash_arm stays 0: the machine drives the emulator's QMI
		 * NOR model itself (prompts/028). serviceFlashMailbox remains
		 * for the dormant ARM-executor fallback. */
	}
	const diskBase = 0x20026000
	if diskBase+len(disk) > 0x20040000 {
		t.Fatalf("disk too large: %d", len(disk))
	}
	for i := 0; i < len(disk); i += 4 {
		m.Poke32(uint32(diskBase+i), binary.LittleEndian.Uint32(disk[i:]))
	}
	m.Poke32(mustSym(t, kernC, "g_dma_disk"), diskBase)
	m.Poke32(mustSym(t, kernC, "g_dma_disksize"), uint32(len(disk)))
	// exec arena.
	m.Poke32(mustSym(t, kernC, "g_arena"), 0x20040000)
	m.Poke32(mustSym(t, kernC, "g_arena_end"), 0x2007FE00)
	m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
	m.Poke32(mustSym(t, kernC, "g_initpid"), 2)
	m.Poke32(mustSym(t, kernC, "g_fgpid"), 1)
	m.Poke32(mustSym(t, kernC, "g_k_sysentry"), mustSym(t, kern, "sys_entry"))
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entrySh, Scratch: 0x2007FE00,
	}); err != nil {
		t.Fatal(err)
	}
	return m, kernC
}

// registerVi compiles the BusyBox vi port, stages its blobs into the
// machine's flash model at the same home dmxgen uses, and patches the
// kernel's registry row 0 — the emulator twin of the firmware staging.
func registerVi(t *testing.T, m *emu.Machine, kernC *dmaasm.Result) {
	t.Helper()
	const viHome, viT, viD = 0x102C0000, 0x10000000, 0x10040000
	mod, err := llir.Merge(parseLL(t, "../xv6/ll/vi.ll"), parseLL(t, "../xv6/ll/ulib.ll"),
		parseLL(t, "../xv6/ll/umalloc.ll"), parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{OptSize: true})
	if err != nil {
		t.Fatal(err)
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: m.Variant(), Compact: true, CompactScratch: 0x2007FE00,
		TextBase: viT, DataBase: viD})
	if err != nil {
		t.Fatal(err)
	}
	text := res.Image.Segments[0].Data
	data := res.Image.Segments[1].Data
	off := viHome - 0x10000000
	copy(m.Flash[off:], text)
	dHome := viHome + uint32(len(text))
	copy(m.Flash[off+len(text):], data)
	rHome := dHome + uint32(len(data))
	rp := off + len(text) + len(data)
	for _, r := range res.Image.Relocs {
		w := r.Off & 0x3FFFFFFF
		if r.Seg == 1 {
			w |= 1 << 31
		}
		if r.Ref == 1 {
			w |= 1 << 30
		}
		binary.LittleEndian.PutUint32(m.Flash[rp:], w)
		rp += 4
	}
	row := mustSym(t, kernC, "g_kimages")
	var name [12]byte
	copy(name[:], "vi")
	vals := []uint32{
		binary.LittleEndian.Uint32(name[0:]), binary.LittleEndian.Uint32(name[4:]),
		binary.LittleEndian.Uint32(name[8:]),
		viHome, uint32(len(text)),
		dHome, uint32(len(data)),
		viT, viD,
		rHome, uint32(len(res.Image.Relocs)),
		mustSym(t, res, "warmstart") - viT, mustSym(t, res, "crtthunk") - viT,
		mustSym(t, res, "dispatch") - viD, mustSym(t, res, "irqresume") - viD,
		mustSym(t, res, "lr") - viD,
		mustSym(t, res, "g___dma_sysmail") - viD, mustSym(t, res, "g___dma_syscall_entry") - viD,
	}
	for i, v := range vals {
		m.Poke32(row+uint32(i)*4, v)
	}
}

// TestXv6Vi: the BusyBox vi port end to end — open a new file, insert
// two lines, save with :wq, and read the result back with cat.
func TestXv6Vi(t *testing.T) {
	m, kernC := bootXsh(t)
	registerVi(t, m, kernC)
	m.TXPace = 0 // vi repaints whole screens; pacing just slows the test
	// Run each input burst until the console goes quiet: vi settles
	// into its key-wait loop between bursts, so "no output for a
	// while" is the step boundary.
	settle := func(feed string, budget uint64) {
		m.FeedConsole(feed)
		var spent uint64
		quiet := 0
		last := len(m.ConsoleOut)
		for spent < budget && quiet < 25 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
			if err != nil {
				t.Logf("console tail: %q", tailB(m.ConsoleOut, 300))
				t.Fatal(err)
			}
			spent += rr.Cycles
			if len(m.ConsoleOut) == last {
				quiet++
			} else {
				quiet = 0
				last = len(m.ConsoleOut)
			}
		}
	}
	settle("vi note.txt\r", 600_000_000)
	settle("ihello from vi\nsecond line\x1b", 400_000_000)
	settle(":wq\r", 400_000_000)
	// Only bytes AFTER the cat echo count: vi's own screen echo of the
	// inserted text must not satisfy the check, and the closing prompt
	// proves sh survived vi's exit (a main() that returns instead of
	// exiting halts the whole machine).
	mark := len(m.ConsoleOut)
	settle("cat note.txt\r", 200_000_000)
	out := strings.ReplaceAll(string(m.ConsoleOut[mark:]), "\r", "")
	if !strings.Contains(out, "hello from vi\nsecond line") {
		t.Errorf("cat does not show the written file; tail: %q", tailB(m.ConsoleOut, 400))
	}
	if !strings.HasSuffix(strings.TrimRight(out, " "), "$") {
		t.Errorf("no prompt after the vi session; tail: %q", tailB(m.ConsoleOut, 200))
	}
}

func tailB(b []byte, n int) string {
	if len(b) > n {
		b = b[len(b)-n:]
	}
	return string(b)
}

// TestXv6EchoCtl: control bytes typed while the console is COOKED (a
// command is running, boot output is streaming) must echo as ^X, not
// verbatim — a raw ESC [ A echo would command the user's terminal.
// The queued arrow still reaches the next readline as type-ahead and
// recalls history.
func TestXv6EchoCtl(t *testing.T) {
	m, _ := bootXsh(t)
	// The arrow lands after Enter, in the cooked window while sh runs
	// `echo x`; the second Enter applies the recalled line.
	m.FeedConsole("echo x\r\x1b[A\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 900_000_000}); err != nil {
		t.Fatal(err)
	}
	out := string(m.ConsoleOut)
	if !strings.Contains(out, "^[[A") {
		t.Errorf("cooked echo of ESC[A is not ^[[A; tail %q", tailB(m.ConsoleOut, 200))
	}
	if strings.Contains(out, "\x1b[A") {
		t.Errorf("raw ESC[A leaked to the terminal; tail %q", tailB(m.ConsoleOut, 200))
	}
	if got := strings.Count(strings.ReplaceAll(out, "\r", ""), "\nx\n"); got != 2 {
		t.Errorf("type-ahead history recall: want 'x' twice, got %d; tail %q",
			got, tailB(m.ConsoleOut, 300))
	}
}

// TestXv6Readline: the raw-mode line editor — mid-line arrow edits,
// tab completion against the root directory, and history recall.
func TestXv6Readline(t *testing.T) {
	m, _ := bootXsh(t)
	m.FeedConsole("echo helo\x1b[D\x1b[Dl\r" + // left,left, insert 'l' -> hello
		"cat READ\tw\x1b[D\x1b[3~\r" + // tab -> "cat README ", type w, left, delete w
		"\x1b[A\x1b[A\r") // history up twice -> "echo hello" again
	if _, err := m.Run(emu.RunConfig{MaxCycles: 900_000_000}); err != nil {
		t.Fatal(err)
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	if got := strings.Count(out, "\nhello\n"); got != 2 {
		t.Errorf("want the edited and history-recalled 'hello' twice, got %d", got)
	}
	if !strings.Contains(out, "the DMA machine runs upstream xv6.") {
		t.Errorf("tab-completed cat README missing")
	}
}

// TestXv6Sh: upstream sh on the full fs — ls, cat, output redirection
// (O_CREATE through sysfile's create), and a pipe into wc.
func TestXv6Sh(t *testing.T) {
	m, _ := bootXsh(t)
	m.FeedConsole("ls\rcat README\recho booom > note\rcat note\recho one; echo two\rcat README | wc\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 900_000_000}); err != nil {
		t.Fatal(err)
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{
		"$ ",
		"README",                             // ls lists it
		"the DMA machine runs upstream xv6.", // cat README
		"booom",                              // cat note (redirected write)
		"one\n", "two\n",                     // the ; list still works
		"1 6 35", // wc on README: 1 line, 6 words, 35 bytes
	} {
		if !strings.Contains(out, want) {
			t.Errorf("console missing %q", want)
		}
	}
}
