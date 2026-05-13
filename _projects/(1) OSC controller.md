---
name: OSC controller
tools: [Arduino, ESP8266, C++, OSC, MIDI, Embedded Systems, Hardware]
image: /assets/img/osc.png
description: The OSC Controller is a wireless interface built on an ESP8266, designed to control audio and visual software such as Max MSP and TouchDesigner. The project later evolved into <object> <a href=https://github.com/speedypleath/CWirelessMIDI/tree/master> WirelessMIDI </a> </object> a plug-in module that enables MIDI instruments to operate wirelessly and is currently still in development.
---

# OSC Controller

A wireless sensor interface built on an ESP8266 (NodeMCU v2) that reads analog inputs through a 16-channel multiplexer and transmits them as OSC messages over UDP — letting physical knobs and sensors control software like Max MSP or TouchDesigner without a cable in sight.

## Overview

The controller reads up to 16 analog sensors through a single ADC pin via a CD74HC4067 multiplexer. Each sensor reading is normalized and dispatched as an OSC message over Wi-Fi, typed by its intended use:

- **Sensor** — raw normalized value for generic mappings
- **MIDI** — normalized to 0–127 for direct MIDI parameter control
- **Cutoff** — scaled for filter cutoff frequency ranges

An I2C LCD displays live sensor values, and Wi-Fi credentials are stored in a JSON config file on the device's LittleFS filesystem — configurable via serial monitor without reflashing.

## Hardware

- **NodeMCU v2** (ESP8266) — Wi-Fi-enabled microcontroller
- **CD74HC4067** 16-channel analog multiplexer — expands the single ADC to 16 inputs
- **16×2 I2C LCD** — live readout of active sensor values
- Analog sensors wired to multiplexer channels (potentiometers, FSRs, etc.)

![schematic](/assets/img/osc_schematic.png)

## Architecture

Three custom libraries handle the separation of concerns:

**`OSCInstance`** manages Wi-Fi setup and OSC transmission. It connects to the network, opens a UDP socket, and sends typed OSC messages to a configurable target IP and port.

**`Multiplexer`** wraps the CD74HC4067: it sets the S0–S3 select pins to route each channel through the shared analog pin, and debounces readings so only genuine changes trigger a message.

**`Settings`** loads Wi-Fi credentials from a `config.json` file on LittleFS. If no config is found, it scans available networks and prompts for credentials over serial, then persists them for future boots.

## Configuration

Flash a `config.json` to the device's data partition:

```json
{
  "network": {
    "ssid": "your_ssid",
    "password": "your_password"
  },
  "osc": {
    "host": ""
  }
}
```

Use PlatformIO's `Build Filesystem Image` → `Upload Filesystem Image` tasks to write it. Alternatively, connect over serial and select a network interactively — credentials are saved to flash automatically.

## What It Became

This project was the seed for [WirelessMIDI](https://github.com/speedypleath/CWirelessMIDI/tree/master), a plug-in module designed to retrofit any MIDI instrument with wireless capability. The OSC Controller proved the ESP8266 + UDP stack was reliable enough for real-time performance use, and the multiplexer approach carried forward into the new design.

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/OSC-Controller" text="Github" size="lg" style="primary" %}
</p>
