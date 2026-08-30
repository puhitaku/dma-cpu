package dmacc_test

// TestProfileRadio: execution-time profile of the radiosity demo,
// ranked hot -> cold. Counts machine fetch reads over BOTH the XIP
// text and the SRAM ramtext (execution cost is fetches regardless of
// placement) from "radio: up" through shot 48, attributed per
// function. Caveat printed with the result: the emulator drains SPI
// instantly, so lcd_flush's silicon wait time (62.5 Mbit wire) is
// estimated analytically, not measured.

import (
	"fmt"
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

func TestProfileRadio(t *testing.T) {
	if os.Getenv("RADIO_PROBES") == "" {
		t.Skip("diagnostic probe (~10 min of emulation): set RADIO_PROBES=1")
	}
	bd := boards.GamePico
	run := func(lo, hi uint32) ([]uint32, map[string]uint32) {
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
		m.Profile(lo, hi)
		runUntil(t, m, "radio: shot 48", at, 8_000_000_000)
		counts := append([]uint32(nil), m.ProfileCounts()...)
		m.Profile(0, 0)
		return counts, prog.Symbols
	}

	agg := map[string]uint64{}
	var total uint64
	attribute := func(counts []uint32, base uint32, syms map[string]uint32) {
		type sym struct {
			name string
			addr uint32
		}
		var fs []sym
		for n, a := range syms {
			if a >= base && a < base+uint32(len(counts))*4 {
				fs = append(fs, sym{n, a})
			}
		}
		sort.Slice(fs, func(i, j int) bool { return fs[i].addr < fs[j].addr })
		si := 0
		for w, c := range counts {
			if c == 0 {
				continue
			}
			a := base + uint32(w)*4
			for si+1 < len(fs) && fs[si+1].addr <= a {
				si++
			}
			nm := "??"
			if si < len(fs) && fs[si].addr <= a {
				nm = fs[si].name
			}
			for _, pre := range []string{"B_", "Ct", "Cf", "Cj", "Pe", "Sw", "St", "Sf", "Sj", "Xr", "Ld", "Sd", "Rv", "Fok", "Fha", "Fhb"} {
				if strings.HasPrefix(nm, pre) {
					if i := strings.Index(nm, "_"); i > 0 {
						nm = "f_" + nm[i+1:]
					}
					break
				}
			}
			if i := strings.LastIndex(nm, "_"); i > 0 {
				allDigits := len(nm[i+1:]) > 0
				for _, ch := range nm[i+1:] {
					if ch < '0' || ch > '9' {
						allDigits = false
					}
				}
				if allDigits {
					nm = nm[:i]
				}
			}
			agg[nm] += uint64(c)
			total += uint64(c)
		}
	}

	c1, syms := run(bd.GameTextXIP, bd.GameTextXIP+0x2A000)
	attribute(c1, bd.GameTextXIP, syms)
	c2, syms2 := run(bd.GameRAMText, bd.GameData)
	attribute(c2, bd.GameRAMText, syms2)

	type item struct {
		name string
		n    uint64
	}
	var items []item
	for n, c := range agg {
		items = append(items, item{n, c})
	}
	sort.Slice(items, func(i, j int) bool { return items[i].n > items[j].n })
	fmt.Printf("RADIOPROF total fetch reads (up..shot48): %d\n", total)
	for i := 0; i < len(items) && i < 24; i++ {
		fmt.Printf("RADIOPROF %2d. %-28s %10d (%5.1f%%)\n", i+1,
			items[i].name, items[i].n, 100*float64(items[i].n)/float64(total))
	}
	_ = emu.CtrlEN
}
