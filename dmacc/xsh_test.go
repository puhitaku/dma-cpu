package dmacc_test

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"strings"
	"sync"
	"testing"

	"github.com/puhitaku/dma-cpu/boards"
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
	return buildUserScratch(t, v, boards.Pico2.Scratch, name, extra...)
}

func buildUserScratch(t *testing.T, v *emu.Variant, scratch uint32, name string, extra ...string) *dmaasm.Result {
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
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, Compact: true, CompactScratch: scratch,
		TextBase: 0x10000000, DataBase: 0x10040000})
	if err != nil {
		t.Fatal(err)
	}
	return res
}

// buildDisk assembles the user programs as DMX-exec files and packs
// them (plus README) into an xv6 filesystem image.
func buildDisk(t *testing.T, v *emu.Variant) []byte {
	return buildDiskBoard(t, v, boards.Pico2)
}

// buildDiskBoard builds a board's RAM disk. Flash-apps boards get a
// data-only disk; the apps become registry rows (registerFlashApps).
func buildDiskBoard(t *testing.T, v *emu.Variant, bd *boards.Board) []byte {
	t.Helper()
	b := fsimg.New(uint32(bd.DiskBlocks), bd.Inodes())
	b.AddDevice("console", 1, 0)
	b.AddFile("README", []byte("the DMA machine runs upstream xv6.\n"))
	if bd.AppsHome == 0 {
		for _, name := range bd.DiskApps {
			res := buildUserScratch(t, v, bd.Scratch, name)
			blob, err := fsimg.DMXExec(res.Image, res.Symbol)
			if err != nil {
				t.Fatal(err)
			}
			b.AddFile(name, blob)
			for _, l := range bd.LinksFor(name) {
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

// runScript runs the machine until the queued console script has been
// consumed and the shell sits quiet at a prompt, or the cycle budget
// runs out. The budget used to be the ONLY stop: a machine at the
// prompt never idles (UART poll + the idle proc), so a plain Run
// always burned its entire allotment — most of the suite's wall time
// was prompt-polling. Quiescence = no new output for three chunks
// with the prompt as the suffix and the input queue drained.
func runScript(t *testing.T, m *emu.Machine, budget uint64) {
	t.Helper()
	var spent uint64
	quiet := 0
	last := len(m.ConsoleOut)
	for spent < budget {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 4_000_000})
		if err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		spent += rr.Cycles
		if len(m.ConsoleIn) == 0 && len(m.ConsoleOut) == last &&
			bytes.HasSuffix(m.ConsoleOut, []byte("$ ")) {
			quiet++
			if quiet >= 3 {
				return
			}
		} else {
			quiet = 0
		}
		last = len(m.ConsoleOut)
	}
}

// flashMailbox is where emulator tests place the ARM-executor mailbox
// (op, off, src, seq, ack — kflash.c's struct flashreq).
const flashMailbox = 0x2007FE10

// serviceFlashMailbox plays the parked ARM: applies one pending
// erase/program request to the flash slice and acks it. Returns
// whether a request was served.
func serviceFlashMailbox(m *emu.Machine, flash []byte) bool {
	return serviceMailbox(m, flash, nil)
}

// serviceMailbox additionally plays the SD card side of the executor
// (op 4: read sector, op 5: init) against the given card image.
func serviceMailbox(m *emu.Machine, flash, sd []byte) bool {
	return serviceMailboxAt(m, flashMailbox, flash, sd)
}

// serviceMailboxAt is serviceMailbox with the mailbox at an explicit
// address (boards place it at Scratch+0x10; the constant is pico2's).
func serviceMailboxAt(m *emu.Machine, flashMailbox uint32, flash, sd []byte) bool {
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
	case 4: // SD: one 512-byte sector at LBA `off` into machine RAM
		for i := uint32(0); i < 512; i += 4 {
			var w uint32
			for k := uint32(0); k < 4; k++ {
				b := byte(0xFF)
				if p := int(off*512 + i + k); sd != nil && p < len(sd) {
					b = sd[p]
				}
				w |= uint32(b) << (8 * k)
			}
			m.Poke32(src+i, w)
		}
	case 5: // SD: initialize; {status, sectors} at src
		if sd == nil {
			m.Poke32(src, ^uint32(0))
		} else {
			m.Poke32(src, 0)
		}
		m.Poke32(src+4, uint32(len(sd)/512))
	}
	m.Poke32(flashMailbox+16, seq)
	return true
}

// bootXshFlash boots with a QSPI flash model attached. The disk is
// staged from the flash slot when its header is valid (as the ARM
// does at boot), else from the golden image; the kernel gets the slot
// address so SYS_sync can burn it.
func bootXshFlash(t *testing.T, flash []byte) (*emu.Machine, *dmaasm.Result) {
	return bootXshBoard(t, flash, boards.Pico2)
}

// bootXshBoard boots the xsh stack exactly as a board deploys it —
// the RAM partition, flash sections and app placement all come from
// boards/boards.go, the same definitions dmxgen ships.
// goldenBoot caches one BOOTED machine per board (blank-flash shape
// only): the ~14s emulated boot to the first shell prompt is
// identical for every console-script test, so it runs once and each
// test gets an independent Clone. Tests that stage their own flash
// (persistence) still boot fresh.
type goldenBoot struct {
	once  sync.Once
	m     *emu.Machine
	kernC *dmaasm.Result
}

var goldens sync.Map // board name -> *goldenBoot

func bootXshBoard(t *testing.T, flash []byte, bd *boards.Board) (*emu.Machine, *dmaasm.Result) {
	t.Helper()
	if flash == nil {
		gi, _ := goldens.LoadOrStore(bd.Name, &goldenBoot{})
		g := gi.(*goldenBoot)
		g.once.Do(func() {
			m, kernC := buildXshBoard(t, nil, bd)
			// Run to the first "$ " prompt (servicing the ARM mailbox
			// for boards that use the executor during boot).
			for i := 0; i < 600; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 5_000_000}); err != nil {
					t.Fatalf("golden %s boot: %v\nconsole:\n%s", bd.Name, err, m.ConsoleOut)
				}
				for serviceMailboxAt(m, bd.Scratch+0x10, m.Flash, nil) {
				}
				if strings.HasSuffix(string(m.ConsoleOut), "$ ") {
					g.m, g.kernC = m, kernC
					return
				}
			}
			t.Fatalf("golden %s boot: no prompt\nconsole:\n%s", bd.Name, m.ConsoleOut)
		})
		if g.m == nil {
			t.Fatalf("golden %s boot failed in another test", bd.Name)
		}
		return g.m.Clone(), g.kernC
	}
	return buildXshBoard(t, flash, bd)
}

