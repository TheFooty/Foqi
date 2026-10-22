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

---

### Day 3 (Oct 16, 2026): Integrated NFC Holster & Center-of-Gravity Stabilization

#### Objectives
- House a standard credit-card sized NFC card (CR80: 85.6 mm x 54.0 mm x 1.0 mm).
- Position card to immediately trigger automation apps (Foqos) via iPhone tap.
- Address desk stability: a 158 mm tall enclosure with a 22 mm base footprint is prone to tipping.

#### Mechanical & RF Engineering Choices
- **NFC Coil Alignment**: On the iPhone 13, the internal NFC loop antenna is situated in the upper 25 mm of the chassis near the camera bump.
- **Side Holster Placement**: Housing the card vertically along the upper side wall places the card's antenna within 3.0 mm of the iPhone's coil.
- **Friction-Fit Clearance**:
  - Width: 54.0 mm + 0.8 mm clearance = 54.8 mm
  - Thickness: 1.0 mm + 0.6 mm clearance = 1.6 mm
- **Thumb Ejection Mechanism**: An 18 mm circular cutout paired with a vertical slide channel allows the card to be ejected with a single upward thumb swipe.
- **Outrigger Base Geometry**: Instead of floating the holster mid-air (which would require messy 3D printing supports), extending the holster down to Z=0 expands the desk footprint from 22 mm to 60.8 mm deep, solving center-of-gravity tipping issues while keeping prints 100% support-free.

---

### Day 4 (Oct 19, 2026): Modular Locking System & Print-Plate Optimization

#### Objectives
- Provide a physical lockout mechanism to prevent spontaneous removal of the phone.
- Engineer sliding interlocks capable of withstanding physical prying.
- Optimize component disposition for 1-click FDM batch printing.

#### Kinematics & Mechanical Interlocks
- **Sliding Lid Tracks**: Implemented horizontal T-slot / rail grooves inside the upper rim:
  - Rail depth: 2.0 mm
  - Rail height: 3.5 mm
  - FDM printer clearance tolerance: 0.4 mm per side to ensure smooth gliding without binding or loose play.
- **Padlock Hasp Alignment**:
  - 6.5 mm shackle hole accommodates standard luggage, gym, or time-lock padlocks (Master Lock 140D standard shackle is ~6.0 mm).
  - Front flange integrates a 45-degree under-chamfer, making it self-supporting during vertical printing.
- **Print Disposition**:
  - `part_to_render = "print_plate"` positions the Cage upright and inverts the Lid 180 degrees onto its flat top face.
  - Zero support material required on any surface.

---

### Day 5 (Oct 22, 2026): Tolerance Verification, DFAM Finalization & Open-Source Release

#### Objectives
- Perform final boolean artifact inspection (eliminating any non-manifold vertices).
- Publish comprehensive engineering documentation, tolerance stackup analyses, and CAD build configurations.

#### Verification & Outcomes
- Audited all subtractive operations to confirm strict epsilon offset hygiene (`EPS = 0.05 mm`), guaranteeing zero coplanar face flicker or STL slice errors in Bambu Studio and PrusaSlicer.
- Verified physical slide clearance on the modular locking lid at 0.4 mm.
- Finalized multi-mode render controller:
  - `"print_plate"` for production slicing.
  - `"assembly"` with translucent preview of iPhone and CR80 card.
  - `"cage"` and `"lid"` for individual component export.
- Completed comprehensive design rationale and project documentation for open-source and university portfolio review.
