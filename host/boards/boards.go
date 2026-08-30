// Package boards is the single source of truth for deployable targets,
// U-Boot style: one Board describes the SKU, the machine's RAM
// partition, the flash sections, and the apps to install. dmxgen
// builds firmware images from a Board, and the emulator test harness
// boots the same definitions — so a memory-map change happens in
// exactly one place.
package boards

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

	// --- dead ARM SRAM: {base, length}, RUNTIME-CLAIM ONLY ---
	// On the boards whose core 0 PSM-halts itself the moment dmx_start
	// returns, the firmware's own RAM — .data, .bss, the heap, and on
	// the RP2040 the boot stack too — is linked into the SCRATCH banks
	// at the top of SRAM (target/firmware/CMakeLists.txt's RAM_ORIGIN
	// and the HIL_FW_RAM_BASE/END pair main.c asserts on its first boot
	// line). After the halt those bytes have no owner at all: the ARM
	// that wrote them is held in reset until the next chip reset. A
	// scene may take them, under two conditions that are not
	// negotiable:
	//
	//   - RUNTIME CLAIM ONLY, never a link-time segment. The loader
	//     RUNS on this memory — dmx_load walks it, the blob staging
	//     buffers live in it, the handover banner is printf'd from it —
	//     right up to dmx_start. A .data/.bss/.ramtext window placed
	//     here would be trampled by the very code that installed it.
	//     Absolute pointers, written only after the machine is up, are
	//     the whole of the legal use.
	//   - No teardown obligation, in either direction. Nothing reads
	//     these bytes again, so a claimant need not restore them; and
	//     nothing wrote them since boot, so a claimant must initialize
	//     everything it reads.
	//
	// Zero on pico and pico2, and deliberately so: their ARM stays
	// alive as the flash mailbox executor (Pico) or simply keeps the
	// stock map (Pico2), its .data/.bss sit at the bottom of SRAM —
	// which is why those boards' machine floor is 0x20002000 — and the
	// scratch banks hold live core stacks. There is nothing dead to
	// claim on a board that never stopped.
	ArmScratchFree [2]uint32

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
	// The framebuffer is SRAM (FbBuf): PSRAM can never be the render
	// target, because window traffic on the shared read master breaks
	// scanout sync (prompts/036, prompts/041). FbHome..FbEnd survives
	// as the pan word the pure-DMA scanout no longer uses. PSRAMBase
	// is the *uncached* CS1 alias, the ARM's bulk store.
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
	// NoFlashExec is the THIRD state: this board ships neither
	// executor. The machine's QMI driver is not used AND the firmware
	// runs no mailbox service, so a flash sync has nothing to run on.
	// The distinction matters at the kernel: an unserviced mailbox is
	// not a failure, it is a HANG (kflash.c's arm_request spins on the
	// ack), so dmxgen bakes a sentinel — g_kflash_arm = KFLASH_NOEXEC
	// — and kflash.c answers -ENODEV, the repo's absent-device face.
	// Ignored unless MachineFlashExec is false.
	NoFlashExec bool
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

