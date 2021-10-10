use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/mechanic.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/motor_mount.scad>;

corner_w = 58;
corner_l = 58;
corner_h = 57.5;
corner_th = 6;
corner_motor_tmpl_wall = 3;
corner_motor_tmpl_btm = 3;
corner_motor_tmpl_h = 8;
corner_motor_tmpl_offset_w = (corner_w - 42)/2 - corner_th + 1;
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
            motor_protrusion(type = "nema17", backlash = 0.1, 
                height = corner_motor_tmpl_btm*2, dir = "z", pos = [0, 0, 0]);
        }
    }
}

module corner_bar_tmpl()
{
    
}

$fn = 100;
corner_motor_tmpl();
