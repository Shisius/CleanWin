// Two smoking barrels
use <cwauger.scad>;
use <cwprofile.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/motor_mount.scad>;

// auger
auger_pitch = 25; //30
auger_shaft_d = 10.3;
auger_shell = 1.2;
auger_claw = 1.0; //0.65;
auger_sector_angle = 90; //180;
auger_groove_h = 4;
auger_groove_a = 0; //110;
auger_groove_backlash = 0.3;
auger_groove_duty = 1/2;

// carriage
car_length = 40;
car_cube_width =18;
car_auger_backlash = [0.4, 0.4, 0.25]; // shaft, thread_xy, thread_z
car_hole_full_d = auger_shaft_d + 2*auger_shell + 2*auger_claw + 
    2*car_auger_backlash[1];
echo(car_cube_shell = (car_cube_width - car_hole_full_d)/2);

// leading profile
lead_shaft_d = 10.3;
lead_shaft_shell = (12 - lead_shaft_d)/2;
profile_width = 40;
profile_height = 17;
profile_support_height = 3;
profile_base_width = 13;

// metal leading profile
lead_metal_shaft_d = 12;
lead_metal_shaft_unit_backlash = 0.1;

// units
unit_width = 36;
unit_height = 50;
motor_unit_length = 10;
motor_unit_bearing = [15, 10, 5]; // outer, inner, height
motor_unit_bearing_backlash = 0.1;
terminal_unit_length = 10;
terminal_unit_bearing = [20, 10, 6]; // outer, inner, height
terminal_unit_bearing_backlash = 0.1;
cw_mount_d_motor = 4;
cw_mount_d_terminal = 5;
cw_mount_spacing_motor = 24;
cw_mount_spacing_terminal = 26;

// Resolution
$fn = 128;

// middle auger part
module cwtsb_auger_middle(length, backlash = 0) {
    cw_ballauger_middle(pitch = auger_pitch, 
        shaft_d = auger_shaft_d + 2 * auger_shell,
        shaft_hole = auger_shaft_d,
        full_d = auger_shaft_d + 2 * auger_shell + 2 * auger_claw,
        backlash = backlash, length = length, groove_h = auger_groove_h,
        groove_a = auger_groove_a, slices = 18);
}

// carriage
module cwtsb_car_cube()
{
    difference() {
        cube([car_cube_width, car_cube_width, car_length], center = true);
        union() {
            translate([0, 0, -car_length])
                cwtsb_auger_middle(2 * car_length, 
                    backlash = -car_auger_backlash);
            cylinder(r = auger_shaft_d/2 + 0.01,
                h = car_length * 2, center = true);
        }
    }
}

// middle drill auger part
module cwtsb_auger_drill_middle(length, backlash = 0) {
    cw_sectorauger_middle(pitch = auger_pitch, 
        shaft_d = auger_shaft_d + 2 * auger_shell,
        shaft_hole = auger_shaft_d,
        full_d = auger_shaft_d + 2 * auger_shell + 2 * auger_claw,
        backlash = backlash, length = length,
        sector_a = auger_sector_angle,
        groove_h = auger_groove_h,
        groove_a = auger_groove_a, 
        groove_backlash = auger_groove_backlash, 
        groove_duty = auger_groove_duty, 
        rot_dir = "r", resolution = 0.1);
}

// carriage. drill version
module cwtsb_car_cube_drill(length = car_length)
{
    difference() {
        cube([car_cube_width, car_cube_width, length], 
            center = true);
        union() {
            translate([0, 0, -car_length])
                cwtsb_auger_drill_middle(2 * length, 
                    backlash = -car_auger_backlash);
            cylinder(r = auger_shaft_d/2 + 0.01,
                h = length * 2, center = true);
        }
    }
}

// carriage for lift testing
module cwtsb_car_cube_lift()
{
    support_thickness = 4;
    support_d = 50;
    car_length = 40;
    union() {
        cwtsb_car_cube_drill(length = car_length);
        translate([0, 0, -car_length/2 + support_thickness/2])
        difference() {
            cylinder(r = support_d/2, h = support_thickness, center = true);
            cylinder(r = car_hole_full_d/2 + 0.1, 
                h = support_thickness + 0.01, center = true);
        }
    }   
}

