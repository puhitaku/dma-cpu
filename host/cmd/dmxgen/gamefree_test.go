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
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
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
		radioBase = 0x2003C000 // radio.c's RAD_RAM / bench.c's buffers
	)
	bd := boards.GamePico
	if got := audioBase - boards.GameFreeBase; got != 40960 {
		t.Errorf("pinned free block is %d bytes, not the documented 40960", got)
	}
	if got := audioEnd - audioBase; got != 16384 {
		t.Errorf("audio ring is %d bytes, not 16384", got)
	}
	if got := bd.Scratch - radioBase; got != 15872 {
		t.Errorf("radiosity region is %d bytes, not 15872", got)
	}
	if got := bd.Scratch - boards.GameFreeBase; got != 73216 {
		t.Errorf("the span is %d bytes, not the documented 73216", got)
	}
}
