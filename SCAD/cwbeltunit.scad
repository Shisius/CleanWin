// CleanWin base units for belt driving mechanics 
// Zero level - is a window frame plane.
// belt_height - height of center of belt from zero level
// profile_height - height of center of leading profile from zero level
// profile_gap - height between profile and window frame
use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/motor_mount.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gt2.scad>;


// Motor unit
// belt_width - only for checking size accordance
// motor_belt_distance - distance between motor mounting plane
//      and center of the belt
// motor_support - thickness of motor mounting plate
// mount_hole - holes diameter for mounting on frame
module cw_motor_unit_eave(motor_type = "nema17", motor_support = 5,  
    gear_diameter = 16, belt_height = 40, profile_wall = 10, 
    motor_belt_distance = 12.8, belt_width = 6, mount_hole = 0)
{
    maximum_motor_height = belt_height - motor_belt_distance;
    support_height = maximum_motor_height + motor_support / 2;
    motor_backlash = [0.2, 0, 0];
    profile_wall_h = maximum_motor_height + motor_support;
    support_size_x = motor_size(type = motor_type, 
                     backlash = motor_backlash)[0];
    support_size_y = motor_size(type = motor_type, 
                     backlash = motor_backlash)[1];
    
    echo(maximum_motor_height = maximum_motor_height);
    echo(belt_support_gap = motor_belt_distance - motor_support - 
         belt_width / 2);
    rotate([0, 0, 180])
    translate([-support_size_x / 2 - profile_wall, 0, 0])
    difference() {
        union() {
            translate([0, 0, support_height])
            cube([support_size_x, 
                  support_size_y, 
                  motor_support], center = true);
            translate([support_size_x / 2 + 
                        profile_wall / 2, 0, profile_wall_h / 2])
            cube([profile_wall, 
                  support_size_y,
                  profile_wall_h], center = true);
        }
        union() {
            // Protrusion
            motor_protrusion(type = motor_type, 
                pos = [0, 0, maximum_motor_height]);
            // bolts
            placeclone(motor_bolt_places(type = motor_type, dir = "z")) 
                shaft(motor_bolt_size(type = motor_type)[0], 
                    length = motor_support + 1, 
                    dir = "z", backlash = 0, 
                    pos = [0, 0, support_height]);
            // gear
            translate([0, 0, support_height])
                cylinder(r = gear_diameter / 2, h = motor_support + 1, 
                    center = true);
            translate([-support_size_x / 4, 0, 
                        support_height])
                cube([support_size_x / 2 + 0.01, 
                      gear_diameter, motor_support + 0.01], 
                      center = true);
            // mount hole
            mirrorcp([0, 1, 0]) shaft(mount_hole, 
                length = profile_wall_h + 1, dir = "z", backlash = 0, 
                pos = [profile_wall / 2 + support_size_x / 2, 
                       support_size_x / 2 - mount_hole * 1.0, 
                       profile_wall_h / 2]);
            
        }
    }
}

// Termanal unit. For profile and belt gear (tightener)
// gear = [outer diameter, inner diameter, height]
// length - total length. 
// module will return you available length of profile hole
// gear_spacer - height of spacer and its shell or [height, shell]
module cw_terminal_unit_drcube(width = 40, belt_height = 40, 
    gear = [18, 5, 8.4], gear_spacer = 1, length = 40, mount_hole = 0)
{
    gear_spacer_height = (len(gear_spacer) == undef) ? gear_spacer :
                          gear_spacer[0];
    gear_spacer_shell = (len(gear_spacer) == undef) ? gear_spacer :
                         gear_spacer[1];
    // height
    cube_height = belt_height - gear[2] / 2 - gear_spacer_height;
    // available profile hole length
    available_profile_hole_l = length - gear[0] / 2 - gear[1] / 2;
    echo(available_terminal_profile_hole_length =
         available_profile_hole_l);
    difference() {
        union() {
            // main
            translate([-length/2, 0, cube_height/2]) 
                cube([length, width, cube_height], center = true);
            // gear spacer
            translate([-length + gear[0]/2, 0, 
                cube_height + gear_spacer_height/2])
                cylinder(r = gear[1]/2 + gear_spacer_shell, 
                    h = gear_spacer_height,  center = true);
        }
        union() {
            // gear mount hole
            translate([-length + gear[0]/2, 0, 
                cube_height/2 + gear_spacer_height / 2])
                cylinder(r = gear[1]/2, 
                    h = cube_height + gear_spacer_height + 0.01, 
                    center = true);
            // unit mount holes
            translate([-length/2, 0, cube_height/2])
            mirrorcp([0, 1, 0]) mirrorcp([1, 0, 0]) 
                translate([length/2 - 1.0*mount_hole, 
                    width/2 - 1.0*mount_hole, 0]) 
                cylinder(r = mount_hole/2, h = cube_height + 0.01, 
                    center = true);
        }
    }
}

// Terminal unit. Adjustable 

$fn = 128;
//cw_motor_unit_eave(mount_hole = 3);
cw_terminal_unit_drcube(mount_hole = 3);
