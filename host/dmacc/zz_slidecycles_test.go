package dmacc_test

// Machine-side cost of one slide draw: emulated cycles between the
// show command's Start/Done markers (the emulator's SD "wire" is
// effectively free, so this is everything EXCEPT the physical SPI
// time), plus the sector count.
import (
	"fmt"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

func TestSlideCycles(t *testing.T) {
	m, _ := bootXshBoard(t, nil, boards.Feather)
	m.SDImage = sdCardImage(t)
	m.TXPace = 0
	m.FeedConsole("mkdir sd\rmount /dev/sd0 sd\r")
	runScript(t, m, 2_000_000_000)
	m.FeedConsole("show sd\r")
	var pre, draw uint64
	phase := 0
	reads0 := 0
	for spent := uint64(0); spent < 8_000_000_000; {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000})
		if err != nil {
			t.Fatal(err)
		}
		spent += rr.Cycles
		out := string(m.ConsoleOut)
		switch phase {
		case 0:
			if strings.Contains(out, "Start drawing") {
				phase = 1
				reads0 = m.SDReads
			}
			pre += rr.Cycles
		case 1:
			draw += rr.Cycles
			if strings.Contains(out, "Done drawing") {
				fmt.Printf("SLIDECYCLES draw=%d cycles (%.1f ms at 300 MHz), sectors=%d runs=%d, per-sector=%d cycles (%.1f us)\n",
					draw, float64(draw)/300e3, m.SDReads-reads0, m.SDRuns,
					draw/uint64(m.SDReads-reads0),
					float64(draw)/float64(m.SDReads-reads0)/300)
				return
			}
		}
	}
	t.Fatalf("no Done; tail %q", tailB(m.ConsoleOut, 200))
}
