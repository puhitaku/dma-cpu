// Package boards is the single source of truth for deployable targets,
// U-Boot style: one Board describes the SKU, the machine's RAM
// partition, the flash sections, and the apps to install. dmxgen
// builds firmware images from a Board, and the emulator test harness
// boots the same definitions — so a memory-map change happens in
// exactly one place.
package boards

// Video scanout DMA channels (kfb.c mirrors these): the compact
// machine owns channels 0-10, so the display engine rides the top of
// the RP2350's 16.
const (
	FbChanWalk = 13 // ring walker: control blocks -> executor's alias0
	FbChanExec = 14 // executor: streams to the HSTX FIFO / kicks the copier
	FbChanCopy = 15 // line copier: PSRAM -> SRAM line buffers
)

// Board describes one deployable target.
type Board struct {
	Name      string
	SKU       string // emu.Variant name: "rp2350" or "rp2040"
	PicoBoard string // pico-sdk board name when it differs from Name

	// --- machine RAM partition (absolute addresses) ---
	// The xsh bundle's resident pieces. Kernel and sh text execute
	// from flash (XIP); only their .ramtext stubs and data live here.
	KernText, KernData    uint32 // the dasm dispatcher
	KernCRText, KernCData uint32 // the C kernel's RAM side
	ShRText, ShData       uint32 // sh's RAM side
	IdleText, IdleData    uint32 // the idle proc (RAM-resident)
	DiskHome              uint32 // the RAM disk
	DiskMax               uint32 // its budget (also the fsimg size)
	Arena, ArenaEnd       uint32 // the exec/heap arena
	Scratch               uint32 // compact window-selector word

	// --- flash sections (absolute XIP addresses) ---
	FlashSize   uint32
	FSSlot      uint32 // persistent-fs slot (4 KiB header + disk)
	FatVol      uint32 // golden vfat volume
	KernTextXIP uint32 // fs-kernel text, executed in place
	ShTextXIP   uint32 // sh text, executed in place
	ViHome      uint32 // vi registry blob; 0 = vi not installed
	ViEnd       uint32
	AppsHome    uint32 // user-app registry blobs; 0 = apps live on the
	AppsEnd     uint32 // RAM disk instead (small-RAM boards free ~80 KiB)

	// --- video (0 = the board has no display) ---
	// PSRAM holds the framebuffer; FbHome..FbEnd is the SRAM slice the
	// scanout engine builds its ring, kick table and line buffers in
	// (prompts/036). PSRAMBase is the *uncached* CS1 alias: both the
	// scanout channels and the renderer use it, so there is no cache
	// to keep coherent.
	PSRAMBase uint32
	PSRAMSize uint32
	FbBuf     uint32 // the SRAM framebuffer itself
	FbHome    uint32 // scanout working area (ring, command buffers)
	FbEnd     uint32

	// --- clocking ---
	// ClkSysKHz overclocks the ARM+bus clock at boot (0 = the SDK
	// default). The DMA machine runs on clk_sys, so cycle-domain
	// constants derive from it: TickCycles keeps the scheduler tick
	// at 100 us wall time regardless.
	ClkSysKHz uint32

	// --- behavior and apps ---
	// MachineFlashExec: the DMA machine drives the flash controller
	// itself for sync (the RP2350 QMI direct-mode driver). Boards
	// without it use the parked ARM's mailbox executor.
	MachineFlashExec bool
	// ReadOnlyFS ships the board without persistence: the fs slot is
	// never staged or written (sync returns -1) even though the flash
	// section stays reserved. Demo posture: a sync can then never
	// disturb the display path.
	ReadOnlyFS   bool
	DiskBlocks   int      // fsimg.New size (1 KiB blocks)
	DiskInodes   int      // fsimg.New inodes (0 = the 64 default)
	DiskApps     []string // user programs baked into the RAM disk
	ToolboxLinks []string // multi-call names linked onto toolbox
	Bundles      []string // dmxgen bundles beyond the HIL suite
}

// Inodes is the RAM disk's inode count (16 inodes fit one block;
// the 64 default costs four — real weight on a 10-block disk).
func (b *Board) Inodes() uint32 {
	if b.DiskInodes == 0 {
		return 64
	}
	return uint32(b.DiskInodes)
}

