package dmacc_test

// TestProfileConsole: where a console byte's cost actually is, in both
// directions, split by the window it executes in.
//
// The fbcon probe next door (TestProfileFbcon) prices the DISPLAY half
// against a displayless twin. This one asks a different question and
// gets a different answer: it attributes the kernel's own execution —
// XIP text and .ramtext, folded onto functions, helpers and comparison
// SITES by host/trace — over two workloads that stress opposite ends of
// the console.
//
//   out   nyancat, the colour-dense writer: 208 SGRs and a thousand
//         cursor addresses a frame, one select() a frame on the way in.
//   in    a typed command line, where every byte arrives as its own RX
//         wake and echoes back through the same tee.
//
// Two things it is here to keep visible, both of them measurements the
// tree acts on:
//
//   1. The comparison bill. dmacc lowers a compare through millicode,
//      so a test is a call, and over a nyancat frame the millicode is
//      ~45% of every record the kernel executes.
//   2. Which of those sites got a fast form. Options.OptSize gives
//      every site the two-record descriptor unless the profile named
//      it (pgo.KernelHotSites / KernelInlineSites) — with one rule on
//      top that the pgo sets do not express: a site in .ramtext is
//      four-move whatever the profile says, because its descriptor
//      would live in flash text and be read with the XIP window down
//      (dmacc siteFourMove, fc.inRAM). This probe used to ask the pgo
//      sets alone and so reported every resident site as DESCRIPTOR,
//      which read as a whole window's worth of code left slow by
//      omission. It was not: those sites were already fast. `form`
//      below asks the same question dmacc does, which is what makes
//      the "descriptor share" line per window mean anything.
//
//      What the resident half IS missing is the top of the ladder —
//      inlining, the only form that removes the millicode call itself.
//      The driver ranks resident sites for it now (zz_pgogen_test.go),
//      and the board's .ramtext window decides how many fit.
//
//	RADIO_PROBES=1 go test ./dmacc/ -run TestProfileConsole -v

import (
	"bytes"
	"fmt"
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/pgo"
	"github.com/puhitaku/dma-cpu/host/trace"
)

func TestProfileConsole(t *testing.T) {
	if os.Getenv("RADIO_PROBES") == "" {
		t.Skip("diagnostic probe (~30 s of emulation): set RADIO_PROBES=1")
	}
	bd := boards.Feather
	// The form Options.OptSize gave each site, from the settings the
	// kernel about to run was compiled with — asked in dmacc's own
	// order (siteInline, then siteFourMove), residency included, so
	// what this prints is the form the image HAS and not the form its
	// profile entry would have asked for.
	form := func(s string, resident bool) string {
		switch {
		case pgo.KernelInlineSites[s]:
			return "inline"
		case resident:
			return "4-move (.ramtext)"
		case pgo.KernelHotSites[s]:
			return "4-move"
		}
		return "DESCRIPTOR"
	}
	// warm runs first and is NOT counted; drive is what the windows see.
	run := func(name string, warm, drive func(m *emu.Machine)) {
		m, kernC := bootXshBoard(t, nil, bd)
		tbl := symTable(t, compileKernelXsh(t, true), m.Variant(), kernC, pgo.KernelLits)
		m.TXPace = 13000 // the wire the boards actually run
		kTxt := textWindow(kernC, bd.KernTextXIP)
		kRam := [2]uint32{bd.KernCRText, bd.KernCData}
		if warm != nil {
			warm(m)
		}
		m.ProfileWindows([][2]uint32{kTxt, kRam})
		drive(m)
		txt := window{kTxt, m.ProfileCountsAt(0)}
		ram := window{kRam, m.ProfileCountsAt(1)}

		h := tbl.Attribute(trace.Region{Lo: kTxt[0], Counts: txt.counts},
			trace.Region{Lo: kRam[0], Counts: ram.counts})
		h.Report(os.Stdout, "\nCONSPROF "+name, trace.ByFunction, 18)
		h.Report(os.Stdout, "CONSPROF "+name+" helpers", trace.ByHelper, 8)

		var xip, res uint64
		for _, c := range txt.counts {
			xip += uint64(c)
		}
		for _, c := range ram.counts {
			res += uint64(c)
		}
		fmt.Printf("CONSPROF %s: XIP text %d reads, .ramtext %d (%.1f%% resident)\n",
			name, xip, res, 100*float64(res)/float64(xip+res))

		for _, w := range []struct {
			tag      string
			win      window
			resident bool
		}{{"XIP text", txt, false}, {".ramtext", ram, true}} {
			sites, tot, n := siteCounts(kernC, w.win, litSet(kernC))
			type kv struct {
				k string
				v uint64
			}
			var ss []kv
			var desc uint64
			for k, v := range sites {
				ss = append(ss, kv{k, v})
				if form(k, w.resident) == "DESCRIPTOR" {
					desc += v
				}
			}
			sort.Slice(ss, func(i, j int) bool {
				if ss[i].v != ss[j].v {
					return ss[i].v > ss[j].v
				}
				return ss[i].k < ss[j].k
			})
			fmt.Printf("CONSPROF %s %s: %d labelled sites, %d executed, "+
				"%.1f%% of site reads in DESCRIPTOR form\n",
				name, w.tag, n, len(sites), 100*float64(desc)/float64(tot))
			for i, e := range ss {
				if i >= 8 {
					break
				}
				fmt.Printf("CONSPROF   %-28s %10d  %5.1f%%  %s\n", e.k, e.v,
					100*float64(e.v)/float64(tot), form(e.k, w.resident))
			}
		}
	}

	// Out: the colour-dense writer, measured over whole frames so the
	// per-frame select() and its tick-paced sleep are both in it. The
	// first two frames are warm-up: the opening one is a full redraw
	// and is not what the port spends its life doing.
	frames := func(n int) func(*emu.Machine) {
		return func(m *emu.Machine) {
			want := bytes.Count(m.ConsoleOut, []byte("seconds!")) + n
			for spent := uint64(0); spent < 5_000_000_000; {
				if bytes.Count(m.ConsoleOut, []byte("seconds!")) >= want {
					return
				}
				rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000})
				if err != nil {
					t.Fatal(err)
				}
				spent += rr.Cycles
			}
			t.Fatalf("nyancat stalled at %d frames",
				bytes.Count(m.ConsoleOut, []byte("seconds!")))
		}
	}
	run("nyancat (12 frames)", func(m *emu.Machine) {
		m.FeedConsole("nyancat\r")
		frames(2)(m)
	}, frames(12))

	// In: a typed line. Every byte is its own RX wake, its own
	// cons_poll and its own echo through the tee.
	run("typed line", nil, func(m *emu.Machine) {
		m.FeedConsole("echo the quick brown fox\r")
		for spent := uint64(0); spent < 2_000_000_000; {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000})
			if err != nil {
				t.Fatal(err)
			}
			spent += rr.Cycles
			if strings.HasSuffix(string(m.ConsoleOut), "$ ") &&
				strings.Contains(string(m.ConsoleOut), "quick brown fox\r\n") {
				return
			}
		}
		t.Fatalf("typed line never completed: %q", tailB(m.ConsoleOut, 200))
	})
}
