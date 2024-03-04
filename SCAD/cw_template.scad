use </home/cat/Projects/UniversalTools/CADLIB/base.scad>;
use </home/cat/Projects/UniversalTools/CADLIB/mechanic.scad>;
use </home/cat/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/cat/Projects/UniversalTools/CADLIB/motor_mount.scad>;

corner_w = 46;
corner_l = 46;
corner_h = 30;
corner_th = 6;
corner_motor_tmpl_wall = 2;
corner_motor_tmpl_btm = 5;
corner_motor_tmpl_h = 4;
corner_motor_tmpl_offset_w = 0;// (corner_w - 42)/2 - corner_th + 1;

corner_motor_w = 27;
// shaft_d, old_bar_h, hew motor_h, old_motor_h
new_bar_h = 5 + 4 - 1.5;
corner_bar_tmpl_offset_h = corner_l/2 - 20/2 - new_bar_h; 

echo(corner_motor_tmpl_offset_w = corner_motor_tmpl_offset_w);

module corner_motor_tmpl()
{
    difference() {
        box(internal = [corner_l, corner_w, corner_motor_tmpl_h], 
            shell = [corner_motor_tmpl_wall, corner_motor_tmpl_wall,
            corner_motor_tmpl_btm]);
        translate([corner_motor_tmpl_offset_w, corner_motor_tmpl_offset_w, 0])
        union() {
            placeclone(motor_bolt_places(type = "nema17", dir = "z"))
            rotate([0,0,90])
            cylinder(d = 3, 
                     h = corner_motor_tmpl_h*20, center = true);
            // protrusion
            translate([0,0,-2*corner_motor_tmpl_btm])
            cylinder(d = 6.35, 
                     h = corner_motor_tmpl_h*20, center = true);
            //motor_protrusion(type = "nema17", backlash = 0.1, 
            //    height = corner_motor_tmpl_btm*2, dir = "z", pos = [0, 0, 0]);
        }
    }
}

module corner_bar_tmpl()
{
    difference() {
        box(internal = [corner_l, corner_motor_w, corner_motor_tmpl_h], 
            shell = [corner_motor_tmpl_wall, corner_motor_tmpl_wall,
            corner_motor_tmpl_btm]);
        translate([corner_bar_tmpl_offset_h, 0, 0])
        union() {
            // protrusion
            translate([0,0,-2*corner_motor_tmpl_btm])
            cylinder(d = 20, h = 100, center = true);
        }
    }
}

module carriage_bar_tmpl()
{
    difference() {
        car_x = 40;
        car_y = 35;
        hole_d = 24;
        box(internal = [car_x, car_y, corner_motor_tmpl_h], 
            shell = [corner_motor_tmpl_wall, corner_motor_tmpl_wall,
            corner_motor_tmpl_btm]);
        translate([car_x/2 - hole_d/2 - 2, car_y/2 - hole_d/2 - 2, 0])
        union() {
            // protrusion
            translate([0,0,-2*corner_motor_tmpl_btm])
            cylinder(d = hole_d, h = 100, center = true);
        }
    }
}

$fn = 100;
corner_motor_tmpl();
