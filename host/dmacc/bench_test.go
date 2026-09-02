package dmacc_test

import (
	"bytes"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestZZBenchXsh measures the machine cycles each shell command costs,
// end to end: from feeding the line to the prompt coming back. TXPace
// is disabled so the numbers are pure compute (bus transfers), not
// UART pacing — the metric that moves when codegen trades speed for
// size. Each command runs twice so the cold (first exec, disk read)
// and warm costs are both visible.
//
// It is NOT behind DMACC_BENCH: the golden boot is shared, so the
// whole table costs half a second, and it is the tree's primary cycle
// ratchet (ratchet_test.go). The heavy benches below stay gated.
//
// One measurement note for whoever reads a diff of these numbers: the
// figures quantize on the scheduler's 15,000-cycle tick, because a
// blocked shell absorbs whole idle ticks. A single command is good to
// about ten ticks; compare the six-command sum, or the deterministic
// cc_* image cycles, before believing a small move.
//
//	go test ./host/dmacc/ -run TestZZBenchXsh -v
func TestZZBenchXsh(t *testing.T) {
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

	// bootXsh returns AT the first prompt (goldenBoot runs the boot
	// once per board and clones it), so there are no boot bytes left
	// to watch for; wait only if this build stopped short of it.
	if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
		if _, ok := waitPrompt(2_000_000_000); !ok {
			t.Fatalf("no boot prompt; console %q", m.ConsoleOut)
		}
	}

	cmds := []string{
		"echo hi",
		"ls",
		"cat README",
		"cat README | wc",
		"free",
		"((((echo deep))))",
	}
	cycles := map[string]uint64{}
	t.Logf("%-24s %14s %14s", "command", "cold cycles", "warm cycles")
	var coldSum, warmSum uint64
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
		cycles["xsh/"+c+"/cold"], cycles["xsh/"+c+"/warm"] = runs[0], runs[1]
		coldSum, warmSum = coldSum+runs[0], warmSum+runs[1]
		t.Logf("%-24s %14d %14d", c, runs[0], runs[1])
	}
	t.Logf("%-24s %14d %14d", "TOTAL", coldSum, warmSum)
	pinSet(t, "xsh/", cycles)
}

func tail(b []byte, n int) string {
	if len(b) > n {
		b = b[len(b)-n:]
	}
	return string(b)
}

// TestZZBenchVi prices the vi port on a real editing session — the
// heaviest interactive application in the tree (a keypress can run
// magnitudes more code than a whole shell command, and vi's text is
// XIP by design). Each phase feeds its keys and runs until the screen
// stops changing; the number recorded is cycles from feed to the LAST
// console change, so the quiet-detection tail does not count. TXPace
// off, as in the other benches.
//
//	DMACC_BENCH=1 go test ./dmacc/ -run TestZZBenchVi -v
func TestZZBenchVi(t *testing.T) {
	if os.Getenv("DMACC_BENCH") == "" {
		t.Skip("set DMACC_BENCH=1 to run the cycle benchmark")
	}
	m, kernC := bootXsh(t)
	registerVi(t, m, kernC, boards.Pico2)
	m.TXPace = 0
	// Small run chunks keep the cycles-to-last-change resolution fine
	// (the recorded number quantizes to the chunk size); the quiet
	// threshold stays at 50M cycles so a long silent compute stretch
	// mid-phase (replace-char reflows before it repaints) cannot end a
	// phase early.
	phase := func(feed string, budget uint64) uint64 {
		m.FeedConsole(feed)
		var spent, lastChange uint64
		quiet := 0
		last := len(m.ConsoleOut)
		for spent < budget && quiet < 100 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000})
			if err != nil {
				t.Fatalf("%v (console tail %q)", err, tail(m.ConsoleOut, 300))
			}
			spent += rr.Cycles
			if len(m.ConsoleOut) == last {
				quiet++
			} else {
				quiet, last, lastChange = 0, len(m.ConsoleOut), spent
			}
		}
		if lastChange == 0 {
			t.Fatalf("phase %q produced no output; console tail %q", feed, tail(m.ConsoleOut, 300))
		}
		return lastChange
	}
	steps := []struct{ name, feed string }{
		{"open README", "vi README\r"},
		{"insert a line", "ithe quick brown fox jumps over the lazy dog\x1b"},
		{"yank line (yy)", "yy"},
		{"paste x10 (p)", strings.Repeat("p", 10)},
		{"delete x5 (dd)", strings.Repeat("dd", 5)},
		{"replace char (rX)", "rX"},
		{"open aaa line (o)", "o" + strings.Repeat("a", 20) + "\x1b"},
		{"yank aaa (yy)", "yy"},
		{"paste aaa x10 (p)", strings.Repeat("p", 10)},
		{"subst %s/a/A/g", ":%s/a/A/g\r"},
		{"quit (:q!)", ":q!\r"},
	}
	pin := map[string]uint64{}
	fmt.Printf("%-20s %14s\n", "vi phase", "cycles")
	var total uint64
	for _, s := range steps {
		n := phase(s.feed, 20_000_000_000)
		total += n
		pin["vi/phase/"+s.name] = n
		fmt.Printf("%-20s %14d\n", s.name, n)
	}
	pin["vi/TOTAL"] = total
	fmt.Printf("%-20s %14d\n", "TOTAL", total)

	// Human pace. The bursts above amortize the repaint — vi skips it
	// whenever the next key is already waiting — so they price typing
	// faster than the machine, not a person at the keyboard. Here each
	// key goes in alone and runs to quiescence before the next one,
	// which is what a keypress actually costs.
	fmt.Printf("\n%-20s %6s %14s %14s\n", "human-paced", "keys", "cycles", "per key")
	human := func(name string, keys ...string) {
		var tot uint64
		for _, k := range keys {
			tot += phase(k, 4_000_000_000)
		}
		pin["vi/human/"+name] = tot
		fmt.Printf("%-20s %6d %14d %14d\n", name, len(keys), tot, tot/uint64(len(keys)))
	}
	phase("vi README\r", 20_000_000_000)
	human("motion l", "l", "l", "l", "l", "l", "l", "l", "l", "l", "l")
	human("replace (rX)", "rX")
	human("delete char (x)", "x")
	phase("i", 4_000_000_000)
	human("insert 5 chars", "h", "e", "l", "l", "o")
	phase("\x1b", 4_000_000_000)
	phase(":q!\r", 20_000_000_000)

	if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
		t.Fatalf("vi did not exit to the prompt; console tail %q", tail(m.ConsoleOut, 300))
	}
	pinSet(t, "vi/", pin)
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
		// bootXshBoard returns at the first prompt (goldenBoot); wait
		// only if this build stopped short of it.
		if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
			if _, ok := waitPrompt(2_000_000_000); !ok {
				t.Fatalf("%s: no boot prompt; console %q", bd.Name, tail(m.ConsoleOut, 200))
			}
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
	pin := map[string]uint64{}
	fmt.Printf("%-44s %12s %12s %12s\n", "workload", "feather", "pico2", "fbcon cost")
	for _, k := range []string{
		"echo 0123456789012345678901234567890123456789",
		"ls /dev", "cat README", "scroll (12x ls /dev)",
	} {
		pin["fbcon/feather/"+k], pin["fbcon/pico2/"+k] = feather[k], pico2[k]
		fmt.Printf("%-44s %12d %12d %+12d\n", k, feather[k], pico2[k], int64(feather[k])-int64(pico2[k]))
	}
	pinSet(t, "fbcon/", pin)
}