// leading profile part
module cwtsb_profile_part(length) {
    cw_keyhole_supported(key_d = lead_shaft_d + lead_shaft_shell*2, 
        key_h = profile_height - profile_support_height, 
        key_base = profile_base_width, 
        key_angle = 60, hole_d = lead_shaft_d, 
        support_h = profile_support_height, support_w = profile_width,
        con_l = 20, con_w = 5, con_h = 8, con_hole_d = 2.8,
        con_hole_offset = 2, rib_h = 8, rib_w = 3, length = length);
}

// units common
module cwtsb_unit_minimal(unit_length, unit_bearing, 
    unit_bearing_backlash, cw_mount_spacing, cw_mount_d)
{
    difference() {
        cube([unit_height, unit_width, motor_unit_length], center = true);
        union() {
            // shaft place
            shaft_hole_d = lead_metal_shaft_d + 
                        lead_metal_shaft_unit_backlash * 2;
            mirrorcp([1, 0, 0]) union () {
                translate([unit_height/2 - lead_metal_shaft_d/2, 0, 0])
                    cylinder(r = shaft_hole_d/2,
                        h = unit_length + 0.01, center = true);
                translate([unit_height/2, 0, 0])
                    cube([shaft_hole_d, shaft_hole_d, 
                        unit_length + 0.01], center = true);
            }
            // bearing
            translate([0, 0, unit_length/2 - unit_bearing[2]/2 + 0.01])
            bearingplace(unit_bearing[0], unit_bearing[1], unit_bearing[2], 
                backlash = unit_bearing_backlash);
            // cwmount
            mirrorcp([0, 1, 0]) shaft(cw_mount_d, 
                length = unit_height + 0.01, backlash = 0, dir = "x", 
                pos = [0, cw_mount_spacing/2, 0]);
        }
    }
}

// motor unit
module cwtsb_motorunit_minimal() {
    translate([0, 0, motor_unit_length/2])
    difference() {
        cwtsb_unit_minimal(motor_unit_length, motor_unit_bearing, 
            motor_unit_bearing_backlash, cw_mount_spacing_motor, 
            cw_mount_d_motor);
        union() {
            // motor mount
            placeclone(motor_bolt_places(type = "nema17", dir = "z"))
            union() {
                cylinder(r = 1.5, h = motor_unit_length + 0.01, 
                    center = true);
                translate([0, 0, motor_unit_length/2])
                cylinder(r = 2.5, h = 4, center = true);
            }
            // protrusion
            motor_protrusion(type = "nema17", backlash = 0.15, dir = "z", 
                pos = [0, 0, -motor_unit_length/2]);
        }
    }
}

// terminal unit
module cwtsb_terminalunit_minimal() {
    translate([0, 0, terminal_unit_length/2])
        cwtsb_unit_minimal(terminal_unit_length, terminal_unit_bearing, 
            terminal_unit_bearing_backlash, cw_mount_spacing_terminal, 
            cw_mount_d_terminal);
}

// Auger-motor connector
module cwtsb_augermotor_connector(length = 20)
{
    cw_hole2trunc_shaft(hole_d = 8, motor_shaft_d = 5, motor_trunc = 0.5, 
        length = length, hole_backlash = 0.2, motor_backlash = 0.3, 
        mount_hole_d = 2.5, mount_hole_pos = 5);
}

// show

//translate([0, 0, -car_length])
//cwtsb_auger_middle(90, backlash = 0);
//cwtsb_auger_drill_middle(150, backlash = 0);
//difference() {
//cwtsb_car_cube_drill();
//    translate([50,0,0]) cube([100,100,100], center = true);
//}
cwtsb_motorunit_minimal();
//cwtsb_terminalunit_minimal();
//cwtsb_car_cube_lift();
//cwtsb_augermotor_connector();