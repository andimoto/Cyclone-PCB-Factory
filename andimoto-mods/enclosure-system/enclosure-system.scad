/* enclosure-system.scad
Author: andimoto@posteo.de
----------------------------

*/
$fn=70;
extra = 0.01;

/* [Beam Parameters] */

// length of x side of beam
beamX = 20;
// length of y side of beam
beamY = 20;
// length of beam
beamLen = 50;
// Wallthickness of the beam
beamWallThickness = 2;
// Thickness of the beam mount plates at the ends
beamMountThickness = 5;

// generate beam mount plates only on one side of beam or on both
beamMountCnt=2; // [0,1,2]

MountNutDia = 6;
MountNutThick = 3;

/* ################ MODULES ################## */
/* ################ MODULES ################## */

module Screw(ScrewDia=3,ScrewLen=10,ScrewHeadDia=6,ScrewHeadLen=3)
{
  translate([0,0,ScrewHeadLen]) cylinder(r=ScrewDia/2,h=ScrewLen);
  cylinder(r=ScrewHeadDia/2,h=ScrewHeadLen);
}
/* Screw(ScrewDia=3,ScrewLen=10,ScrewHeadDia=6,ScrewHeadLen=3); */

module NutScrewCutout(ScrewDia=3, ScrewCutoutLen=15, NutDia=6, NutCutoutLen=10, rotX=0, rotY=0, rotZ=0, zOffset=0, nutFn=6)
{
  translate([0,0,zOffset])
  rotate([rotX,rotY,rotZ])
  union()
  {
    cylinder(r=ScrewDia/2 + 0.2, h=ScrewCutoutLen);
    rotate([0,0,0]) cylinder(r=NutDia/2 + 0.2, h=NutCutoutLen, $fn=nutFn);
  }
}

/* translate([beamWallThickness,beamWallThickness,extra+beamMountThickness-3])
NutScrewCutout(ScrewDia=3, ScrewCutoutLen=15, NutDia=6, NutCutoutLen=3, rotX=180, rotY=0, rotZ=0, zOffset=3); */


module beamMount(bX=20,bY=20,bH=100, wallTh=5)
{
  hull()
  {
    cube([bX, beamWallThickness, wallTh]);
    cube([beamWallThickness, bY, wallTh]);
  }
}
/* beamMount(); */



module enclosure_beam(bX=20,bY=20,bH=100, wallTh=5, btmMountTh=5)
{
  difference()
  {
    union()
    {
      difference() {
        cube([bX, bY, bH]);
        translate([wallTh,wallTh,-extra]) cube([bX-wallTh+extra, bY-wallTh+extra, bH+extra*2]);
      }
      if(beamMountCnt>0)
        beamMount(bX,bY,wallTh,btmMountTh);
      if(beamMountCnt>1)
        translate([0,0,bH-btmMountTh]) beamMount(bX,bY,wallTh,btmMountTh);
    }

    translate([wallTh+4,wallTh+4,extra+btmMountTh-MountNutThick])
    NutScrewCutout(ScrewDia=3, ScrewCutoutLen=btmMountTh+extra*2, NutDia=MountNutDia, NutCutoutLen=MountNutThick,
      rotX=180, rotY=0, rotZ=0, zOffset=MountNutThick);

    translate([wallTh+4,wallTh+4,-extra+bH-btmMountTh])
    NutScrewCutout(ScrewDia=3, ScrewCutoutLen=btmMountTh+extra*2, NutDia=MountNutDia, NutCutoutLen=MountNutThick,
      rotX=0, rotY=0, rotZ=0, zOffset=0);
  }
}
enclosure_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