// TestZZBenchNyancat prices the framebuffer console's heaviest
// application, which is also the only colour-dense one in the tree:
// nyancat paints 1,131 cells of background escape a frame, addressed
// as changed runs against the previous frame, and every byte of that
// goes to the display AND out the UART.
//
// Two sessions, and the difference between them is the point. Paced is
// the wire the boards actually run (TXPace 13000 = 115200 baud), so it
// says what a person sees; free-running takes the transmitter away and
// leaves the machine's own compute. When the paced figure is the larger
// of the two the UART is setting the pace and no amount of kernel work
// will move the frame.
//
// A frame is the interval between counter lines, and the recorded
// figure is the mean over a whole twelve-frame animation cycle starting
// at the second frame — the first is a full redraw, which the port does
// once and then never again. Console bytes per frame ride along,
// because they are what both consumers are actually being handed.
//
//	DMACC_BENCH=1 go test ./dmacc/ -run TestZZBenchNyancat -v
func TestZZBenchNyancat(t *testing.T) {
	if os.Getenv("DMACC_BENCH") == "" {
		t.Skip("set DMACC_BENCH=1 to run the cycle benchmark")
	}
	const cycle = 12 // frames in the animation before it repeats
	session := func(pace uint64) (uint64, uint64) {
		m, _ := bootXshBoard(t, nil, boards.Feather)
		m.TXPace = pace
		m.FeedConsole("nyancat\r")
		frames := 0
		var atCyc uint64
		var atOut int
		var first uint64
		var firstOut int
		for spent := uint64(0); spent < 6_000_000_000; {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 200_000})
			if err != nil {
				t.Fatalf("%v (console tail %q)", err, tail(m.ConsoleOut, 200))
			}
			spent += rr.Cycles
			n := bytes.Count(m.ConsoleOut, []byte("seconds!"))
			if n == frames {
				continue
			}
			frames = n
			atCyc, atOut = m.Cycle, len(m.ConsoleOut)
			if frames == 2 { // the opening full redraw is behind us
				first, firstOut = atCyc, atOut
			}
			if frames == 2+cycle {
				return (atCyc - first) / cycle, uint64(atOut-firstOut) / cycle
			}
		}
		t.Fatalf("nyancat drew %d frames of %d; console tail %q",
			frames, 2+cycle, tail(m.ConsoleOut, 200))
		return 0, 0
	}
	paced, bytesPerFrame := session(13000)
	free, _ := session(0)
	fmt.Printf("%-24s %14s %14s\n", "nyancat", "cycles/frame", "ms/frame")
	for _, r := range []struct {
		name string
		cyc  uint64
	}{{"paced (115200 baud)", paced}, {"free-running", free}} {
		fmt.Printf("%-24s %14d %14.1f\n", r.name, r.cyc, float64(r.cyc)/150000)
	}
	fmt.Printf("%-24s %14d\n", "console bytes/frame", bytesPerFrame)
	pinSet(t, "nyancat/", map[string]uint64{
		"nyancat/frame/paced": paced,
		"nyancat/frame/free":  free,
		"nyancat/bytes/frame": bytesPerFrame,
	})
}
