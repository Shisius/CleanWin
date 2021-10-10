// double inversed auger
use <MCAD/screw.scad>
use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;

$fa = 1;
module true_auger()
{
    ;
}

pitch = 24;
auger_d = 12;
ball_r = 2.5;
auger_backlash = 0.2;
module cwdia_auger()
{
    ball_groove2(pitch, 120, auger_d, ball_radius = ball_r, 
        slices = 300);
}

module cwdia_doubleauger() {
    translate([0, 0, -60])
    union() {
        cwdia_auger();
        rotate([0, 0, 180]) mirror([1, 0, 0]) cwdia_auger();
        cylinder(h = 120, r = auger_d/2);
    }
}

module cwdia_carriage() {
    difference() {
        translate([0, 0, pitch]) cube([32, 32, 2*pitch], center = true);
        cwdia_doubleauger();
    }
}
shaft_d = auger_d - 2*auger_backlash;
shaft_ball_r = ball_r - auger_backlash;
module cwdia_shaft() {
    $fn = 128;
    shaft_h = 120;
    difference() {
        union() {
            cylinder(r = shaft_d/2, h = shaft_h);
            placeclone([for (i = [0:(shaft_h/pitch-1)]) 
                [shaft_d/2, 0, pitch * i + ball_r]]) 
                sphere(r = shaft_ball_r, center = true);
            placeclone([for (i = [0:(shaft_h/pitch-1)]) 
                [-shaft_d/2, 0, pitch * (i + 0.5) + ball_r]]) 
                sphere(r = shaft_ball_r, center = true);
        }
        cylinder(r = 5, h = shaft_h + 1);
    }
}

module show_inside()
{
    difference() {
        union() {
            //translate([0, 0, -ball_r]) cwdia_shaft();
            cwdia_carriage();
        }
        translate([0, 50, 0]) cube([100, 100, 200], center = true);
    }
}
show_inside();
//cwdia_shaft();
//cwdia_carriage();
//cwdia_doubleauger();