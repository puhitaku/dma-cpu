package dmacc_test

// The wallclock regression suite (prompts/044). `ticks` counts
// scheduler quanta the injector DELIVERED; the kernel has no
// safepoints and the injector is one-shot, re-armed at kexit, so a
// long kernel stay delivers at most one. A 640x480 slide is drawn by
// ONE SYS_read, and `show` used to report it as 0.00s because it
// asked the tick counter how long it took.
//
// The fix reads the TIMER block's free-running microsecond counter at
// the point of use (target/xv6/dma/kproc.c: wall_now, wall_since,
// us_div). These tests are what keeps it honest: the draw reports a
// duration matching the cycles it actually took, the pair arithmetic
// survives the 32-bit microsecond wrap, and a timed sleeper wakes on
// the FIRST tick after its deadline rather than after n more ticks.

import (
	"fmt"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/fsimg"
)

// bigSlide is one full-size 480p slide: 307200 bytes, no zero bytes
// (so every framebuffer word is distinguishable from blank).
func bigSlide() []byte {
	s := make([]byte, 640*480)
	for i := range s {
		s[i] = byte(i*7 + 3)
		if s[i] == 0 {
			s[i] = 1
		}
	}
	return s
}

// showDuration pulls the hundredths out of one of show's "(S.HHs)"
// suffixes: `Done drawing /sd/big.sld (0.41s)` -> 41.
func showDuration(out, line string) (int, error) {
	i := strings.Index(out, line)
	if i < 0 {
		return 0, fmt.Errorf("no %q in the console", line)
	}
	rest := out[i:]
	if j := strings.IndexByte(rest, '\n'); j >= 0 {
		rest = rest[:j]
	}
	a := strings.LastIndex(rest, " (")
	b := strings.LastIndex(rest, "s)")
	if a < 0 || b < a {
		return 0, fmt.Errorf("no duration in %q", rest)
	}
	dur := rest[a+2 : b]
	dot := strings.IndexByte(dur, '.')
	if dot < 0 {
		return 0, fmt.Errorf("malformed duration %q", dur)
	}
	sec, err := strconv.Atoi(dur[:dot])
	if err != nil {
		return 0, fmt.Errorf("malformed duration %q: %w", dur, err)
	}
	hun, err := strconv.Atoi(dur[dot+1:])
	if err != nil {
		return 0, fmt.Errorf("malformed duration %q: %w", dur, err)
	}
	return sec*100 + hun, nil
}

// runBigSlide boots the feather xsh with a card holding one full-size
// slide, shows it, and returns the console plus the cycle span the
// draw took, measured INDEPENDENTLY of the kernel's own clock: from
// the machine cycle at which "Opened …" reached the console to the
// one at which "Done drawing …" did.
//
// Those two markers bracket exactly what show times. show_load logs
// "Opened", logs "Start drawing", takes uptime() into t0, runs the
// read loop, then takes uptime() again and logs "Done drawing" with
// the difference. The bracket is a hair wider than dt — one flushed
// log line at each end — and the draw is the rest of it. The middle
// marker is NOT usable: the SD driver borrows the console TX channel
// for the duration of the burst, so "Start drawing" only lands on the
// wire once the draw is over.
func runBigSlide(t *testing.T, prep func(m *emu.Machine)) (out string, drawCycles uint64) {
	t.Helper()
	fatb := fsimg.NewFAT32(4096) // 2 MiB card
	fatb.AddFile("BIG.SLD", bigSlide())
	sd := fatb.Bytes()

	m, _ := bootXshBoard(t, nil, boards.Feather)
	v := m.Variant()
	// Joystick pins idle high, as on the board: the viewer polls them.
	for _, pin := range []int{24, 26, 27, 28, 29} {
		m.Poke32(v.GPIOCtrlAddr(pin), v.GPIOOutCtrl(true))
	}
	m.SDImage = sd
	if prep != nil {
		prep(m)
	}
	m.FeedConsole("mkdir /sd\rmount sd0 /sd\rshow /sd/big.sld\r")

	var opened, done uint64
	sdr0 := 0
	for i := 0; i < 400_000; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		for serviceMailbox(m, m.Flash, sd) {
		}
		o := string(m.ConsoleOut)
		if opened == 0 && strings.Contains(o, "Opened /sd/big.sld") {
			opened, sdr0 = m.Cycle, m.SDReads
		}
		if done == 0 && strings.Contains(o, "Done drawing /sd/big.sld") {
			done = m.Cycle
			m.FeedConsole("q")
		}
		if done != 0 && strings.HasSuffix(o, "$ ") {
			// The slide really came off the card in between: 307200
			// bytes is 600 sectors, plus the FAT chain walk.
			if n := m.SDReads - sdr0; n < 600 {
				t.Fatalf("the draw served %d sectors, want >= 600", n)
			}
			return strings.ReplaceAll(string(m.ConsoleOut), "\r", ""), done - opened
		}
	}
	t.Fatalf("the slide was never drawn\nconsole:\n%s", m.ConsoleOut)
	return "", 0
}

