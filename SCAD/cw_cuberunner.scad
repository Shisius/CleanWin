use </home/shisius/Projects/UniversalTools/CADLIB/profile.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use <cwbeltunit.scad>;


belt_width = 6;
belt_height = 41;
profile_size = 20;
profile_gap = 10;
profile_length = 1000;
profile_motor_intersection = 10;
profile_terminal_intersection = 10;
module cwcbr_profile()
{
    square_profile(20, length = profile_length, dir = "x", 
                pos = [0, 0, profile_size / 2 + profile_gap]);
}

module cwcbr_motor_unit()
{
    difference() {
        union() {
            translate([0, 0, 0])
            cw_motor_unit_eave(motor_type = "nema17", 
                motor_support = 7,  
                gear_diameter = 16, 
                belt_height = belt_height, 
                profile_wall = 11, 
                motor_belt_distance = 13, 
                belt_width = belt_width,
                mount_hole = 4);
        }
        union() {
            translate([-profile_length/2 + profile_motor_intersection, 
                0, 0])
                cwcbr_profile();
        }
    }
}

module cwcbr_terminal_unit()
{
    difference() {
        cw_terminal_unit_drcube(width = 42, belt_height = belt_height, 
            gear = [20, 4.9, 8.4], gear_spacer = 1, length = 25, 
            mount_hole = 4);
        translate([profile_length/2 - profile_terminal_intersection, 
            0, 0])
            cwcbr_profile();
    }
}
module cwcbr_all()
{
    translate([profile_length / 2 - profile_motor_intersection, 0, 0])
        cwcbr_motor_unit();
    translate([-profile_length/2 + profile_terminal_intersection, 0, 0]) 
        cwcbr_terminal_unit();
    %translate([0, 0, 0]) cwcbr_profile();
    %translate([0, 0, belt_height]) 
        cube([profile_length + 75, 13, belt_width], center = true);
}

cwcbr_motor_unit();
translate([-15, 45, 0]) rotate([0, 0, -120]) cwcbr_terminal_unit();
$fn = 100;
//minkowski() {
//key_hole(d = 10, h = 15, base = 15, angle = 60, hole = 8, length = 30);
//    sphere(r = 0.2, $fn = 16);
//}