func buildXshBoard(t *testing.T, flash []byte, bd *boards.Board) (*emu.Machine, *dmaasm.Result) {
	t.Helper()
	v, err := emu.VariantByName(bd.SKU)
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
	kcDasm := compileKernelXsh(t, bd.FbBuf != 0)
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
			Variant: v, Compact: true, CompactScratch: bd.Scratch,
			TextBase: text, DataBase: data, RAMTextBase: rtext})
	}
	// XIP layout (prompts/030): kernC and sh text executes from the
	// flash window; only their .ramtext stubs and data live in SRAM.
	kern, err := casm(ksrc, bd.KernText, bd.KernData, 0)
	if err != nil {
		t.Fatal(err)
	}
	kernC, err := casm(kcDasm, bd.KernTextXIP, bd.KernCData, bd.KernCRText)
	if err != nil {
		t.Fatal(err)
	}
	sh, err := casm(shDasm, bd.ShTextXIP, bd.ShData, bd.ShRText)
	if err != nil {
		t.Fatal(err)
	}
	idle, err := casm(idleDasm, bd.IdleText, bd.IdleData, 0)
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
		flash = make([]byte, bd.FlashSize)
	}
	if uint32(len(flash)) < bd.FlashSize {
		t.Fatalf("flash model smaller than the board's part: %#x", len(flash))
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
	// Flash-apps boards: user programs live in flash as registry rows.
	if bd.AppsHome != 0 {
		registerFlashApps(t, m, v, kernC, bd)
	}
	// The RAM disk: staged from a valid flash slot, else golden.
	disk := buildDiskBoard(t, v, bd)
	slotXIP := bd.FSSlot
	if persist {
		off := int(slotXIP - emu.XIPBase)
		h := func(i int) uint32 { return binary.LittleEndian.Uint32(flash[off+4*i:]) }
		var gold uint32
		for i := 0; i+4 <= len(disk); i += 4 {
			gold += binary.LittleEndian.Uint32(disk[i:])
		}
		m.Poke32(mustSym(t, kernC, "g_goldsum"), gold)
		if h(0) == 0x32464D44 && h(2) == uint32(len(disk)) && h(4) == gold { /* 'DMF2' */
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
		if bd.ReadOnlyFS {
			slotXIP = 0 // read-only board: sync disabled, golden disk only
		}
		m.Poke32(mustSym(t, kernC, "g_fsslot"), slotXIP)
		m.Poke32(mustSym(t, kernC, "g_fatvol"), bd.FatVol)
		// The kernel posts erase/program requests to the ARM-executor
		// mailbox; emulator tests service it via serviceFlashMailbox,
		// playing the parked ARM (kflash.c explains why).
		/* g_kflash_arm stays 0: the machine drives the emulator's QMI
		 * NOR model itself (prompts/028). serviceFlashMailbox remains
		 * for the dormant ARM-executor fallback. */
	}
	diskBase := bd.DiskHome
	if diskBase+uint32(len(disk)) > bd.DiskHome+bd.DiskMax {
		t.Fatalf("disk too large: %d", len(disk))
	}
	for i := 0; i < len(disk); i += 4 {
		m.Poke32(diskBase+uint32(i), binary.LittleEndian.Uint32(disk[i:]))
	}
	m.Poke32(mustSym(t, kernC, "g_dma_disk"), diskBase)
	m.Poke32(mustSym(t, kernC, "g_dma_disksize"), uint32(len(disk)))
	// exec arena.
	m.Poke32(mustSym(t, kernC, "g_arena"), bd.Arena)
	m.Poke32(mustSym(t, kernC, "g_arena_end"), bd.ArenaEnd)
	m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
	m.Poke32(mustSym(t, kernC, "g_initpid"), 2)
	m.Poke32(mustSym(t, kernC, "g_fgpid"), 1)
	m.Poke32(mustSym(t, kernC, "g_k_sysentry"), mustSym(t, kern, "sys_entry"))
	// GPIO / PIO driver bases (kgpio.c), SKU-resolved like g_fatvol.
	m.Poke32(mustSym(t, kernC, "g_iobank0"), v.IOBank0Base)
	m.Poke32(mustSym(t, kernC, "g_padsbank0"), v.PadsBank0Base)
	m.Poke32(mustSym(t, kernC, "g_pio0base"), v.PIO0Base)
	m.Poke32(mustSym(t, kernC, "g_gpiopins"), uint32(v.GPIOPins))
	m.Poke32(mustSym(t, kernC, "g_gpio_hi"), v.GPIOOutCtrl(true))
	m.Poke32(mustSym(t, kernC, "g_gpio_lo"), v.GPIOOutCtrl(false))
	m.Poke32(mustSym(t, kernC, "g_dmacpy_ctrl"), v.KDMACopyCtrl())
	if !bd.MachineFlashExec {
		/* Boards without the QMI machine executor use the parked
		 * ARM's mailbox for flash sync AND SD reads — the executor
		 * exists regardless of persistence (serviceMailbox plays it). */
		m.Poke32(mustSym(t, kernC, "g_kflash_arm"), bd.Scratch+0x10)
	}
	// HDMI framebuffer (kfb.c, prompts/036): framebuffer boards get
	// the fb globals (and a PSRAM model for the storage side);
	// g_fb_base stays 0 elsewhere.
	if bd.FbBuf != 0 {
		if bd.PSRAMSize != 0 {
			m.PSRAM = make([]byte, bd.PSRAMSize)
		}
		m.Poke32(mustSym(t, kernC, "g_fb_base"), bd.FbBuf)
		m.Poke32(mustSym(t, kernC, "g_fb_ctl"), bd.FbHome)
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entrySh, Scratch: bd.Scratch,
	}); err != nil {
		t.Fatal(err)
	}
	return m, kernC
}

