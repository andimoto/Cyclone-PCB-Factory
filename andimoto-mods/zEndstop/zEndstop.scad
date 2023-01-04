/* zEndstop.scad
Author: andimoto@posteo.de
----------------------------

*/

$fn = 80;

extra = 0.2;
rodDia = 8;

rodWallTh = 2;

zEndStpHeight = 10;

rodDistance =  40.0;
M3NutX = 6;
M3NutWall = 2;

pcbHoleDiff = 20;
pcbHolderX = 29;

module zEndstop()
{
  difference() {
    union()
    {
      screwClamp();
      translate([rodDistance,0,0]) screwClamp();
      cube([rodDistance,rodWallTh*3,zEndStpHeight]);

      translate([5.5+rodDistance+rodDia/2,-10.4,0])
      rotate([0,0,76])
      endstopHolder();
    }

    cylinder(r=rodDia/2+extra,h=zEndStpHeight+extra);
    translate([rodDistance,0,0]) cylinder(r=rodDia/2+extra,h=zEndStpHeight+extra);

    translate([0,-2,M3NutX])
    rotate([90,180,0]) lockScrewCutout();
    translate([rodDistance,-2,M3NutX])
    rotate([90,180,0]) lockScrewCutout();
  }
}
zEndstop();


/* translate([1.9+rodDistance+rodDia/2,-1,0])
rotate([0,0,76])
endstopHolder(); */
module endstopHolder()
{
  difference() {
    cube([pcbHolderX,6,zEndStpHeight]);

    hull()
    {
      translate([pcbHolderX/2-pcbHolderX/4,0,zEndStpHeight]) cube([pcbHolderX/2,6,0.1]);
      translate([pcbHolderX/2-pcbHolderX/8,0,zEndStpHeight/2]) cube([pcbHolderX/4,6,0.1]);
    }

    translate([-1,M3NutX+0.8,-M3NutX/2])
    union()
    {
      translate([M3NutX,0,M3NutX])
      rotate([90,180,0]) lockScrewCutout();
      translate([M3NutX+pcbHoleDiff,0,M3NutX])
      rotate([90,180,0]) lockScrewCutout();
    }
  }
}

/* translate([-M3NutX/2-M3NutWall/2,-(rodDia/2+rodWallTh),0])  */
/* screwClamp(); */
module screwClamp()
{
  hull()
  {
    cylinder(r=rodDia/2+rodWallTh,h=zEndStpHeight);
    translate([-M3NutX/2-M3NutWall/2,-(rodDia/2+rodWallTh)-3,0])
      cube([M3NutX+M3NutWall,0.1,zEndStpHeight]);

  }
}

/* translate([0,-2,M3NutX])
rotate([90,180,0]) lockScrewCutout(); */

M3ScrewDia = 3+0.1; //mm
M3ScrewHeight = 6+1; //mm
M3ScrewHeadDia = 5.5; //mm
M3ScrewHeadHeight = 3; //mm
module lockScrewCutout()
{
  M3Screw(d=M3ScrewDia+0.5,h=21,dHead=M3ScrewHeadDia+0.5,hHead=M3ScrewHeadHeight+10);
  translate([-M3NutX/2,-M3NutX/2,3]) cube([M3NutX,M3NutX*1.5,2.6]);
}
module M3Screw(d=M3ScrewDia,h=M3ScrewHeight,dHead=M3ScrewHeadDia,hHead=M3ScrewHeadHeight)
{
  cylinder(r=d/2,h=h);
  translate([0,0,h]) cylinder(r=dHead/2,h=hHead);
}
