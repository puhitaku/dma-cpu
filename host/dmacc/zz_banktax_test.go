package dmacc_test

import (
	"fmt"
	"os"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestZZBankTax prices the compact encoding's bank state at RUNTIME:
// what share of executed 8-byte records is window-switch / count-reload
// machinery rather than payload. It profiles fetch reads over the three
// text regions of a booted xsh feather while five shell commands run,
// then classifies each fetched record by its write address — a switch
// record writes fetch's AL3_WRITE_ADDR, a count record a bank's
// AL2_TRANS_COUNT, everything else moves data.
//
// A word pair whose two halves have different read counts was read as
// data, not fetched as a record (pool literals and .word tables share
// these ranges); those are reported as skew and left unclassified.
//
// Measured 2026-08-29: 23.0% of executed records are bank state
// (switches 1501534, count reloads 1300, payload 5021334) — the figure
// behind prompts/042 §10 (b). Nearly all of it is switches, and each
// one is a bank transition the payload record stream demands, so it is
// not reclaimable by planner-side elision (host/dmaasm/compact.go).
//
//	BANKTAX=1 go test ./host/dmacc/ -run TestZZBankTax -v
func TestZZBankTax(t *testing.T) {
	if os.Getenv("BANKTAX") == "" {
		t.Skip("set BANKTAX=1 to price the compact bank state")
	}
	bd := boards.Feather
	swAddr := emu.ChanRegAddr(emu.CompactFetch, emu.OffAl3WriteAddr)
	cntAddr := map[uint32]bool{}
	for b := 0; b < emu.CompactNumBanks; b++ {
		cntAddr[emu.ChanRegAddr(b, emu.OffAl2TransCount)] = true
	}
	var pay, sw, cnt, skew uint64
	scan := func(name string, lo, hi uint32) {
		m, _ := bootXshBoard(t, nil, bd)
		m.TXPace = 0
		m.Profile(lo, hi)
		m.FeedConsole("echo hi\rls\rcat README\rcat README | wc\rfree\r")
		runScript(t, m, 3_000_000_000)
		counts := append([]uint32(nil), m.ProfileCounts()...)
		m.Profile(0, 0) // reading the image below must not count
		var p, s, c, k uint64
		for w := 0; w+1 < len(counts); w += 2 {
			n := uint64(counts[w])
			if n == 0 {
				continue
			}
			if uint64(counts[w+1]) != n {
				k += n
				continue
			}
			wa, err := m.Read(lo+uint32(w)*4+4, 4)
			if err != nil {
				continue
			}
			switch {
			case wa == swAddr:
				s += n
			case cntAddr[wa]:
				c += n
			default:
				p += n
			}
		}
		fmt.Printf("BANKTAX %-16s payload=%-10d switch=%-9d count=%-7d skew=%-8d tax=%.2f%%\n",
			name, p, s, c, k, 100*float64(s+c)/float64(p+s+c))
		pay, sw, cnt, skew = pay+p, sw+s, cnt+c, skew+k
	}
	scan("kernel-xip", bd.KernTextXIP, bd.KernTextXIP+300000)
	scan("kernel-ramtext", bd.KernCRText, bd.KernCData)
	scan("arena", bd.Arena, bd.ArenaEnd)
	fmt.Printf("BANKTAX %-16s payload=%-10d switch=%-9d count=%-7d skew=%-8d tax=%.2f%%\n",
		"TOTAL", pay, sw, cnt, skew, 100*float64(sw+cnt)/float64(pay+sw+cnt))
}
