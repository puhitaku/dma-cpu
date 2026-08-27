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
	// ConsRings, when nonzero, enables console DMA (emu.ConsTxCh and
	// friends): a 1 KiB-aligned block holding the UART RX ring (1 KiB
	// at +0) and TX ring (512 B at +0x400). 16-channel SKUs only.
	ConsRings uint32
	Scratch   uint32 // ARM mailbox page (flash executor at +0x10)

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
	FbHome    uint32 // the (vestigial) pan word
	FbEnd     uint32
	// DTab marks a pure-DMA-scanout board and homes the descriptor
	// program's staged blob (boards.ScanoutTable): two board-pool
	// channels walk it forever, streaming HSTX command words and fb
	// rows into the FIFO with zero CPU involvement. DTabRAM is the
	// SRAM home the program RUNS from (the firmware copies it there at
	// boot); silicon proved twice that the walker's reads cannot
	// tolerate the XIP window. When DTabRAM lies inside the arena,
	// ArenaEnd is clamped down to it.
	DTab    uint32
	DTabRAM uint32

	// --- bare-metal game console (Bundles ["game"]; no xv6) ---
	// One dmacc-compiled image: text executes from flash (XIP), the
	// .ramtext records and data (framebuffer included) live in SRAM.
	GameTextXIP uint32
	GameRAMText uint32
	GameData    uint32

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
	// MachineSDExec: the machine drives the SD card itself (ksd.c,
	// SPI mode over SPI0 with the ch11 drain borrow) instead of the
	// ARM-mailbox executor. SDCSPin is the chip-select GPIO.
	MachineSDExec bool
	SDCSPin       int
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

// SizeApps compile with dmacc's OptSize (outlined comparison sites).
// Exec copies a disk app's text+data whole into the arena, so every
// byte is RAM; the descriptor form pays ~2x per branch, which stays
// off the latency showcases (fbtest) and can't amortize its fixed
// helper cost in the tiny apps (echo/cat/ls measured net-negative).
// sh and the kernels stay fast: their text is XIP flash, so OptSize
// would buy no SRAM there at all.
// (show left the set: profiling its slide renders found the 2x
// descriptor-compare cost running ~1.8M times per slide through the
// shared millicode — the speed tax outgrew the 3K arena win.)
var SizeApps = map[string]bool{"toolbox": true, "hwtools": true}

// XIPApps run pre-relocated on registry (flash-apps) boards: compiled
// XIPText and assembled at their final addresses, text executes in
// place from its flash home and exec claims only [ramtext][data] at
// the arena's first allocation. The simple ON/OFF switch for the
// mechanism vi pioneered — flip a name to true and it stops paying
// text into the arena. All pre-relocated images share the one SRAM
// home, so at most one runs at a time (a second exec fails cleanly);
// disk-file boards and DMX files on the fs ignore the flag — those
// stay load-anywhere by design. vi is always pre-relocated where
// installed (Board.ViHome).
var XIPApps = map[string]bool{}

var fbApps = append(append([]string{}, stdApps...), "fbtest", "show")