// TestXv6ShowWallclock is the regression this whole change exists for.
// One SYS_read paints the slide; the scheduler delivers ~one tick
// across the whole of it, so the old tick-counting uptime reported
// 0.00s. The duration `show` prints must now match the cycles the
// draw really took, under the emulator's honest microsecond mapping
// (emu.DefaultCyclesPerUS).
func TestXv6ShowWallclock(t *testing.T) {
	t.Parallel()
	out, drawCycles := runBigSlide(t, nil)
	t.Logf("console:\n%s", out)

	got, err := showDuration(out, "Done drawing /sd/big.sld")
	if err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, out)
	}
	// Hundredths of a second the draw actually spent.
	want := int(drawCycles / emu.DefaultCyclesPerUS / 10000)
	t.Logf("draw bracket: %d cycles = %d us = %d.%02ds; show printed %d.%02ds",
		drawCycles, drawCycles/emu.DefaultCyclesPerUS,
		want/100, want%100, got/100, got%100)

	if got == 0 {
		t.Fatalf("show reported a 0.00s draw over %d cycles — the wallclock "+
			"is counting delivered ticks again", drawCycles)
	}
	// The bracket is slightly wider than what show times (a log line
	// at each end), so the printed figure sits just inside it.
	if got < want-3 || got > want+1 {
		t.Errorf("show printed %d.%02ds for a draw the harness clocked at "+
			"%d cycles (%d.%02ds); want within [%d, %d] hundredths",
			got/100, got%100, drawCycles, want/100, want%100, want-3, want+1)
	}
	// The kernel's own stamps come off the same clock and must move
	// across the draw: a boot-time [0.000] on every line was the same
	// bug wearing a different hat.
	if !strings.Contains(out, "[0.000] xv6-dma version ") {
		t.Errorf("the boot banner is not stamped at the epoch:\n%s", out)
	}
}

