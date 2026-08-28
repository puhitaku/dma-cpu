package dmacc_test

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// viTerm is the terminal vi paints on: a rows x cols grid of cells
// plus the cursor, driven by the escape subset vi.c emits — CSI H
// (place_cursor, redraw's "cursor to top,left"), CSI K (clear_to_eol),
// CSI J (redraw's clear-to-end-of-screen), the standout SGRs and the
// alternate-screen switch of vi_main.
//
// The grid is the contract. vi's byte stream is free to change (that
// is the whole point of repainting fewer lines); what a user sees is
// not, so the tests below compare grids, not bytes.
type viTerm struct {
	rows, cols int
	cell       []byte
	row, col   int
}

func newViTerm(rows, cols int) *viTerm {
	t := &viTerm{rows: rows, cols: cols, cell: make([]byte, rows*cols)}
	t.erase(0, len(t.cell))
	return t
}

func (t *viTerm) erase(from, to int) {
	for i := from; i < to; i++ {
		t.cell[i] = ' '
	}
}

// write folds one chunk of console output into the grid.
func (t *viTerm) write(b []byte) error {
	for i := 0; i < len(b); i++ {
		c := b[i]
		switch {
		case c == 0x1b:
			n, err := t.escape(b[i:])
			if err != nil {
				return err
			}
			i += n - 1
		case c == '\r':
			t.col = 0
		case c == '\n':
			if t.row >= t.rows-1 {
				return fmt.Errorf("newline on the last row: the model does not scroll")
			}
			t.row++
		case c == 8: // backspace
			if t.col > 0 {
				t.col--
			}
		case c == 7: // bell
		case c >= ' ' && c < 0x7f:
			if t.col >= t.cols {
				return fmt.Errorf("write past column %d at row %d", t.cols, t.row)
			}
			t.cell[t.row*t.cols+t.col] = c
			t.col++
		default:
			return fmt.Errorf("unexpected control byte %#02x", c)
		}
	}
	return nil
}

// escape consumes one escape sequence at the head of b and returns
// how many bytes it took.
func (t *viTerm) escape(b []byte) (int, error) {
	if len(b) < 3 || b[1] != '[' {
		// vi emits no escape that is not a CSI; a bare one at the end
		// of a chunk would mean output stopped mid-sequence.
		return len(b), fmt.Errorf("truncated or non-CSI escape %q", b)
	}
	i := 2
	for i < len(b) && (b[i] == '?' || b[i] == ';' || (b[i] >= '0' && b[i] <= '9')) {
		i++
	}
	if i >= len(b) {
		return len(b), fmt.Errorf("unterminated CSI %q", b)
	}
	params, final := string(b[2:i]), b[i]
	i++
	num := func(s string, def int) int {
		if s == "" {
			return def
		}
		v, err := strconv.Atoi(s)
		if err != nil {
			return def
		}
		return v
	}
	switch final {
	case 'H': // cursor position, 1-based
		r, c := 1, 1
		if params != "" {
			f := strings.Split(params, ";")
			r = num(f[0], 1)
			if len(f) > 1 {
				c = num(f[1], 1)
			}
		}
		t.row, t.col = clampInt(r-1, 0, t.rows-1), clampInt(c-1, 0, t.cols-1)
	case 'K': // clear to end of line
		t.erase(t.row*t.cols+t.col, (t.row+1)*t.cols)
	case 'J': // clear to end of screen
		t.erase(t.row*t.cols+t.col, len(t.cell))
	case 'm': // standout on/off: not part of the cell grid
	case 'h', 'l': // ?1049: alternate screen
	default:
		return i, fmt.Errorf("unhandled CSI %q%c", params, final)
	}
	return i, nil
}

func clampInt(v, lo, hi int) int {
	if v < lo {
		return lo
	}
	if v > hi {
		return hi
	}
	return v
}

// String renders the grid the way the goldens below record it: one
// line per row with trailing blanks trimmed, and the cursor last.
func (t *viTerm) String() string {
	var sb strings.Builder
	for r := 0; r < t.rows; r++ {
		sb.Write([]byte(strings.TrimRight(string(t.cell[r*t.cols:(r+1)*t.cols]), " ")))
		sb.WriteByte('\n')
	}
	fmt.Fprintf(&sb, "[cursor %d,%d]", t.row, t.col)
	return sb.String()
}

