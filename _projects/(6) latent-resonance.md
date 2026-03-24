---
name: latent-resonance
tools: [Python, StyleGAN2, MediaPipe, Librosa, PyTorch]
image: /assets/img/latent-resonance.png
description: A computational instrument that transmutes facial micro-movements into generated audio spectrograms using machine learning and computer vision.
---

# latent-resonance

**latent-resonance** is a generative software system that interprets spatiotemporal data from the human face to navigate a machine-learning model trained on audio spectrograms. By combining computer vision with generative audio synthesis, it creates a feedback loop where the user performs "silent vocals" that the machine interprets into new, hallucinatory sounds.

![Generated Spectrograms](/assets/img/latent-resonance-spectrograms.png)

## Core Concept

The system adheres to the constraint of **non-representation**. The user's body is never visualized. Instead, their physical presence is abstracted into the parameters of a sound wave—frequency, amplitude, and noise—visualized as a spectrogram and reconstructed into audio in real-time.

## Technical Pipeline

The pipeline consists of four distinct stages:

### 1. Input (Computer Vision)
A webcam captures the user's face, and **MediaPipe** tracks 468 facial landmarks in real-time.

### 2. Translation (Regression)
Spatiotemporal features—velocity, jaw openness, head tilt—are extracted and mapped to a high-dimensional latent vector that drives the generative model.

### 3. Generation (The Model)
A **StyleGAN2-ada** model generates unique 512×512 spectrogram images based on the input vector. The model was trained on a curated dataset of nearly 500 spectrograms sourced from freesound.org.

### 4. Reconstruction (Sonification)
The generated spectrogram is converted into audio using the **Griffin-Lim algorithm** (via librosa), estimating phase data to produce sound.

## Mapping System

The system maps energy states rather than 1:1 coordinates:

| Facial Action | Spatiotemporal Data | Sonic/Visual Result |
|--------------|---------------------|---------------------|
| **Head Rotation** | Angular Velocity | Time-stretch (playback speed) |
| **Mouth Openness** | Lip distance | Bandpass filter (frequency range) |
| **Eyebrow Tension** | Brow-eye distance | Noise/entropy (digital glitches) |
| **Stillness** | Minimal movement | Clarity (pure tone) |

## Model Training

The StyleGAN2-ada model was trained using transfer learning:

- **Platform:** Kaggle (2× Tesla T4 GPUs)
- **Duration:** 400 kimg (~9 hours)
- **Dataset:** ~500 curated spectrograms from drone/bass audio samples
- **Challenges:** Custom CUDA ops required PyTorch fallbacks; tensor shape mismatches resolved for grayscale input

![Training Progression](/assets/img/latent-resonance-training.png)

## Technical Stack

- **Computer Vision:** Google MediaPipe for facial landmark tracking
- **Audio Processing:** Librosa for spectrogram generation and Griffin-Lim reconstruction
- **Generative Model:** StyleGAN2-ada with transfer learning
- **Audio Source:** Custom dataset curated from freesound.org

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/latent-resonance" text="Github" size="lg" style="primary" %}
</p>
