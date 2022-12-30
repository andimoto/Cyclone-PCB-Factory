// Cyclone Z-endswitch mod
// version: 1.0
// author: Marq Kole
// Based on the original design at http://www.thingiverse.com/thing:1131591
// by Sn00zerman, licensed under CC + Attribution.
// Modifications:
// - created the original design and the modification in OpenSCAD.
// - added support for the endswitch PCB mount;
// - added nut holes for the bolts that hold the switch PCB;
// - added a slit and bolt/nut holes for tightening the rods to the
//   endswitch block.

// For this Z-endswitch block you will need:
// - endstop switch board (e.g. http://preview.tinyurl.com/j9maqf2);
// - 4x M3 nut;
// - 2x M3x10 bolt;
// - 2x M3x8 bolt.

w_zend       =  54.0;
h_zend       =  20.0;
d_zend       =  16.0;

w_rodhole    =   8.0;
d_rodhole    =  16.0;
s_rh_centers =  40.0;

w_bolthole   =   3.5;
d_bolthole   =   10.0;

d_nuthole    =   2.3;
w_nuthole    =   5.8;

d_nutslot    =   5.5;

w_pcbmount   =   6.0;
l_pcbmount   =  26.0;
d_pcbmount   =   2.0;

w_clamp      =   3.0;

w_slit       =   1.0;
l_slit       =  16.0;

d_clamphole  =  10.0;
w_clamphole  =   3.5;
s_ch_centers =  22.0;
d_cnutslot   =   4.0;

d_pcboffset  =   h_zend - d_pcbmount - w_rodhole - 2*w_clamp;

d_support    =   0.5;

$fn          = 120;
eps          =   0.05;
d_fit        =   0.25;

setScrewDia = 3;

module zendswitch() {
    difference() {
        union() {

            hull()
            {
              // Main block.
              translate([-2.5-s_rh_centers/2, -w_rodhole/2 - w_clamp +1, d_zend/2])
                  cube([s_rh_centers+5, h_zend - d_pcbmount -1, d_zend/2]);
              translate([3-s_rh_centers/2, 1-w_rodhole/2 - w_clamp, 0])
                  cube([s_rh_centers-6, h_zend - d_pcbmount-6, 0.1]);
            }
            hull()
            {
              // PCB mount block.
              translate([-l_pcbmount/2, w_rodhole/2 + w_clamp + d_pcboffset, d_zend - w_pcbmount])
                  cube([l_pcbmount, d_pcbmount, w_pcbmount]);

              // PCB mount support.
              translate([-l_pcbmount/2, w_rodhole/2 + w_clamp + d_pcbmount - d_support+2.2, d_zend - w_pcbmount-d_pcboffset/2-0.2])
                  cube([l_pcbmount, 0.1, 0.1]);
            }
            // Half-cylinders on the sides of the main block.
            for (i = [-1, 1])
                translate([i*s_rh_centers/2, 0, 0])
                        cylinder(r = w_rodhole/2 + w_clamp, h = d_zend);
        }

        // Cutouts for the rod holes.
        for (i = [-1, 1])
            translate([i*s_rh_centers/2, 0, d_zend - d_rodhole])
                cylinder(r = w_rodhole/2 + d_fit, h = d_rodhole + eps);

        // Cutouts for bolt/nut holes for the PCB mount
        for (i = [-1, 1])
            translate([-l_pcbmount/2 + i*w_pcbmount/2 + (1-i)*l_pcbmount/2, h_zend/2 + d_pcbmount + eps+1, d_zend - w_pcbmount/2])
                rotate([90, 0, 0])
                    union() {
                        cylinder(r = w_bolthole/2 + d_fit, h = d_bolthole + eps);
                        translate([0, 0, d_nutslot - d_nuthole - d_fit+2])
                            rotate([0, 0, 90])
                                cylinder(r = (w_nuthole/2 + d_fit)*2/sqrt(3), h = d_nuthole + d_fit, $fn = 6);
                        translate([-w_nuthole/2 - d_fit, 0, d_nutslot - d_nuthole - d_fit+2])
                            cube([w_nuthole + 2*d_fit, w_pcbmount, d_nuthole + d_fit]);
                    }


        /* setScrews to fix this endstop in a variable position */
        rotate([-90,0,0])
        union()
        {
          translate([h_zend,-d_zend/1.5,0])
          cylinder(r=setScrewDia/2,h=h_zend - d_pcbmount);
          translate([-h_zend,-d_zend/1.5,0])
          cylinder(r=setScrewDia/2,h=h_zend - d_pcbmount);
        }
    }
}