// TestXv6WallclockWrap runs the same draw with the microsecond
// counter's low word rolling over during it. That is the only thing
// exercising the wide half of the pair arithmetic — wall_since's
// borrow and us_div's high-word division — which the counter reaches
// on its own only after 71.6 minutes.
func TestXv6WallclockWrap(t *testing.T) {
	t.Parallel()
	// Park the machine 5 ms of wallclock short of the wrap. The boot
	// epoch is already captured by the time the prompt appears, so
	// the elapsed pair the kernel computes spans the rollover.
	const wrap = uint64(emu.DefaultCyclesPerUS) << 32
	out, drawCycles := runBigSlide(t, func(m *emu.Machine) {
		m.Cycle = wrap - 5000*emu.DefaultCyclesPerUS
	})
	t.Logf("console:\n%s", out)

	got, err := showDuration(out, "Done drawing /sd/big.sld")
	if err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, out)
	}
	want := int(drawCycles / emu.DefaultCyclesPerUS / 10000)
	t.Logf("across the 32-bit microsecond wrap: %d cycles = %d.%02ds; "+
		"show printed %d.%02ds", drawCycles, want/100, want%100, got/100, got%100)
	if got == 0 || got < want-3 || got > want+1 {
		t.Errorf("show printed %d.%02ds across the counter wrap for a draw the "+
			"harness clocked at %d cycles (%d.%02ds)",
			got/100, got%100, drawCycles, want/100, want%100)
	}
	// The kernel's own stamps are the direct read of the pair. Elapsed
	// here really is ~4295 s of emulated wallclock (the machine was
	// parked just short of the rollover), so the stamps must cross
	// 2^32 us = 4294.967296 s and stay ordered while they do. A stale
	// high word paired with a fresh low one lands a full 4295 s out —
	// either back at zero or up around 8590 — and breaks one of the
	// two.
	stamps := kernelStamps(out)
	if len(stamps) < 3 {
		t.Fatalf("expected the boot and SD stamps in the console:\n%s", out)
	}
	const wrapMS = uint64(1) << 32 / 1000 // 4294967 ms
	var crossed bool
	for i, ms := range stamps {
		if i > 0 && ms < stamps[i-1] {
			t.Errorf("kernel stamps ran backwards: %d ms after %d ms\n%s",
				ms, stamps[i-1], out)
		}
		if ms >= wrapMS {
			crossed = true
		}
		if ms > wrapMS+60_000 {
			t.Errorf("kernel stamp at %d ms is 4295 s past the session — "+
				"the high-low-high read paired mismatched halves\n%s", ms, out)
		}
	}
	if !crossed {
		t.Errorf("no kernel stamp crossed %d ms: this session never exercised "+
			"the wide half of the pair arithmetic\n%s", wrapMS, out)
	}
}

// kernelStamps reads the milliseconds out of every klogts() stamp in a
// console transcript. The kernel's stamps carry THREE fraction digits
// ("[4294.990] sd: …"); show's user-side stamps carry two, which is
// what tells the two apart on a line-by-line scan.
func kernelStamps(out string) []uint64 {
	var ms []uint64
	for _, ln := range strings.Split(out, "\n") {
		if !strings.HasPrefix(ln, "[") {
			continue
		}
		close := strings.IndexByte(ln, ']')
		dot := strings.IndexByte(ln, '.')
		if close < 0 || dot < 0 || dot > close || close-dot != 4 {
			continue
		}
		sec, err := strconv.ParseUint(ln[1:dot], 10, 64)
		if err != nil {
			continue
		}
		frac, err := strconv.ParseUint(ln[dot+1:close], 10, 64)
		if err != nil {
			continue
		}
		ms = append(ms, sec*1000+frac)
	}
	return ms
}