// spin/trap (signal demos), wc, and help left the toolbox: help is an
// sh builtin now (it streams /dev/apps) and the rest earned no keep.
var stdLinks = []string{"kill", "free", "sync", "mount",
	"umount", "mkdir", "rm", "clear"}

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
	KernCRText: 0x20004000, KernCData: 0x2000E800, /* +10K: the resident
	// tick/console path (dmacc ResidentFuncs); the data window's slack pays */
	ShRText: 0x20019800, ShData: 0x2001C000,
	IdleText: 0x20024000, IdleData: 0x20025000,
	DiskHome: 0x20026000, DiskMax: 0x6000, // 24 KiB: data only — apps in flash
	Arena: 0x2002C000, ArenaEnd: 0x2007F800, // ~334 KiB
	ConsRings: 0x2007F800, // UART rings fill the gap up to the scratch page
	Scratch:   0x2007FE00,

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

	// KernCData +1 KiB: the shared-runtime host plus the resident-exec
	// path grew ramtext past the old window (the data side has slack).
	KernText: 0x20002000, KernData: 0x20003000,
	KernCRText: 0x20004000, KernCData: 0x2000E800, /* +10K: the resident
	// tick/console path (dmacc ResidentFuncs); the data window's slack pays */
	ShRText: 0x20018800, ShData: 0x2001B000,
	IdleText: 0x2001F800, IdleData: 0x20020800,
	DiskHome: 0x20021800, DiskMax: 0x6000, // 24 KiB: data files only
	Arena: 0x20027800, ArenaEnd: 0x2003FC00, // ~97 KiB
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

	// Repacked tight (measured sizes + ~0x200-0x400 margins): the
	// firmware's staging buffer now borrows the arena, so the family
	// floor (0x20002000) is back; the param.h shim trimmed the fs
	// tables; sh runs RecursionDepth 8. Every byte reclaimed here is
	// arena — the window that decides whether `show` fits beside the
	// scanout table.
	// KernCData moved up 1 KiB for the shared-runtime host: the vector
	// page + force-included bodies grew ramtext to ~31.6K, and the
	// slot-colored data side had the slack to give.
	KernText: 0x20002000, KernData: 0x20002400,
	KernCRText: 0x20002600, KernCData: 0x2000D200, /* ramtext grows +10K: the
	// resident tick/console path (dmacc ResidentFuncs) joins the shared
	// runtime so the idle machine never reads flash while the display
	// scans */
	// Repacked after the flash literal-pool split + const-global
	// rodata (measured: kernel data 32.5K with the profiled hot pool
	// resident, sh data 8.6K all-cold). The arena covers sh's heap
	// (16.6K) + resident vi's [ramtext][data] claim (24.8K) + argv +
	// vi's full 40K heap ask with ~15K to spare.
	ShRText: 0x20015800, ShData: 0x20016A00,
	IdleText: 0x20018E00, IdleData: 0x20019000,
	DiskHome: 0x20019200, DiskMax: 0x2800, // 10 KiB: room for a demo's
	// simultaneous files (a text file + a mount point + slack)
	Arena: 0x2001BA00, ArenaEnd: 0x20030300, // 82.2 KiB up to the table
	ConsRings: 0x20034400, // UART rings; FbBuf follows at 0x20034C00
	Scratch:   0x2007FE00,

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
	// vi returns via pre-relocation: text executes in place from
	// flash, so its arena claim is only [ramtext][data] (~41K) plus
	// a small heap — inside the 66K arena the fb once priced it out
	// of. Section sits above the scanout staging blob (DTab + ~17K).
	ViHome: 0x10560000, ViEnd: 0x105E0000,
	// Apps are flash-resident registry rows (the pico pattern): the
	// toolbox with the slide viewer outgrew any reasonable RAM disk.

	// 300 MHz overclock (the machine IS the bus: clk_sys is machine
	// speed; clk_hstx stays on the repurposed USB PLL, so video
	// timing is untouched). Tick cycles scale via TickCycles().
	ClkSysKHz: 300000,

	// The framebuffer is SRAM. The 036-era "~1000x slower" DMA-window
	// figure was copier contention, not silicon: probed quiet-bus
	// access is wire-speed (~113 ns/word, prompts/041). What still
	// forbids PSRAM here is the render side: sustained machine window
	// traffic puts QSPI transactions on the shared DMA read master
	// and breaks scanout sync. While scanning, QSPI rides the QMI
	// streamer (43.5 MB/s, display-safe) or the ARM — never a machine
	// record — which makes PSRAM a storage tier, not working memory.
	PSRAMBase: 0x15000000, PSRAMSize: 0x800000,
	FbBuf:  0x20034C00,                    // 640x480 = 300 KiB, to 0x2007FC00
	FbHome: 0x2007FC00, FbEnd: 0x2007FE00, // the (vestigial) pan word
	// The scanout descriptor program: staged via flash (DTab) but RUN
	// from SRAM (DTabRAM) — the flash-resident table was tried twice
	// (pre- and post-HP/streamer) and broke the display both times:
	// the walker's own reads must never touch a stallable window. The
	// SRAM home caps the arena (ArenaEnd is clamped to DTabRAM), which
	// currently keeps `show` from fitting — the standing trade recorded
	// in the map below.
	DTab:    0x10540000,
	DTabRAM: 0x20030300, /* table ends 16B shy of the console rings */

	// Flash sync goes through the parked ARM's mailbox executor, NOT
	// the machine's QMI direct-mode driver: that driver leaves XIP in
	// plain-SPI mode, and on silicon the degraded M0 interleaved with
	// the scanout's QPI PSRAM bursts corrupted kernel fetches within
	// a millisecond of resuming the display (prompts/036). The SDK
	// path restores full quad XIP and re-runs the CS1 setup hook.
	MachineFlashExec: false,
	MachineSDExec:    true, /* ksd.c owns the card; ARM keeps only
	 * boot staging, USB and flash-sync */
	SDCSPin: 10, /* D10: the Adalogger FeatherWing CS */
	// RO by default: the HDMI console is the product; persistence is
	// a nice-to-have and stays off until wanted (slides arrive over
	// USB, not the fs). The sync machinery itself remains validated
	// (silicon + TestXv6ShFeather re-arms it in the emulator).
	ReadOnlyFS: true,
	DiskBlocks: 10,
	DiskInodes: 8, /* one inode block; frees data blocks for the
	 * write showcase + the SD mount point */
	DiskApps:     fbApps,
	ToolboxLinks: stdLinks,
	Bundles:      []string{"shell", "syscall", "exec", "xsh"},
}

// GamePico: the original Pi Pico (RP2040) as a bare-metal game
// console — no xv6, both ARM cores asleep after boot. Peripherals:
// a 240x240 ST7789 LCD on SPI0 (write-only 8-pin module: no TE, no
// MISO), two joysticks, two chained WS2811 LEDs (PIO), a MAX98357A
// I2S amp (PIO; SD_MODE strapped high = (L+R)/2, GAIN strapped).
// clk_sys overclocks to 200 MHz for machine headroom; clk_peri moves
// to a repurposed 125 MHz USB PLL (the RP2040 has no peri divider),
// keeping UART in spec and SPI0 at the ST7789's 62.5 MHz ceiling.
var GamePico = &Board{
	Name: "gamepico",
	SKU:  "rp2040",

	GameRAMText: 0x20002000, // self-modifying records + the radiosity
	// shooter's resident hot path (dmxgen ResidentFuncs): 33 KiB window
	GameData:    0x2000A800, // data + the 240x240 RGB565 framebuffer;
	// grows toward the audio ring at 0x20038000 (the drum PCM moved
	// to flash, returning its 40 KiB arena to this segment)
	Scratch:     0x2003FE00,

	FlashSize:   0x200000,
	GameTextXIP: 0x10100000, // upper half: clear of the firmware image

	ClkSysKHz: 250000,
	Bundles:   []string{"game"},
}

// All maps board names to definitions.
var All = map[string]*Board{
	Pico2.Name:    Pico2,
	Pico.Name:     Pico,
	Feather.Name:  Feather,
	GamePico.Name: GamePico,
}

// Default returns the canonical board for a SKU (the -sku flag's
// back-compat mapping).
func Default(sku string) *Board {
	if sku == "rp2040" {
		return Pico
	}
	return Pico2
}
