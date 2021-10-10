// For pitch
use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/motor_mount.scad>;
// Parameters
// solp - solar panel
// thick - thicness
// hldr - holder
// bklh - backlash
// term - terminal
solp_thick = 18;
solp_l = 40;
solp_w = 30;

motor_t = "nema17";
motor_bolts = motor_bolt_size(motor_t, backlash = [0, 0]); //[3, 5, 2]

profile_w = 40;
profile_h = 20;

belt_w = 6;
belt_hldr_w = 9;

gear_d = 13;
gear_full_w = 15; // full Y space for gear and belt

motor_shaft_d = 6;
term_shaft_d = 5;

shaft_d = 8;
shaft_dist = 25; // distance between shafts
shaft_bklh = 0.1;

unit_w = 36;
unit_h = 25;
motor_unit_l = 40;

unit_bottom_thick = 3;
unit_back_wall = 4;
shaft_hldr_w = (unit_w - gear_full_w)/2;
shaft_bolts = [2.5, 5, 3];

cap_bolt_d = 2.5;
cap_bolt_h = 10;
cap_bolt_dist_motor = motor_unit_l * 1/2;

shaft_h = unit_bottom_thick + shaft_d/2 + motor_bolts[2];
shaft_bolts_h = unit_h - shaft_h - shaft_d/2 - shaft_bolts[2];
echo(shaft_h = shaft_h);
echo(shaft_bolts_h = shaft_bolts_h);




// Motor_unit
module solspl_motor_unit()
{
    difference() {
        union() {
            // bottom platform
            translate([0, 0, unit_bottom_thick/2])
            cube([motor_unit_l, unit_w, unit_bottom_thick], 
                center = true);
            // back wall
            translate([motor_unit_l/2 - unit_back_wall/2, 0, unit_h/2])
            cube([unit_back_wall, unit_w, unit_h], center = true);
            // shaft holders
            mirrorcp([0, 1, 0]) 
            translate([0, (unit_w - shaft_hldr_w)/2, unit_h/2])
            cube([motor_unit_l, shaft_hldr_w, unit_h], center = true);
        }
        union() {
            // nema 17
            placeclone(motor_bolt_places(type = motor_t, dir = "z"))
            union() {
                translate([0, 0, unit_bottom_thick/2 + 0.005])
                cylinder(r = motor_bolts[0]/2, 
                    h = unit_bottom_thick + 0.02, 
                    center = true);
                translate([0, 0, 
                    (unit_h + unit_bottom_thick + 0.01)/2])
                cylinder(r = motor_bolts[1]/2, 
                    h = unit_h - unit_bottom_thick + 0.02, 
                    center = true);
            }
            // shafts
            mirrorcp([0, 1, 0])
            shaft(shaft_d, backlash = shaft_bklh, dir = "x", 
                length = motor_unit_l - unit_back_wall + 0.01, 
                pos = [-unit_back_wall, shaft_dist/2, shaft_h]);
            // motor shaft hole
            translate([0, 0, unit_bottom_thick/2])
            cylinder(r = motor_shaft_d/2, h = unit_bottom_thick + 0.01, 
                center = true);
            // shaft holder bolts holes
            mirrorcp([0, 1, 0])
            union() {
                translate([0, (unit_w - shaft_hldr_w)/2, 
                    shaft_h + shaft_d/2 + shaft_bolts_h/2])
                cylinder(r = shaft_bolts[0]/2, h = shaft_bolts_h + 0.5, 
                    center = true);
                translate([0, (unit_w - shaft_hldr_w)/2, 
                    unit_h - shaft_bolts[2]/2])
                cylinder(r = shaft_bolts[1]/2, h = shaft_bolts[2] + 0.01,
                    center = true);
            }
            // cap bolts
            mirrorcp([1, 0, 0]) mirrorcp([0, 1, 0])
            translate([cap_bolt_dist_motor/2, (unit_w - shaft_hldr_w)/2, 
                unit_h - cap_bolt_h/2])
            cylinder(d = cap_bolt_d, h = cap_bolt_h + 0.01, center = true);
        }
    }
}



















$fn = 64;
solspl_motor_unit();