// ArmScratchEnd is the exclusive top of the board's dead-ARM window,
// or 0 where the board has none (see Board.ArmScratchFree).
func (b *Board) ArmScratchEnd() uint32 {
	if b.ArmScratchFree[1] == 0 {
		return 0
	}
	return b.ArmScratchFree[0] + b.ArmScratchFree[1]
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

// stdApps is THE app set — identical on every xv6 board. A command
// is portable as an executable even where its hardware isn't: fbtest
// and show run everywhere and print "no fb" on displayless boards
// (the kernel's fb stub answers -ENODEV; PORT.md, "Device absence").
var stdApps = []string{"echo", "cat", "ls", "toolbox", "hwtools",
	"fbtest", "show"}

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

// spin/trap (signal demos), wc, and help left the toolbox: help is an
// sh builtin now (it streams /dev/apps) and the rest earned no keep.
var stdLinks = []string{"kill", "free", "sync", "mount",
	"umount", "mkdir", "rm", "clear"}

// LinksFor returns the multi-call names linked onto the given app
// image (busybox-style argv[0] dispatch): the toolbox carries the
// board's ToolboxLinks; hwtools always carries the gpio/mux/blink trio.
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
	KernCRText: 0x20004000, KernCData: 0x2000EE00, /* +11.5K: the resident
	// tick/console path (dmacc ResidentFuncs), the reciprocal
	// divide-by-ten (dmacc __rt_udivmod10) and the fact-directed
	// compare bodies (__cw_eqzp/__cw_ltp); the data slack pays */
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
	KernCRText: 0x20004000, KernCData: 0x2000EE00, /* +11.5K: the resident
	// tick/console path (dmacc ResidentFuncs), the reciprocal
	// divide-by-ten (dmacc __rt_udivmod10) and the fact-directed
	// compare bodies (__cw_eqzp/__cw_ltp); the data slack pays */
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
// HDMI console: the framebuffer lives at the top of SRAM and a
// pure-DMA ring scans it out (prompts/036). The scanout working set
// is carved off the top of the arena (32 KiB).
var Feather = &Board{
	Name:      "feather",
	SKU:       "rp2350",
	PicoBoard: "adafruit_feather_rp2350",

	// Repacked tight (measured sizes + ~0x200-0x400 margins): the
	// firmware's staging buffer borrows the arena, the param.h shim
	// trimmed the fs tables, and sh runs 2 recursion clones plus the
	// frame-stack tail (prompts/042 §6 — the windows still have its
	// 4 KB of slack in them). Every byte reclaimed here is arena — the
	// window that decides whether `show` fits beside the scanout table.
	//
	// THE FLOOR IS 0x20000000 ON THIS BOARD, not the 0x20002000 family
	// floor pico/pico2 keep: the feather firmware links its own .data/
	// .bss into the RP2350 scratch banks and PSM-halts core0 once the
	// machine is running, so nothing of the ARM's is left down here to
	// collide with. The whole fixed run of windows below slid down by
	// that 8 KiB at UNCHANGED SIZES — only the bases moved — and the
	// arena took the whole gap (68.75 -> 76.75 KiB). Note this is a
	// per-BOARD floor: dmxgen's per-SKU layout map (its `layouts`,
	// which homes the standalone cc_*/registry HIL images) still
	// starts at 0x20002000, because the same SKU's plain pico2 runs a
	// firmware whose RAM lives there.
	// KernCData sits 1 KiB above where the pre-shared-runtime map put
	// it: the vector page + force-included bodies grew ramtext to
	// ~31.6K, and the slot-colored data side had the slack to give.
	KernText: 0x20000000, KernData: 0x20000400,
	KernCRText: 0x20000600, KernCData: 0x2000E300, /* ramtext grows +22.25K:
	// the resident tick/console path (dmacc ResidentFuncs) joins the shared
	// runtime so the idle machine never reads flash while the display
	// scans, plus the reciprocal divide-by-ten (__rt_udivmod10) and the
	// fact-directed compare bodies (__cw_eqzp/__cw_ltp). The fb console's
	// cursor_xor joined next, and then kfbcon_putc itself (dmxgen's
	// kernResident, prompts/042 §1): +11 KiB of window here, and +2.5 KiB
	// on the data side below, because a pool word a .ramtext record reads
	// is resident by force (dmaasm.Options.PoolText) — kfbcon_putc's own
	// literals arrive with it and would otherwise evict the profiled hot
	// pool. 13.5 KiB total, and the arena is what pays. */
	// Repacked after the flash literal-pool split + const-global
	// rodata (measured: kernel data 32.5K with the profiled hot pool
	// resident, sh data 8.6K all-cold). The arena covers sh's heap and
	// resident vi's [ramtext][data] claim + argv + vi's first heap
	// chunk: 63 KiB, the peak measured by walking kproc.c's free list
	// through a whole editing session here, leaving ~13.75 KiB spare
	// now that the floor move handed the arena its 8 KiB. vi's chunk
	// ask is 40K and a SECOND one still does not fit — it never did —
	// so the spare is headroom for the heavier viewers, not a second vi.
	ShRText: 0x20016E00, ShData: 0x20018000,
	IdleText: 0x2001A400, IdleData: 0x2001A600,
	DiskHome: 0x2001A800, DiskMax: 0x2800, // 10 KiB: room for a demo's
	// simultaneous files (a text file + a mount point + slack)
	Arena: 0x2001D000, ArenaEnd: 0x20030300, // 76.75 KiB up to the table
	ConsRings: 0x20034400, // UART rings; FbBuf follows at 0x20034C00
	Scratch:   0x2007FE00,
	// The RP2350's two 4 KiB scratch banks are CONTIGUOUS, so the
	// firmware links .data/.bss/heap into them as one 8 KiB region
	// (the boot stack does not fit and borrows the arena's top
	// instead). Dead once core 0 halts; no claimant here yet.
	ArmScratchFree: [2]uint32{0x20080000, 0x2000},

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
	// flash, so its arena claim is only [ramtext][data] (26K) plus a
	// small heap — inside the 76.75K arena the fb once priced it out
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

	// NO FLASH EXECUTOR AT ALL on this board — the third state, and
	// the reason NoFlashExec exists. The machine's QMI direct-mode
	// driver was never usable here (it leaves XIP in plain-SPI mode,
	// and on silicon the degraded M0 interleaved with the scanout's
	// QPI PSRAM bursts corrupted kernel fetches within a millisecond
	// of resuming the display, prompts/036), so sync used the parked
	// ARM's mailbox instead. That mailbox service is gone from the
	// feather firmware: the ARM's RAM moved into the scratch banks and
	// core0 is PSM-halted once the machine is up, so nobody is left to
	// answer a request. The kernel is told so explicitly (dmxgen bakes
	// g_kflash_arm = KFLASH_NOEXEC) and a sync attempt returns -ENODEV
	// instead of spinning on an ack that will never come. Storage that
	// still works: the SD card, which the MACHINE drives (ksd.c).
	MachineFlashExec: false,
	NoFlashExec:      true,
	MachineSDExec:    true, /* ksd.c owns the card; the ARM keeps only
	 * boot staging and USB */
	SDCSPin: 10, /* D10: the Adalogger FeatherWing CS */
	// RO anyway: the HDMI console is the product; persistence is a
	// nice-to-have and slides arrive over USB, not the fs. With
	// NoFlashExec the two agree — ReadOnlyFS zeroes the slot, and the
	// absent executor means even a re-armed slot cannot burn.
	ReadOnlyFS: true,
	DiskBlocks: 10,
	DiskInodes: 8, /* one inode block; frees data blocks for the
	 * write showcase + the SD mount point */
	DiskApps:     stdApps,
	ToolboxLinks: stdLinks,
	Bundles:      []string{"shell", "syscall", "exec", "xsh"},
}

// GamePico: the original Pi Pico (RP2040) as a bare-metal game
// console — no xv6, both ARM cores asleep after boot. Peripherals:
// a 240x240 ST7789 LCD on SPI0 (write-only 8-pin module: no TE, no
// MISO), two joysticks, two chained WS2811 LEDs (PIO), a MAX98357A
// I2S amp (PIO; SD_MODE strapped high = (L+R)/2, GAIN strapped).
// clk_sys overclocks to 250 MHz for machine headroom; clk_peri moves
// to a repurposed 125 MHz USB PLL (the RP2040 has no peri divider),
// keeping UART in spec and SPI0 at the ST7789's 62.5 MHz ceiling.
var GamePico = &Board{
	Name: "gamepico",
	SKU:  "rp2040",

	// The floor is SRAM's own base, not the 0x20002000 family floor:
	// the gamepico firmware links its .data/.bss into the scratch
	// banks and PSM-halts core0 once the machine is running, so the
	// low 8 KiB is the machine's. Only this per-BOARD window moved —
	// dmxgen's per-SKU `layouts` map still starts the standalone
	// cc_*/registry HIL images at 0x20002000, because the same rp2040
	// entry serves the plain pico, whose firmware lives down here.
	GameRAMText: 0x20000000, // self-modifying records + the radiosity
	// shooter's resident hot path (dmxgen ResidentFuncs): a 44 KiB
	// window, 36 before the floor move — the +8 KiB is headroom for
	// the inline-compare trampoline banks and future ResidentFuncs
	GameData: 0x2000B000, // data + the 240x240 RGB565 framebuffer;
	// grows toward GameFreeBase (below), which pins the top of the
	// segment 40 KiB short of the audio ring
	Scratch: 0x2003FE00,
	// The RP2040's SRAM ends in two 4 KiB scratch banks; the firmware
	// links its whole RAM side into them (RAM_ORIGIN 0x20040000 for
	// .data/.bss/heap, SCRATCH_X/Y above it for the core stacks) and
	// core 0 halts at the PSM the moment the machine is up. radio.c
	// claims the window at runtime for its fixed-size lookups — the
	// projected corner grids and the per-patch face tables — which is
	// what lets the whole scene-exclusive span below hold nothing but
	// arrays that scale with the patch count.
	ArmScratchFree: [2]uint32{0x20040000, 0x2000},

	FlashSize:   0x200000,
	GameTextXIP: 0x10100000, // upper half: clear of the firmware image

	ClkSysKHz: 250000,
	Bundles:   []string{"game"},
}

// GameFreeBase pins the bottom of the gamepico's scene-exclusive SRAM
// span: everything from here to the machine's scratch word is free for
// one scene at a time to claim, and dmxgen REFUSES a build whose game
// data segment reaches past it (buildGame's checkGameFree). The point
// of the pin is contiguity — a scene that wants a big flat working set
// gets one span, not three fragments:
//
//	0x2002E000..0x20038000  40960 B  unconditionally free
//	0x20038000..0x2003C000  16384 B  fx.c's audio ring — free to a
//	                                 scene that BORROWS it first
//	0x2003C000..0x2003FE00  15872 B  free to a scene that does not
//	                                 want bench.c's buffers
//	                       -------
//	0x2002E000..0x2003FE00  73216 B  contiguous, 71.5 KiB
//
// Only the first block is unconditional; the rest is scene-exclusive,
// which is why the pin sits below all three. The ring is the sharp
// edge: ch9 free-runs over it forever (silence is a zeroed ring, which
// is what keeps the amp from popping), so a scene claiming those
// bytes must quiesce the channel before its first store and hand back
// silence on the way out — fx.c's aud_borrow/aud_release, used by
// radio.c. bench.c's overlap needs no protocol at all: it stays above
// the ring, and the two demos never run together.
//
// radio.c is what the span was pinned for and what now measures it:
// its eleven per-patch arrays claim 64680 B from 0x2002E000 up (a
// 24x24 wall grid, 3080 patches), leaving 8536 B spare. Its FIXED-size
// lookups live somewhere else entirely — Board.ArmScratchFree, the
// dead ARM window — because a 6250-byte corner grid in here would
// have cost a whole step of grid resolution.
//
// 0x2002E000 is where the drum arena used to start, so the boundary is
// one bench.c already documents. Data currently ends at 0x2002D60C —
// about 2.5 KiB of margin, and the assert tripping on some future
// build is the signal to MOVE the pin deliberately rather than to
// shave a scene.
const GameFreeBase = 0x2002E000

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