// TickCycles is the scheduler tick period in clk_sys cycles: 100 us
// of wall time at the board's clock (the silicon-calibrated 15000 at
// the 150 MHz default).
func (b *Board) TickCycles() uint32 {
	if b.ClkSysKHz == 0 {
		return 15000
	}
	return b.ClkSysKHz / 10
}

// HasBundle reports whether the board installs the named bundle.
func (b *Board) HasBundle(name string) bool {
	for _, x := range b.Bundles {
		if x == name {
			return true
		}
	}
	return false
}

var stdApps = []string{"echo", "cat", "ls", "toolbox", "hwtools"}
var fbApps = append(append([]string{}, stdApps...), "fbtest", "show")
var stdLinks = []string{"kill", "spin", "trap", "free", "sync", "mount",
	"umount", "wc", "mkdir", "rm", "help"}

// LinksFor returns the multi-call names linked onto the given app
// image (busybox-style argv[0] dispatch): the toolbox carries the
// board's ToolboxLinks; fbtools always carries the fb pair.
func (b *Board) LinksFor(app string) []string {
	switch app {
	case "toolbox":
		return b.ToolboxLinks
	case "hwtools":
		return []string{"gpio", "mux", "blink"}
	}
	return nil
}

// Pico2: RP2350, 520 KiB SRAM, 4 MiB flash. The full experience —
// everything including vi and the machine-driven flash executor.
var Pico2 = &Board{
	Name: "pico2",
	SKU:  "rp2350",

	KernText: 0x20002000, KernData: 0x20003000,
	KernCRText: 0x20004000, KernCData: 0x2000C000,
	ShRText: 0x20019800, ShData: 0x2001C000,
	IdleText: 0x20024000, IdleData: 0x20025000,
	DiskHome: 0x20026000, DiskMax: 0x6000, // 24 KiB: data only — apps in flash
	Arena: 0x2002C000, ArenaEnd: 0x2007FC00, // ~335 KiB
	Scratch: 0x2007FE00,

	FlashSize:   0x400000,
	FSSlot:      0x10200000,
	FatVol:      0x10240000,
	KernTextXIP: 0x10260000,
	ShTextXIP:   0x102A0000,
	ViHome:      0x102C0000, ViEnd: 0x10310000,
	AppsHome: 0x10310000, AppsEnd: 0x10390000,

	MachineFlashExec: true,
	DiskBlocks:       24,
	DiskApps:         stdApps,
	ToolboxLinks:     stdLinks,
	Bundles:          []string{"shell", "syscall", "exec", "xsh"},
}

// Pico: RP2040, 264 KiB SRAM, 2 MiB flash. The same xv6 + GPIO/PIO
// experience, minus vi (no room in the arena) and with flash sync
// through the ARM mailbox executor (the RP2040 SSI has no equivalent
// of the QMI direct-mode trick).
var Pico = &Board{
	Name: "pico",
	SKU:  "rp2040",

	KernText: 0x20002000, KernData: 0x20003000,
	KernCRText: 0x20004000, KernCData: 0x2000B800,
	ShRText: 0x20018800, ShData: 0x2001A800,
	IdleText: 0x2001F000, IdleData: 0x20020000,
	DiskHome: 0x20021000, DiskMax: 0x6000, // 24 KiB: data files only
	Arena: 0x20027000, ArenaEnd: 0x2003FC00, // ~99 KiB
	Scratch: 0x2003FE00,

	FlashSize:   0x200000,
	FSSlot:      0x10100000,
	FatVol:      0x10120000,
	KernTextXIP: 0x10140000,
	ShTextXIP:   0x10180000,
	// no vi: its arena footprint alone exceeds what 264 KiB leaves
	AppsHome: 0x101A0000, AppsEnd: 0x101E0000,

	MachineFlashExec: false,
	DiskBlocks:       24,
	DiskApps:         stdApps,
	ToolboxLinks:     stdLinks,
	Bundles:          []string{"xsh"},
}

