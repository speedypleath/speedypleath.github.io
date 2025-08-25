---
name: resonance
tools: [Python, Max MSP, TouchDesigner, Node.js]
image: /assets/img/td.png
description: Resonance is an interactive audiovisual installation driven by real-time emotion detection and biometric feedback. It generates an audio-visual output in response to participants' emotional states.
---

# resonance

The purpose of **resonance** is to place the viewer in direct confrontation with their own emotions. The work emphasizes that the question ["PANIC – yes/no?"](https://ars.electronica.art/mediaservice/en/2025/04/02/ars-electronica-2025-panic-yes-no/), which served as the Ars Electronica theme in the year of its presentation, can only be answered personally.
66
## Data collection

The installation collects biometric data from participants using a Muse 2 EEG headset, a GSR sensor, and facial expression recognition to predict their emotional state. It employs multiple models for emotion recognition, mapping the resulting signals onto the Valence-Arousal-Dominance (VAD) space. The EEG model was trained on the NeuroSense dataset, following the methodology described in this [article](https://ieeexplore.ieee.org/document/10737340/). The GSR model, trained on the [WESAD](https://archive.ics.uci.edu/dataset/465/wesad+wearable+stress+and+affect+detection) dataset, classifies only whether the participant is aroused or not, while the facial expression recognition model categorizes input into six discrete emotions: neutral, sadness, happiness, anger, suprise and fear. A web application was used to monitor the signals and classifications, allowing intervention when sensor malfunctions occurred.

![preview](/assets/img/td.png)

## Translating emotions into sound and visuals

The sound design was created using Max MSP alongside a Node server that exposes an API for integration with Max. The project blends various generative composition techniques with hard-coded triggers that activate in response to the emotions detected. The composition is organized into four elements: harmony, melody, percussion, and FX. Harmony and FX were found to be most effective in influencing the valence of the sound, with musical modes correlating to emotional value and FX triggering immediate responses. Melody and percussion, on the other hand, were particularly effective in modulating arousal, with the density of events having the strongest impact.

![search](/assets/img/max.png)

The visual component was developed in TouchDesigner, combining generative elements with pre-recorded video. Some visuals were created using mathematical models, such as Voronoi diagrams, while others were based on time-lapse footage enhanced with various visual effects. The visuals are synchronized to the rhythm of the sound, enhancing immersion. A key feature of the visual stream is that participants see their own reflection distorted, eliciting a strong emotional response.

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/resonance_installation" text="Github" size="lg" style="primary" %}
</p>