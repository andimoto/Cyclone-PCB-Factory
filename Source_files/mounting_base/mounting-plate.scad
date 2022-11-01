/* mounting-plate.scad
Author: andimoto@posteo.de
----------------------------

*/
$fn = 80;

extra = 0.1;

mountingPlateX = 270; //mm
mountingPlateY = 250; //mm
mountingPlateZ = 1; //mm

edgeRadius = 10; //mm

mountingAreaX = 238; //mm
mountingAreaY = 240; //mm
mountingAreaMarkerZ = 0.4; //mm

mountingScrewDia = 3;

/* X root point is the mid hole of the YBackFrame
   Y root point are the lower holes of YFrontRodIdlers
   Debug true to mark this point red, false -> no marking*/
mountingHoleArray = [
/*YBackFrame*/
[  0  ,193.5, true],
[-22.5,177  , false],
[ 22.5,177  , false],
/*YFrontFrame*/
[ 11.0, 45  , false],
[ 22.5, 28.5, false],
[-69.0, 28.5, false],
/* YFrontRodIdler L */
[-78  , 11  , false],
[-58  ,-0.5 , false],
[-98  ,-0.5 , false],
/* YFrontRodIdler R */
[ 78  , 11  , false],
[ 58  ,-0.5 , false],
[ 98  ,-0.5 , false],
/* XFrames */
[-105 ,213.5, false],
[-105 ,181.5, false],

[105  ,213.5, false],
[105  ,181.5, false],

[-105 ,131.5, true],
[105  ,131.5, true],
];


yShift = 7;


module mountingPlate(roundEdge = true)
{
  difference()
  {
    if(roundEdge == true)
    {
      translate([edgeRadius,edgeRadius,0])
      minkowski()
      {
        cube([mountingPlateX-edgeRadius*2,mountingPlateY-edgeRadius*2, mountingPlateZ]);
        cylinder(r=edgeRadius, h=0.00001);
      }
    }
    else
    {
      cube([mountingPlateX,mountingPlateY, mountingPlateZ]);
    }
    translate([0,0,0])
    difference()
    {
      translate([(mountingPlateX-mountingAreaX)/2,(mountingPlateY-mountingAreaY)/2,mountingPlateZ-mountingAreaMarkerZ])
      cube([mountingAreaX,mountingAreaY, mountingAreaMarkerZ+extra]);
      translate([(mountingPlateX-mountingAreaX)/2+1,(mountingPlateY-mountingAreaY)/2+1,mountingPlateZ-mountingAreaMarkerZ-extra/2])
      cube([mountingAreaX-2,mountingAreaY-2, mountingAreaMarkerZ+extra]);
    }

    translate([mountingPlateX/2,(mountingPlateY-mountingAreaY)/2+yShift,0])
    holePattern();
  }
}


module hole(x = 0,y = 0)
{
  translate([x,y,0])
    cylinder(r=mountingScrewDia/2+0.2, h=mountingPlateZ+extra);
}

module holePattern()
{
  for (hole = mountingHoleArray)
  {
    if(hole[2] == false)
    {
      hole(x=hole[0],y=hole[1]);
    }else{
      #hole(x=hole[0],y=hole[1]);
    }
  }
}
/*
color("RED")
translate([0,0,20])
holePattern(); */

mountingPlate();
