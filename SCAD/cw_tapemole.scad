use <../../UniversalTools/CADLIB/base.scad>;

function round_corner_root(a,b,r) = 
    sqrt(pow(r,2) / (pow(b,2) + pow(a,2)) - 0.25);
function round_corner_x(a, b, r) = b * round_corner_root(a, b, r) - a/2;
function round_corner_y(a, b, r) = a * round_corner_root(a, b, r) - b/2;

function cw_profile_circle_x(wb, wt, rh, r) = 
    wt/2 - round_corner_x((wb-wt)/2, rh, r);
function cw_profile_circle_y(wb, wt, rh, h, r) = 
    h/2 - rh - round_corner_y((wb-wt)/2, rh, r);

car_wb = 44;
car_wt = 30;
car_bl = 0.1;
car_h = 25;
car_l = 40;
car_rh = car_h/2;

profile_w = 50;
profile_wall = (profile_w - car_wb)/2;
profile_btm = 6;
profile_h = car_h + profile_btm;
profile_r = 50;
profile_l = 40;

belt_w = 16;
belt_th = 4;
belt_step = 3;
belt_fix_w = 1.0;
belt_fix_h = 1.2;
belt_fix_l = car_l/2 - belt_step;

gear_d = 14;

module profile_tm(wb, wt, h, r, l, rh)
{
    intersection() {
        cube([wb, h, l], center = true);
        intersection() {
            translate([cw_profile_circle_x(wb, wt, rh, r), 
                       cw_profile_circle_y(wb, wt, rh, h, r), 
                       0])
            cylinder(r = r, h = l, center = true);
            translate([-cw_profile_circle_x(wb, wt, rh, r), 
                       cw_profile_circle_y(wb, wt, rh, h, r), 
                       0])
            cylinder(r = r, h = l, center = true);
        }
    }
}

module car_tm()
{
    union() {
        difference() {
            profile_tm(car_wb - car_bl*2, car_wt - car_bl*2, 
                car_h - car_bl, profile_r, car_l, car_rh);
            union() {
                // Free belt
                translate([0, -car_h/2 + belt_th/2, 0])
                cube([belt_w, belt_th + 0.01, car_l + 0.01], center = true);
                // Fixed belt
                fixed_belt_cube_h = car_h - gear_d + belt_fix_h - belt_th/2;
                echo(fixed_belt_protrusion = fixed_belt_cube_h);
                translate([0, 
                    -car_h/2 + belt_th/2 + gear_d + fixed_belt_cube_h/2 - 
                    belt_fix_h, 0])
                cube([belt_w, fixed_belt_cube_h + 0.01, 
                    car_l + 0.01], center = true); 
            }
        }
        mirrorcp([0, 0, 1])
        placeclone(
            [for (i = [0:floor(belt_fix_l/belt_step)]) 
            [0, -car_h/2 + belt_th/2 + gear_d - belt_fix_h/2, 
            car_l/2 - i*belt_step - belt_fix_w/2]])
                cube([belt_w, belt_fix_h + 0.01, belt_fix_w], center = true);
    }
}

module lead_tm() {
    difference() {
        union() {
            profile_tm(profile_w, car_wt + 2*profile_wall, 
                car_h + profile_wall, profile_r, profile_l, car_rh);
        }
        union() {
            translate([0, profile_wall/2, 0])
            profile_tm(car_wb, car_wt, 
                car_h + 0.01, profile_r, profile_l + 0.01, car_rh);
        } 
    }
}

$fn = 500;
lead_tm();
translate([0, profile_wall/2 + car_bl/2, 0])
car_tm();