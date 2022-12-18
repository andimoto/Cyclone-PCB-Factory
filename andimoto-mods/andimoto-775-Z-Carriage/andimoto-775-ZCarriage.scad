/* andimoto-775-ZCarriage.scad
Author: andimoto@posteo.de
----------------------------

*/
$fn=100;


LM8UU_TubeDia = 17; //mm

LM8UU_Dia = 15+0.2; //mm
LM8UU_HoldDia = 12; //mm

LM8UU_HoldThickness = 1.5; //mm
LM8UU_HoldHeight = 24-0.25; //mm

M3ScrewDia = 3+0.1; //mm
M3ScrewHeight = 6+1; //mm
M3ScrewHeadDia = 5.5; //mm
M3ScrewHeadHeight = 3; //mm

LM8U_RefPoint01 = [
[20.055,54.6],  // right
[-19.945,54.6]  // left
];

LM8U_RefPoint02 = [
[19.95,11],  // right
[-20.03,11]  // left
];

CarriageHeight = 25+0.251;


M5Dia = 5+0.4;
M5NutDia = 9+0.2;
M5_XDiff = 15;


module standardCycloneSpindleCarriage01()
{
  translate([0,65.6/2,0]) import("Cycl_Zcarriage_Spindle-01.stl", convexity=6);
}
module standardCycloneSpindleCarriage02()
{
  translate([0,21/2,0]) import("Cycl_Zcarriage_Spindle-02.stl", convexity=6);
}
/* standardCycloneSpindleCarriage02(); */

module M3Screw()
{
  cylinder(r=M3ScrewDia/2,h=M3ScrewHeight);
  translate([0,0,M3ScrewHeight]) cylinder(r=M3ScrewHeadDia/2,h=M3ScrewHeadHeight);
}

module andimoto755ZCarriage01()
{
  difference() {
    union()
    {
      standardCycloneSpindleCarriage01();
      hexFiller();

      translate([LM8U_RefPoint01[0][0],LM8U_RefPoint01[0][1],LM8UU_HoldThickness])
      cylinder(r=LM8UU_TubeDia/2,h=LM8UU_HoldHeight);

      translate([LM8U_RefPoint01[1][0],LM8U_RefPoint01[1][1],LM8UU_HoldThickness])
      cylinder(r=LM8UU_TubeDia/2,h=LM8UU_HoldHeight);
    }

    translate([LM8U_RefPoint01[0][0],LM8U_RefPoint01[0][1],LM8UU_HoldThickness])
    cylinder(r=LM8UU_Dia/2,h=LM8UU_HoldHeight+1);

    translate([LM8U_RefPoint01[1][0],LM8U_RefPoint01[1][1],LM8UU_HoldThickness])
    cylinder(r=LM8UU_Dia/2,h=LM8UU_HoldHeight+1);

    translate([11,60,CarriageHeight-M3ScrewHeight])
    M3Screw();
    translate([-11+0.095,60,CarriageHeight-M3ScrewHeight])
    M3Screw();

    translate([LM8U_RefPoint01[0][0]+M5_XDiff,35.6-2,CarriageHeight/2]) plateScrewCutout(rotX=-90, rotY=0, rotZ=0);
    translate([LM8U_RefPoint01[1][0]-M5_XDiff,35.6-2,CarriageHeight/2]) plateScrewCutout(rotX=-90, rotY=0, rotZ=0);
  }
}
andimoto755ZCarriage01();


module andimoto755ZCarriage02()
{
  difference() {
    union()
    {
      standardCycloneSpindleCarriage02();
      translate([0,65.6,0]) mirror([0,1,0]) hexFiller();

      translate([LM8U_RefPoint02[0][0],LM8U_RefPoint02[0][1],LM8UU_HoldThickness])
      cylinder(r=LM8UU_TubeDia/2,h=LM8UU_HoldHeight);

      translate([LM8U_RefPoint02[1][0],LM8U_RefPoint02[1][1],LM8UU_HoldThickness])
      cylinder(r=LM8UU_TubeDia/2,h=LM8UU_HoldHeight);
    }

    translate([LM8U_RefPoint02[0][0],LM8U_RefPoint02[0][1],LM8UU_HoldThickness])
    cylinder(r=LM8UU_Dia/2,h=LM8UU_HoldHeight+1);

    translate([LM8U_RefPoint02[1][0],LM8U_RefPoint02[1][1],LM8UU_HoldThickness])
    cylinder(r=LM8UU_Dia/2,h=LM8UU_HoldHeight+1);

    translate([10.9,6,CarriageHeight-M3ScrewHeight])
    M3Screw();
    translate([-11+0.095,6,CarriageHeight-M3ScrewHeight])
    M3Screw();


    translate([LM8U_RefPoint02[0][0]+M5_XDiff,30+2,CarriageHeight/2]) plateScrewCutout(rotX=90, rotY=0, rotZ=0);
    translate([LM8U_RefPoint02[1][0]-M5_XDiff,30+2,CarriageHeight/2]) plateScrewCutout(rotX=90, rotY=0, rotZ=0);
  }
}
/* andimoto755ZCarriage02(); */

/* close hexagons for making new once */
module hexFiller()
{
  difference()
  {
    union()
    {
      translate([49-20,65.5-20,0]) cube([12,20.09,CarriageHeight-1]);
      translate([-41,65.5-20,0]) cube([12,20.09,CarriageHeight-1]);
    }

    translate([49-12,65.5-36.15,0]) rotate([0,0,34.2]) cube([20,20,CarriageHeight+1]);
    translate([-41-12,65.5-25.28,0]) rotate([0,0,-34.2]) cube([20,20,CarriageHeight+1]);
    standardCycloneSpindleCarriage01();
  }
}

/* hexFiller(); */
/* plateScrewCutout(); */
module plateScrewCutout(rotX=0, rotY=0, rotZ=0)
{
  rotate([rotX,rotY,rotZ])
  union()
  {
    cylinder(r=M5Dia/2, h=40);
    rotate([0,0,30]) cylinder(r=M5NutDia/2, h=30, $fn=6);
  }
}
