use <CADLIB/base.scad>;
use <CADLIB/mechanic.scad>;
use <CADLIB/gears.scad>;
use <CADLIB/motor_mount.scad>;
use <CADLIB/profile.scad>;
use <CADLIB/gt2.scad>;
use </home/shisius/Build/Bolts/nuts_and_bolts_v1.95.scad>;

belt_w = 10.0;
belt_th = 1.3;
belt_base_th = 0.6;
belt_hole_w = 13.0;
belt_hole_th = 5.0;
gear_d = 13;
gear_h = 15;
gear_motor_max_d = 17;
gear_max_d = 20;
gear_shaft_d = 5;

bar_d = 20.2;
bar_h = 15;
bar_l = 1500;
bar_th = 1.7;
bar_stop = 34;
bar_mount_d = 4;
bar_mount_indent = [9, 7];
bar_mount_h_offset = -0;
bar_mount_hex = 8;
bar_mount_hex_h = 4;

bar_mount_indent_gear = 0;

unit_w = 40;
unit_l = 50;
unit_h = 45;

unit_mount_d = 3.5;

motor_plate_th = 21;
motor_prot_h = 3;

term_wall = 4;
term_gear_indent = unit_l - gear_max_d/2 - term_wall;
term_bar_stop = term_wall*1.5 + gear_max_d;
term_gear_skirt_h = 5;
term_gear_hldr_th = 5;
term_gear_blsh = 0.2;
term_interbar_l = 30;

car_full_l = 30;
car_border_th = 2;
car_main_l = car_full_l;
car_slider_d = bar_d + 4.5;
car_bar_blsh = 0.5;
car_th = 2;
car_outer_d = car_slider_d + car_th*2;
car_window_gap_min = 0.9;

bridge_h = 15.2;
bridge_w = 15.2;
bridge_l = 600;
bridge_btm_th = 1.5;
bridge_side_th = 1.8;
bridge_mount_d = 4;
//bridge_mount_indent = []

car_bridge_hldr_l = 20;
car_bridge_hldr_h = bridge_h + 2;
car_belt_border_w = 7;
car_belt_border_h = 3;
car_belt_hldr_shell = 4;
car_belt_mount_d = 3;
car_fasten_d = 3;
car_back_wall = 1.5;

cw_mount_w = 12;
cw_mount_h = 3;
cw_mount_a = 45;
cw_mount_wall = 5;
cw_mount_dist = 18;
cw_mount_mount_d = 3.2;
cw_mount_mount_hat = 8;
cw_mount_mount_h = 2;
cw_mount_plate_h = 1.0;
cw_mount_stem = 0.2;

cw_term_mount_dist = 24;
bar_term_mount_indent = [12, 4];

echo(bottom_gap = - bar_d/2 + bar_h);

module hbar_motor_unit() {
    difference() {
        union() {
            cube([unit_l, unit_w, unit_h], center = true);
        }
        union() {
            // bar
            translate([bar_stop,0,bar_h - unit_h/2]) rotate([0, 90, 0])
            cylinder(d = bar_d, h = unit_l + 0.1, center = true);
            // motor_mount
            translate([0, -motor_plate_th])
            placeclone(motor_bolt_places(type = "nema17", dir = "y"))
            rotate([90,0,0])
            cylinder(d = motor_bolt_size(type = "nema17", backlash = [0, 0.4])[1], 
                     h = unit_w, center = true);
            placeclone(motor_bolt_places(type = "nema17", dir = "y"))
            rotate([90,0,0])
            cylinder(d = motor_bolt_size(type = "nema17")[0], h = unit_w + 0.1, 
                     center = true);
            // protrusion
            motor_protrusion(type = "nema17", backlash = 0.3, 
                height = motor_prot_h, dir = "y", pos = [0, unit_w/2, 0]);
            // gear
            rotate([90,0,0])
            cylinder(d = gear_motor_max_d, h = unit_w+0.1, center = true);
            // mount
            mirrorcp([0,1,0])
            translate([-cw_mount_wall, cw_mount_dist/2, -unit_h/2 + cw_mount_h])
            rotate([-90, 0, 90])
            fishtop(gender = "m", size = cw_mount_w, 
                    depth = cw_mount_h, angle = cw_mount_a, length = unit_l, 
                    stem = 0.1, backlash = 0.1);
            mirrorcp([1,0,0]) mirrorcp([0,1,0])
            translate([unit_l/2 - unit_mount_d, unit_w/2 - unit_mount_d])
            cylinder(d = unit_mount_d, h = unit_h + 0.1, center = true);
            // belt
            translate([unit_l/4, 0, 0])
            cube([unit_l/2 + gear_d, belt_hole_w, belt_hole_th + gear_d],
                center = true);
            //translate([unit_l/4, 0, gear_d/2 - bar_d/4])
            //cube([unit_l/2 + gear_d, belt_hole_w, belt_hole_th + bar_d/2],
            //    center = true);
            // bar mount
            translate([unit_l/2 - bar_mount_indent[0], 0, 
                       bar_h - unit_h/2 + bar_mount_h_offset])
            rotate([90,0,0])
            bolt_nut_mount(l = unit_w + 0.1, d = bar_mount_d);
            translate([-unit_l/2 + bar_mount_indent[1] + bar_stop, 0, 
                       bar_h - unit_h/2 + bar_mount_h_offset])
            rotate([90,0,0])
            bolt_nut_mount(l = unit_w + 0.1, d = bar_mount_d);
        }
    }
}

