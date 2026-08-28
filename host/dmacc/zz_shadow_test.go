package dmacc_test

// Throwaway diagnostic: does the floor's radiosity contain box
// shadows? Dumps the 10x10 floor patch brightness (bR+bG+bB) after
// ~256 shots. RAD_RAM layout mirrors radio.c.
import (
	"fmt"
	"os"
	"testing"
)

func TestShadowMap(t *testing.T) {
	if os.Getenv("RADIO_PROBES") == "" {
		t.Skip("diagnostic probe (~9 min of emulation): set RADIO_PROBES=1")
	}
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Sequencer", "menu: Benchmark", "menu: Radiosity"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "radio: up", at, 100_000_000)
	runUntil(t, m, "radio: shot 128", at, 40_000_000_000)
	const rad = 0x2003C000
	const stride = 1360
	rd16 := func(base, p uint32) uint32 {
		a := rad + base + 2*p
		w := m.Peek32(a &^ 3)
		return (w >> ((a & 2) * 8)) & 0xFFFF
	}
	dump := func(name string, base int, rowlab func(k int) string) {
		fmt.Printf("SHADOW %s brightness map:\n", name)
		for k := 9; k >= 0; k-- {
			row := "SHADOW "
			for i := 0; i < 10; i++ {
				p := uint32(base + k*10 + i)
				b := rd16(4080, p) + rd16(5440, p) + rd16(6800, p)
				row += fmt.Sprintf("%6d", b)
			}
			fmt.Println(row, rowlab(k))
		}
	}
	dump("floor (x right, z away)", 100, func(k int) string { return fmt.Sprintf("z=%d", 212+24*k) })
	dump("back wall (x right, y rows)", 0, func(k int) string { return fmt.Sprintf("y=%d", -108+24*k) })
	dump("left wall (rows z away)", 300, func(k int) string { return fmt.Sprintf("z=%d", 212+24*k) })
	dump("right wall (rows z away)", 400, func(k int) string { return fmt.Sprintf("z=%d", 212+24*k) })
}