// viScreenPhases is the editing session the oracle replays: motions
// that must not repaint anything, single-line edits, line edits that
// shift the rest of the file, scrolling both ways past the window,
// and a whole-file substitution. Each phase's rendered screen is
// pinned by viScreenGolden.
var viScreenPhases = []struct{ name, feed string }{
	// The file: 84 lines of four repeating shapes, separated by
	// singles so no scroll position looks like another.
	{"open", "vi big\r"},
	{"motion jjjj", "jjjj"},
	{"motion llll", "llll"},
	{"motion kh", "kh"},
	{"replace char rZ", "rZ"},
	{"delete char x", "x"},
	// A change that starts exactly where a screen line starts is the
	// case a "the text after it only moved" rule gets wrong most
	// easily - the newline the next line begins after moves too.
	{"delete at column 0", "0x"},
	{"replace at column 0", "0rQ"},
	{"delete to eol D", "D"},
	{"append A", "Atail\x1b"},
	{"backspace in insert", "ixy\x7f\x1b"},
	{"delete line dd", "dd"},
	{"put line p", "p"},
	{"open line o", "oopened line\x1b"},
	{"insert i", "iINS\x1b"},
	{"join J", "J"},
	{"flip case ~", "~~~"},
	{"half page down", "\x04"},
	{"half page up", "\x15"},
	{"page down", "\x06"},
	{"page down again", "\x06"},
	{"page up", "\x02"},
	{"search", "/delta\r"},
	{"bottom G", "G"},
	{"edit at bottom", "obottom\x1b"},
	{"top 1G", "1G"},
	{"substitute", ":%s/beta/BETA/g\r"},
	{"scroll to end", "\x06\x06\x06\x06"},
	{"quit", ":q!\r"},
}

// TestXv6ViScreen is the vi port's screen-equivalence oracle: it
// drives a session over a file several screens long and compares the
// rendered 24x80 grid — text and cursor — against a golden captured
// from the port before refresh() learned to skip lines. Any change to
// vi.c that alters what the user sees fails here.
//
// Re-record with VI_SCREEN_RECORD=1 (and only after reading the diff:
// a changed golden is a changed screen).
func TestXv6ViScreen(t *testing.T) {
	t.Parallel()
	m, kernC := bootXsh(t)
	registerVi(t, m, kernC, boards.Pico2)
	m.TXPace = 0

	// Run one input burst until the console goes quiet: vi settles
	// into its key-wait loop between bursts.
	settle := func(feed string, budget uint64) {
		m.FeedConsole(feed)
		var spent uint64
		quiet := 0
		last := len(m.ConsoleOut)
		for spent < budget && quiet < 40 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000})
			if err != nil {
				t.Fatalf("%v\nconsole tail: %q", err, tailB(m.ConsoleOut, 300))
			}
			spent += rr.Cycles
			if len(m.ConsoleOut) == last {
				quiet++
			} else {
				quiet = 0
				last = len(m.ConsoleOut)
			}
		}
	}

	// Build the file with the shell: four lines of distinct shape,
	// then two rounds of quadrupling with a single line wedged
	// between the copies, so the result (84 lines) never repeats.
	for _, c := range []string{
		"echo alpha line one > a",
		"echo beta > b",
		"echo gamma gamma gamma gamma > c",
		"echo delta 4 > d",
		"cat a b c d > g1",
		"cat g1 a g1 b g1 c g1 d > g2",
		"cat g2 a g2 b g2 c g2 d > big",
	} {
		settle(c+"\r", 400_000_000)
	}
	if out := string(m.ConsoleOut); strings.Contains(out, "cannot open") ||
		strings.Contains(out, "no free") || strings.Contains(out, "error") {
		t.Fatalf("staging the file failed; console tail: %q", tailB(m.ConsoleOut, 400))
	}

	term := newViTerm(24, 80)
	seen := len(m.ConsoleOut)
	var got []string
	for _, p := range viScreenPhases {
		settle(p.feed, 4_000_000_000)
		if err := term.write(m.ConsoleOut[seen:]); err != nil {
			t.Fatalf("phase %q: %v\nchunk: %q", p.name, err, m.ConsoleOut[seen:])
		}
		seen = len(m.ConsoleOut)
		got = append(got, term.String())
	}
	if os.Getenv("VI_SCREEN_RECORD") != "" {
		var sb strings.Builder
		sb.WriteString("var viScreenGolden = []string{\n")
		for i, g := range got {
			fmt.Fprintf(&sb, "\t// %s\n\t`%s`,\n", viScreenPhases[i].name, g)
		}
		sb.WriteString("}\n")
		fmt.Print(sb.String())
		return
	}
	if len(viScreenGolden) != len(got) {
		t.Fatalf("golden has %d phases, session produced %d", len(viScreenGolden), len(got))
	}
	for i, g := range got {
		if g != viScreenGolden[i] {
			t.Errorf("phase %q renders a different screen:\n--- want ---\n%s\n--- got ---\n%s",
				viScreenPhases[i].name, viScreenGolden[i], g)
		}
	}
	if !strings.HasSuffix(strings.TrimRight(string(m.ConsoleOut), " "), "$") {
		t.Errorf("no prompt after the session; tail: %q", tailB(m.ConsoleOut, 200))
	}
}

