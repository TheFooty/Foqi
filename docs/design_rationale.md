# Engineering Design Rationale & Trade Studies

This document details the engineering principles, tolerance stackup analyses, and Design for Additive Manufacturing (DFAM) methodologies behind Foqi.

---

## 1. Ergonomic & Anthropometric Sizing

### 1.1 Device Cavity Tolerancing
The internal compartment was dimensioned based on the iPhone 13 form factor:
- **Nominal iPhone 13**: 146.7 mm x 71.5 mm x 7.65 mm
- **Protective Case Allowance**: Standard dual-injection cases add 4.0–6.0 mm in width, 1.5–3.0 mm in depth, and 4.0–6.0 mm in height.
- **Internal Pocket Spec**: 82.0 mm x 16.0 mm x 155.0 mm.
- **Clearance Margin**:
  - X-axis clearance: $(82.0 - 77.5) / 2 = 2.25\text{ mm}$ per side.
  - Y-axis clearance: $(16.0 - 11.5) / 2 = 2.25\text{ mm}$ per side.
  - Z-axis clearance: $155.0 - 152.0 = 3.0\text{ mm}$ vertical clearance.
This allows smooth gravity drop-in and extraction while preventing excessive rattling or internal tilt.

### 1.2 Anti-Touch Grille Anthropometry
A core design goal is to allow notification reading while blocking capacitive touchscreen interaction:
- **Human Fingertip Breadth**: 5th percentile female index finger breadth is 13.8 mm; 95th percentile male is 20.2 mm.
- **Capacitive Threshold**: Modern projective capacitance screens require contact area diameter $> 8\text{ mm}$ with human tissue to register touch events.
- **Slot Geometry**: Width of 5.5 mm with a 3.0 mm wall depth prevents fleshy contact from penetrating deeply enough to reach the glass surface $(d_{\text{gap}} = 3.0\text{ mm} + 2.25\text{ mm} = 5.25\text{ mm})$.

---

## 2. RF & Hardware Automation Integration

### 2.1 Near Field Communication (NFC) Dynamics
Apple integrates the NFC controller and loop antenna at the extreme top edge of the iPhone 13 chassis, surrounding the camera bump.
- **Read Range**: High-frequency RFID / NFC (13.56 MHz, ISO/IEC 14443) has an effective near-field read distance through plastic polymers of 10–25 mm.
- **Placement**: Positioning the CR80 card in the upper third of the vertical holster ensures the card's inductive coil is within $\le 4\text{ mm}$ of the phone's internal antenna when docked.
- **Card Retention & Ejection**:
  - Pocket size: $54.8\text{ mm} \times 1.6\text{ mm} \times 76.0\text{ mm}$.
  - Exposed card length: $85.6 - 75.0 = 10.6\text{ mm}$ protruding from the top lip.
  - Thumb cutout: 18.0 mm circular aperture combined with an open vertical channel enables instantaneous thumb slide-eject for tap-to-focus triggers (e.g. Foqos, iOS Shortcuts).

---

## 3. Design for Additive Manufacturing (DFAM)

| Feature | Conventional Pitfall | Foqi DFAM Solution |
| :--- | :--- | :--- |
| **Viewing Grille** | Horizontal slots require bridging or support | Vertical pill slots with filleted caps; 100% self-supporting along Z axis |
| **Corner Fillets** | OpenSCAD `minkowski()` sum slows compile to >5 min | 2D hull extrusions of 4 corner circles (`linear_extrude`); compiles in <0.2 s |
| **Side Holster** | Cantilevered side pocket overhangs at 90° | Extended full-height outrigger down to bed; forms anti-tip stabilizer foot |
| **Padlock Hasp** | Horizontal tabs sag during overhang bridging | 45-degree support-free chamfer underneath the flange |
| **Lid Rails** | Tight tolerances bind from FDM layer stepping | 0.4 mm bilateral offset on interlocking guides ensures smooth slide fit |

---

## 4. Finite Element & Wall Rigidity Considerations
With a height of 158.0 mm, tall FDM prints are vulnerable to delamination under torsional loads.
- Wall thickness of 3.0 mm provides 6 solid perimeters on standard 0.4 mm nozzles (0.45 mm line width).
- Infill density of 15–20% gyroid infill yields uniform isotropic shear modulus and impact resistance.