zendswitch();

module zendswitch_mod() {
    difference() {
        union() {
            // Main block.
            translate([-s_rh_centers/2, -w_rodhole/2 - w_clamp, 0])
                cube([s_rh_centers, h_zend - d_pcbmount, d_zend]);

            // PCB mount block.
            translate([-s_rh_centers/2, w_rodhole/2 + w_clamp + d_pcboffset, d_zend - w_pcbmount])
                cube([l_pcbmount, d_pcbmount, w_pcbmount]);

            // PCB mount support.
            translate([-s_rh_centers/2, w_rodhole/2 + w_clamp + d_pcboffset + d_pcbmount - d_support, 0])
                cube([l_pcbmount, d_support, d_zend - w_pcbmount]);

            // Half-cylinders on the sides of the main block.
            for (i = [-1, 1])
                translate([i*s_rh_centers/2, 0, 0])
                        cylinder(r = w_rodhole/2 + w_clamp, h = d_zend);
        }

        // Cutouts for the rod holes.
        for (i = [-1, 1])
            translate([i*s_rh_centers/2, 0, d_zend - d_rodhole])
                cylinder(r = w_rodhole/2 + d_fit, h = d_rodhole + eps);

        // Cutouts for teh half-cylindrical parts of the slits for
        // the rod clamps.
        for (i = [-1, 1])
            translate([i*s_rh_centers/2, 0, -eps])
                difference() {
                    cylinder(r = w_rodhole/2 + d_fit, h = d_zend + 2*eps);
                    translate([0, 0, -eps])
                        cylinder(r = w_rodhole/2 - w_slit - d_fit, h = d_zend + 4*eps);
                    translate([-(1+i)/2*w_rodhole, -w_rodhole, -eps])
                        cube([w_rodhole, 2*w_rodhole, d_zend + 4*eps]);
                }

        // Cutouts for the straight parts of the slits for
        // rod clamps.
        for (i = [-1, 1])
            translate([i*s_rh_centers/2 - (i+1)/2*l_slit + i*eps, -w_rodhole/2 - d_fit, -eps])
                cube([l_slit + eps, w_slit + 2*d_fit, d_zend + 2*eps]);

        // Cutouts for the perpendicular parts of the slits for
        // rod clamps.
        for (i = [-1, 1])
            translate([i*(s_rh_centers/2 - l_slit) + (i-1)*(w_slit + d_fit -  eps/2) + i*eps, -w_rodhole/2 - w_clamp - eps, -eps])
                cube([2*w_slit + 2*d_fit, w_clamp + 2*eps, d_zend + 2*eps]);

        // Cutouts for bolt/nut holes for the PCB mount.
        for (i = [-1, 1])
            translate([-s_rh_centers/2 + i*w_pcbmount/2 + (1-i)*l_pcbmount/2, h_zend/2 + d_pcbmount + eps, d_zend - w_pcbmount/2])
                rotate([90, 0, 0])
                    union() {
                        cylinder(r = w_bolthole/2 + d_fit, h = d_bolthole + eps);
                        translate([0, 0, d_nutslot - d_nuthole - d_fit])
                            rotate([0, 0, 90])
                                cylinder(r = (w_nuthole/2 + d_fit)*2/sqrt(3), h = d_nuthole + d_fit, $fn = 6);
                        translate([-w_nuthole/2 - d_fit, 0, d_nutslot - d_nuthole - d_fit])
                            cube([w_nuthole + 2*d_fit, w_pcbmount, d_nuthole + d_fit]);
                    }

        // Cutouts for bolt/nut holes for the rod clamps mount.
        for (i = [-1, 1])
            translate([i*s_ch_centers/2, d_clamphole - w_rodhole/2 - w_clamp - eps, d_zend - d_rodhole])
                rotate([90, 0, 0])
                    union() {
                        cylinder(r = w_clamphole/2 + d_fit, h = d_clamphole + eps);
                        translate([0, 0, d_cnutslot - d_nuthole - d_fit])
                            rotate([0, 0, 90])
                                cylinder(r = (w_nuthole/2 + d_fit)*2/sqrt(3), h = d_nuthole + d_fit, $fn = 6);
                        translate([-w_nuthole/2 - d_fit, 0, d_cnutslot - d_nuthole - d_fit])
                            cube([w_nuthole + 2*d_fit, w_rodhole, d_nuthole + d_fit]);
                    }
    }
}

/* zendswitch_mod(); */
