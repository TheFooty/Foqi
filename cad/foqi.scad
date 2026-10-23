// part to render
part_to_render = "print_plate";

// mesh resolution
$fn = 60;

// phone clearance
phone_w = 85;
phone_d = 20;
phone_h = 155;

// wall thickness
wall_t = 3;
floor_t = 3;
corner_r = 4;

// grille parameters
num_slots = 7;
slot_w = 5.5;
slot_bottom_clear = 14;
slot_top_clear = 18;
mid_rib_h = 8;

// cr80 card parameters
nfc_slot_location = "side";
nfc_card_w = 54;
nfc_card_h = 85.6;
nfc_card_t = 1;
nfc_tol_w = 0.8;
nfc_tol_t = 0.6;
nfc_lip_t = 1.8;
thumb_w = 18;

// lock parameters
lock_hole_d = 6.5;
lid_tolerance = 0.4;

eps = 0.05;
eps2 = 0.10;

box_w = phone_w + 2 * wall_t;
box_d = phone_d + 2 * wall_t;
box_h = phone_h + floor_t;

nfc_pocket_w = nfc_card_w + nfc_tol_w;
nfc_pocket_t = nfc_card_t + nfc_tol_t;
nfc_pocket_h = nfc_card_h + 1;

// fast rounded box
module rounded_box(w, d, h, r) {
    clamped_r = min(r, min(w / 2, d / 2));
    linear_extrude(height = h) {
        hull() {
            translate([clamped_r, clamped_r]) circle(r = clamped_r);
            translate([w - clamped_r, clamped_r]) circle(r = clamped_r);
            translate([w - clamped_r, d - clamped_r]) circle(r = clamped_r);
            translate([clamped_r, d - clamped_r]) circle(r = clamped_r);
        }
    }
}

// self supporting arch slot module
module pointed_slot_y(width, height, depth) {
    r = width / 2;
    hull() {
        translate([0, -eps, r])
            rotate([-90, 0, 0])
                cylinder(r = r, h = depth + 2 * eps);
        translate([0, -eps, height - r])
            rotate([-90, 0, 0])
                cylinder(r = r, h = depth + 2 * eps);
    }
    // pointed 45 degree top arch eliminates bridging
    translate([0, -eps, height - r])
        rotate([-90, 0, 0])
            linear_extrude(height = depth + 2 * eps)
                polygon([[-r, 0], [r, 0], [0, r]]);
}

// main cage body
module phone_jail_cage() {
    difference() {
        union() {
            rounded_box(box_w, box_d, box_h, corner_r);

            // front padlock tab with self supporting 45 degree ramp
            hasp_ramp_h = 16;
            translate([box_w / 2 - 12, -wall_t, box_h - 18 - hasp_ramp_h]) {
                hull() {
                    translate([0, wall_t, 0])
                        cube([11, eps, eps]);
                    translate([0, 0, hasp_ramp_h])
                        cube([11, wall_t + 2, 18]);
                }
            }

            // side holster outrigger
            if (nfc_slot_location == "side") {
                holster_w = nfc_pocket_t + nfc_lip_t + wall_t;
                holster_d = nfc_pocket_w + 2 * wall_t;
                holster_y = (box_d - holster_d) / 2;

                translate([box_w - 0.5, holster_y, 0])
                    rounded_box(holster_w + 0.5, holster_d, box_h, corner_r);
            }

            // base pedestal
            if (nfc_slot_location == "base") {
                pedestal_d = nfc_pocket_t + nfc_lip_t + 10;
                translate([0, -pedestal_d, 0])
                    rounded_box(box_w, box_d + pedestal_d, 36, corner_r);
            }
        }

        // phone cavity
        translate([wall_t, wall_t, floor_t])
            rounded_box(phone_w, phone_d, phone_h + 20, 2);

        // dual bank viewing grille with center anti vibration brace
        total_slot_span = box_h - slot_top_clear - (floor_t + slot_bottom_clear);
        bank_h = (total_slot_span - mid_rib_h) / 2;
        grille_margin_x = 10;
        available_w = box_w - 2 * grille_margin_x;
        step_x = (available_w - slot_w) / (num_slots - 1);

        for (i = [0 : num_slots - 1]) {
            x_pos = grille_margin_x + (i * step_x) + (slot_w / 2);

            // lower bank
            translate([x_pos, 0, floor_t + slot_bottom_clear])
                pointed_slot_y(slot_w, bank_h, wall_t);

            // upper bank
            translate([x_pos, 0, floor_t + slot_bottom_clear + bank_h + mid_rib_h])
                pointed_slot_y(slot_w, bank_h, wall_t);
        }

        // padlock hole in cage
        translate([box_w / 2, -wall_t / 2, box_h - 9])
            rotate([0, 90, 0])
                cylinder(d = lock_hole_d, h = 30, center = true);

        // top sliding track grooves
        rail_depth = 2;
        rail_h = 3.5;
        rail_z = box_h - rail_h;

        translate([wall_t - rail_depth, wall_t - eps, rail_z])
            cube([rail_depth + eps, phone_d + eps, rail_h + eps]);

        translate([box_w - wall_t, wall_t - eps, rail_z])
            cube([rail_depth + eps, phone_d + eps, rail_h + eps]);

        // nfc card pocket
        if (nfc_slot_location == "side") {
            holster_d = nfc_pocket_w + 2 * wall_t;
            holster_y = (box_d - holster_d) / 2;
            pocket_depth = 75;
            pocket_floor_z = box_h - pocket_depth;

            translate([box_w + wall_t, (box_d - nfc_pocket_w) / 2, pocket_floor_z])
                cube([nfc_pocket_t, nfc_pocket_w, pocket_depth + 10]);

            translate([box_w + wall_t + nfc_pocket_t - eps, box_d / 2, pocket_floor_z + 20])
                rotate([0, 90, 0])
                    cylinder(d = thumb_w, h = nfc_lip_t + 2 * eps);

            translate([box_w + wall_t + nfc_pocket_t - eps, (box_d - thumb_w) / 2, pocket_floor_z + 20])
                cube([nfc_lip_t + 2 * eps, thumb_w, pocket_depth]);
        }

        if (nfc_slot_location == "base") {
            pedestal_d = nfc_pocket_t + nfc_lip_t + 10;
            translate([(box_w - nfc_pocket_w) / 2, -pedestal_d + wall_t, floor_t])
                cube([nfc_pocket_w, nfc_pocket_t, 35]);

            translate([box_w / 2, -pedestal_d - eps, floor_t + 16])
                rotate([-90, 0, 0])
                    cylinder(d = thumb_w, h = wall_t + 2 * eps);
        }

        // charger port
        translate([box_w / 2, box_d / 2, -eps])
            hull() {
                translate([-6, 0, 0]) cylinder(d = 8, h = floor_t + 2 * eps);
                translate([ 6, 0, 0]) cylinder(d = 8, h = floor_t + 2 * eps);
            }
    }
}

