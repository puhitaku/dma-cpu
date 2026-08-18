// Package boards is the single source of truth for deployable targets,
// U-Boot style: one Board describes the SKU, the machine's RAM
// partition, the flash sections, and the apps to install. dmxgen
// builds firmware images from a Board, and the emulator test harness
// boots the same definitions — so a memory-map change happens in
// exactly one place.
package boards

// Board describes one deployable target.
type Board struct {
	Name string
	SKU  string // emu.Variant name: "rp2350" or "rp2040"

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

	// --- behavior and apps ---
	// MachineFlashExec: the DMA machine drives the flash controller
	// itself for sync (the RP2350 QMI direct-mode driver). Boards
	// without it use the parked ARM's mailbox executor.
	MachineFlashExec bool
	DiskBlocks       int      // fsimg.New size (1 KiB blocks)
	DiskApps         []string // user programs baked into the RAM disk
	ToolboxLinks     []string // multi-call names linked onto toolbox
	Bundles          []string // dmxgen bundles beyond the HIL suite
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

var stdApps = []string{"echo", "cat", "ls", "toolbox"}
var stdLinks = []string{"kill", "spin", "trap", "free", "sync", "mount",
	"umount", "wc", "mkdir", "rm", "gpio", "mux", "blink"}

// Pico2: RP2350, 520 KiB SRAM, 4 MiB flash. The full experience —
// everything including vi and the machine-driven flash executor.
var Pico2 = &Board{
	Name: "pico2",
	SKU:  "rp2350",

	KernText: 0x20002000, KernData: 0x20003000,
	KernCRText: 0x20004000, KernCData: 0x2000C000,
	ShRText: 0x20018000, ShData: 0x2001C000,
	IdleText: 0x20024000, IdleData: 0x20025000,
	DiskHome: 0x20026000, DiskMax: 0x18000, // 96 KiB
	Arena: 0x20040000, ArenaEnd: 0x2007FC00,
	Scratch: 0x2007FE00,

	FlashSize:   0x400000,
	FSSlot:      0x10200000,
	FatVol:      0x10240000,
	KernTextXIP: 0x10260000,
	ShTextXIP:   0x102A0000,
	ViHome:      0x102C0000, ViEnd: 0x10310000,

	MachineFlashExec: true,
	DiskBlocks:       96,
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
	ShRText: 0x20017000, ShData: 0x20019000,
	IdleText: 0x2001D800, IdleData: 0x2001E800,
	DiskHome: 0x2001F800, DiskMax: 0x6000, // 24 KiB: data files only
	Arena: 0x20025800, ArenaEnd: 0x2003FC00, // ~105 KiB
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

// All maps board names to definitions.
var All = map[string]*Board{
	Pico2.Name: Pico2,
	Pico.Name:  Pico,
}

// Default returns the canonical board for a SKU (the -sku flag's
// back-compat mapping).
func Default(sku string) *Board {
	if sku == "rp2040" {
		return Pico
	}
	return Pico2
}