// registerRow patches one kimages registry row (the emulator twin of
// dmxgen's patchRow) for a flash-resident image.
func registerRow(t *testing.T, m *emu.Machine, kernC *dmaasm.Result, idx int,
	name string, res *dmaasm.Result, tHome, tLen, dHome, dLen, rHome, nrel uint32) {
	t.Helper()
	const iT, iD = 0x10000000, 0x10040000
	row := mustSym(t, kernC, "g_kimages") + uint32(idx)*72
	var nb [12]byte
	copy(nb[:], name)
	vals := []uint32{
		binary.LittleEndian.Uint32(nb[0:]), binary.LittleEndian.Uint32(nb[4:]),
		binary.LittleEndian.Uint32(nb[8:]),
		tHome, tLen, dHome, dLen, iT, iD, rHome, nrel,
		mustSym(t, res, "warmstart") - iT, mustSym(t, res, "crtthunk") - iT,
		mustSym(t, res, "dispatch") - iD, mustSym(t, res, "irqresume") - iD,
		mustSym(t, res, "lr") - iD,
		mustSym(t, res, "g___dma_sysmail") - iD, mustSym(t, res, "g___dma_syscall_entry") - iD,
	}
	for i, v := range vals {
		m.Poke32(row+uint32(i)*4, v)
	}
}

// stageFlashImage writes text+data+packed relocs at home in the flash
// model and returns (dHome, rHome, end).
func stageFlashImage(m *emu.Machine, res *dmaasm.Result, home uint32) (uint32, uint32, uint32) {
	text := res.Image.Segments[0].Data
	data := res.Image.Segments[1].Data
	off := home - 0x10000000
	copy(m.Flash[off:], text)
	dHome := home + uint32(len(text))
	copy(m.Flash[off+uint32(len(text)):], data)
	rHome := dHome + uint32(len(data))
	rp := off + uint32(len(text)) + uint32(len(data))
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
	return dHome, rHome, 0x10000000 + rp
}

// registerFlashApps: the flash-apps boards' user programs as registry
// rows (toolbox's multi-call aliases share its blob).
func registerFlashApps(t *testing.T, m *emu.Machine, v *emu.Variant,
	kernC *dmaasm.Result, bd *boards.Board) {
	t.Helper()
	cursor := bd.AppsHome
	idx := 0 /* vi tests claim the first free row afterwards */
	for _, name := range bd.DiskApps {
		res := buildUserScratch(t, v, bd.Scratch, name)
		text, data := res.Image.Segments[0].Data, res.Image.Segments[1].Data
		dHome, rHome, end := stageFlashImage(m, res, cursor)
		names := append([]string{name}, bd.LinksFor(name)...)
		for _, n := range names {
			registerRow(t, m, kernC, idx, n, res, cursor, uint32(len(text)),
				dHome, uint32(len(data)), rHome, uint32(len(res.Image.Relocs)))
			idx++
		}
		cursor = end
	}
	if cursor > bd.AppsEnd {
		t.Fatalf("apps overflow the flash budget: %#x > %#x", cursor, bd.AppsEnd)
	}
}

