// Some leading profiles for cleanwin
use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/profile.scad>;

// Supported keyhole
// Supposed to be connectable part of profile
// con_ - connector parameters
// rib_ - side ribs parameters
// _d - diameter, _h - height, _w - width, _l - length
module cw_keyhole_supported(key_d = 1, key_h = 1, key_base = 1, 
    key_angle = 45, hole_d = 0, support_h = 1, support_w = 1, 
    con_l = 0, con_w = 0, con_h = 0, con_hole_d = 0, 
    con_hole_offset = 0, rib_w = 0, rib_h = 0, length = 1)
{
    total_l = length;
    //translate([0, support_h, 0])
    difference() {
        union() {
            key_hole(d = key_d, h = key_h, base = key_base, 
                angle = key_angle, hole = hole_d, length = total_l);
            // support
            translate([0, -support_h/2, con_l]) 
                cube([support_w, support_h, total_l], center = true);
            // connectors
            mirrorcp([1, 0, 0]) 
            translate([support_w/2 - con_w/2, con_h/2, 
                -length/2 + con_l])
                cube([con_w, con_h, con_l*2], center = true);
            // ribs
            mirrorcp([1, 0, 0])
            translate([support_w/2 - rib_w/2, rib_h/2, con_l/2])
                cube([rib_w, rib_h, length - con_l], center = true);
        }
        // holes
        translate([0, 0, con_l/2]) mirrorcp([0, 0, 1])
        translate([0, 0, total_l/2])
        union() {
            mirrorcp([0, 0, 1]) mirrorcp([1, 0, 0])
            translate([support_w/2 - con_w/2, con_h/2 - support_h/2, 
                con_l/2 - con_hole_d/2 - con_hole_offset])
            rotate([90, 0, 0])
                cylinder(r = con_hole_d/2, h = support_h + con_h + 0.01, 
                    center = true);
            mirrorcp([0, 0, 1]) translate([0, con_h/2 - support_h/2, 
                con_l/2 - con_hole_d/2 - con_hole_offset])
            rotate([90, 0, 0])
                cylinder(r = con_hole_d/2, h = support_h + con_h + 0.01, 
                    center = true);
        }
    }
}

$fn = 64;
cw_keyhole_supported(key_d = 12, key_h = 14, key_base = 15, 
    key_angle = 60, hole_d = 10.3, support_h = 3, support_w = 40,
    con_l = 15, con_w = 8, con_h = 4, con_hole_d = 3,
    con_hole_offset = 2, length = 100);