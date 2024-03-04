use <../../UniversalTools/CADLIB/base.scad>;
use <../../UniversalTools/CADLIB/mechanic.scad>;
use <../../UniversalTools/CADLIB/gears.scad>;
use <../../UniversalTools/CADLIB/motor_mount.scad>;
use <../../UniversalTools/CADLIB/profile.scad>;
use <../../UniversalTools/CADLIB/gt2.scad>;
//use <../../../Build/Bolts/nuts_and_bolts_v1.95.scad>;

main_line = 21;

prof_deep = 5;

snell_w = 7.2;
snell_h = 10.45;
snell_th = 2;
snell_depth = 7;

car_l = 19;
car_top_bl = 0.5;
screw_bias_belt = 2.5;
screw_bias_snell = 7.5;

snell_z = main_line + 10 - 30 + car_top_bl;
snell_mount_th = 5;

module prof2020(l)
{
    scale([l, 1, 1])  
    translate([20 - prof_deep, 0, main_line]) 
    rotate ([0, 0, 90])
    import("stl/prof2020.stl", convexity=10);
}

module nema17()
{
    translate([-1, -49.5, main_line]) 
    rotate ([0, -90, 0])
    import("stl/nema17.stl", convexity=10);
}

module gear20(l=0)
{
    translate([-1+l,0,main_line])
    rotate([90,0,0])
    rotate([0,0,10])
    gt2gear_teeth(width=10, n_teeth = 20, hole_d = 5);
}

module belt6(l=100)
{
    translate([-1+l/2,0,main_line])
    gt2belt_sync(w=6, l=l, gear=20);
}

module bot_unit()
{
    difference()
    {
        translate([0,0,20])
        cube([40,30,40],center=true);
        translate([-1,0,main_line])
        {
            rotate([90,0,0])
            cylinder(d=19,h=31,center=true);
            mirrorcp([0,1,0])
            translate([0,15,0])
            rotate([90,0,0])
            cylinder(d=22, h = 2.5*2, center=true);
            mirrorcp([1,0,0]) mirrorcp([0,0,1])
            translate([31/2,0,31/2])
            rotate([90,0,0])
            cylinder(d=3,h=31,center=true);
            mirrorcp([1,0,0]) mirrorcp([0,1,0])
            translate([12,10,-1])
            cylinder(d=4, h=42, center=true);
        }
        translate([20,0,main_line])
        cube([40,12,18],center=true);
        translate([20-prof_deep/2,0,main_line])
        cube([prof_deep+0.1,20,20],center=true);
    }
}

module top_unit(l)
{
    translate([l+20-2*prof_deep,0,0])
    difference()
    {
        translate([35/2,0,35/2])
        cube([35,30,35],center=true);
        
        translate([21,0,main_line])
        rotate([90,0,0])
        cylinder(d=5,h=32,center=true);
        
        translate([15,0,main_line])
        cube([30,16,18],center=true);
        translate([prof_deep/2,0,main_line])
        cube([prof_deep+0.1,20,20],center=true);
    }
}



module car_unit()
{
    
    module car_main(l)
    {
        translate([0,0,main_line])
        difference()
        {
            translate([0,0,car_top_bl-5])
            cube([l, 40, 30], center=true);
            rotate([0,90,0])rotate([0,0,90])
            prism([l+1])
            polygon([[-10,11], [-10,10-6.9],[-6,10-6.9],[-6,-10+6.9],
                     [-10,-10+6.9],[-10,-10],
                     [10,-10],[10,-10+6.9],[6,-10+6.9],[6,10-6.9],
                     [10,10-6.9],[10,11],[-10,11]]);
            
            mirrorcp([0,1,0])mirrorcp([1,0,0])
            translate([snell_w/2-snell_th/2,20,car_top_bl-5])
            cube([snell_th,snell_depth*2,31], center=true);
            mirrorcp([0,1,0])
            translate([0,20,car_top_bl-5+snell_h-snell_th])
            cube([snell_w,snell_depth*2,30.01], center=true);
            
            mirrorcp([0,1,0])mirrorcp([1,0,0])
            translate([l/2-(l-snell_w)/4, screw_bias_belt + 10, car_top_bl-5])
            union() {
                cylinder(h=31, d=3, center=true);
                translate([0,0,-15])
                prism(5) hexagon(5.5);
            }
            
            mirrorcp([0,1,0])mirrorcp([1,0,0])
            translate([l/2-(l-snell_w)/4, screw_bias_snell + 10, car_top_bl-5])
            union() {
                cylinder(h=31, d=3, center=true);
                translate([0,0,-15])
                rotate([0,0,60])prism(5) hexagon(5.5);
            }
        }
    }
    