// registerVi compiles the BusyBox vi port, stages its blobs into the
// machine's flash model at the same home dmxgen uses, and patches the
// kernel's registry row 0 — the emulator twin of the firmware staging.
func registerVi(t *testing.T, m *emu.Machine, kernC *dmaasm.Result) {
	t.Helper()
	bd := boards.Pico2
	mod, err := llir.Merge(parseLL(t, "../xv6/ll/vi.ll"), parseLL(t, "../xv6/ll/ulib.ll"),
		parseLL(t, "../xv6/ll/umalloc.ll"), parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: m.Variant(), Compact: true, CompactScratch: bd.Scratch,
		TextBase: 0x10000000, DataBase: 0x10040000})
	if err != nil {
		t.Fatal(err)
	}
	text, data := res.Image.Segments[0].Data, res.Image.Segments[1].Data
	dHome, rHome, _ := stageFlashImage(m, res, bd.ViHome)
	// Claim the first free registry row (flash apps filled the front).
	base := mustSym(t, kernC, "g_kimages")
	idx := 0
	for ; idx < 20; idx++ {
		if m.Peek32(base+uint32(idx)*72)&0xFF == 0 {
			break
		}
	}
	registerRow(t, m, kernC, idx, "vi", res, bd.ViHome, uint32(len(text)),
		dHome, uint32(len(data)), rHome, uint32(len(res.Image.Relocs)))
}

