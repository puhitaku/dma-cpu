package main

// The link-time pin under the gamepico's scene-exclusive SRAM span.
// buildGame enforces it on the real image, but building the real image
// means compiling the whole game and booting it in the emulator — far
// too slow to ask the question this test asks, which is only whether
// the bound is checked at the right byte and says something useful when
// it is not. So the check itself is the unit: one image that ends
// exactly on the pin (legal, the boundary case that a naive `>=` would
// reject) and one that ends a single byte past it.

import (
	"os"
	"regexp"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

func TestCheckGameFree(t *testing.T) {
	bd := *boards.GamePico // a copy: the check reads GameData/Scratch
	room := int(boards.GameFreeBase - bd.GameData)

	if err := checkGameFree(&bd, room); err != nil {
		t.Errorf("data ending exactly on the pin must be legal: %v", err)
	}
	if err := checkGameFree(&bd, room-1024); err != nil {
		t.Errorf("data a KiB short of the pin must be legal: %v", err)
	}

	err := checkGameFree(&bd, room+1)
	if err == nil {
		t.Fatalf("data one byte past %#x was accepted", uint32(boards.GameFreeBase))
	}
	// The message has to name the overrun and where to fix it: the
	// answer to this failure is a deliberate move of the pin, and the
	// error is the only place that gets said at build time.
	for _, want := range []string{
		"1 bytes past", "0x2002e000", "GameFreeBase",
	} {
		if !strings.Contains(strings.ToLower(err.Error()), strings.ToLower(want)) {
			t.Errorf("error %q does not mention %q", err, want)
		}
	}
}

// The span the pin protects is the composition boards.GameFreeBase
// documents; if any piece of it moves, the arithmetic there is stale.
func TestGameFreeSpan(t *testing.T) {
	const (
		audioBase = 0x20038000 // fx.c's ring (dmxgen's auBase)
		audioEnd  = 0x2003C000
		benchBase = 0x2003C000 // the block bench.c's buffers sit in
	)
	bd := boards.GamePico
	if got := audioBase - boards.GameFreeBase; got != 40960 {
		t.Errorf("pinned free block is %d bytes, not the documented 40960", got)
	}
	if got := audioEnd - audioBase; got != 16384 {
		t.Errorf("audio ring is %d bytes, not 16384", got)
	}
	if got := bd.Scratch - benchBase; got != 15872 {
		t.Errorf("the top block is %d bytes, not 15872", got)
	}
	if got := bd.Scratch - boards.GameFreeBase; got != 73216 {
		t.Errorf("the span is %d bytes, not the documented 73216", got)
	}
}

// ArmScratchFree is a claim on memory the FIRMWARE places, and the two
// sides are linked by nothing but agreement: CMake feeds RAM_ORIGIN to
// the linker and HIL_FW_RAM_BASE/END to main.c's boot assert, while
// boards.go tells a scene the same window is free after the halt. If
// they ever drift, a scene's working set lands on live firmware RAM
// during boot and the failure is a garbled load, not an error. So the
// halt boards' windows are read back out of the CMake file here, and
// the boards that keep their ARM alive are pinned as empty.
func TestArmScratchFree(t *testing.T) {
	src, err := os.ReadFile("../../../target/firmware/CMakeLists.txt")
	if err != nil {
		t.Fatal(err)
	}
	re := regexp.MustCompile(`HIL_FW_RAM_BASE=(0x[0-9a-fA-F]+)u HIL_FW_RAM_END=(0x[0-9a-fA-F]+)u`)
	var cmake [][2]uint32
	for _, m := range re.FindAllSubmatch(src, -1) {
		base, err := strconv.ParseUint(string(m[1]), 0, 32)
		if err != nil {
			t.Fatal(err)
		}
		end, err := strconv.ParseUint(string(m[2]), 0, 32)
		if err != nil {
			t.Fatal(err)
		}
		cmake = append(cmake, [2]uint32{uint32(base), uint32(end)})
	}
	if len(cmake) == 0 {
		t.Fatal("CMakeLists.txt no longer defines HIL_FW_RAM_BASE/END pairs")
	}
	seen := map[[2]uint32]bool{}
	for _, w := range cmake {
		seen[w] = true
	}
	for _, bd := range boards.All {
		w := bd.ArmScratchFree
		if w[1] == 0 {
			// No constant means "this ARM never stopped". The boards
			// that say so must also be the ones CMake leaves on the
			// stock map, i.e. the ones with no HIL_ARM_HALT pair.
			continue
		}
		if !seen[[2]uint32{w[0], bd.ArmScratchEnd()}] {
			t.Errorf("%s: ArmScratchFree %#x..%#x is not a window "+
				"target/firmware/CMakeLists.txt links the firmware into",
				bd.Name, w[0], bd.ArmScratchEnd())
		}
	}
	for _, bd := range []*boards.Board{boards.Pico, boards.Pico2} {
		if bd.ArmScratchFree[1] != 0 {
			t.Errorf("%s keeps its ARM alive as the mailbox executor; "+
				"it has no dead scratch to hand out", bd.Name)
		}
	}
	// Every claimant writes absolute pointers, so the window must be
	// real SRAM on the SKU — not the address one bank past the end.
	for _, bd := range boards.All {
		if bd.ArmScratchFree[1] == 0 {
			continue
		}
		v, err := emu.VariantByName(bd.SKU)
		if err != nil {
			t.Fatal(err)
		}
		if bd.ArmScratchEnd() > 0x20000000+v.SRAMSize {
			t.Errorf("%s: ArmScratchFree ends at %#x, past %s's SRAM",
				bd.Name, bd.ArmScratchEnd(), bd.SKU)
		}
	}
}
