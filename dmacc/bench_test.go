package dmacc_test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/boards"
	"github.com/puhitaku/dma-cpu/emu"
)

// TestZZBenchXsh measures the machine cycles each shell command costs,
// end to end: from feeding the line to the prompt coming back. TXPace
// is disabled so the numbers are pure compute (bus transfers), not
// UART pacing — the metric that moves when codegen trades speed for
// size. Runs only with DMACC_BENCH=1; each command runs twice so the
// cold (first exec, disk read) and warm costs are both visible.
//
//	DMACC_BENCH=1 go test ./dmacc/ -run TestZZBenchXsh -v
func TestZZBenchXsh(t *testing.T) {
	if os.Getenv("DMACC_BENCH") == "" {
		t.Skip("set DMACC_BENCH=1 to run the cycle benchmark")
	}
	m, _ := bootXsh(t)
	m.TXPace = 0

	// Watching the UART data register gives the exact cycle the
	// prompt's last byte goes out — no chunk quantization.
	dr := m.Variant().UARTDRAddr()
	waitPrompt := func(budget uint64) (uint64, bool) {
		var spent uint64
		mark := len(m.ConsoleOut)
		for spent < budget {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000, WatchWrites: []uint32{dr}})
			if err != nil {
				t.Fatalf("run: %v (console %q)", err, m.ConsoleOut[mark:])
			}
			spent += rr.Cycles
			if rr.Reason == emu.StopWatch {
				if len(m.ConsoleOut) > mark && strings.HasSuffix(string(m.ConsoleOut), "$ ") {
					return spent, true
				}
				continue
			}
			if rr.Reason == emu.StopIdle || rr.Reason == emu.StopStalled {
				return spent, false
			}
		}
		return spent, false
	}

	// Boot to the first prompt.
	if _, ok := waitPrompt(2_000_000_000); !ok {
		t.Fatalf("no boot prompt; console %q", m.ConsoleOut)
	}

	cmds := []string{
		"echo hi",
		"ls",
		"cat README",
		"cat README | wc",
		"free",
		"((((echo deep))))",
	}
	fmt.Printf("%-24s %14s %14s\n", "command", "cold cycles", "warm cycles")
	for _, c := range cmds {
		var runs [2]uint64
		for i := 0; i < 2; i++ {
			m.FeedConsole(c + "\r")
			n, ok := waitPrompt(3_000_000_000)
			if !ok {
				t.Fatalf("%q: no prompt after %d cycles; console tail %q",
					c, n, tail(m.ConsoleOut, 200))
			}
			runs[i] = n
		}
		fmt.Printf("%-24s %14d %14d\n", c, runs[0], runs[1])
	}
}

func tail(b []byte, n int) string {
	if len(b) > n {
		b = b[len(b)-n:]
	}
	return string(b)
}

// TestZZBenchFbcon prices the framebuffer console (prompts/036): the
// same command set runs on Feather (fbcon rendering every byte) and
// on Pico 2 (identical kernel, fb dormant), TXPace off, so the delta
// is pure fbcon cost — glyph rendering, escape parsing, and the
// pan-based scroll. The scroll row runs twelve /dev listings so the
// screen wraps several times.
//
//	DMACC_BENCH=1 go test ./dmacc/ -run TestZZBenchFbcon -v
func TestZZBenchFbcon(t *testing.T) {
	if os.Getenv("DMACC_BENCH") == "" {
		t.Skip("set DMACC_BENCH=1 to run the cycle benchmark")
	}
	session := func(bd *boards.Board) map[string]uint64 {
		m, _ := bootXshBoard(t, nil, bd)
		m.TXPace = 0
		dr := m.Variant().UARTDRAddr()
		waitPrompt := func(budget uint64) (uint64, bool) {
			var spent uint64
			mark := len(m.ConsoleOut)
			for spent < budget {
				rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000, WatchWrites: []uint32{dr}})
				if err != nil {
					t.Fatalf("run: %v (console %q)", err, m.ConsoleOut[mark:])
				}
				spent += rr.Cycles
				if rr.Reason == emu.StopWatch {
					if len(m.ConsoleOut) > mark && strings.HasSuffix(string(m.ConsoleOut), "$ ") {
						return spent, true
					}
					continue
				}
				if rr.Reason == emu.StopIdle || rr.Reason == emu.StopStalled {
					return spent, false
				}
			}
			return spent, false
		}
		if _, ok := waitPrompt(2_000_000_000); !ok {
			t.Fatalf("%s: no boot prompt; console %q", bd.Name, tail(m.ConsoleOut, 200))
		}
		res := map[string]uint64{}
		for _, c := range []string{"echo 0123456789012345678901234567890123456789", "ls /dev", "cat README"} {
			for i := 0; i < 2; i++ { // warm the exec path, keep run 2
				m.FeedConsole(c + "\r")
				n, ok := waitPrompt(3_000_000_000)
				if !ok {
					t.Fatalf("%s %q: no prompt; console tail %q", bd.Name, c, tail(m.ConsoleOut, 200))
				}
				res[c] = n
			}
		}
		var scroll uint64
		for i := 0; i < 12; i++ {
			m.FeedConsole("ls /dev\r")
			n, ok := waitPrompt(3_000_000_000)
			if !ok {
				t.Fatalf("%s scroll: no prompt; console tail %q", bd.Name, tail(m.ConsoleOut, 200))
			}
			scroll += n
		}
		res["scroll (12x ls /dev)"] = scroll
		return res
	}
	feather := session(boards.Feather)
	pico2 := session(boards.Pico2)
	fmt.Printf("%-44s %12s %12s %12s\n", "workload", "feather", "pico2", "fbcon cost")
	for _, k := range []string{
		"echo 0123456789012345678901234567890123456789",
		"ls /dev", "cat README", "scroll (12x ls /dev)",
	} {
		fmt.Printf("%-44s %12d %12d %+12d\n", k, feather[k], pico2[k], int64(feather[k])-int64(pico2[k]))
	}
}
