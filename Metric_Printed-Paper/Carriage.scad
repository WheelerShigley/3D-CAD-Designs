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

//Wheel Depth (mm)
wD = 2 + 0.02;
//Wheel-Alignment-Rod Diameter (mm)
hD= 0.5;

//End-Adapter Width (mm)
eW = 3;
//End-Adapter Depth (mm)
eD = 5;
//End-Adapter-Insert Radius (mm)
eIR = 1;
//End-Adapter-Inset Depth (mm)
eID = 3;

//Alignment-Pin Height (mm)
pH = 2;
//Alignment-Pin Rounding-Radius (mm)
pR = 0.5-0.05;

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

module endCavity() {
    _diameter = 2*R;
    union() {
        difference() {
            cube([_diameter,_diameter,_diameter], center = true);
            cube([eW,_diameter,_diameter], center = true);
        }
        translate([0,(_diameter-eID)/2,0]) {
            rotate([90,0,0]) {
                $fn = 4*3.14*eIR;
                cylinder(h = eID, r = eIR, center = true);
            }
        }
    }
}

module alignmentPin(height) {
    $fn = 4*3.14*pR;
    union() {
        cylinder(h = height, r = pR);
        translate([0,0,height]) {
            sphere(r = pR);
        }
    }
}

module alignmentPins() {
    _height = R + pH - pR;
    
    union() {
        for(dx = [0:D:_unThickenedWidth/2]) {
            for(dy = [0:D:_unThickenedLength/2]) {
                translate([dx,dy,0]) {
                    alignmentPin(height = _height);
                }
            }
        }
        for(dx = [D:D:_unThickenedWidth/2]) {
            for(dy = [-D:-D:-_unThickenedLength/2]) {
                translate([dx,dy,0]) {
                    alignmentPin(height = _height);
                }
            }
        }
        for(dx = [-D:-D:-_unThickenedWidth/2]) {
            for(dy = [D:D:_unThickenedLength/2]) {
                translate([dx,dy,0]) {
                    alignmentPin(height = _height);
                }
            }
        }
        for(dx = [0:-D:-_unThickenedWidth/2]) {
            for(dy = [0:-D:-_unThickenedLength/2]) {
                translate([dx,dy,0]) {
                    alignmentPin(height = _height);
                }
            }
        }
    }
}

module modifiedLattice(center = false) {
    _halfQuantizedWidth  = D*floor(_unThickenedWidth /D/2);
    //_halfQuantizedLength = D*floor(_unThickenedLength/D/2);
    translate([0,0,center?0:T/4]) {
        difference() {
            union() {
                Lattice(center = true);
                alignmentPins();
            }
            union() {
                for(side_x = [-1,1]) {
                    for(side_y = [-1,1]) {
                        translate(
                            [
                                side_x*_halfQuantizedWidth,
                                side_y*(_ThickenedLength/2 - R),
                                0
                            ]
                        ) {
                           rotate([0,0,side_y<0?180:0]) {
                              endCavity();
                           } 
                        }
                    }
                }
            }
        }
    }
}

modifiedLattice();