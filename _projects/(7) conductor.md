---
name: Gesture Conductor
tools: [Python, MediaPipe, OpenCV, Computer Vision, MIDI, Music Theory, LilyPond, TidalCycles]
image: /assets/img/conductor.png
description: Real-time conducting gesture interface and SATB figured bass harmonization engine using computer vision and MIDI.
---

# Gesture Conductor

Gesture Conductor turns a webcam into an interactive conducting interface paired with an automatic figured bass realization engine. It tracks hand gestures in real time to extract tempo, dynamics, and articulation, driving a four-part SATB harmony over multi-channel MIDI.

![Gesture Conductor Preview](/assets/img/conductor.png){:class="img-fluid rounded"}

## Overview

The system bridges computer vision with classical music theory across two subsystems:

1. **Vision & Kinematics**: MediaPipe tracks 3D hand landmarks from a standard video feed. The beat detector analyzes vertical inflection points to estimate tempo (30–240 BPM), maps hand velocity to MIDI dynamics (velocity 0–127), and derives articulation (legato vs. staccato duration) from gesture sharpness.
2. **Figured Bass Realization Engine**: A rule-based music theory module parses LilyPond score files (`.ily`, `.ly`) and harmonizes figured bass lines into four-part SATB arrangements following common-practice voice leading rules.

In interactive mode, each downward and upward conducting bounce triggers the next chord in the progression, synchronizing the ensemble to the conductor's live tempo and phrasing.

## Figured Bass & Voice Leading Engine

The realization engine reads LilyPond files containing a bass voice and a `\figuremode` block, generating four distinct vocal lines:

```lilypond
<<
  \new Voice { 
    \clef bass 
    c4 f g c | d g c2
  }
  \new FiguredBass {
    \figuremode {
      <_>4 <6> <7> <_> | <6> <7> <_>2
    }
  }
>>
```

### Supported Notation
- **Figures**: Root position (`<5 3>`, `<_>`), first inversion (`<6>`), second inversion (`<6 4>`), and 7th chords with inversions (`<7>`, `<6 5>`, `<4 3>`, `<4 2>`).
- **Accidentals**: Sharps (`+`), flats (`-`), and naturals (`!`).
- **Durations**: Whole (`1`), half (`2`), quarter (`4`), 8th (`8`), 16th (`16`), and 32nd (`32`) notes.

### Voice Leading Rules
The generator evaluates candidate chord voicings against classical counterpoint constraints:
- **Vocal ranges**: Soprano (C4–A5), Alto (G3–D5), Tenor (C3–A4), Bass (E2–E4).
- **Voice spacing**: Limits interval distance between adjacent upper voices (S–A, A–T) to at most one octave.
- **Motion constraints**: Strictly prohibits parallel fifths and octaves in strict mode, prioritizes common-tone retention, minimizes total voice movement, and favors contrary motion between soprano and bass.

## Multi-Channel MIDI & Live Coding

The output layer routes each vocal part to a separate MIDI channel:
- **Channel 1**: Soprano
- **Channel 2**: Alto
- **Channel 3**: Tenor
- **Channel 4**: Bass

By transmitting over virtual MIDI ports (such as the macOS IAC Driver or loopMIDI on Windows), the engine connects directly to DAWs like Ableton Live, Logic Pro, and Reaper to control software instruments or hardware synthesizers.

The engine also includes an exporter that converts realized progressions into pattern definitions for the TidalCycles live coding environment.

## Architecture

```
conductor/
├── src/
│   ├── gesture_conductor/        # Vision, kinematics & gesture detection
│   │   ├── detector.py           # MediaPipe hand tracker
│   │   ├── beat_detector.py      # Beat trajectory & tempo analyzer
│   │   ├── conductor.py          # Musical gesture analyzer
│   │   └── visualiser.py         # OpenCV HUD and trajectory overlay
│   └── realization/              # Music theory, parsing & MIDI engine
│       ├── lilypond_parser.py    # AST parser for LilyPond scores
│       ├── generator.py          # 4-part SATB voice leading realizer
│       ├── midi_communicator.py  # Multi-channel MIDI output handler
│       ├── adaptive_midi_player.py # Tempo-synchronized MIDI sequencer
│       └── tidal_exporter.py     # TidalCycles pattern exporter
├── examples/                     # Figured bass score files (.ily)
├── scripts/                      # CLI tools for standalone playback & analysis
│   ├── play_figured_bass_midi.py
│   ├── realize_figured_bass.py
│   └── export_to_tidal.py
└── main_conductor_midi.py        # Integrated live conducting application
```

## CLI & Interactive Controls

### Keybindings

| Key | Action |
|:---|:---|
| **SPACE** | Start / pause gesture tracking and MIDI playback |
| **R** | Reset conductor state and rewind score to start |
| **C** | Clear gesture trajectory trails and history |
| **Q** | Exit application |

### CLI Utilities

```bash
# Realize figured bass and inspect voice leading
python scripts/realize_figured_bass.py examples/figured_bass.ily

# Standalone MIDI playback with fixed BPM and velocity
python scripts/play_figured_bass_midi.py examples/figured_bass.ily 120 80

# Export realized progression to TidalCycles pattern
python scripts/export_to_tidal.py examples/figured_bass.ily output.tidal
```

## Technical Stack

- **Computer Vision**: MediaPipe HandLandmarker, OpenCV
- **Audio & MIDI**: Mido, `python-rtmidi`
- **Language & Tooling**: Python 3.12, UV package manager
- **Testing & Quality**: pytest, Ruff, Black

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/conductor" text="Github" size="lg" style="primary" %}
</p>