module hbar_terminal_unit_holder() {
    difference() {
        union() {
            cube([unit_l, unit_w, unit_h], center = true);
        }
        union() {
            // bar
            translate([term_bar_stop, 0, bar_h - unit_h/2]) rotate([0, 90, 0])
            cylinder(d = bar_d, h = unit_l + 0.1, center = true);
            // gear
            translate([unit_l/2 - term_gear_indent, 0, 0]) rotate([90,0,0])
            cylinder(d = gear_max_d, h = gear_h + term_gear_blsh*2, center = true);
            // belt
            translate([unit_l/4, 0, 0])
            cube([unit_l/2 + gear_d, belt_hole_w, belt_hole_th + gear_d], 
                center = true);
            // axis
            translate([unit_l/2 - term_gear_indent, 0, 0]) rotate([90,0,0])
            bolt_nut_mount(d = gear_shaft_d, l = unit_w + 0.01);
            // mount
            mirrorcp([1, 0, 0])
            translate([-cw_term_mount_dist/2, -cw_mount_wall, -unit_h/2 + cw_mount_h])
            rotate([-90, 0, 0])
            fishtop(gender = "m", size = cw_mount_w, 
                    depth = cw_mount_h, angle = cw_mount_a, length = unit_w, 
                    stem = 0.1, backlash = 0.1);
            // bar mount
            translate([unit_l/2 - bar_term_mount_indent[0], 0, 
                       bar_h - unit_h/2 + bar_mount_h_offset])
            rotate([90,0,0])
            bolt_nut_mount(l = unit_w + 0.1, d = bar_mount_d);
            translate([-unit_l/2 + bar_term_mount_indent[1] + bar_stop, 0, 
                       bar_h - unit_h/2 + bar_mount_h_offset])
            rotate([90,0,0])
            bolt_nut_mount(l = unit_w + 0.1, d = bar_mount_d);
            // delete useless
            translate([0, 0, unit_h/2]) 
            cube([unit_l+1, unit_w+1, unit_h - gear_max_d - bar_stop*2], 
                center = true);
        }
    }
}

