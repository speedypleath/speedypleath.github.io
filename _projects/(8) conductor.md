---
name: Gesture Conductor
tools: [Python, MediaPipe, OpenCV, Computer Vision]
image: /assets/img/conductor.png
description: Real-time conducting gesture recognition system that detects hand movements and extracts musical parameters
---

# Gesture Conductor

A real-time conducting gesture recognition system that detects hand movements and extracts musical parameters like tempo, articulation, and beat timing using computer vision and MediaPipe.

## Overview

Gesture Conductor transforms your webcam into a musical conducting interface. Using advanced computer vision and hand tracking, it recognizes conducting gestures in real-time and extracts key musical parameters:

- **Tempo Detection**: Automatically calculates BPM from conducting motion
- **Beat Tracking**: Identifies downbeats and beat patterns
- **Articulation Analysis**: Detects gesture dynamics (legato, staccato, etc.)
- **Real-time Visualization**: Visual feedback of detected gestures and parameters

## Technical Stack

Built with modern Python tools for computer vision and signal processing:

- **MediaPipe**: Google's hand tracking solution for robust gesture detection
- **OpenCV**: Real-time video processing and visualization
- **Python 3.9+**: Core application logic
- **UV Package Manager**: Fast, reliable dependency management

## Features

### Core Capabilities

- Real-time hand tracking with sub-frame latency
- Musical parameter extraction (tempo, beat positions, articulation)
- Visual feedback system with gesture trails and beat indicators
- Session recording and data export
- Configurable sensitivity and detection parameters

### Controls

- **SPACE**: Toggle beat detection
- **R**: Reset beat history
- **S**: Save session data
- **Q/ESC**: Exit application

## Use Cases

- **Music Education**: Teaching conducting techniques with immediate visual feedback
- **Performance Practice**: Solo rehearsal tool for conductors
- **Interactive Installations**: Gesture-based music control for exhibitions
- **Research**: Conducting gesture analysis and tempo extraction studies

## Development

The project follows modern Python best practices:

- Type hints throughout codebase
- Comprehensive test coverage with pytest
- Code formatting with Black and Ruff
- Modular architecture for easy extension

## Architecture

```
gesture_conductor/
├── detector.py        # Hand tracking and gesture detection
├── beat_detector.py   # Beat detection and tempo extraction
├── musical_params.py  # Musical parameter extraction
├── visualizer.py      # Real-time visualization
└── main.py           # Application entry point
```

Each module is independently testable and designed for reusability in other music-tech projects.

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/conductor" text="Github" size="lg" style="primary" %}
</p>