// TestXv6Vi: the BusyBox vi port end to end — open a new file, insert
// two lines, save with :wq, and read the result back with cat.
func TestXv6Vi(t *testing.T) {
	t.Parallel()
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
	// "jjx" rides along with the command: it lands while vi is still
	// exec-loading, i.e. in the COOKED window without a newline. The
	// raw switch must commit it (kproc SYS_ttyraw), and vi must
	// consume it as ordinary type-ahead (two harmless j's, one x on an
	// empty buffer) — the user-reported "i needs Enter" bug.
	settle("vi note.txt\rjjx", 600_000_000)
	// Flash-resident exec loads vi with a long silent stretch, so the
	// quiet heuristic can return before vi runs: wait for the
	// alternate-screen switch before probing raw mode.
	for spent := uint64(0); spent < 1_000_000_000 &&
		!strings.Contains(string(m.ConsoleOut), "\x1b[?1049h"); {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
		if err != nil {
			t.Fatal(err)
		}
		spent += rr.Cycles
	}
	// A lone ESC after startup must be handled by vi in raw mode, not
	// cooked-echoed as ^[ — the discriminating check for SYS_ttyraw
	// actually engaging.
	rawMark := len(m.ConsoleOut)
	settle("\x1b", 100_000_000)
	if strings.Contains(string(m.ConsoleOut[rawMark:]), "^[") {
		t.Fatalf("ESC cooked-echoed inside vi: raw mode not engaged; got %q",
			string(m.ConsoleOut[rawMark:]))
	}
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

// TestXv6ShPico: the whole xv6 stack booted exactly as the Pico
// (RP2040) board deploys it — 264 KiB SRAM, XIP kernel and sh text,
// flash-resident apps behind registry rows, the ARM-mailbox flash
// executor, and the 2 MiB flash map. One board definition drives
// both this boot and dmxgen's shipped image.
func TestXv6ShPico(t *testing.T) {
	t.Parallel()
	m, _ := bootXshBoard(t, nil, boards.Pico)
	m.FeedConsole("ls\rcat README\recho pico > note\rcat note\r" +
		"cat README | wc\rgpio write 5 1\rgpio read 5\rls /dev\rhelp\rfree\r")
	runScript(t, m, 1_500_000_000)
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{
		"the DMA machine runs upstream xv6.", // cat via a flash registry row
		"\npico\n",                           // redirection onto the RAM disk
		"1 6 35",                             // pipe into wc (also flash-resident)
		"\n1\n",                              // gpio loopback on the rp2040 variant
		"fat0",                               // devfs
		"builtin: cd",                        // help header
		"blink",                              // help lists the registry
		"arena: total",                       // free
	} {
		if !strings.Contains(out, want) {
			t.Errorf("pico session missing %q", want)
		}
	}
}

// TestXv6ShFeather boots the Feather board: the PSRAM-backed
// framebuffer comes up (boot line + /dev/fb0), the console still
// works, and fbtest exercises the SYS_fb API end to end (acquire,
// user writes straight into the PSRAM window, verify, release).
func TestXv6ShFeather(t *testing.T) {
	t.Parallel()
	// A blank flash part: persistence is live, so `sync` runs the
	// machine's QMI direct-mode session with the scanout enabled —
	// the kfb_pause/resume bracket is on the path (prompts/036).
	flash := make([]byte, boards.Feather.FlashSize)
	for i := range flash {
		flash[i] = 0xFF
	}
	m, kernC := bootXshBoard(t, flash, boards.Feather)
	// The shipped feather is read-only (ReadOnlyFS); re-arm the slot
	// here so the ARM-mailbox sync machinery — pause/park the scanout,
	// flash ops, XIP restore, resume — keeps emulator coverage.
	m.Poke32(mustSym(t, kernC, "g_fsslot"), boards.Feather.FSSlot)
	m.FeedConsole("ls /dev\rcat /dev/fb0\rfbtest\rcat /dev/fb0\r" +
		"echo persists > note\rsync\rcat note\recho done\r")
	// Chunked run: the feather syncs through the ARM-executor mailbox
	// (boards.Feather.MachineFlashExec is false), which the test plays.
	for used := uint64(0); used < 2_500_000_000; used += 500_000 {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 500_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		for serviceFlashMailbox(m, flash) {
		}
		if strings.Contains(strings.ReplaceAll(string(m.ConsoleOut), "\r", ""), "\ndone\n") {
			break
		}
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{
		"fb: 640x480x8 on",  // kfb_init on the boot path
		"fb0",               // devfs node
		"640x480x8 owner=0", // fb0 text after release
		"fb ok 640x480x8",   // fbtest acquired, wrote, verified
		"\npersists\n",      // written, synced, read back
		"\ndone\n",          // still alive after pause/resume
	} {
		if !strings.Contains(out, want) {
			t.Errorf("feather session missing %q", want)
		}
	}
}

// TestXv6Fbcon checks the rendered pixels, not the UART echo: after
// `echo zqzq`, the framebuffer must contain the cell sequence
// z,q,z,q (identical 64-byte glyph cells at positions 0 and 2, a
// different one at 1) at least twice — the typed echo and the output
// line. Then enough output to scroll: the kick table's READ column
// must rotate away from the framebuffer base (the pan IS the scroll),
// and rendering must still work.
func TestXv6Fbcon(t *testing.T) {
	t.Parallel()
	m, _ := bootXshBoard(t, nil, boards.Feather)
	m.FeedConsole("echo zqzq\r")
	runScript(t, m, 900_000_000)
	fbBuf := boards.Feather.FbBuf
	cell := func(r, c int) []byte {
		var b []byte
		for y := 0; y < 8; y++ {
			off := uint32((r*8+y)*640 + c*8)
			for k := uint32(0); k < 8; k += 4 {
				w := m.Peek32(fbBuf + off + k)
				b = append(b, byte(w), byte(w>>8), byte(w>>16), byte(w>>24))
			}
		}
		return b
	}
	blank := make([]byte, 64)
	countZQZQ := func() int {
		n := 0
		for r := 0; r < 30; r++ {
			for c := 0; c+3 < 80; c++ {
				z, q := cell(r, c), cell(r, c+1)
				if bytes.Equal(z, blank) || bytes.Equal(z, q) {
					continue
				}
				if bytes.Equal(z, cell(r, c+2)) && bytes.Equal(q, cell(r, c+3)) {
					n++
					c += 3
				}
			}
		}
		return n
	}
	if got := countZQZQ(); got < 2 {
		t.Errorf("want >=2 rendered zqzq cell runs (echo + output), got %d", got)
	}
	// Scroll: twelve /dev listings overflow the 30-row screen.
	panWord := boards.Feather.FbHome // the feeder's pan control word
	if got := m.Peek32(panWord); got != 0 {
		t.Fatalf("pan should be 0 before scrolling, got %#x", got)
	}
	var lots strings.Builder
	for i := 0; i < 12; i++ {
		lots.WriteString("ls /dev\r")
	}
	m.FeedConsole(lots.String() + "echo zqzq\r")
	runScript(t, m, 2_500_000_000)
	if got := m.Peek32(panWord); got == 0 {
		t.Errorf("the pan word did not advance: scroll is not panning")
	}
	if got := countZQZQ(); got < 1 {
		t.Errorf("no rendered zqzq after scrolling")
	}
}

// TestXv6SD mounts a vfat SD card end to end: the kernel's fat
// driver reads the card sector-by-sector through the ARM-executor
// mailbox (played by serviceMailbox), for both a superfloppy card
// (BPB at sector 0) and an MBR-partitioned one. Then the slide
// viewer: `show /sd` loads .sld files straight into the framebuffer,
// navigates on a console key, and quits on 'q' — fb content is
// asserted against the card's bytes.
func TestXv6SD(t *testing.T) {
	t.Parallel()
	slideA := make([]byte, 4096)
	slideB := make([]byte, 4096)
	for i := range slideA {
		slideA[i] = byte(i*7 + 3)
		slideB[i] = byte(i*13 + 5)
	}
	// A two-series deck (SLDK container) with SMALL 4096-byte slides:
	// the bytes-per-slide header field must be honored, not assumed.
	// Series 169 carries the slides in reverse so selection is provable.
	deck := append([]byte(nil), "SLDK"...)
	le := func(v uint32) []byte {
		var w [4]byte
		binary.LittleEndian.PutUint32(w[:], v)
		return w[:]
	}
	deck = append(deck, le(1)...)
	deck = append(deck, le(2)...)
	deck = append(deck, le(4096)...)
	base := uint32(16 + 24*2)
	for i, name := range []string{"43", "169"} {
		var nm [12]byte
		copy(nm[:], name)
		deck = append(deck, nm[:]...)
		deck = append(deck, le(2)...)
		deck = append(deck, le(base+uint32(i)*2*4096)...)
		deck = append(deck, le(0)...)
	}
	deck = append(deck, slideA...) // series 43: A, B
	deck = append(deck, slideB...)
	deck = append(deck, slideB...) // series 169: B, A
	deck = append(deck, slideA...)

	fatb := fsimg.NewFAT32(2048)
	fatb.AddFile("DECK.SLDK", deck)
	fatb.AddFile("HELLO.TXT", []byte("hello from the sd card\n"))
	// macOS AppleDouble dropping: matches *.sld and sorts before A —
	// the viewer must skip dotfiles or the deck opens with garbage.
	fatb.AddFile("._A.SLD", bytes.Repeat([]byte{0xEE}, 512))
	fatb.AddFile("A.SLD", slideA)
	fatb.AddFile("B.SLD", slideB)
	vol := fatb.Bytes()

	run := func(name string, sd []byte) {
		t.Run(name, func(t *testing.T) {
			m, kernC := bootXshBoard(t, nil, boards.Feather)
			_ = kernC
			// Joystick pins idle high (self-pulled-up): drive the
			// emulator's loopback levels so the viewer sees releases.
			v := m.Variant()
			for _, pin := range []int{24, 26, 27, 28, 29} {
				m.Poke32(v.GPIOCtrlAddr(pin), v.GPIOOutCtrl(true))
			}
			// The two variants exercise the two mount spellings: the
			// bare device with an absolute target, and the /dev path
			// with a relative target (cwd is /).
			mnt := "mount sd0 /sd\r"
			if name == "superfloppy" {
				mnt = "mount /dev/sd0 sd\r"
			}
			feed := "mkdir /sd\r" + mnt + "ls /dev\rls /sd\r" +
				"cat /sd/HELLO.TXT\rmount\rshow /sd\r"
			m.FeedConsole(feed)
			fbBuf := boards.Feather.FbBuf
			// The dynamic input script: page the slide show, quit it,
			// then re-run the viewer on /dev/sd0 as a raw-read probe.
			fed2, fedQ, fed3, fed4 := false, false, false, false
			fed5, fed6, fed7 := false, false, false
			deadline := uint64(3_000_000_000)
			for used := uint64(0); used < deadline; used += 200_000 {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
					t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
				}
				for serviceMailbox(m, m.Flash, sd) {
				}
				out := string(m.ConsoleOut)
				if !fed2 && strings.Contains(out, "show /sd") &&
					strings.Contains(out, "hello from the sd card") {
					// Give the viewer time to load slide A, check the
					// fb, page to B, check, then quit.
					ok := true
					for i := 0; i < 4096; i += 4 {
						if m.Peek32(fbBuf+uint32(i)) == 0 {
							ok = false
							break
						}
					}
					if ok { // slide A landed
						got := m.Peek32(fbBuf)
						want := uint32(slideA[0]) | uint32(slideA[1])<<8 |
							uint32(slideA[2])<<16 | uint32(slideA[3])<<24
						if got != want {
							t.Fatalf("fb: got %#x want %#x (slide A)", got, want)
						}
						m.FeedConsole("n")
						fed2 = true
					}
				}
				if fed2 && !fedQ {
					got := m.Peek32(fbBuf)
					wantB := uint32(slideB[0]) | uint32(slideB[1])<<8 |
						uint32(slideB[2])<<16 | uint32(slideB[3])<<24
					if got == wantB {
						m.FeedConsole("q")
						fedQ = true
					}
				}
				if fedQ && !fed3 && strings.HasSuffix(out, "$ ") {
					m.FeedConsole("show /dev/sd0\r")
					fed3 = true
				}
				if fed3 && !fed4 {
					// The card's first sector, byte-exact in the fb.
					w0 := binary.LittleEndian.Uint32(sd[0:])
					w508 := binary.LittleEndian.Uint32(sd[508:])
					if m.Peek32(fbBuf) == w0 && m.Peek32(fbBuf+508) == w508 {
						m.FeedConsole("q")
						fed4 = true
					}
				}
				// Deck phase: select series 169 (slides reversed: B then
				// A) and page through it via seek().
				if fed4 && !fed5 && strings.HasSuffix(out, "$ ") {
					m.FeedConsole("show /sd/deck.sldk 169\r")
					fed5 = true
				}
				wantA := binary.LittleEndian.Uint32(slideA[0:])
				wantB := binary.LittleEndian.Uint32(slideB[0:])
				if fed5 && !fed6 && m.Peek32(fbBuf) == wantB {
					m.FeedConsole("n")
					fed6 = true
				}
				if fed6 && !fed7 && m.Peek32(fbBuf) == wantA {
					m.FeedConsole("q")
					fed7 = true
				}
				if fed7 && strings.HasSuffix(string(m.ConsoleOut), "$ ") &&
					strings.Contains(string(m.ConsoleOut), "sd0 on /sd") {
					break
				}
			}
			out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
			t.Logf("console:\n%s", out)
			for _, want := range []string{
				"hello from the sd card", // cat through the sector cache
				"a.sld",                  // ls (lowercased 8.3)
				"sd0 on /sd type vfat (ro)",
				"2 slides found", // the viewer's log (dotfile skipped)
				"Opened /sd/a.sld",
				"Done drawing /sd/b.sld",
				"UART: right", // the fed "n"
				"UART: quit",
				"Opened /dev/sd0", // the raw-read probe
			} {
				if !strings.Contains(out, want) {
					t.Errorf("missing %q", want)
				}
			}
			// ls /dev after the mount: sd0 with the card's capacity.
			sdline := ""
			for _, ln := range strings.Split(out, "\n") {
				// skip the mount listing's "sd0 on /sd ..." row
				if strings.HasPrefix(ln, "sd0 ") && !strings.Contains(ln, " on ") {
					sdline = ln
				}
			}
			if !strings.Contains(sdline, fmt.Sprint(len(sd))) {
				t.Errorf("ls /dev sd0 row %q lacks capacity %d", sdline, len(sd))
			}
			if !fed2 {
				t.Errorf("the viewer never displayed slide A")
			}
			if !fed7 {
				t.Errorf("deck series 169 never paged (fed5=%v fed6=%v)", fed5, fed6)
			}
			for _, want := range []string{
				"2 slides found (series 169)",
				"Start drawing slide 2 on FB",
				"Done drawing slide 2",
			} {
				if !strings.Contains(out, want) {
					t.Errorf("deck log missing %q", want)
				}
			}
			if !fed4 {
				t.Errorf("show /dev/sd0 never landed the raw sector in the fb: "+
					"fb[0]=%#x want %#x, fb[508]=%#x want %#x (fed3=%v)",
					m.Peek32(fbBuf), binary.LittleEndian.Uint32(sd[0:]),
					m.Peek32(fbBuf+508), binary.LittleEndian.Uint32(sd[508:]), fed3)
			}
		})
	}
	run("superfloppy", vol)
	// MBR-partitioned: partition 0 (type 0x0C) at LBA 64.
	mbr := make([]byte, 64*512)
	pe := 446
	mbr[pe+4] = 0x0C
	binary.LittleEndian.PutUint32(mbr[pe+8:], 64)
	binary.LittleEndian.PutUint32(mbr[pe+12:], uint32(len(vol)/512))
	mbr[510] = 0x55
	mbr[511] = 0xAA
	run("mbr", append(mbr, vol...))
}

// TestXv6GpioMux: the gpio/mux commands drive IO_BANK0 through the
// kernel API — the emulator records OUTOVER events and loops the
// driven level back through GPIOx_STATUS, so `gpio read` verifies
// `gpio write` end to end.
func TestXv6GpioMux(t *testing.T) {
	t.Parallel()
	m, _ := bootXsh(t)
	v := m.Variant()
	m.FeedConsole("gpio write 5 1\rgpio read 5\rgpio write 5 0\rgpio read 5\r" +
		"mux 3 pio0\rgpio read 99\recho done\r")
	runScript(t, m, 900_000_000)
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	if !strings.Contains(out, "\n1\n") || !strings.Contains(out, "\n0\n") {
		t.Errorf("gpio read loopback missing; console %q", out)
	}
	if !strings.Contains(out, "gpio: bad pin") {
		t.Errorf("pin bound check missing")
	}
	var hi, lo bool
	for _, e := range m.GPIOEvents {
		if e.Pin == 5 && e.High {
			hi = true
		}
		if e.Pin == 5 && !e.High {
			lo = true
		}
	}
	if !hi || !lo {
		t.Errorf("OUTOVER events for pin 5: hi=%v lo=%v", hi, lo)
	}
	if got := m.Peek32(v.IOBank0Base+8*3+4) & 0x1F; got != 6 {
		t.Errorf("mux 3 pio0: FUNCSEL = %d, want 6", got)
	}
	if !strings.Contains(out, "\ndone\n") {
		t.Errorf("session did not finish")
	}
}

// TestXv6Blink: both blink modes. GPIO mode is a soft loop the fg
// SIGINT stops (LED left low); PIO mode loads the program, starts SM0
// asynchronously, survives the program exiting, and `blink stop`
// gates it off.
func TestXv6Blink(t *testing.T) {
	t.Parallel()
	m, _ := bootXsh(t)
	v := m.Variant()
	m.FeedConsole("blink gpio 7\r")
	// A few 300-tick half-periods (4.5M cycles each): run until the
	// pin has visibly blinked instead of burning a fixed budget.
	for spent := uint64(0); spent < 250_000_000; {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 4_000_000})
		if err != nil {
			t.Fatal(err)
		}
		spent += rr.Cycles
		n := 0
		for _, e := range m.GPIOEvents {
			if e.Pin == 7 {
				n++
			}
		}
		if n >= 6 {
			break
		}
	}
	m.FeedConsole("\x03") // Ctrl-C stops the soft loop
	runScript(t, m, 200_000_000)
	var toggles int
	last := -1
	for _, e := range m.GPIOEvents {
		if e.Pin != 7 {
			continue
		}
		lv := 0
		if e.High {
			lv = 1
		}
		if lv != last {
			toggles++
			last = lv
		}
	}
	if toggles < 3 {
		t.Errorf("soft blink: %d level changes on pin 7, want >= 3", toggles)
	}
	if last != 0 {
		t.Errorf("SIGINT handler must leave the LED low")
	}

	m.FeedConsole("blink pio 8\recho ok\r")
	runScript(t, m, 400_000_000)
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	if !strings.Contains(out, "\nok\n") {
		t.Fatalf("blink pio did not return to the prompt (async start)")
	}
	prog := []uint32{0xE081, 0xE03F, 0xFF01, 0x0042, 0xE03F, 0xFF00, 0x0045, 0x0001}
	for i, want := range prog {
		if got := m.Peek32(v.PIO0Base + 0x48 + uint32(i)*4); got != want {
			t.Errorf("INSTR_MEM[%d] = %#x, want %#x", i, got, want)
		}
	}
	if m.Peek32(v.PIO0Base)&1 == 0 {
		t.Errorf("SM0 not enabled after blink pio")
	}
	if got := m.Peek32(v.IOBank0Base+8*8+4) & 0x1F; got != 6 {
		t.Errorf("pin 8 FUNCSEL = %d, want pio0(6)", got)
	}
	m.FeedConsole("blink stop 8\recho fin\r")
	runScript(t, m, 400_000_000)
	if m.Peek32(v.PIO0Base)&1 != 0 {
		t.Errorf("SM0 still enabled after blink stop")
	}
}

