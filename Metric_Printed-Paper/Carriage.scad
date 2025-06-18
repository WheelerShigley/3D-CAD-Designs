include<paper.scadh>;
include<common.scadh>;

//Paper Standard (metric)
A = 7;
//distance between points (mm)
D = 10;
//Lattice Radius (mm)
R = 2.5;

//Wall thickness (mm)
T = 10;
// Alignment Thickness (mm)
aT = 10;

//Stamp Extension (long cylinders) Height from "Base" Cylinders (mm)
sH = 10+10+10;
//Stamp Extension Radius (mm)
sR = 1-0.01;

//Wheel Depth
wD = 2 + 0.02;
//Wheel-Alignment-Rod Diameter
hD= 0.5;

_unThickenedLength = metricPaperLong( a = A);
_unThickenedWidth =  metricPaperShort(a = A);
_ThickenedLength =  _unThickenedLength + 2*T + 2*aT;
_ThickenedWidth =   _unThickenedWidth;

module Lattice(center = false) {
    $fn = 4*3.14*R;

    translate([0,0,center ? 0 : T/4]) {
        union() {
            for(dy = [0:D:_unThickenedLength/2]) {
                translate([0,dy,0]) {
                    rotate([0,90,0]) {
                        cylinder(r = R, h = _ThickenedWidth, center = true);
                    }
                }
            }
            for(dy = [0:-D:-_unThickenedLength/2]) {
                translate([0,dy,0]) {
                    rotate([0,90,0]) {
                        cylinder(r = R, h = _ThickenedWidth, center = true);
                    }
                }
            }
            
            for(dx = [0:D:_unThickenedWidth/2]) {
                translate([dx,0,0]) {
                    rotate([90,0,0]) {
                        cylinder(r = R, h = _ThickenedLength, center = true);
                    }
                }
            }
            for(dx = [0:-D:-_unThickenedWidth/2]) {
                translate([dx,0,0]) {
                    rotate([90,0,0]) {
                        cylinder(r = R, h = _ThickenedLength, center = true);
                    }
                }
            }
        }
    }
}

_halfWidthCount  = floor(_unThickenedWidth /D/2);
_halfLengthCount = floor(_unThickenedLength/D/2);

translate([0,0,T/2]) {
    union() {
        Lattice(center = true);
    }
}