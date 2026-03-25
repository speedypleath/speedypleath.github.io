---
name: latent-resonance
tools: [Python, StyleGAN2, GAN, MediaPipe, Librosa, PyTorch, Computer Vision, Machine Learning, Audio Synthesis, Generative Art, Deep Learning]
image: /assets/img/latent-resonance/fakes36_kaggle.png
description: A computational instrument that transmutes facial micro-movements into generated audio spectrograms using machine learning and computer vision.
---

# Latent Resonance: Facial Acoustics

**A computational instrument that transmutes facial micro-movements into generated audio spectrograms.**

![Latent Space Navigation](/assets/img/latent-resonance/output.gif){:class="img-fluid rounded mx-auto d-block"}

## Project Overview

This project is a generative software system that interprets spatiotemporal data from the human face to navigate a machine-learning model trained on audio spectrograms. By combining **computer vision** with **generative audio synthesis**, it creates a feedback loop where the user performs "silent vocals" that the machine interprets into new, hallucinatory sounds.

**Core Concept:** The system adheres to the constraint of **non-representation**. The user's body is never visualized. Instead, their physical presence is abstracted into the *parameters* of a sound wave—frequency, amplitude, and noise—visualized as a spectrogram and reconstructed into audio in real-time.

## System Architecture

The pipeline consists of four distinct stages:

1. **Input (Computer Vision):** A webcam captures the user. MediaPipe tracks 468 facial landmarks.
2. **Translation (Regression):** Spatiotemporal features (velocity, jaw openness, head tilt) are extracted and mapped to a high-dimensional latent vector.
3. **Generation (The Model):** A GAN generates a unique 512×512 spectrogram image based on the input vector.
4. **Reconstruction (Sonification):** The generated image is converted into audio using the **Griffin-Lim algorithm** (via librosa), estimating phase data to produce sound.

## The Dataset

The model was trained on a custom-curated dataset of almost 500 spectrograms generated from audio samples sourced via [freesound.org](https://freesound.org) (dark drone, sustained tones, reese bass, and similar structured harmonic material).

![Dataset - Real Spectrograms](/assets/img/latent-resonance/reals_kaggle.png){:class="img-fluid rounded"}

### Training Process

The curated spectrogram dataset was used to train a StyleGAN model using transfer learning from pre-trained weights (FFHQ). Training was performed on free-tier GPU platforms (Google Colab and Kaggle).

#### Training on Kaggle

**Platform:** Kaggle (2× Tesla T4 GPUs)  
**Duration:** 400 kimg (~9 hours)  
**Model:** StyleGAN2-ada (translation-equivariant)

##### Phase 1: The Nightmare Phase (0–50 kimg)

You will see terrifying, melted faces. Some might have "bassline textures" instead of skin, but you will clearly see eyes or mouths. Audio quality is unusable—static with weird voice-like formants.

![Phase 1](/assets/img/latent-resonance/fakes0_kaggle.png){:class="img-fluid rounded"}

##### Phase 2: The "Structure" Phase (50–200 kimg)

The faces fade away. You start seeing horizontal lines (which are bass notes). Audio becomes "Lo-Fi"—recognizable as a drone or bass, but watery or phasey.

![Phase 2](/assets/img/latent-resonance/fakes12_kaggle.png){:class="img-fluid rounded"}

##### Phase 3: The "Usable" Phase (200–400 kimg)

The lines become sharp and high-contrast. The background becomes solid black. Audio quality is good—sharp lines produce pure sine waves, blurry lines produce noise.

![Phase 3](/assets/img/latent-resonance/fakes36_kaggle.png){:class="img-fluid rounded"}

### Training using Autolume

Generated RGB dataset using magma colormap to allow transfer learning from pre-trained weights.

![Dataset - Autolume](/assets/img/latent-resonance/reals_autolume.png){:class="img-fluid rounded"}

Training progression through three phases:

| Phase 1: FFHQ Data | Phase 2: Distorted | Phase 3: Clear |
|:---:|:---:|:---:|
| ![Phase 1](/assets/img/latent-resonance/fakes0_autolume.png) | ![Phase 2](/assets/img/latent-resonance/fakes8_autolume.png) | ![Phase 3](/assets/img/latent-resonance/fakes16_autolume.png) |

## Controls & Interaction

The system does not map 1:1 coordinates. Instead, it maps **energy states**:

| Facial Action | Spatiotemporal Data | Sonic/Visual Result |
|:---|:---|:---|
| **Head Rotation (Y-Axis)** | Angular Velocity | **Time-Stretch:** Controls the playback speed of the generated sample. |
| **Mouth Openness** | Distance (LipTop, LipBottom) | **Bandpass Filter:** Determines the frequency range. |
| **Eyebrow Tension** | Distance (Brow, Eye) | **Noise/Entropy:** Adds jitter to the latent vector, introducing digital glitches. |
| **Stillness** | Minimal Position Change | **Clarity:** The model settles on a "pure" tone. |

## Technical Challenges

### The "Phase" Problem
Standard spectrogram images only store amplitude (loudness), discarding phase (timing). Implemented the Griffin-Lim algorithm to iteratively estimate the phase signal.

### Latent Space Mapping
Used smoothing functions (Linear Interpolation) on the input vector to allow sounds to "morph" slowly rather than snapping instantly, creating a fluid, drone-like aesthetic.

### Training on Free-Tier GPUs
StyleGAN2's custom CUDA ops failed to compile on Tesla T4 GPUs, requiring fallback to native PyTorch implementations. This forced model capacity reduction to fit in 15GB VRAM, but the 490-spectrogram dataset was small enough that the reduced model could still learn meaningful structure.

## Technical Stack

- **Computer Vision:** Google MediaPipe
- **Audio Processing:** Librosa
- **Model Architecture:** StyleGAN2-ada
- **Audio Samples:** freesound.org
- **Python 3.13+** with uv package manager

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/latent-resonance" text="Github" size="lg" style="primary" %}
</p>
