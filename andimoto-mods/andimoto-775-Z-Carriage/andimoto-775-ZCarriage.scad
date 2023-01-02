/* andimoto-775-ZCarriage.scad
Author: andimoto@posteo.de
----------------------------

*/
$fn=100;
extra = 0.1;

LM8UU_TubeDia = 17+0.4; //mm

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
M5NutDia = 9+0.4;
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

module M3Screw(d=M3ScrewDia,h=M3ScrewHeight,dHead=M3ScrewHeadDia,hHead=M3ScrewHeadHeight)
{
  cylinder(r=d/2,h=h);
  translate([0,0,h]) cylinder(r=dHead/2,h=hHead);
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

    /* M5 Screws for Spindle Plate */
    translate([LM8U_RefPoint01[0][0]+M5_XDiff,35.6-2,CarriageHeight/2]) plateScrewCutout(rotX=-90, rotY=0, rotZ=0);
    translate([LM8U_RefPoint01[1][0]-M5_XDiff,35.6-2,CarriageHeight/2]) plateScrewCutout(rotX=-90, rotY=0, rotZ=0);
  }
}



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

    /* M5 Screws for Spindle Plate */
    translate([LM8U_RefPoint02[0][0]+M5_XDiff,30+2,CarriageHeight/2]) plateScrewCutout(rotX=90, rotY=0, rotZ=0);
    translate([LM8U_RefPoint02[1][0]-M5_XDiff,30+2,CarriageHeight/2]) plateScrewCutout(rotX=90, rotY=0, rotZ=0);
  }
}

/* z carriage */
if(0)
{
  translate([0,0,0])
  union()
  {
    translate([0,-65.6,25.25*2/*+8.5*/])
    mirror([0,0,1])
    andimoto755ZCarriage01();
    translate([0,0,0])
    mirror([0,1,0])
    andimoto755ZCarriage02();
  }
}


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
module plateScrewCutout(rotX=0, rotY=0, rotZ=0, fn=6)
{
  rotate([rotX,rotY,rotZ])
  union()
  {
    cylinder(r=M5Dia/2, h=60);
    rotate([0,0,30]) cylinder(r=M5NutDia/2, h=30, $fn=fn);
  }
}

spindlePlateScrewDist = 69.5;
spindlePlateX = 86;
spindlePlateZ = 50.5;
spindlePlateY = 5;

spindleDiaExtra = 0.6;
spindleDia1 = 44.5+0.6; //outer spindle diameter with clearance
spindleHeight = 67;
spindlePlateDiff = 2;
wallThickness = 7;

M3NutX = 6;


