# Engineering Devlog

Documenting the chronological design, prototyping, and validation process of Foqi.

---

### Day 1 (Oct 11, 2026): Problem Formulation & Clearance Modeling

#### Objectives
- Establish physical boundaries for an iPhone 13 inside a typical protective bumper case.
- Determine minimum structural wall thickness for FDM printing.

#### Observations & Anthropometric Sizing
- Bare iPhone 13 dimensions: 146.7 mm x 71.5 mm x 7.65 mm.
- Standard protective case (TPU/polycarbonate hybrid) increases dimensions to ~152 mm x 78 mm x 13 mm.
- Set internal clearance targets:
  - Width: 82.0 mm (+4.0 mm clearance)
  - Depth: 16.0 mm (+3.0 mm clearance)
  - Height: 155.0 mm (+3.0 mm clearance)
- Wall thickness set to 3.0 mm to resist flex when dropped or torqued.
- Implemented `rounded_box` module using 2D extrusion of 4 circles within a `hull()` to avoid OpenSCAD's computationally expensive `minkowski()` sum.

---

### Day 2 (Oct 13, 2026): Anti-Touch Grille & Anthropometric Sizing

#### Objectives
- Create a front viewing face that keeps notifications legible while blocking screen interaction.
- Integrate pass-through charging access.

#### Research & Calculations
- Capacitive touchscreen activation requires approximately 8–10 mm of conductive fleshy fingertip contact.
- Adult index finger breadth averages 16–20 mm (5th percentile is ~14 mm).
- Designing slots at 5.5 mm with 4.9 mm rigid bars makes screen interaction physically impossible:
  - Total span across front face: 68 mm
  - 7 slots of 5.5 mm width spaced across the display
  - Rounded capsule ends (`pill_slot_y`) eliminate sharp internal stress concentrations and ensure clean FDM bridgeability.
- Added a 20 mm x 8 mm slotted oval port at the bottom floor for Lightning and USB-C cable pass-through.