// sliding locking lid
module locking_lid() {
    lid_w = box_w;
    lid_d = box_d;
    lid_cap_t = 3.5;
    rail_depth = 2 - lid_tolerance;
    rail_h = 3.5 - lid_tolerance;

    difference() {
        union() {
            // main plate
            rounded_box(lid_w, lid_d, lid_cap_t, corner_r);

            // left and right guide rails with overlap
            translate([wall_t - rail_depth, wall_t + lid_tolerance, -rail_h])
                cube([rail_depth, phone_d - 2 * lid_tolerance, rail_h + eps]);

            translate([box_w - wall_t, wall_t + lid_tolerance, -rail_h])
                cube([rail_depth, phone_d - 2 * lid_tolerance, rail_h + eps]);

            // inner retention block with overlap
            translate([wall_t + lid_tolerance, wall_t + lid_tolerance, -4.5])
                rounded_box(phone_w - 2 * lid_tolerance, phone_d - 2 * lid_tolerance, 4.5 + eps, 1.5);

            // front padlock tongue solidly integrated into main plate
            translate([box_w / 2 + 1, -wall_t, -18])
                cube([11, wall_t + 2, 18 + lid_cap_t]);
        }

        // matching padlock hole
        translate([box_w / 2, -wall_t / 2, -9])
            rotate([0, 90, 0])
                cylinder(d = lock_hole_d, h = 30, center = true);

        // finger grip
        translate([lid_w / 2, lid_d - 5, lid_cap_t + 8])
            sphere(r = 10);
    }
}

// nfc card preview
module nfc_card_preview() {
    color([0.15, 0.55, 0.95, 0.9])
        rounded_box(nfc_card_t, nfc_card_w, nfc_card_h, 3.18);
}

// render selector
if (part_to_render == "cage") {
    phone_jail_cage();
} else if (part_to_render == "lid") {
    translate([0, 0, 3.5])
        rotate([180, 0, 0])
            locking_lid();
} else if (part_to_render == "print_plate") {
    phone_jail_cage();
    translate([box_w + 24, 0, 3.5])
        rotate([180, 0, 0])
            locking_lid();
} else if (part_to_render == "assembly") {
    phone_jail_cage();
    translate([0, 0, box_h])
        locking_lid();
    if (nfc_slot_location == "side") {
        pocket_depth = 75;
        translate([box_w + wall_t + (nfc_pocket_t - nfc_card_t) / 2,
                   (box_d - nfc_card_w) / 2,
                   box_h - pocket_depth])
            nfc_card_preview();
    }
}
