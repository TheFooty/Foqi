// phone clearance
phone_w = 82;
phone_d = 16;
phone_h = 155;

// wall thickness
wall_t = 3;
floor_t = 3;
corner_r = 4;

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

// main body
difference() {
    rounded_box(box_w, box_d, box_h, corner_r);
    
    // phone cavity
    translate([wall_t, wall_t, floor_t])
        rounded_box(phone_w, phone_d, phone_h + 10, 2);
}
