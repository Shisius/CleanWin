// Auger mechanic
use <MCAD/screw.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/thread.scad>;

/// Add grooves to auger
module add_grooves(groove_h, groove_a, full_d, auger_d, full_length, duty = 1/3, backlash = 0)
{
    difference() {
        children();
        union() {
            // bottom grove
            rotate([0, 0, groove_a])
            cube([full_d * 2, auger_d * duty, groove_h * 2], center = true);
            // top groove
            rotate([0, 0, groove_a])
            mirrorcp([0, 1, 0]) translate([0, full_d/2, full_length])
                cube([full_d*2, full_d - auger_d * duty, (groove_h - backlash)*2], 
                    center = true);
        }
    }
}

/// Ball auger
// middle part of auger.
// backlash - only for auger. for hole use another hole diameter.
// groove_h - connecting groove height
// groove_a - connecting groove angle
module cw_ballauger_middle(pitch = 20, shaft_d = 14, shaft_hole = 10, 
    full_d = 25, backlash = 0, length = 100, groove_h = 5, 
    groove_a = 0, slices = 256)
{
    ball_r = (full_d - shaft_d) / 2 - backlash;
    auger_d = shaft_d - backlash * 2;
    full_length = length + groove_h;
    difference() {
        add_grooves(groove_h, groove_a, full_d, auger_d, full_length)
        union() {
            difference() {
                translate([0, 0, -ball_r])
                ball_groove2(pitch, full_length + ball_r, auger_d, 
                    ball_radius = ball_r, slices = slices);
                union() {
                    // cut bottom
                    translate([0, 0, -ball_r - 0.001]) 
                        cube([full_d * 2, full_d * 2, 2 * ball_r], 
                            center = true);
                    // cut top
                    translate([0, 0, full_length + ball_r + 0.001]) 
                        cube([full_d * 2, full_d * 2, 2 * ball_r], 
                            center = true);
                }
            }
            cylinder(r = auger_d/2, h = full_length);
        }
        translate([0, 0, -1]) 
            cylinder(h = full_length + 2, r = shaft_hole / 2);
    }
}

/// Sector auger
// See provious auger description
// sector_a - slice sector angle
// resolution - in z axis in mm
// backlash = [shaft, thread_xy, thread_z] backlash. 
// Or scalar if the backlashes are all the same.
module cw_sectorauger_middle(pitch = 20, shaft_d = 14, shaft_hole = 10,
    full_d = 25, backlash = 0, length = 100, sector_a = 90, groove_h = 5,
    groove_a = 0, groove_backlash= 0, groove_duty = 1/3, rot_dir = "r", 
    resolution = 0.1)
{
    backlash_v = (len(backlash) == 3) ? backlash :
        [backlash, backlash, backlash];
    auger_shaft_d = shaft_d - backlash_v[0] * 2;
    auger_thread_d = full_d - backlash_v[1] * 2;
    auger_sector_a = sector_a - 2 * 360 * backlash_v[2] / pitch;
    full_length = length + groove_h - groove_backlash;
    difference() {
        add_grooves(groove_h, groove_a, full_d, auger_shaft_d, full_length, 
                backlash = groove_backlash, duty = groove_duty)
        translate([0, 0, full_length/2])
        sector_auger(pitch, outer_d = auger_thread_d, shaft_d = auger_shaft_d, 
            sector_a = auger_sector_a, rot_dir = rot_dir, 
            length = full_length, resolution = resolution);
        translate([0, 0, -1]) 
            cylinder(h = full_length + 2, r = shaft_hole / 2);
    }
}

// Auger-motor connector
// Sleeve for auger leading pipe with stepper motor shaft connector
// mount_hole_pos - Position of mount hole counted from top of connector
module cw_hole2trunc_shaft(hole_d = 8, motor_shaft_d = 5, motor_trunc = 0.5, 
    length = 10, hole_backlash = 0.1, motor_backlash = 0.1, mount_hole_d = 3, 
    mount_hole_pos = 3)
{
    difference() {
        shaft(hole_d, length = length, backlash = -hole_backlash);
        union() {
            truncated_shaft(motor_shaft_d, motor_trunc, 
                backlash = motor_backlash, length = length + 0.01);
            translate([hole_d/2, 0, length/2 - mount_hole_pos]) 
            rotate([0, 90, 0])
                cylinder(r = mount_hole_d/2, h = hole_d/2, center = true);
        }
    }
}

//$fn = 32;
cwa_l = 100;
cw_ballauger_middle(pitch = 20, shaft_d = 13, shaft_hole = 10, 
    full_d = 18, backlash = 0, length = cwa_l, 
    groove_h = 5, groove_a = 60, 
    slices = 256);
translate([0, 0, cwa_l])
%cw_ballauger_middle(pitch = 20, shaft_d = 13, shaft_hole = 10, 
    full_d = 18, backlash = 0, length = cwa_l, 
    groove_h = 5, groove_a = 60, 
    slices = 256);