module hbar_terminal_unit_gear() {
    difference() {
        union() {
            // gear_holder
            mirrorcp([0, 1, 0]) translate([0, gear_h/2 + term_gear_blsh, 0])
            union() {
                rotate([-90, 0, 0]) 
                cylinder(d = gear_max_d, h = term_gear_hldr_th);
                translate([gear_max_d/4, term_gear_hldr_th/2, 0])
                cube([gear_max_d/2, term_gear_hldr_th, gear_max_d], 
                    center = true);
            }
            // interbar
            translate([term_interbar_l/2 + gear_max_d/2 + term_gear_skirt_h, 
                0,bar_h - unit_h/2]) 
            rotate([0, 90, 0])
            cylinder(d = bar_d - bar_th*2, h = term_interbar_l, center = true);
            // Skirt
            translate([gear_max_d/2 + term_gear_skirt_h/2, 0, 
                bar_h - unit_h/2]) rotate([0, 90, 0]) 
            cylinder(d = bar_d + 1, h = term_gear_skirt_h, center = true);
            translate([gear_max_d/2 + term_gear_skirt_h/2, 0, 0])
            cube([term_gear_skirt_h, 
                gear_h + term_gear_blsh*2 + term_gear_hldr_th*2, gear_max_d], 
                center = true);
        }
        union() {
            // belt
            translate([term_interbar_l/2 + gear_max_d/2 + term_gear_skirt_h/2
                , 0, gear_d/2 + gear_max_d/4-gear_d/4])
            cube([term_interbar_l + term_gear_skirt_h + gear_max_d + 0.1, 
                belt_hole_w, belt_hole_th + gear_max_d/2-gear_d/2], 
                center = true);
            translate([term_interbar_l/2 + gear_max_d/2 + term_gear_skirt_h/2
                , 0, -gear_d/2])
            cube([term_interbar_l + term_gear_skirt_h + 0.1, 
                belt_hole_w, belt_hole_th], center = true);
            // gear mount
            rotate([90,0,0]) cylinder(d = gear_shaft_d, 
                h = gear_h + term_gear_blsh*2 + term_gear_hldr_th*2 + 0.1, 
                center = true);
            // bar mount
            translate([unit_l/2 - bar_mount_indent_gear, 0, 
                       bar_h - unit_h/2 + bar_mount_h_offset])
            rotate([90,0,0]) cylinder(d = bar_mount_d, h = unit_w + 0.1, 
                                          center = true);
        }
    }
}

module hbar_carriage_main()
{
    difference() {
        union() {
            cylinder(d = car_outer_d, h = car_main_l, center = true);
            // bridge mount
            translate([car_bridge_hldr_l/2 + car_outer_d/4, 
                       car_bridge_hldr_h/2 - car_outer_d/2, 0])
            cube([car_bridge_hldr_l + car_outer_d/2, car_bridge_hldr_h, 
                  car_main_l], center = true);
            // belt
            translate([0, car_outer_d/2 + car_belt_border_h, 0])
            rotate([0, 0, 180])
            fishtop(gender = "m", size = car_belt_border_w*2 + belt_w, 
                depth = car_belt_border_h, angle = 45, length = car_main_l, 
                stem = car_outer_d/2);
            // lugs for fastening
            translate([-car_outer_d/4 - car_back_wall/2, 0, 0])
            cube([car_outer_d/2 + car_back_wall, car_outer_d, car_main_l],
                center = true);
        }
        union() {
            cylinder(d = bar_d + car_bar_blsh*2, h = car_main_l + 0.1, 
                     center = true);
            cylinder(d = car_slider_d, h = car_main_l - car_border_th*2,
                     center = true);
            // bridge
            translate([car_bridge_hldr_l/2 + car_outer_d/2, 
                bridge_h/2 - car_outer_d/2 - 0.01, 0]) 
            rotate([90,0,0])
            square_channel(h = bridge_h, w = bridge_w, 
                btm_th = bridge_btm_th, side_th = bridge_side_th, 
                l = car_bridge_hldr_l + 0.01);
            // bridge mount
            translate([car_bridge_hldr_l/4 + car_outer_d/2, 
                bridge_h/2 - car_outer_d/2 - 0.01, 0])
            bolt_nut_mount(l = car_main_l + 0.01, d = bridge_mount_d);
            translate([3*car_bridge_hldr_l/4 + car_outer_d/2, 
                bridge_h/2 - car_outer_d/2 - 0.01, 0])
            bolt_nut_mount(l = car_main_l + 0.01, d = bridge_mount_d);
            // fasten carriage
            mirrorcp([0, 1, 0])
            translate([-car_outer_d/2 + car_fasten_d + 0.1, 
                car_outer_d/2 - car_fasten_d - 0.1, 0])
            rotate([0, 0, 30])
            bolt_nut_mount(l = car_main_l + 0.01, d = car_fasten_d);
            // belt
            translate([0, -bar_h + unit_h/2 + gear_d/2, 0.5])
            rotate([-90, 90, 0])
            gt2lock_pattern(n_pin = car_main_l/2 + 2, width = belt_w, 
                support = car_belt_border_h);
            // window frame
            w_frame_th = car_outer_d;
            translate([0, -w_frame_th/2 - bar_h + car_window_gap_min, 0])
            cube([car_outer_d + 2 * car_bridge_hldr_l + 0.01, w_frame_th, 
                car_main_l + 0.01], center = true);
        }
    }
}

