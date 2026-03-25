---
name: pytranspleet
tools: [Python, JavaScript, TypeScript, HTML, CSS]
image:
description: Audio application for splitting stems and transcribing notes from audio files
---

# Split stems and transcribe notes from audio files

![pytranspleet logo](/assets/img/pytranspleet/logo.png){:class="img-fluid rounded mx-auto d-block" style="max-width: 300px;"}

An audio processing application that combines stem separation and music transcription. Built to analyze audio files by splitting them into individual instrument tracks (stems) and transcribing the musical notes.

## Features

- **Stem Separation**: Uses Demucs to split audio files into individual instrument tracks
- **Note Transcription**: Extracts musical notes from audio
- **Web Interface**: Modern web UI built with TypeScript, JavaScript, and HTML/CSS
- **Python Backend**: Robust backend with comprehensive testing and type checking

## Technical Stack

- **Python 3.9** (required for Demucs compatibility)
- **Poetry** for dependency management
- **Demucs** for stem separation
- **TypeScript/JavaScript** frontend
- **pytest** for testing with coverage
- **Ruff** for linting
- **mypy** for type checking
- **tox** for comprehensive test automation

## Development

The project follows best practices with:
- Comprehensive test suite
- Type checking
- Linting and code quality tools
- Automated testing with tox

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/pytranspleet" text="Github" size="lg" style="primary" %}
</p>
