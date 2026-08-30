package dmacc_test

// Throwaway diagnostic: does the floor's radiosity contain box
// shadows? Dumps a wall's patch brightness (bR+bG+bB) after ~256
// shots. The layout constants mirror radio.c — grid edge, array
// stride and the base of the scene-exclusive span — so a change there
// is a change here.
import (
	"fmt"
	"os"
	"testing"
)

func TestShadowMap(t *testing.T) {
	if os.Getenv("RADIO_PROBES") == "" {
		t.Skip("diagnostic probe (long emulation): set RADIO_PROBES=1")
	}
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Parachute", "menu: Puni Puni", "menu: Boing",
		"menu: Radiosity"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "radio: up", at, 100_000_000)
	runUntil(t, m, "radio: shot 256", at, 200_000_000_000)
	// radio.c: N, NP, PSTRIDE = (NP*2+3)&^3, RAD_RAM = GameFreeBase
	const (
		n       = 24
		np      = 5*n*n + 164 + (n/4)*(n/4)
		stride  = (np*2 + 3) &^ 3
		rad     = 0x2002E000
		psize   = 240 / n
		nearest = 200 + psize/2
	)
	rd16 := func(base, p uint32) uint32 {
		a := rad + base + 2*p
		w := m.Peek32(a &^ 3)
		return (w >> ((a & 2) * 8)) & 0xFFFF
	}
	dump := func(name string, base int, rowlab func(k int) string) {
		fmt.Printf("SHADOW %s brightness map:\n", name)
		for k := n - 1; k >= 0; k-- {
			row := "SHADOW "
			for i := 0; i < n; i++ {
				p := uint32(base + k*n + i)
				b := rd16(3*stride, p) + rd16(4*stride, p) + rd16(5*stride, p)
				row += fmt.Sprintf("%6d", b)
			}
			fmt.Println(row, rowlab(k))
		}
	}
	zlab := func(k int) string { return fmt.Sprintf("z=%d", nearest+psize*k) }
	dump("floor (x right, z away)", n*n, zlab)
	dump("back wall (x right, y rows)", 0, func(k int) string {
		return fmt.Sprintf("y=%d", -120+psize/2+psize*k)
	})
	dump("left wall (rows z away)", 3*n*n, zlab)
	dump("right wall (rows z away)", 4*n*n, zlab)
}