module hbar_belt_holder()
{
    difference() {
        union() {
            fishtop(gender = "f", size = car_belt_border_w*2 + belt_w, 
                    depth = car_belt_border_h, angle = 45, length = car_main_l/2, 
                    shell = [car_belt_hldr_shell, car_belt_hldr_shell], 
                    backlash = 0.1);
            translate([0, car_belt_border_h/2 - belt_th/2 - 0.01, 0])
            cube([belt_w, car_belt_border_h - belt_th, car_main_l/2], 
                center = true);
        }
    }
}

module hbar_mount_plate()
{
    difference() {
        union() {
            // mount
            mirrorcp([0,1,0])
            translate([-cw_mount_wall/2, cw_mount_dist/2, 
                cw_mount_plate_h/2 + cw_mount_h])
            rotate([-90, 0, 90])
            fishtop(gender = "m", size = cw_mount_w, 
                    depth = cw_mount_h, angle = cw_mount_a, 
                    length = unit_l - cw_mount_wall, 
                    stem = 0.1, backlash = 0);
            // plate
            cube([unit_l, unit_w, cw_mount_plate_h], center = true);
        }
        translate([-cw_mount_wall/2, 0, 0])
        mirrorcp([1,0,0]) mirrorcp([0,1,0])
        translate([unit_l/4, cw_mount_dist/2, 0])
        union() {
            cylinder(d = cw_mount_mount_d, h = cw_mount_h * 3, center = true);
            translate([0,0,cw_mount_plate_h/2 + cw_mount_h - cw_mount_mount_h/2])
            cylinder(d1 = cw_mount_mount_d, d2 = cw_mount_mount_hat, 
                     h = cw_mount_mount_h + 0.1, center = true);
        }
    }
}

module hbar_mount_plate_term()
{
    difference() {
        union() {
            // mount
            mirrorcp([1,0,0])
            translate([cw_term_mount_dist/2, -cw_mount_wall/2,  
                cw_mount_plate_h/2 + cw_mount_h + cw_mount_stem])
            rotate([-90, 0, 0])
            fishtop(gender = "m", size = cw_mount_w, 
                    depth = cw_mount_h, angle = cw_mount_a, 
                    length = unit_w - cw_mount_wall, 
                    stem = 0.1 + cw_mount_stem, backlash = 0);
            // plate
            cube([unit_l, unit_w, cw_mount_plate_h], center = true);
        }
        translate([0, -cw_mount_wall/2, 0])
        mirrorcp([1,0,0]) mirrorcp([0,1,0])
        translate([cw_term_mount_dist/2, unit_w/4, 0])
        union() {
            cylinder(d = cw_mount_mount_d, h = cw_mount_h * 3, center = true);
            translate([0,0,cw_mount_plate_h/2 + cw_mount_h 
                + cw_mount_stem - cw_mount_mount_h/2])
            cylinder(d1 = cw_mount_mount_d, d2 = cw_mount_mount_hat, 
                     h = cw_mount_mount_h + 0.1, center = true);
        }
    }
}

module hbar_full(bar_length = bar_l, car_pos = unit_l*2, bridge_length = bridge_l) 
{
    union() {
        mirrorcp([0, 1, 0])
        translate([0, -bridge_length/2, 0])
        union() {
            // motor unit
            translate([unit_l/2,0,0])
            hbar_motor_unit();
            // bar
            translate([bar_length/2,0, bar_h - unit_h/2])
            rotate([0, 90, 0])
            cylinder(d = bar_d, h = bar_length - 2*bar_stop, center = true);
            // car
            translate([car_pos, 0, -bar_h/2])
            rotate([90,0,90])
            hbar_carriage_main();
            // terminal
            translate([bar_length - unit_l/2, 0, 0])
            mirror([0,1,0])
            rotate([0, 0, 180])
            hbar_terminal_unit_holder();
        }
        // bridge
        translate([car_pos, 0, bridge_h/2 - car_outer_d/2 -bar_h/2]) 
        rotate([180,0,90])
        square_channel(h = bridge_h, w = bridge_w, 
            btm_th = bridge_btm_th, side_th = bridge_side_th, 
            l = bridge_length);
    }
}

$fn = 100;
hbar_motor_unit();
//hbar_terminal_unit_gear();
//hbar_belt_holder();
//difference() {
//    hbar_carriage_main();
//    translate([0,0,-car_main_l/2]) cube([100,100, car_main_l], center = true);
//}
//hbar_mount_plate();
//hbar_full(200, 100, 100);
//hbar_terminal_unit_holder();
//hbar_mount_plate_term();