// Feather: Adafruit Feather RP2350 with PSRAM — RP2350A, 520 KiB
// SRAM, 8 MiB flash, 8 MiB QSPI PSRAM on QMI CS1 (GPIO8), HSTX pins
// GPIO12-19 on the 22-pin DVI port. The Pico2 experience plus an
// HDMI console: the framebuffer lives at the start of PSRAM and a
// pure-DMA ring scans it out (prompts/036). The scanout working set
// is carved off the top of the arena (32 KiB).
var Feather = &Board{
	Name:      "feather",
	SKU:       "rp2350",
	PicoBoard: "adafruit_feather_rp2350",

	// KernText sits 2 KiB above the family floor: linking the SDK's
	// hardware_psram grows the firmware's .bss past 0x20002000 (the
	// boot check caught the overlap on silicon, prompts/036).
	KernText: 0x20002800, KernData: 0x20003400,
	KernCRText: 0x20004000, KernCData: 0x2000C000,
	// ShRText sits 2 KiB above the pico2 map: the fb kernel's data
	// (LUTs + the 24-row image registry) outgrew the 0xD800 window.
	ShRText: 0x2001A000, ShData: 0x2001C000,
	// 480p squeeze (prompts/039): the disk shrinks to an echo-redirect
	// showcase and the arena to one exec'd app (show, the largest at
	// ~39 KiB, is the one binary a presentation needs) — the freed
	// 126 KiB doubles the framebuffer's rows.
	// idle and the disk tuck into sh-data's slack (sh uses ~17 KiB of
	// its old 32 KiB window); every reclaimed KiB is arena.
	IdleText: 0x20020800, IdleData: 0x20020C00,
	DiskHome: 0x20021000, DiskMax: 0x2800, // 10 KiB: write showcase only
	Arena: 0x20023800, ArenaEnd: 0x20034C00, // 69 KiB
	Scratch: 0x2007FE00,

	// Flash sections sit in the upper 4 MiB: the feather firmware ELF
	// (all bundles + vi + apps + the golden disk) exceeds 2 MiB, so
	// the pico2 map's 0x10200000 slot would sit INSIDE the program —
	// a sync then eats the firmware (and a flash eats the slot).
	FlashSize:   0x800000,
	FSSlot:      0x10400000,
	FatVol:      0x10440000,
	KernTextXIP: 0x10460000,
	ShTextXIP:   0x104A0000,
	AppsHome:    0x104C0000, AppsEnd: 0x10540000,
	// No vi: the SRAM framebuffer shrank the arena below what the
	// editor needs. (A presentation device edits nothing.) Apps are
	// flash-resident registry rows (the pico pattern): the toolbox
	// with the slide viewer outgrew any reasonable RAM disk.

	// 300 MHz overclock (the machine IS the bus: clk_sys is machine
	// speed; clk_hstx stays on the repurposed USB PLL, so video
	// timing is untouched). Tick cycles scale via TickCycles().
	ClkSysKHz: 300000,

	// The framebuffer is SRAM: DMA-master accesses through the QMI
	// PSRAM window cost ~1000x a CPU access on silicon (prompts/036),
	// and this machine IS DMA. 640x240 bytes, scanned double; PSRAM
	// stays for bulk storage the ARM handles (slides over USB).
	PSRAMBase: 0x15000000, PSRAMSize: 0x800000,
	FbBuf:  0x20034C00,                    // 640x480 = 300 KiB, to 0x2007FC00
	FbHome: 0x2007FC00, FbEnd: 0x2007FE00, // the feeder's pan word

	// Flash sync goes through the parked ARM's mailbox executor, NOT
	// the machine's QMI direct-mode driver: that driver leaves XIP in
	// plain-SPI mode, and on silicon the degraded M0 interleaved with
	// the scanout's QPI PSRAM bursts corrupted kernel fetches within
	// a millisecond of resuming the display (prompts/036). The SDK
	// path restores full quad XIP and re-runs the CS1 setup hook.
	MachineFlashExec: false,
	// RO by default: the HDMI console is the product; persistence is
	// a nice-to-have and stays off until wanted (slides arrive over
	// USB, not the fs). The sync machinery itself remains validated
	// (silicon + TestXv6ShFeather re-arms it in the emulator).
	ReadOnlyFS:   true,
	DiskBlocks:   10,
	DiskInodes:   16,
	DiskApps:     fbApps,
	ToolboxLinks: stdLinks,
	Bundles:      []string{"shell", "syscall", "exec", "xsh"},
}

// All maps board names to definitions.
var All = map[string]*Board{
	Pico2.Name:   Pico2,
	Pico.Name:    Pico,
	Feather.Name: Feather,
}

// Default returns the canonical board for a SKU (the -sku flag's
// back-compat mapping).
func Default(sku string) *Board {
	if sku == "rp2040" {
		return Pico
	}
	return Pico2
}
