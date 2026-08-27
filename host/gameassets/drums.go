package gameassets

import (
	"encoding/binary"
	"math"
)

// DrumPCM synthesizes the sequencer's five-drum kit — ports of the
// renderers that used to run ON the machine into a 40 KiB SRAM arena
// (the kick gained a properly descending pitch sweep on the way).
// Moving the synthesis to build time lets the PCM live in the flash
// blob like every other clip (the ring copier streams it by DMA
// either way) and returns the whole arena to the data segment.
// Frames are stereo-duplicated 16-bit samples, one word per frame.
//
//	kick    triangle wave gliding down in pitch (808-style)
//	snare   square wave, high and short
//	tom     square wave, lower, with a slight droop
//	hat     1-bit LFSR white noise, very short
//	cymbal  1-bit LFSR white noise, long tail
//
// Lengths must match seq.c's dlen table: the step copier moves
// dlen[i]*4 bytes per hit.
func DrumPCM() [][]byte {
	kick := renderKick(2800)
	snare := renderSquare(1900, 67, false, 10000, 9)
	tom := renderSquare(2000, 138, true, 12000, 11)
	hat := renderNoise(800, 9000, 7)
	cym := renderNoise(2700, 9000, 10)
	out := [][]byte{kick, snare, tom, hat, cym}
	for _, d := range out {
		fadeEnds(d)
	}
	return out
}

func frame(s int) uint32 {
	us := uint32(uint16(s))
	return us<<16 | us
}

func renderKick(n int) []byte {
	// An explicit DESCENDING pitch sweep with a separate amplitude
	// envelope. The old slope/amp triangle was subtly backwards: the
	// pitch is slope/(4*amp), and amp decayed FASTER than slope, so
	// the "glide" actually rose. Synthesis runs on the host now, so
	// the honest float form costs nothing: ~500 Hz punch diving to a
	// ~115 Hz body over 8 ms, then a steady thump fading out.
	d := make([]byte, 4*n)
	const f0, f1, fs = 500.0, 115.0, 44100.0
	phase := 0.0
	for i := 0; i < n; i++ {
		f := f1 + (f0-f1)*math.Exp(-float64(i)/(0.008*fs))
		phase += f / fs
		if phase >= 1 {
			phase -= 1
		}
		tri := 4*math.Abs(phase-0.5) - 1 // -1..1 triangle
		env := math.Exp(-float64(i) / 1400)
		binary.LittleEndian.PutUint32(d[4*i:], frame(int(14000*tri*env)))
	}
	return d
}

func renderSquare(n, half int, glide bool, amp, dk int) []byte {
	d := make([]byte, 4*n)
	ph, pol := 0, 1
	for i := 0; i < n; i++ {
		ph++
		if ph >= half {
			ph = 0
			pol = -pol
		}
		if glide && i&31 == 0 {
			half++
		}
		amp -= amp >> dk
		v := amp
		if pol <= 0 {
			v = -amp
		}
		binary.LittleEndian.PutUint32(d[4*i:], frame(v))
	}
	return d
}

func renderNoise(n, amp, dk int) []byte {
	d := make([]byte, 4*n)
	x := uint32(0x1D872B41)
	for i := 0; i < n; i++ {
		x ^= x << 13
		x ^= x >> 17
		x ^= x << 5
		amp -= amp >> dk
		v := amp
		if x&1 == 0 {
			v = -amp
		}
		binary.LittleEndian.PutUint32(d[4*i:], frame(v))
	}
	return d
}

// fadeEnds: steep fade-in/out on a drum's ends (48 frames each) —
// the raw waveforms start and stop mid-swing, an audible pop.
func fadeEnds(d []byte) {
	fade := func(i, sh int) {
		w := binary.LittleEndian.Uint32(d[4*i:])
		s := int(int16(uint16(w))) >> sh
		binary.LittleEndian.PutUint32(d[4*i:], frame(s))
	}
	n := len(d) / 4
	for k := 0; k < 6; k++ {
		for i := 0; i < 8; i++ {
			fade(k*8+i, 6-k)
			fade(n-48+k*8+i, k+1)
		}
	}
}
