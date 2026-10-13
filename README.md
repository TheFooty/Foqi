# Foqi: Parametric Focus Lockout & NFC Automation Dock

[![OpenSCAD](https://img.shields.io/badge/CAD-OpenSCAD-orange.svg)](https://openscad.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![3D Print Ready](https://img.shields.io/badge/FDM-100%25%20Support--Free-brightgreen.svg)](#3d-printing--manufacturing-specifications)

**Foqi** is a minimalistic, parametric 3D-printable "phone jail" and desktop focus dock engineered to curb doomscrolling and encourage intentional smartphone habits. 

Designed specifically for an **iPhone 13** in a protective case, Foqi introduces deliberate physical friction while maintaining screen visibility for urgent notifications and integrating a dedicated **CR80 NFC card slot** to trigger app automations (such as [Foqos](https://foqos.co) and Apple Shortcuts).

---

## The Engineering Problem

Digital wellness apps fail because disabling a screen-time block is as simple as pressing "Ignore Limit" or typing an emergency passcode. 

Foqi addresses the root psychological vector: **frictionless access**. By locking the device behind physical barrier geometry:
1. **Notifications Remain Visible**: An anthropometrically engineered vertical grille keeps notifications, timers, and incoming calls readable.
2. **Touch Interaction is Blocked**: 5.5 mm slot widths physically prevent fingertips from making capacitive contact with the glass.
3. **Intentional Release**: An integrated NFC card must be deliberately retrieved to tap or automate focus sessions, enforcing deliberate cognitive intent.

---

## System Architecture & Iterative Development

Foqi was designed from first principles across 5 iterative engineering phases:

| Iteration | Milestone | Primary Engineering Focus |
| :--- | :--- | :--- |
| **v1** | Clearance Modeling | Establish parametric clearance cavity for iPhone 13 + protective bumper case. |
| **v2** | Anti-Touch Grille | Determine anthropometric finger gap thresholds; add bottom charging port. |
| **v3** | NFC Holster & Stability | Position CR80 card at iPhone NFC loop; expand footprint to prevent tip-over. |
| **v4 / Master** | Modular Locking System | Design sliding interlock lid with padlock hasp; optimize for 0-support FDM print plate. |

> Detailed day-by-day notes, equations, and trade-offs are documented in [`docs/devlog.md`](docs/devlog.md) and [`docs/design_rationale.md`](docs/design_rationale.md).

---

## Key Mechanical Features

### 1. Anthropometrically Sized Viewing Grille
- **Slot Width**: 5.5 mm (adult fingertips average 14–20 mm breadth).
- **Capsule Geometry**: Rounded pill cutouts (`hull` of cylinder primitives) avoid sharp stress-riser corners and bridge seamlessly in FDM printers without sagging.
- **Pass-through Port**: 20 mm x 8 mm oblong cutout at the base allows charging cable connection during lock sessions.

### 2. Integrated CR80 NFC Holster
- **Form Factor**: Tailored for standard credit-card-sized RFID/NFC cards (85.6 mm x 54.0 mm x 1.0 mm).
- **Antenna Proximity**: Aligned with the top edge of the phone where Apple places the iPhone 13 NFC loop antenna, permitting tap reads through the thin 3.0 mm divider wall.
- **Thumb Ejection**: 18 mm circular push notch and continuous vertical channel allow smooth one-finger card extraction.
- **Outrigger Base**: Holster extends to the build plate ($Z=0$), broadening the desktop footprint from 22 mm to 60.8 mm for rock-solid anti-tip stability.

### 3. Modular Sliding Lid & Padlock Hasp
- **Kinematic Constraints**: Integrated horizontal guide rails constrain all degrees of freedom except forward slide.
- **Padlock Flange**: 6.5 mm shackle hole accepts standard luggage locks, mini Master Locks, or digital countdown timers.
- **Support-Free Chamfer**: 45-degree angle beneath the front tab allows vertical printing without support material.

---

## CAD Parameter Summary

All geometry is fully parameterized at the top of [`cad/foqi.scad`](cad/foqi.scad):

```openscad
// Phone Compartment Clearance
phone_w = 85.0;    // Width clearance (X axis, mm)
phone_d = 20.0;    // Depth clearance (Y axis, mm)
phone_h = 155.0;   // Height clearance (Z axis, mm)

// Wall & Floor Thickness
wall_t  = 3.0;     // Perimeter wall thickness (mm)
floor_t = 3.0;     // Bottom base thickness (mm)

// Viewing Grille
num_slots = 7;     // Number of vertical slots
slot_w    = 5.5;   // Slot width (mm)

// NFC Card Cavity (CR80)
nfc_card_w = 54.0; // Card width (mm)
nfc_card_h = 85.6; // Card height (mm)
nfc_card_t = 1.0;  // Nominal card thickness (mm)
nfc_tol_w  = 0.8;  // Width clearance tolerance (mm)
nfc_tol_t  = 0.6;  // Thickness clearance tolerance (mm)
```

---

## 3D Printing & Manufacturing Specifications

| Parameter | Recommended Setting |
| :--- | :--- |
| **Technology** | FDM / FFF |
| **Material** | PLA, PETG, or ABS |
| **Nozzle Diameter** | 0.4 mm |
| **Layer Height** | 0.20 mm (Standard) |
| **Wall Perimeters** | 4–6 perimeters (ensures 100% solid walls at 3.0 mm) |
| **Infill** | 15–20% Gyroid or Grid |
| **Supports** | **None (100% support-free)** |
| **Print Orientation** | `part_to_render = "print_plate"` (Cage upright, Lid inverted flat) |

---

## NFC Automation Workflow (Foqos / Apple Shortcuts)

1. **Provision Card**: Write your lock automation URL or trigger tag to any standard NTAG213/215/216 CR80 card.
2. **Dock Phone**: Insert the iPhone 13 into the main cavity and slide the locking lid shut.
3. **Engage Focus**: Secure the hasp with a padlock or combination lock.
4. **Trigger Session**: Tap the card against the phone (or slide it into the docked holster) to trigger the iOS Shortcut that launches Foqos and activates Do Not Disturb / Focus Mode.
5. **Unlock**: When the timer concludes or study goal is reached, retrieve your physical key or combination to unlock the enclosure.

---

## Repository Structure

```
Foqi/
├── .gitignore                  # Ignore STL/3MF binaries and editor temp files
├── LICENSE                     # MIT License
├── README.md                   # Project overview and technical documentation
├── docs/
│   ├── devlog.md               # Chronological day-by-day engineering log
│   └── design_rationale.md     # Anthropometric math, RF design, and DFAM trade studies
└── cad/
    ├── v1_clearance_box.scad   # Iteration 1: Initial clearance volume
    ├── v2_notification_grille.scad # Iteration 2: Anti-touch viewing slots
    ├── v3_nfc_holster.scad     # Iteration 3: CR80 card dock and outrigger foot
    ├── foqi.scad               # Iteration 4: Master parametric modular production model
    └── locking_pin.scad        # 3D-printable dual-action retention pin (hardware-free closure)
```

---

## Author & Project Background

Developed by **Vedanth Mydur** as an applied engineering project in human-computer interaction, mechanical product design, and digital wellness hardware.