module spindleHolder()
{
  difference()
  {
      union()
      {
        hull()
        {
          cube([spindlePlateX,spindlePlateY,spindlePlateZ]);
          translate([spindlePlateX/2-spindleDia1/2-wallThickness,20,0]) cube([spindleDia1+wallThickness*2,1,spindlePlateZ]);
        }
        hull()
        {
          translate([spindlePlateX/2-spindleDia1/2-wallThickness,20,0]) cube([spindleDia1+wallThickness*2,1,spindlePlateZ]);
          translate([spindlePlateX/2-spindleDia1/2-wallThickness,38,0]) cube([spindleDia1+wallThickness*2,1,spindlePlateZ]);
        }
        hull()
        {
          translate([spindlePlateX/2-spindleDia1/2-wallThickness,38,0]) cube([spindleDia1+wallThickness*2,1,spindlePlateZ]);
          translate([spindlePlateX/2-spindleDia1/8-wallThickness,spindleDia1+spindlePlateDiff+wallThickness/2,0])
            cube([spindleDia1/4+wallThickness*2,1,spindlePlateZ]);
        }
      }

      /* side cutout */
      translate([13,21,0])
      cube([wallThickness*2,2,spindlePlateZ]);

      translate([spindlePlateX/2,spindleDia1/2+spindlePlateDiff,0])
      spindleDummy(spindleDia1,spindleHeight);

      translate([spindlePlateX/2,0,0])
      union()
      {
        translate([LM8U_RefPoint02[0][0]+M5_XDiff,33+2,CarriageHeight/2]) plateScrewCutout(rotX=90, rotY=0, rotZ=0, fn=50);
        translate([LM8U_RefPoint02[1][0]-M5_XDiff,33+2,CarriageHeight/2]) plateScrewCutout(rotX=90, rotY=0, rotZ=0, fn=50);
        translate([LM8U_RefPoint02[0][0]+M5_XDiff,33+2,CarriageHeight/2+CarriageHeight]) plateScrewCutout(rotX=90, rotY=0, rotZ=0, fn=50);
        translate([LM8U_RefPoint02[1][0]-M5_XDiff,33+2,CarriageHeight/2+CarriageHeight]) plateScrewCutout(rotX=90, rotY=0, rotZ=0, fn=50);
      }

      /* lock screw nut pocket */
      translate([spindlePlateX/2,0,0])
      union()
      {
        translate([-spindleDia1/2-wallThickness/2,13, M3NutX])
        rotate([-90,0,0]) lockScrewCutout();

        translate([-spindleDia1/2-wallThickness/2,13, CarriageHeight*2-M3NutX])
        rotate([-90,180,0]) lockScrewCutout();
      }

      /* #### save some material #### */
      translate([spindlePlateX/2,0,CarriageHeight+CarriageHeight/2+4])
      hexSaver();
      translate([spindlePlateX/2,0,CarriageHeight])
      hexSaver();
      translate([spindlePlateX/2,0,CarriageHeight/2-4])
      hexSaver();

      tempZ = (CarriageHeight/2+4)/2;
      translate([spindlePlateX/2-spindleDia1/6,0,CarriageHeight+tempZ])
      hexSaver();
      translate([spindlePlateX/2-spindleDia1/6,0,CarriageHeight-tempZ])
      hexSaver();

      translate([spindlePlateX/2+spindleDia1/6,0,CarriageHeight+tempZ])
      hexSaver();
      translate([spindlePlateX/2+spindleDia1/6,0,CarriageHeight-tempZ])
      hexSaver();

      translate([spindlePlateX/2+spindleDia1/3,0,CarriageHeight])
      hexSaver();
      translate([spindlePlateX/2-spindleDia1/3,0,CarriageHeight])
      hexSaver();

      translate([spindlePlateX/2+spindleDia1/3,0,CarriageHeight/2-4])
      hexSaver();
      translate([spindlePlateX/2-spindleDia1/3,0,CarriageHeight/2-4])
      hexSaver();

      translate([spindlePlateX/2+spindleDia1/3,0,CarriageHeight+CarriageHeight/2+4])
      hexSaver();
      translate([spindlePlateX/2-spindleDia1/3,0,CarriageHeight+CarriageHeight/2+4])
      hexSaver();
      /* #### save some material #### */


      /* air ventilation */
      translate([spindlePlateX/2+spindleDia1/2-8,0,0])
      cube([4,2,60]);
      translate([spindlePlateX/2-4-spindleDia1/2+8,0,0])
      cube([4,2,60]);
    }
}

/* spindle holder */
/* translate([-spindlePlateX/2,0,0]) spindleHolder(); */

/* translate([-spindleDia1/2-wallThickness/2,13, M3NutX])
rotate([-90,0,0]) lockScrewCutout();

translate([-spindleDia1/2-wallThickness/2,13, CarriageHeight*2-M3NutX])
rotate([-90,180,0]) lockScrewCutout(); */

pencilHolderWallThickness = 5;
pencilMaxDia = 18;

pencilHolder();
module pencilHolder()
{
  difference() {
    union()
    {
      cylinder(r=(spindleDia1-spindleDiaExtra)/2,h=CarriageHeight/4);
      translate([0,0,CarriageHeight/4])
        cylinder(r1=(spindleDia1-spindleDiaExtra)/2,r2=(pencilMaxDia)/2+pencilHolderWallThickness,h=CarriageHeight/4);
      cylinder(r=pencilMaxDia/2+pencilHolderWallThickness,h=CarriageHeight);
    }
    cylinder(r=pencilMaxDia/2,h=CarriageHeight);
    cylinder(r2=pencilMaxDia/2,r1=pencilMaxDia/2+pencilHolderWallThickness,h=CarriageHeight/4);

    for(i = [0:2])
    {
      rotate([0,0,120*i])
      translate([0,-pencilMaxDia/2+2,CarriageHeight*0.8])
      rotate([90,0,0])
      lockScrewCutout();
    }
  }
}




module hexSaver()
{
  rotate([-90,0,0])
  rotate([0,0,90])
  cylinder(r=5,h=100,$fn=6);
}

module lockScrewCutout()
{
  M3Screw(d=M3ScrewDia+0.5,h=21,dHead=M3ScrewHeadDia+0.5,hHead=M3ScrewHeadHeight+10);
  translate([-M3NutX/2,-M3NutX/2,3]) cube([M3NutX,M3NutX*1.5,2.4]);
}

module spindleDummy(sDia1=40,sHeight1=30)
{
  cylinder(r=sDia1/2,h=sHeight1);
}