// TestXv6PauseDeadline is Option B: a timed sleeper holds a
// MICROSECOND deadline, so it wakes on the first tick after that
// deadline passes — not after n more ticks are delivered. The
// difference only shows when ticks go missing, which is the normal
// case here: fbtest sleeps 1000 quanta (100 ms), and a kernel stay
// that long delivers one tick, not a thousand.
func TestXv6PauseDeadline(t *testing.T) {
	t.Parallel()
	m, kernC := bootXshBoard(t, nil, boards.Feather)
	tk := mustSym(t, kernC, "g_ticks")
	v := m.Variant()

	m.FeedConsole("fbtest\r")
	// Run until fbtest reaches its pause(1000).
	slot := -1
	for i := 0; i < 20000 && slot < 0; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		if !strings.Contains(string(m.ConsoleOut), "test card up") {
			continue
		}
		for s := 0; s < 8; s++ {
			if procField(m, kernC, s, pfState) == stSleeping &&
				procField(m, kernC, s, pfChan) == mustSym(t, kernC, "g_ticks") {
				slot = s
				break
			}
		}
	}
	if slot < 0 {
		t.Fatalf("fbtest never parked in pause()\nconsole:\n%s", m.ConsoleOut)
	}

	now, err := m.Read(v.TimerRawL, 4)
	if err != nil {
		t.Fatal(err)
	}
	deadline := procField(m, kernC, slot, pfWakeUS)
	// pause(1000): 1000 quanta of 100 us. The deadline is that far
	// ahead of the moment it was armed, which is at most this instant.
	if ahead := int32(deadline - now); ahead <= 0 || ahead > 100_000 {
		t.Errorf("wake_us is %d us from now, want a deadline in (0, 100000] "+
			"— pause(1000) is 100 ms", ahead)
	}
	t.Logf("slot %d sleeping with a deadline %d us out (now=%d)",
		slot, int32(deadline-now), now)

	// The long kernel stay, synthesized: time passes, no tick is
	// delivered. Under a tick-counted deadline the sleeper would now
	// need 1000 more deliveries; under a microsecond one it needs the
	// next tick and nothing else.
	m.Cycle += uint64(uint32(deadline-now)+50) * emu.DefaultCyclesPerUS
	before := m.Peek32(tk)
	woke := uint32(0)
	for i := 0; i < 200; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		if procField(m, kernC, slot, pfState) != stSleeping {
			woke = m.Peek32(tk) - before
			break
		}
	}
	if woke == 0 && procField(m, kernC, slot, pfState) == stSleeping {
		t.Fatalf("the sleeper never woke after its deadline passed (%d ticks "+
			"delivered)", m.Peek32(tk)-before)
	}
	// One delivered tick is the whole cost. Allow the second that a
	// sampling boundary can add; a thousand would be the old bug.
	if woke > 2 {
		t.Errorf("the sleeper needed %d delivered ticks after its deadline "+
			"had already passed; a microsecond deadline needs the next one",
			woke)
	}
	t.Logf("woke %d delivered tick(s) after the deadline passed", woke)
}

// parkFbtest runs `fbtest` to its pause(1000) and returns the slot it
// parked in. The 100 ms deadline is the longest sleep in the tree and
// the one a 10 kHz tick has to skip a thousand ticks' worth of walk
// for, which is what these tests are about.
func parkFbtest(t *testing.T, m *emu.Machine, kernC *dmaasm.Result) int {
	t.Helper()
	before := strings.Count(string(m.ConsoleOut), "test card up")
	m.FeedConsole("fbtest\r")
	for i := 0; i < 20000; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		if strings.Count(string(m.ConsoleOut), "test card up") <= before {
			continue
		}
		for s := 0; s < 8; s++ {
			if procField(m, kernC, s, pfState) == stSleeping &&
				procField(m, kernC, s, pfChan) == mustSym(t, kernC, "g_ticks") {
				return s
			}
		}
	}
	t.Fatalf("fbtest never parked in pause()\nconsole:\n%s", m.ConsoleOut)
	return -1
}

