/* mounting-plate.scad
Author: andimoto@posteo.de
----------------------------

*/
$fn = 80;

extra = 0.1;

mountingPlateX = 280; //mm
mountingPlateY = 250; //mm
mountingPlateZ = 10; //mm

edgeRadius = 5; //mm

mountingAreaX = 238; //mm
mountingAreaY = 210; //mm
mountingAreaMarkerZ = 1; //mm

mountingScrewDia = 3;

/* X root point is the mid hole of the YBackFrame
   Y root point are the lower holes of YFrontRodIdlers */
mountingHoleArray = [
/*YBackFrame*/
[  0  ,183],
[-21.5,167],
[ 21.5,167],
/*YFrontFrame*/
[ 10.5, 43],
[ 21.5, 27],
[-65.5, 27],
/* YFrontRodIdler L */
[-55  ,  0],
[-92.5,  0],
[-74  , 11],
/* YFrontRodIdler R */
[ 55  ,  0],
[ 92.5,  0],
[ 74  , 11],
/* XFrames */
[-101 ,125],
[-101 ,172],
[101  ,125],
[101  ,172],
];



module mountingPlate(roundEdge = true)
{
  difference()
  {
    if(roundEdge == true)
    {
      minkowski()
      {
        cube([mountingPlateX,mountingPlateY, mountingPlateZ]);
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

    translate([mountingPlateX/2,(mountingPlateY-mountingAreaY)/2+10,0])
    holePattern();
  }
}

module holePattern()
{
  for (hole = mountingHoleArray)
  {
    translate([hole[0],hole[1],0])
    cylinder(r=mountingScrewDia/2+0.2, h=mountingPlateZ+extra);
  }
}
/*
color("RED")
translate([0,0,20])
holePattern(); */

mountingPlate();
