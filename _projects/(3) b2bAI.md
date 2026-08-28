---
name: b2bAI
tools: [JUCE, C++, Python, DEAP, Genetic Algorithms, Pybind11, VST, Audio Plugin, Music Theory]
image: /assets/img/b2bAI.png
description: An interactive audio plugin that generates, mutates, and combines MIDI sequences using multi-objective genetic algorithms and algorithmic complexity metrics.
---

# b2bAI: Evolutionary MIDI Generation

b2bAI is an interactive audio plugin that uses evolutionary algorithms to generate, continue, and mutate MIDI sequences. Developed as my undergraduate thesis in Computer Science at the University of Bucharest, the project bridges algorithmic composition with direct user interaction inside standard Digital Audio Workstations (DAWs).

![Plugin Interface](/assets/img/b2bAI/interfata.jpeg){:class="img-fluid rounded"}

## The Core Concept

Most algorithmic composition systems are autonomous black boxes: they produce entire pieces without user guidance. b2bAI approaches algorithmic music as a collaborative process. Musicians configure musical constraints—such as syncopation levels, scale modes, consonance ratios, and note densities—while genetic algorithms evolve candidate phrases in real time.

## System Architecture

The project connects a C++ audio plugin to a Python evolutionary engine:

![System Architecture](/assets/img/b2bAI/Architecture.png){:class="img-fluid rounded"}

- **Audio Plugin (C++ / JUCE)**: Packaged as VST3, AU, and Standalone applications. The user interface uses `foleys_gui_magic` to render an interactive 8-track piano roll, MIDI file browser, and configuration panels.
- **Genetic Engine (`midi-generator`, Python / DEAP)**: Evaluates populations of musical phrases using multi-objective fitness functions.
- **Interoperability Bridge (C++ / Pybind11)**: Runs an embedded Python interpreter directly inside the C++ plugin process, passing note arrays and parameters across language boundaries without disk serialization.

## Evolutionary Mechanics

### Chromosome Representation
A musical sequence is encoded as a discrete array of metric pulses (ticks). Each `Gene` struct contains:
- `pitch`: MIDI note number (0–127)
- `velocity`: Note velocity (0–127)
- `remaining_ticks`: Remaining duration of the sounding note

To handle notes spanning multiple ticks, custom decorators intercept crossover and mutation events, repairing `remaining_ticks` so note lengths remain musically coherent.

```
Individual: [ (C4, 90, 3), (C4, 90, 2), (C4, 90, 1), (Rest, 0, 0), (G4, 80, 2), (G4, 80, 1) ]
```

### Generation via Multi-Objective Optimization (NSGA-II)
The `generate` command evolves melodies from scratch using the **NSGA-II** selection operator across three competing musical fitness objectives:

1. **Syncopation**: Quantified using either the **Weighted Note-to-Beat Distance (WNBD)** metric or rhythmic **Off-beatness**.
2. **Note Density**: The ratio of active note pulses against the total bar length.
3. **Consonance Ratio**: The proportion of pitches belonging to the selected root key and musical mode (Major, Minor, Dorian, Phrygian, Lydian, Mixolydian, Locrian).

![Fitness Evolution](/assets/img/b2bAI/genetic.png){:class="img-fluid rounded"}

### Continuation & Combination via Normalized Compression Distance (NCD)
The `continue` and `combine` functions extrapolate existing motifs or blend two parent melodies. To assess how closely a child sequence matches the structural style of a reference pattern, the fitness function calculates the **Normalized Compression Distance (NCD)**:

$$NCD(x, y) = \frac{\max(C(xy) - C(x), C(yx) - C(y))}{\max(C(x), C(y))}$$

Where $C(x)$ approximates the **Kolmogorov complexity** of a sequence using dictionary compression algorithms (LZ77, LZ78, or LZW). Sequences that compress efficiently alongside the reference motif score higher fitness.

## Plugin Features

- **8-Track Piano Roll**: Inspect, edit, resize, and draw notes with mouse and scroll-wheel controls.
- **Integrated File Management**: Browse local directories, preview MIDI files, and export generated phrases directly to disk.
- **Four Operational Modes**:
  - **Generate**: Create brand-new sequences from rhythm and scale parameters.
  - **Mutate**: Apply controlled pitch, velocity, and duration mutations to an existing loop.
  - **Continue**: Extend a short melodic phrase into a longer section using NCD similarity.
  - **Combine**: Merge rhythmic and melodic traits from multiple seed tracks.

![Piano Roll](/assets/img/b2bAI/pianoroll.jpeg){:class="img-fluid rounded"}

## Technical Stack

- **Audio & UI Framework**: JUCE 7, `foleys_gui_magic`, Boost (Unit Test & Logging)
- **Evolutionary Computation**: Python 3.10, DEAP, NumPy
- **Language Bindings**: Pybind11 (embedded interpreter)
- **Build System**: CMake 3.23, GNU Make, Clang

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/b2bAI" text="Github" size="lg" style="primary" %}
</p>