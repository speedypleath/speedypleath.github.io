---
title: "Designing a Prototyping Board in KiCad: From Breadboard to Perfboard & Fab"
date: 2026-08-27
description: "A complete workflow for designing perfboard prototyping layouts and custom PCBs in KiCad — covering 2.54 mm pad arrays, bus distribution, 3D color-coded jumper wires, and the dual-board fabrication pipeline."
tags:
  - kicad
  - electronics
  - hardware
  - prototyping
  - pcb
  - teensy
---

Solderless breadboards are indispensable for quick sanity checks, but as soon as a project grows beyond a few components — multiple sensors, high-speed buses like I²C or SPI, microcontrollers, and button matrices — they quickly degrade into fragile rats-nests. One nudged wire during testing can cause intermittent signals that waste hours of debugging.

The standard jump is to immediately order a custom PCB from a fabrication house. But during active R&D or thesis prototyping, waiting two weeks for a revision cycle just to realize you swapped TX/RX or miscalculated a footprint pitch is agonizing.

There is a powerful middle path: **designing perfboards and prototyping boards directly in KiCad**. 

By treating the prototyping board as a first-class CAD citizen, you can use the same verified schematic to produce both a hand-wireable perfboard build and a compact production PCB.

![Manufactured Board vs Perfboard Render](/assets/img/kicad-prototyping/perfboard-3d-render-green.png){:class="img-fluid rounded"}

Here is the complete workflow, along with solutions to KiCad quirks, 3D wire visualization, and lessons from building the **Haptic Console Control Unit**.

---

## 1. The Strategy: One Schematic, Two Boards

