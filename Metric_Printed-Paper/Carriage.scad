include<paper.scadh>;

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

_unThickenedLength = metricPaperLong( a = A);
_unThickenedWidth =  metricPaperShort(a = A);
_ThickenedLength =  _unThickenedLength + 4*T + 2* aT;
_ThickenedWidth =   _unThickenedWidth  + 2*T;

module Lattice() {
    $fn = 4*3.14*R;

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

Lattice();