// viScreenGolden is what the session above renders, captured from
// the port as it was before refresh() learned to leave lines alone.
var viScreenGolden = []string{
	// open
	`alpha line one
beta
gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big 1/84 1%
[cursor 0,0]`,
	// motion jjjj
	`alpha line one
beta
gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big 5/84 5%
[cursor 4,0]`,
	// motion llll
	`alpha line one
beta
gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big 5/84 5%
[cursor 4,4]`,
	// motion kh
	`alpha line one
beta
gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big 4/84 4%
[cursor 3,3]`,
	// replace char rZ
	`alpha line one
beta
gamma gamma gamma gamma
delZa 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 4/84 4%
[cursor 3,3]`,
	// delete char x
	`alpha line one
beta
gamma gamma gamma gamma
dela 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 4/84 4%
[cursor 3,3]`,
	// delete at column 0
	`alpha line one
beta
gamma gamma gamma gamma
ela 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 4/84 4%
[cursor 3,0]`,
	// replace at column 0
	`alpha line one
beta
gamma gamma gamma gamma
Qla 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 4/84 4%
[cursor 3,0]`,
	// delete to eol D
	`alpha line one
beta
gamma gamma gamma gamma

alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 4/84 4%
[cursor 3,0]`,
	// append A
	`alpha line one
beta
gamma gamma gamma gamma
tail
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 4/84 4%
[cursor 3,3]`,
	// backspace in insert
	`alpha line one
beta
gamma gamma gamma gamma
taixl
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 4/84 4%
[cursor 3,3]`,
	// delete line dd
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
- big [Modified] 4/83 4%
[cursor 3,0]`,
	// put line p
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
taixl
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 5/83 6%
[cursor 4,0]`,
	// open line o
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
taixl
opened line
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
- big [Modified] 6/85 7%
[cursor 5,10]`,
	// insert i
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
taixl
opened linINSe
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
- big [Modified] 6/85 7%
[cursor 5,12]`,
	// join J
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
taixl
opened linINSe alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 6/84 7%
[cursor 5,15]`,
	// flip case ~
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
taixl
opened linINSe ALPha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 6/84 7%
[cursor 5,18]`,
	// half page down
	`beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
- big [Modified] 12/84 14%
[cursor 0,0]`,
	// half page up
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
taixl
opened linINSe ALPha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 12/84 14%
[cursor 11,0]`,
	// page down
	`beta
gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
- big [Modified] 23/84 27%
[cursor 0,0]`,
	// page down again
	`gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
- big [Modified] 45/84 53%
[cursor 0,0]`,
	// page up
	`beta
gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
- big [Modified] 45/84 53%
[cursor 22,0]`,
	// search
	`gamma gamma gamma gamma
delta 4
alpha line one
alpha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
- big [Modified] 46/84 54%
[cursor 22,0]`,
	// bottom G
	`beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
delta 4
~
~
~
~
~
~
~
~
~
~
~
- big [Modified] 84/84 100%
[cursor 11,0]`,
	// edit at bottom
	`beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
delta 4
bottom
~
~
~
~
~
~
~
~
~
~
- big [Modified] 85/85 100%
[cursor 12,5]`,
	// top 1G
	`alpha line one
beta
gamma gamma gamma gamma
alpha line one
taixl
opened linINSe ALPha line one
beta
gamma gamma gamma gamma
delta 4
beta
alpha line one
beta
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
beta
gamma gamma gamma gamma
delta 4
delta 4
alpha line one
alpha line one
beta
- big [Modified] 1/85 1%
[cursor 0,0]`,
	// substitute
	`alpha line one
BETA
gamma gamma gamma gamma
delta 4
BETA
alpha line one
BETA
gamma gamma gamma gamma
delta 4
gamma gamma gamma gamma
alpha line one
BETA
gamma gamma gamma gamma
delta 4
delta 4
delta 4
bottom
~
~
~
~
~
~
- big [Modified] 80/85 94%
[cursor 11,0]`,
	// scroll to end
	`bottom
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
- big [Modified] 85/85 100%
[cursor 0,5]`,
	// quit
	`bottom
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
$
[cursor 23,2]`,
}
