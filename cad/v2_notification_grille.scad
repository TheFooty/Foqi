// phone clearance
phone_w = 82;
phone_d = 16;
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

$fn = 60;

box_w = phone_w + 2 * wall_t;
box_d = phone_d + 2 * wall_t;
box_h = phone_h + floor_t;

eps = 0.05;

// fast rounded box
module rounded_box(w, d, h, r) {
    linear_extrude(height = h) {
        hull() {
            translate([r, r]) circle(r = r);
            translate([w - r, r]) circle(r = r);
            translate([w - r, d - r]) circle(r = r);
            translate([r, d - r]) circle(r = r);
        }
    }
}

// vertical pill slot through front face
module pill_slot_y(width, height, depth) {
    r = width / 2;
    hull() {
        translate([0, -eps, r])
            rotate([-90, 0, 0])
                cylinder(r = r, h = depth + 2 * eps);
        translate([0, -eps, height - r])
            rotate([-90, 0, 0])
                cylinder(r = r, h = depth + 2 * eps);
    }
}

// main body
difference() {
    rounded_box(box_w, box_d, box_h, corner_r);
    
    // phone cavity
    translate([wall_t, wall_t, floor_t])
        rounded_box(phone_w, phone_d, phone_h + 10, 2);

    // viewing grille
    slot_span_h = box_h - slot_top_clear - (floor_t + slot_bottom_clear);
    grille_margin_x = 10;
    available_w = box_w - 2 * grille_margin_x;
    step_x = (available_w - slot_w) / (num_slots - 1);

    for (i = [0 : num_slots - 1]) {
        x_pos = grille_margin_x + (i * step_x) + (slot_w / 2);
        translate([x_pos, 0, floor_t + slot_bottom_clear])
            pill_slot_y(slot_w, slot_span_h, wall_t);
    }

    // bottom charger port
    translate([box_w / 2, box_d / 2, -eps])
        hull() {
            translate([-6, 0, 0]) cylinder(d = 8, h = floor_t + 2 * eps);
            translate([ 6, 0, 0]) cylinder(d = 8, h = floor_t + 2 * eps);
        }
}
