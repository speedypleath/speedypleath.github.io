---
name: b2bAI
tools: [JUCE, C++, Python, DEAP, Genetic Algorithms, Pybind11, VST, Audio Plugin, Music Theory]
image: /assets/img/b2bAI.png
description: Interactive audio plugin that generates, mutates, and combines MIDI sequences using multi-objective genetic algorithms and algorithmic complexity metrics.
---

# b2bAI: Evolutionary MIDI Generation

b2bAI is an interactive audio plugin that uses evolutionary algorithms to generate, continue, and mutate MIDI sequences. Developed as my undergraduate thesis in Computer Science at the University of Bucharest, the project brings algorithmic composition directly into digital audio workstations (DAWs) as a collaborative, real-time creative tool.

![Plugin Interface](/assets/img/b2bAI/interfata.jpeg){:class="img-fluid rounded"}

## The Core Concept

Most algorithmic composition systems function as autonomous black boxes, generating entire pieces without human intervention. b2bAI treats algorithmic music as a collaborative process. The musician sets musical constraints, including syncopation levels, scale modes, consonance ratios, and note densities, while genetic algorithms evolve candidate phrases in real time.

## System Architecture

The software pairs a high-performance C++ audio plugin with a Python evolutionary engine:

![System Architecture](/assets/img/b2bAI/Architecture.png){:class="img-fluid rounded"}

- **Audio Plugin (C++ / JUCE)**: Packaged in VST3, AU, and standalone formats. The interface uses `foleys_gui_magic` to provide an 8-track piano roll, a local MIDI file browser, and dedicated parameter controls.
- **Genetic Engine (`midi-generator`, Python / DEAP)**: Evaluates candidate musical phrases using multi-objective fitness functions.
- **Interoperability Bridge (C++ / Pybind11)**: Runs an embedded Python interpreter inside the audio processor, exchanging note arrays and parameter structs in memory without disk writes.

## Evolutionary Mechanics

### Chromosome Representation
Musical sequences are represented as discrete metric pulse arrays (ticks). Each `Gene` struct stores:
- `pitch`: MIDI note number (0 to 127)
- `velocity`: Note velocity (0 to 127)
- `remaining_ticks`: Remaining duration of the active note

When mutation or crossover alters note lengths across several ticks, custom decorators repair `remaining_ticks` across consecutive genes to maintain rhythmic continuity.

```
Individual: [ (C4, 90, 3), (C4, 90, 2), (C4, 90, 1), (Rest, 0, 0), (G4, 80, 2), (G4, 80, 1) ]
```

### Generation with Multi-Objective Optimization (NSGA-II)
The `generate` command evolves melodic phrases from scratch using **NSGA-II** selection across three fitness criteria:

1. **Syncopation**: Measured via the **Weighted Note-to-Beat Distance (WNBD)** metric or rhythmic **Off-beatness**.
2. **Note Density**: The ratio of sounding pulses to total bar length.
3. **Consonance Ratio**: The proportion of pitches matching the selected root key and mode (Major, Minor, Dorian, Phrygian, Lydian, Mixolydian, or Locrian).

![Fitness Evolution](/assets/img/b2bAI/genetic.png){:class="img-fluid rounded"}

### Continuation and Combination via Normalized Compression Distance (NCD)
The `continue` and `combine` functions extend musical motifs or merge two parent sequences. To measure how closely a candidate phrase matches the structural patterns of a seed melody, the fitness function computes the **Normalized Compression Distance (NCD)**:

$$NCD(x, y) = \frac{\max(C(xy) - C(x), C(yx) - C(y))}{\max(C(x), C(y))}$$

$C(x)$ estimates the **Kolmogorov complexity** of a sequence using dictionary compression (LZ77, LZ78, or LZW). Phrases that compress efficiently alongside the reference motif receive higher fitness scores.

## Plugin Features

- **8-Track Piano Roll**: Draw, edit, resize, and delete notes directly on the grid.
- **File Management**: Inspect local directories, audition MIDI files, and export generated phrases to disk.
- **Four Generation Modes**:
  - **Generate**: Synthesize new phrases from rhythmic and modal parameters.
  - **Mutate**: Apply controlled pitch, velocity, and duration variations to an existing loop.
  - **Continue**: Extend a melodic idea using NCD structural similarity.
  - **Combine**: Blend motifs and rhythmic structures from multiple tracks.

![Piano Roll](/assets/img/b2bAI/pianoroll.jpeg){:class="img-fluid rounded"}

## Technical Stack

- **Audio and UI**: JUCE 7, `foleys_gui_magic`, Boost (Unit Testing and Logging)
- **Evolutionary Engine**: Python 3.10, DEAP, NumPy
- **Language Bindings**: Pybind11 (embedded runtime)
- **Build System**: CMake 3.23, GNU Make, Clang

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/b2bAI" text="Github" size="lg" style="primary" %}
</p>