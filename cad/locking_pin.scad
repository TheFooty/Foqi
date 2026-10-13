// foqi locking pin
// mesh resolution
$fn = 60;

// lock parameters matching foqi cage
lock_hole_d = 6.5;
cage_tab_t = 8;
hasp_ramp_h = 12;
lid_cap_t = 3.5;
effective_cage_t = cage_tab_t + hasp_ramp_h / 2;
tab_stack_t = effective_cage_t + lid_cap_t;

// pin sizing
pin_clearance = 0.6;
pin_d = lock_hole_d - pin_clearance;
pin_grip_len = tab_stack_t + 1.0;

// head parameters
head_d = 14;
head_h = 4;
lanyard_hole_d = 3.2;

// snap detent parameters
barb_d = lock_hole_d + 0.4;
barb_ramp_h = 1.0;
barb_lip_h = 0.6;
entry_cone_h = 2.2;
slot_w = 1.2;
slot_h = 12;
relief_d = 1.6;
cross_hole_d = 2.2;

eps = 0.05;

// locking pin module
module locking_pin() {
    total_pin_h = head_h + pin_grip_len + barb_ramp_h + barb_lip_h + entry_cone_h;
    barb_start_z = head_h + pin_grip_len;
    slot_start_z = total_pin_h - slot_h;
    cross_z = head_h + tab_stack_t + 0.6;

    difference() {
        union() {
            // ergonomic pull head with chamfered rim
            cylinder(d1 = head_d, d2 = head_d - 1.5, h = head_h);

            // pin shaft
            translate([0, 0, head_h - eps])
                cylinder(d = pin_d, h = pin_grip_len + 2 * eps);

            // detent reverse ramp
            translate([0, 0, barb_start_z])
                cylinder(d1 = pin_d, d2 = barb_d, h = barb_ramp_h);

            // detent waist
            translate([0, 0, barb_start_z + barb_ramp_h])
                cylinder(d = barb_d, h = barb_lip_h);

            // lead in entry cone
            translate([0, 0, barb_start_z + barb_ramp_h + barb_lip_h])
                cylinder(d1 = barb_d, d2 = pin_d - 1.8, h = entry_cone_h);
        }

        // grip notches around head perimeter
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
                translate([head_d / 2, 0, -eps])
                    cylinder(d = 2.2, h = head_h + 2 * eps);
        }

        // lanyard pull hole through head
        translate([0, 0, head_h / 2])
            rotate([90, 0, 0])
                cylinder(d = lanyard_hole_d, h = head_d + 2, center = true);

        // flex slot for spring prongs
        translate([-slot_w / 2, -(pin_d + 2) / 2, slot_start_z])
            cube([slot_w, pin_d + 2, slot_h + eps]);

        // circular stress relief at slot root
        translate([0, 0, slot_start_z])
            rotate([90, 0, 0])
                cylinder(d = relief_d, h = pin_d + 2, center = true);

        // optional cross hole for cotter pin or wire deadlock
        translate([0, 0, cross_z])
            rotate([0, 90, 0])
                cylinder(d = cross_hole_d, h = barb_d + 2, center = true);
    }
}

// default render
locking_pin();