// TestXv6Devfs: /dev lists the machine's resources as files; the gpio
// file reflects pad state; the mount table names devfs.
func TestXv6Devfs(t *testing.T) {
	t.Parallel()
	m, _ := bootXsh(t)
	m.FeedConsole("ls /dev\rgpio write 5 1\rcat /dev/gpio\rcat /dev/pio0\rmount\recho done\r")
	runScript(t, m, 1_200_000_000)
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	for _, want := range []string{"console", "fat0", "gpio", "pio0", "pio1", "pio2",
		"05=1", "sm_enable=0x0", "devfs on /dev type devfs (ro)", "\ndone\n"} {
		if !strings.Contains(out, want) {
			t.Errorf("devfs session missing %q", want)
		}
	}
}

// TestXv6EchoCtl: control bytes typed while the console is COOKED (a
// command is running, boot output is streaming) must echo as ^X, not
// verbatim — a raw ESC [ A echo would command the user's terminal.
// The queued arrow still reaches the next readline as type-ahead and
// recalls history.
func TestXv6EchoCtl(t *testing.T) {
	t.Parallel()
	// A fresh (unbooted) machine on purpose: this test's whole premise
	// is type-ahead landing in the cooked window, and that timing only
	// exists when the input is queued before boot — the golden-clone
	// path starts at the prompt and would hand the arrow to the line
	// editor instead.
	m, _ := buildXshBoard(t, nil, boards.Pico2)
	// The arrow lands after Enter, in the cooked window while sh runs
	// `echo x`; the second Enter applies the recalled line.
	m.FeedConsole("echo x\r\x1b[A\r")
	runScript(t, m, 900_000_000)
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

// TestXv6ViNoArg: `vi` without a filename must open an unnamed empty
// buffer — not stat address 0 and complain "'(null)' is not a regular
// file" (xv6's open(NULL) walks address 0 instead of faulting).
func TestXv6ViNoArg(t *testing.T) {
	t.Parallel()
	m, kernC := bootXsh(t)
	registerVi(t, m, kernC)
	m.TXPace = 0
	settle := func(feed string, budget uint64) {
		m.FeedConsole(feed)
		var spent uint64
		quiet := 0
		last := len(m.ConsoleOut)
		for spent < budget && quiet < 25 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
			if err != nil {
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
	settle("vi\r", 600_000_000)
	if strings.Contains(string(m.ConsoleOut), "(null)") {
		t.Fatalf("no-arg vi stats NULL; tail %q", tailB(m.ConsoleOut, 300))
	}
	settle("inoname buffer\x1b", 400_000_000)
	settle(":w noname.txt\r", 400_000_000)
	settle(":q\r", 300_000_000)
	mark := len(m.ConsoleOut)
	settle("cat noname.txt\r", 200_000_000)
	out := strings.ReplaceAll(string(m.ConsoleOut[mark:]), "\r", "")
	if !strings.Contains(out, "noname buffer") {
		t.Errorf(":w from the unnamed buffer failed; tail %q", tailB(m.ConsoleOut, 300))
	}
}

// TestXv6Readline: the raw-mode line editor — mid-line arrow edits,
// tab completion against the root directory, and history recall.
//
// The first phase deliberately sends NO trailing newline: raw mode
// must deliver and interpret keys immediately. A cooked console would
// (a) echo the arrow as ^[[D (ECHOCTL) and (b) hold every byte until
// Enter — the regression that shipped when SYS_ttyraw read the wrong
// mailbox slot and readline only appeared to work via type-ahead.
func TestXv6Readline(t *testing.T) {
	t.Parallel()
	m, _ := bootXsh(t) // the golden clone is already at the prompt
	mark := len(m.ConsoleOut)
	m.FeedConsole("echo helo\x1b[D\x1b[Dl") // no newline!
	if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000_000}); err != nil {
		t.Fatal(err)
	}
	live := string(m.ConsoleOut[mark:])
	if strings.Contains(live, "^[[D") {
		t.Fatalf("arrow echoed as ^[[D: raw mode is not engaged; got %q", live)
	}
	if !strings.Contains(live, "hello") {
		t.Fatalf("mid-line insert not visible before Enter (line-buffered?); got %q", live)
	}
	m.FeedConsole("\r" +
		"cat READ\tw\x1b[D\x1b[3~\r" + // tab -> "cat README ", type w, left, delete w
		"\x1b[A\x1b[A\r") // history up twice -> "echo hello" again
	runScript(t, m, 900_000_000)
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
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
	t.Parallel()
	m, _ := bootXsh(t)
	m.FeedConsole("ls\rcat README\recho booom > note\rcat note\recho one; echo two\rcat README | wc\r")
	runScript(t, m, 900_000_000)
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