    module belt_sup(l)
    {
        plate_th = 3;
        plate_w = 30;
        sup_h = 7;
        belt_gap = 2.5;
        belt_deep = 0.5;
        translate([0,0,plate_th/2+car_top_bl-5+15+main_line])
        difference()
        {
            union()
            {
                difference(){
                    cube([l, plate_w, plate_th], center=true);
                    cube([l+1,6,plate_th+1], center=true);
                }
                mirrorcp([1,0,0])
                union() {
                    translate([sup_h/2+belt_gap/2,0,plate_th/2-sup_h/2])
                    rotate([90,0,0]) cylinder(h=6,d=sup_h,center=true);
                    translate([l/4+sup_h/4+belt_gap/4,0,plate_th/2-sup_h/2])
                    cube([l/2-belt_gap/2-sup_h/2,6,sup_h],center=true);
                }
            }
            translate([0,0,plate_th/2])
            cube([l+1,6,belt_deep*2],center=true);
            
            mirrorcp([0,1,0])mirrorcp([1,0,0])
            translate([l/2-(l-snell_w)/4, screw_bias_belt + 10, 0])
            cylinder(h=plate_th+1, d=3, center=true);
            
            mirrorcp([0,1,0])
            translate([0,20,0])
            cube([snell_w,snell_depth*2,plate_th+1], center=true);
            
        }
    }
    
    color([0.8,1,0],1) car_main(car_l);
    color([0.8,0.5,0],0.7) belt_sup(car_l);
    
}

module snell_x()
{
    module snell_prof(l)
    {
        translate([0,l/2+20-snell_depth,snell_z+snell_h/2+0.01])
        difference()
        {
            cube([snell_w,l,snell_h],center=true);
            translate([0,0,-snell_th/2-0.01])
            cube([snell_w-snell_th*2,l+1,snell_h-snell_th],center=true);
        }
    }
    
    module snell_add()
    {
        difference()
        {
            translate([0,20-snell_depth/2,snell_z])
            union()
            {
                translate([0,0,30/2+snell_h/2+snell_mount_th/2])
                cube([snell_w,snell_depth,30-snell_h+snell_mount_th],
                      center=true);
                translate([0,(snell_depth-5)/2,snell_mount_th/2+30])
                cube([car_l,5,snell_mount_th],center=true);
            }
            
            mirrorcp([0,1,0])mirrorcp([1,0,0])
            translate([car_l/2-(car_l-snell_w)/4, screw_bias_snell + 10, 
                        snell_mount_th/2+30+snell_z])
            cylinder(h=snell_mount_th+1, d=3, center=true);
            
        }
    }
    
    color([0,0.5,0.8],0.7) snell_prof(50);
    color([0,0.5,0.8],0.7) snell_add();
}

$fn=128;

cw_l = 132;

nema17();
color([0,1,1]) gear20();
color([0,1,1]) gear20(l=cw_l);
color([0,1,0]) belt6(l=cw_l);
color([0.8,1,0],1) bot_unit();
color([0.8,1,0],0.8) top_unit(100);
color([0.8,0.8,0.8],0.7) prof2020(1);
translate([50,0,0]) car_unit();
translate([50,0,0]) snell_x();
