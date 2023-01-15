/* enclosure-system.scad
Author: andimoto@posteo.de
----------------------------

*/
$fn=70;
extra = 0.01;

/* [Beam Parameters] */

// do a complete enclosure simulation
sim = true;
// length of x side of beam
beamX = 20;
// length of y side of beam
beamY = 20;
// length of beam
beamLen = 60;
// Wallthickness of the beam
beamWallThickness = 2;
// Thickness of the beam mount plates at the ends
beamMountThickness = 5;

// generate beam mount plates only on one side of beam or on both
beamMountCnt=2; // [0,1,2]
// enable mounting holes for panels
panelsMountingX = true;
// enable mounting holes for panels
panelsMountingY = true;

panelsMountingHolesCnt = 2;
mountingHolesDist = 20;

panelHolesX_MoveX = 0;
panelHolesX_MoveZ = 0;

panelHolesY_MoveY = 0;
panelHolesY_MoveZ = 0;

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

module panelMountingHoles(ScrewDia=3,holeLen=beamWallThickness, holeCnt=3, holeDist=20)
{
  for(i=[0:1:holeCnt-1])
  {
    translate([0,i*holeDist,0]) cylinder(r=ScrewDia/2,h=holeLen);
  }
}
/* rotate([90,00,0])
panelMountingHoles(ScrewDia=3,holeLen=beamWallThickness, holeCnt=5, holeDist=20); */

module beamMount(bX=20,bY=20,bH=100, wallTh=5)
{
  hull()
  {
    cube([bX, beamWallThickness, wallTh]);
    cube([beamWallThickness, bY, wallTh]);
  }
}
/* beamMount(); */



module corner_beam(bX=20,bY=20,bH=100, wallTh=5, btmMountTh=5)
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

    /* bottom screw cutouts for connecting multiple beams together */
    translate([wallTh+4,wallTh+4,extra+btmMountTh-MountNutThick])
    NutScrewCutout(ScrewDia=3, ScrewCutoutLen=btmMountTh+extra*2, NutDia=MountNutDia, NutCutoutLen=MountNutThick,
      rotX=180, rotY=0, rotZ=0, zOffset=MountNutThick);
    /* top screw cutouts for connecting multiple beams together */
    translate([wallTh+4,wallTh+4,-extra+bH-btmMountTh])
    NutScrewCutout(ScrewDia=3, ScrewCutoutLen=btmMountTh+extra*2, NutDia=MountNutDia, NutCutoutLen=MountNutThick,
      rotX=0, rotY=0, rotZ=0, zOffset=0);


    /* mounting holes for X side */
    if(panelsMountingX == true)
    {
      holesOffset = (beamLen - (panelsMountingHolesCnt-1)*mountingHolesDist)/2;

      translate([panelHolesX_MoveX,extra,panelHolesX_MoveZ])
      translate([beamX/2,beamWallThickness,holesOffset])
      rotate([90,00,0])
      panelMountingHoles(ScrewDia=3.4,holeLen=beamWallThickness+extra*2, holeCnt=panelsMountingHolesCnt, holeDist=mountingHolesDist);
    }

    /* mounting holes for Y side */
    if(panelsMountingY == true)
    {
      holesOffset = (beamLen - (panelsMountingHolesCnt-1)*mountingHolesDist)/2;

      translate([0,panelHolesY_MoveY,panelHolesY_MoveZ])
      translate([-extra,beamY/2,holesOffset])
      rotate([90,00,90])
      panelMountingHoles(ScrewDia=3.4,holeLen=beamWallThickness+extra*2, holeCnt=panelsMountingHolesCnt, holeDist=mountingHolesDist);
    }
  }
}

/* corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness); */

module panel(panelX=100,panelZ=100,panelThick=3)
{
  color("Ivory") cube([panelX,panelThick,panelZ]);
}


/* do simulation of enclosure */
if(sim == true)
{
  translate([15,-4,0]) panel(panelX=110,panelZ=120,panelThick=4);
  translate([15,120+15+4,0]) panel(panelX=110,panelZ=120,panelThick=4);
  translate([110+30+4,15,0]) rotate([0,0,90]) panel(panelX=110,panelZ=120,panelThick=4);
  translate([0,15,0]) rotate([0,0,90]) panel(panelX=110,panelZ=120,panelThick=4);


  union()
  {
    translate([0,0,0]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
    translate([0,0,beamLen]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
  }

  translate([140,0,0])
  rotate([0,0,90])
  union()
  {
    translate([0,0,0]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
    translate([0,0,beamLen]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
  }

  translate([140,140,0])
  rotate([0,0,180])
  union()
  {
    translate([0,0,0]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
    translate([0,0,beamLen]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
  }

  translate([0,140,0])
  rotate([0,0,270])
  union()
  {
    translate([0,0,0]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
    translate([0,0,beamLen]) corner_beam(beamX,beamY,beamLen, beamWallThickness, beamMountThickness);
  }
}