// TestXv6TickGuard: the cached earliest deadline (kproc.c next_us)
// makes the deadline walk per-DEADLINE work instead of per-tick work.
//
// Before it, every delivered tick with any timed sleeper standing read
// TIMERAWL and compared all eight proc slots. A 10 kHz tick against
// pause(1000) does that a thousand times to wake one process once; on
// the nyancat frame loop it was 7.9% of every record the kernel ran,
// ~900 of ~1050 walks a frame waking nobody.
//
// The probe is the walk's own entry word. tick_wake is a whole
// function outside .ramtext now, so a profile window over the kernel's
// XIP text counts its first instruction fetch exactly once per call —
// the walk count, with no counter in the shipped kernel to pay for it.
func TestXv6TickGuard(t *testing.T) {
	t.Parallel()
	bd := boards.Feather
	m, kernC := bootXshBoard(t, nil, bd)
	v := m.Variant()
	tk := mustSym(t, kernC, "g_ticks")
	kTxt := textWindow(kernC, bd.KernTextXIP)
	entry := mustSym(t, kernC, "f_tick_wake")
	if entry < kTxt[0] || entry >= kTxt[1] {
		t.Fatalf("tick_wake sits at %#x, outside the kernel's XIP text "+
			"[%#x,%#x) — the walk belongs in flash, not in the resident "+
			"window (kproc.c, dmxgen kernResident)", entry, kTxt[0], kTxt[1])
	}
	walks := func() uint32 { return m.ProfileCountsAt(0)[(entry-kTxt[0])/4] }

	slot := parkFbtest(t, m, kernC)
	deadline := procField(m, kernC, slot, pfWakeUS)
	if got := m.Peek32(mustSym(t, kernC, "g_next_us")); got != deadline {
		t.Errorf("next_us is %#x with the only timed sleeper due at %#x — "+
			"arm_timed must fold every deadline into the cache", got, deadline)
	}
	if m.Peek32(mustSym(t, kernC, "g_ntimed")) == 0 {
		t.Fatal("ntimed is 0 with a sleeper parked on &ticks")
	}

	// Ticks well short of the deadline: the guard skips every one of
	// them. 300 quanta is 30 ms against a 100 ms sleep.
	m.ProfileWindows([][2]uint32{kTxt})
	const quiet = 300
	for at := m.Peek32(tk); m.Peek32(tk)-at < quiet; {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
	}
	if now, err := m.Read(v.TimerRawL, 4); err == nil && int32(now-deadline) >= 0 {
		t.Fatalf("the deadline passed during the quiet phase (now %#x, "+
			"deadline %#x) — the test measured the wrong thing", now, deadline)
	}
	if n := walks(); n != 0 {
		t.Errorf("%d deadline walk(s) over %d delivered ticks that could not "+
			"wake anybody; the next_us guard should have skipped all of them",
			n, quiet)
	}
	t.Logf("%d delivered ticks short of the deadline: %d walks", quiet, walks())

	// The deadline arrives. Exactly one walk, and it wakes the sleeper.
	now, err := m.Read(v.TimerRawL, 4)
	if err != nil {
		t.Fatal(err)
	}
	m.Cycle += uint64(uint32(deadline-now)+50) * emu.DefaultCyclesPerUS
	m.ProfileWindows([][2]uint32{kTxt})
	woke := false
	for i := 0; i < 200 && !woke; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		woke = procField(m, kernC, slot, pfState) != stSleeping
	}
	if !woke {
		t.Fatal("the sleeper never woke after its deadline passed")
	}
	if n := walks(); n != 1 {
		t.Errorf("%d walks to wake one due sleeper, want exactly 1", n)
	}
	// ntimed is the hint the whole guard hangs off, and the one thing it
	// may never be is stale LOW — next_us has no "none" sentinel, so
	// ntimed == 0 is what tells arm_timed to SET the cache instead of
	// minimizing into a value from an older epoch. Check that direction,
	// not the count: by the time the wake is observable another process
	// may legitimately have armed one (the run continues in whole
	// chunks), and a nonzero hint with nobody sleeping is merely the
	// documented stale-EARLY case.
	timed := 0
	for s := 0; s < 8; s++ {
		if procField(m, kernC, s, pfState) != stSleeping {
			continue
		}
		if ch := procField(m, kernC, s, pfChan); ch == tk ||
			ch == mustSym(t, kernC, "g_selwait_to") {
			timed++
		}
	}
	if timed > 0 && m.Peek32(mustSym(t, kernC, "g_ntimed")) == 0 {
		t.Errorf("ntimed is 0 with %d timed sleeper(s) parked; the hint may "+
			"run high but never low — arm_timed reads it as \"next_us holds "+
			"nothing\"", timed)
	}
	t.Logf("deadline reached: %d walk, sleeper woke, ntimed %d with %d timed "+
		"sleeper(s) left", walks(), m.Peek32(mustSym(t, kernC, "g_ntimed")), timed)
}