When prototyping complex hardware (such as my [Haptic Console Control Unit](https://github.com/speedypleath/control-unit-kicad)), maintaining multiple separate schematics for breadboard, perfboard, and custom PCB is an error-prone nightmare. 

Instead, adopt the **Single-Schematic / Dual-Board** strategy:

![Schematic](/assets/img/kicad-prototyping/schematic_readable.png){:class="img-fluid rounded"}

1. **One verified schematic**: Capture all components, connectors, decoupling capacitors, and pull-ups. Run Electrical Rules Check (ERC) until you have **0 errors and 0 warnings**.
2. **Board A — Hand-wireable Perfboard**: A 2.54 mm grid-aligned physical layout designed with structured power buses and point-to-point jumper wires. Paired with an interactive HTML wiring guide and a 1:1 scale printable placement template.
3. **Board B — Compact Manufactured PCB**: An SMD/through-hole layout with optimized copper traces, ground planes, and Gerber X2 exports ready for JLCPCB/PCBWay fabrication.

![Manufactured Board 3D](/assets/img/kicad-prototyping/manufactured-board-green-3d.png){:class="img-fluid rounded"}

---

## 2. Building the Perfboard Pad Grid in KiCad

Creating a standard 2.54 mm (0.1 in) perfboard matrix in KiCad's PCB Editor only takes a few minutes:

1. **Place the anchor footprint**: Open the PCB editor and add a single through-hole pad footprint (e.g. `Connector:1X01_NO_SILK` or `TestPoint:TestPoint_Pad_D1.5mm`). Place it at the top-left origin `(0, 0)`.
2. **Hide silkscreen clutter**: Right-click the footprint → **Properties** → untick "Show" for both **Reference** and **Value**. Having 1,600 visible `REF**` labels will grind rendering to a crawl and obscure your layout.
3. **Create the Array**:
   - Right-click the footprint → **Create Array** (`Ctrl+N` / `Cmd+N`).
   - Set **Horizontal Count** and **Vertical Count** (for a 90 × 150 mm board, a 32 × 50 matrix works well).
   - Set **Horizontal Spacing** and **Vertical Spacing** to **2.54 mm**.
4. **Lock the Grid Pads (Critical Step)**:
   - When you subsequently trigger **Update PCB from Schematic** (`F8`), KiCad will consider all grid pads "extra" and try to delete them.
   - Select all grid pads → right-click → **Locking → Lock**. Locked footprints cannot be moved or deleted by automatic schematic syncs.
   - Additionally, in the *Update PCB from Schematic* dialog, ensure **"Delete extra footprints"** is **unticked**.

> **Pro-Tip**: If you need to remove a locked pad to make room for a mechanical mounting hole or a large module, hit **Delete** once, and then hit **Delete again** while the confirmation toast is visible.

---

## 3. Power Architecture & Bus Topologies

A reliable prototyping board needs clean power and ground distribution. Leaving power routing until the end results in erratic voltage drops and ground loops.

```
+-------------------------------------------------------------+
|  TERMINAL STRIP (Edge)                                      |
|  [ GND ] ==========> Continuous GND Rail across board       |
|  [ 5V  ] ==========> Continuous 5V Rail across board        |
|  [ 3V3 ] ==========> Continuous 3.3V Rail across board      |
|  ---------------------------------------------------------  |
|  SHARED BUSES (e.g., I2C SDA / SCL with 4.7k pull-ups)     |
|  =========================================================  |
|  COMPONENT ZONE (Teensy / Sockets / Drivers / Buttons)      |
+-------------------------------------------------------------+
```

### Key Layout Principles

- **Dedicated Power Rails**: Run continuous solid bus wires (or copper tracks) across full columns or rows for `GND`, `5V`, and `3.3V`.
- **Bus Terminators & Pull-Ups**: Mount bus pull-ups (such as 4.7 kΩ resistors for I²C SDA/SCL lines) directly adjacent to the power rail feed.
- **Edge Terminal Strip**: Place a 3-pin or 4-pin header on the board margin for direct bench power supply hookup or external test leads.
- **Socket Everything**: Always use female machine-pin sockets for microcontrollers (Teensy 4.1, ESP32, Arduino) and ICs. This allows quick component swaps and prevents overheating sensitive chips during point-to-point soldering.

---

## 4. Visualizing Jumper Wires in 3D (`jumper-wires-kicad`)

One of the biggest frustrations when hand-wiring a perfboard from KiCad is visualization. KiCad's raytraced 3D viewer renders all copper traces in a single uniform color per layer. If you use a physical 6-color jumper wire kit (e.g., red, yellow, white, orange, green, blue), standard traces can't give you a true visual preview of your harness.

To solve this, I built [**`jumper-wires-kicad`**](https://github.com/speedypleath/jumper-wires-kicad) — a standalone library of decorative, net-less footprints paired with color-coded 3D `.wrl` wire-tube models.

```
jumper-wires-kicad/
├── 3dmodels/              # 6 parametric .wrl wire-tube models (one per color)
├── JumperWires.pretty/    # 6 static footprints (Jumper_Wire_<Color>)
└── scripts/
    ├── gen_wire.py        # Generates .wrl tube geometry
    └── place_wire.py      # Batch-places wire footprints from a JSON segment list
```

### The Scale & Rotation Gotcha

When building parametric 3D models for KiCad, non-uniform scaling (`Scale X = length`, `Scale Y = 1`, `Scale Z = 1`) combined with rotation exhibits a nasty bug if the model geometry is defined from `(0, 0, 0)` to `(length, 0, 0)`:

> **The Rotation Trap**: Because KiCad evaluates scaling before rotation around the local origin, asymmetric geometry causes rotated segments (e.g. 90° vertical or 45° diagonal wires) to distort dramatically, often stretching across the entire canvas.

The solution in `gen_wire.py` is centering the tube geometry strictly at the local origin:

$$\text{Geometry X span: } \left[-\frac{\text{length}}{2}, +\frac{\text{length}}{2}\right]$$

Centered at $(0, 0, \text{radius})$ tangent to $Z=0$, non-uniform stretching and rotation remain rock solid at any angle.

### Automated Batch Placement

Instead of hand-placing dozens of wire footprints, `place_wire.py` reads a JSON segment list and places footprints automatically using KiCad's Python API:

```json
[
  [12.70, 25.40, 63.50, 25.40, "red", "5V_BUS"],
  [12.70, 27.94, 63.50, 27.94, "black", "GND_BUS"],
  [30.48, 40.64, 45.72, 40.64, "blue", "I2C_SDA"]
]
```

Run it directly inside KiCad's bundled Python environment:

```bash
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 \
    scripts/place_wire.py /path/to/board.kicad_pcb segments.json
```

---

## 5. Case Study: The Haptic Console Control Unit

In the [Control Unit (M6) project](https://github.com/speedypleath/control-unit-kicad), this workflow powered the entire hardware bring-up:

- **Teensy 4.1 Core**: High-speed ARM Cortex-M7 managing 6 independent haptic actuator driver slots, dual analog joysticks, 8 action buttons, illuminated command buttons, and a 4×4 numpad matrix.
- **Connector Standard v1.1**: Adopted uniform 6-pin JST-XH connectors for all modules:
  1. `GND` | 2. `3.3V` | 3. `5V` | 4. `SDA` | 5. `SCL` | 6. `IRQ`
- **Interactive Wiring Guide**: Every hand-wired connection is cataloged as an alphanumeric grid reference (e.g. `S1.Pin1 → Q23`), rendered into an interactive web guide alongside a 1:1 scale printable PDF drill-template.
- **Zero-Defect Manufactured Board**: Once the prototype was validated on perfboard, the manufactured PCB was routed (697 track segments, 42 vias, 0 unrouted nets) and sent to fab with zero ERC/DRC errors.

![Manufactured Board Gerber Layout](/assets/img/kicad-prototyping/manufactured-board-gerber-layout.png){:class="img-fluid rounded"}

---

## 6. Practical Rules of Thumb for KiCad Prototyping

1. **Use Custom Path Variables**: Point libraries to `${JUMPER_WIRES_LIB}` configured in **Preferences → Configure Paths**. Never rely on `${KIPRJMOD}` for shared global libraries, as project-less `.kicad_pcb` files will fail to resolve 3D model paths.
2. **Never regex `.kicad_sch` or `.kicad_pcb` by hand**: KiCad S-expression syntax is deceptively complex. Always use the official `pcbnew` Python bindings, `kicad-cli`, or verified MCP toolchains.
3. **Check DRC with Realistic Fab Constraints**: Set your design rules (clearance 0.15 mm, track width 0.2 mm, via drill 0.3 mm) to match standard low-cost fab capabilities early so your board is fab-ready on day one.

---

## Conclusion & Resources

Designing your prototyping boards in KiCad gives you the best of both worlds: rapid benchtop assembly with hand-wireable perfboards, zero ambiguity thanks to 3D color-coded wiring, and an effortless transition to professional fabricated PCBs.

Explore the repositories and guides:
- [**control-unit-kicad on GitHub**](https://github.com/speedypleath/control-unit-kicad) — Schematic, perfboard build, and manufactured PCB files.
- [**jumper-wires-kicad on GitHub**](https://github.com/speedypleath/jumper-wires-kicad) — 3D jumper wire library and placement scripts.
- [**Live Control Unit Wiring Guide**](https://speedypleath.github.io/control-unit-kicad/wiring-guide.html) — Interactive point-to-point perfboard assembly plan.
