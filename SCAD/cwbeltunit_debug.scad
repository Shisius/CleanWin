use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/motor_mount.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gt2.scad>;

// Termanal unit. For profile and belt gear (tightener)
module cw_terminal_unit_tight_debug(width = 40, belt_height = 40, 
    gear_d = 25, gear_h = 15, gear_shell = 6, gear_cover = 30, 
    bearing = [16.4, 5, 5.2], 
    profile_l = 50, cube_profile_w = 20, profile_gap = 10, 
    nut_size = 14, nut_h = 8, bolt_wall = 20, bolt_d = 8,
    mount_hole = 3)
{
    total_l = profile_l + nut_h + bolt_wall;
    cube_h = belt_height - gear_h / 2;
    cover_h = gear_h + gear_shell;
    cube_roof = cube_h - profile_gap - cube_profile_w;
    echo(max_bearing_h = cube_roof);
    difference() {
        union() {
            // main
            translate([total_l/2, 0, cube_h/2]) 
                cube([total_l, width, cube_h], center = true);
            // gear shell
            translate([total_l - gear_cover/2, 0, cube_h + cover_h/2])
                cube([gear_cover, width, cover_h], center = true);
            //translate([-length + gear[0]/2, 0, 
            //    cube_height + gear_spacer_height/2])
            //    cylinder(r = gear[1]/2 + gear_spacer_shell, 
            //        h = gear_spacer_height,  center = true);
        }
        union() {
            // profile
            translate([profile_l/2, 0, cube_profile_w/2 + profile_gap])
                cube([profile_l + 0.01, cube_profile_w, cube_profile_w], 
                    center = true);
            // Nut
            translate([profile_l + nut_h/2, 0, 
                profile_gap + cube_profile_w/2])
            rotate([0, 90, 0])
            prism(h = nut_h + 0.01) hexagon(nut_size);
            // Tightener bolt
            translate([total_l - bolt_wall/2, 0, 
                profile_gap + cube_profile_w/2]) rotate([0, 90, 0])
                cylinder(r = bolt_d/2, h = bolt_wall + 0.01, center = true);
            // gear hole
            translate([total_l - gear_shell - gear_d/2, 0, 
                cube_h + gear_h/2])
                cylinder(r = gear_d/2, h = gear_h + 0.01, center = true);
            gear_cube_l = gear_cover - gear_d/2 - gear_shell;
            translate([total_l - gear_shell - gear_d/2 - gear_cube_l/2, 0, 
                cube_h + gear_h/2])
                cube([gear_cube_l + 0.01, gear_d, gear_h + 0.01], 
                    center = true);
            // bearing
            translate([total_l - gear_shell - gear_d/2, 0, 
                cube_h + gear_h/2]) mirrorcp([0, 0 ,1])
                translate([0, 0, gear_h/2 + bearing[2]/2])
                cylinder(r = bearing[0]/2, h = bearing[2] + 0.01, 
                    center = true);
            // bearing shaft
            translate([total_l - gear_shell - gear_d/2, 0, 
                cube_h + gear_h/2])
                cylinder(r = bearing[1]/2, h = gear_h + gear_shell*2 + 0.01, 
                    center = true);
            // unit mount holes
            translate([total_l/2, 0, (cube_h + cover_h)/2])
            mirrorcp([0, 1, 0]) mirrorcp([1, 0, 0]) 
                translate([total_l/2 - 1.0*mount_hole, 
                    width/2 - 1.0*mount_hole, 0]) 
                cylinder(r = mount_hole/2, h = cube_h + cover_h + 0.01, 
                    center = true);
        }
    }
}

module make_gear()
{
    
}
$fn = 128;
cw_terminal_unit_tight_debug();