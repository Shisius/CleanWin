use </home/shisius/Projects/UniversalTools/CADLIB/base.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/mechanic.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gears.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/motor_mount.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/profile.scad>;
use </home/shisius/Projects/UniversalTools/CADLIB/gt2.scad>;
use <cw_hbar.scad>;

sink_outer_w = 20;
sink_inner_w = 18;
sink_shell = sink_outer_w - sink_inner_w;
sink_depth = 15;
sink_l = 600;
sink_full_h = 30;
sink_min_h = 7;
sink_h_ch_l = 200;
sink_pipe_d_max = 10;
sink_pipe_d_min = 4.5;
sink_pipe_d_mid = 6.5;
sink_ft_groove_size = 12;
sink_ft_groove_depth = 8;
sink_ft_groove_l = 12;
sink_ft_groove_a = 65;

module water_sink()
{
    difference() {
        union() {
            prism(h = sink_outer_w)
            polygon([[-sink_l/2, sink_full_h], [sink_l/2, sink_full_h], 
                     [sink_l/2, sink_full_h - sink_min_h],
                     [sink_l/2 - sink_h_ch_l, 0],
                     [-sink_l/2 + sink_h_ch_l, 0],
                     [-sink_l/2, sink_full_h - sink_min_h]]);
            // Pipe
            translate([-1.5 *sink_pipe_d_max, -1.5 * sink_pipe_d_max, 0])
            cube([5 * sink_pipe_d_max, 3 * sink_pipe_d_max + 0.01, sink_outer_w], 
                center = true);
        }
        union() {
            translate([0, 0, -sink_shell/2 - 0.01])
            prism(h = sink_inner_w)
            polygon([[-sink_l/2 + sink_shell, sink_full_h + 0.01], 
                     [sink_l/2 - sink_shell, sink_full_h + 0.01], 
                     [sink_l/2 - sink_shell, sink_full_h - sink_min_h + sink_shell],
                     [sink_pipe_d_max/2, sink_depth],
                     [-sink_pipe_d_max/2, sink_depth],
                     [-sink_l/2 + sink_shell, sink_full_h - sink_min_h + sink_shell]]);
            // Pipe hole
            translate([0, sink_full_h/2, -sink_shell/2 - 0.01])
            rotate([90, 0, 0])
            cylinder(d = sink_pipe_d_max, h = sink_full_h + 0.1, center = true);
            translate([-2 * sink_pipe_d_max, 0, -sink_shell/2 - 0.01])
            intersection() {
                torus(4 * sink_pipe_d_max, sink_pipe_d_max);
                translate([1.25 * sink_pipe_d_max, -1.5 * sink_pipe_d_max, 0])
                cube([2.5 * sink_pipe_d_max, 
                    3 * sink_pipe_d_max + 0.01, sink_outer_w], center = true);
            }
            translate([-2.5 * sink_pipe_d_max, -2 * sink_pipe_d_max, 
                -sink_shell/2 - 0.01])
            rotate([0, 90, 0])
            cylinder(d2 = sink_pipe_d_max, d1 = sink_pipe_d_min, 
                h = sink_pipe_d_max + 0.01, center = true);
            translate([-3.5 * sink_pipe_d_max, -2 * sink_pipe_d_max, 
                -sink_shell/2 - 0.01])
            rotate([0, 90, 0])
            cylinder(d = sink_pipe_d_mid, 
                h = sink_pipe_d_max + 0.01, center = true);
        }
    }
}

module water_sink_end()
{
    union() {
        intersection() {
            water_sink();
            translate([sink_l/2, 0, 0])
            cube([400, 100, 100], center = true);
        }
        translate([sink_l/2 - sink_h_ch_l - sink_ft_groove_l/2,  
            sink_ft_groove_depth/2 + (sink_full_h - sink_depth)/2, 0])
        rotate([0, 90, 180])
        fishtop(gender = "m", size = sink_ft_groove_size, 
                    depth = sink_ft_groove_depth, angle = sink_ft_groove_a, 
                    length = sink_ft_groove_l + 0.01, 
                    stem = 0, backlash = 0);
    }
}

module water_sink_mid()
{
    difference() {
        intersection() {
            water_sink();
            translate([0, 0, 0])
            cube([200, 100, 100], center = true);
        }
        mirrorcp([1, 0, 0])
        translate([sink_l/2 - sink_h_ch_l - sink_ft_groove_l/2,  
            sink_ft_groove_depth/2 + (sink_full_h - sink_depth)/2, 0])
        rotate([0, 90, 180])
        fishtop(gender = "m", size = sink_ft_groove_size, 
                    depth = sink_ft_groove_depth, angle = sink_ft_groove_a, 
                    length = sink_ft_groove_l + 0.5, 
                    stem = 0, backlash = 0.2);
    }
}

$fn = 100;
water_sink_end();