// TestXv6TickGuardStaleEarly: the other half of the next_us invariant.
// The cache is allowed to run EARLY and never late, so the interesting
// case is a timed sleeper that leaves by a door other than its own
// deadline — and the tree has exactly one program that opens it.
// nyancat parks in select(fd 0, DELAY_TICKS) once a frame; a keystroke
// commits input, cons_poll calls sel_wake, and the sleeper is RUNNABLE
// with a deadline nobody holds still standing in next_us.
//
// What must survive that: the next timed sleeper still wakes. The
// stale minimum is allowed to cost ONE walk that wakes nobody — the
// walk that recomputes it — and nothing more.
func TestXv6TickGuardStaleEarly(t *testing.T) {
	t.Parallel()
	bd := boards.Feather
	m, kernC := bootXshBoard(t, nil, bd)
	v := m.Variant()
	tk := mustSym(t, kernC, "g_ticks")
	selTo := mustSym(t, kernC, "g_selwait_to")
	nextUS := mustSym(t, kernC, "g_next_us")
	kTxt := textWindow(kernC, bd.KernTextXIP)
	entry := mustSym(t, kernC, "f_tick_wake")
	walks := func() uint32 { return m.ProfileCountsAt(0)[(entry-kTxt[0])/4] }

	// Park nyancat in its per-frame select.
	m.FeedConsole("nyancat\r")
	slot := -1
	for i := 0; i < 40000 && slot < 0; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 500_000}); err != nil {
			t.Fatalf("nyancat: %v (tail %q)", err, tailB(m.ConsoleOut, 200))
		}
		for s := 0; s < 8; s++ {
			if procField(m, kernC, s, pfState) == stSleeping &&
				procField(m, kernC, s, pfChan) == selTo {
				slot = s
			}
		}
	}
	if slot < 0 {
		t.Fatalf("nyancat never parked in a timed select (tail %q)",
			tailB(m.ConsoleOut, 200))
	}
	sel := procField(m, kernC, slot, pfWakeUS)
	if got := m.Peek32(nextUS); got != sel {
		t.Errorf("next_us is %#x with the only timed sleeper — a select "+
			"timeout — due at %#x; SYS_select must arm through arm_timed too",
			got, sel)
	}

	// A keystroke, not the deadline. nyancat's select returns nonzero
	// and it leaves; next_us keeps pointing at a timeout that will
	// never be claimed.
	m.FeedConsole("q")
	for i := 0; i < 40000; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 500_000}); err != nil {
			t.Fatalf("nyancat exit: %v (tail %q)", err, tailB(m.ConsoleOut, 200))
		}
		if strings.HasSuffix(string(m.ConsoleOut), "$ ") {
			break
		}
	}
	if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
		t.Fatalf("nyancat did not return to the prompt (tail %q)",
			tailB(m.ConsoleOut, 200))
	}

	// The next timed sleeper, armed on top of whatever the early wake
	// left behind.
	m.ProfileWindows([][2]uint32{kTxt})
	fb := parkFbtest(t, m, kernC)
	deadline := procField(m, kernC, fb, pfWakeUS)
	armWalks := walks()
	if armWalks > 1 {
		t.Errorf("%d walks between the early wake and the next arming; a "+
			"stale-early next_us costs one walk that wakes nobody and then "+
			"settles", armWalks)
	}
	for at := m.Peek32(tk); m.Peek32(tk)-at < 200; {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
	}
	if n := walks() - armWalks; n > 1 {
		t.Errorf("%d walks over 200 ticks short of the new deadline; the "+
			"first one recomputes the minimum and the rest should be skipped", n)
	}
	// And the wake itself is not lost, which is what stale-LATE would
	// have cost.
	now, err := m.Read(v.TimerRawL, 4)
	if err != nil {
		t.Fatal(err)
	}
	m.Cycle += uint64(uint32(deadline-now)+50) * emu.DefaultCyclesPerUS
	woke := false
	for i := 0; i < 200 && !woke; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000}); err != nil {
			t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
		}
		woke = procField(m, kernC, fb, pfState) != stSleeping
	}
	if !woke {
		t.Fatal("the sleeper armed after an early wake never woke — a " +
			"stale-LATE next_us is a missed wake, which is the one thing " +
			"the cache may not do")
	}
	t.Logf("early wake left %d cleanup walk(s); the next deadline still woke", armWalks)
}
