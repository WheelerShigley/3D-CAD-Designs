include<paper.scadh>;

//Metric Standard
A = 7;
//Height (mm)
H = 200;

//Thickness (mm)
T = 10;
//Distance between holes (mm)
dD = 10;
//side-smoothing Radius, this cuts *into* the slot-wideness, on both sides (mm)
rA = 1;
//slots wideness (mm)
dA = 5+2*rA;

//grove depth (mm)
gD = 1;

//Magnet Height (mm)
mH = 3;
//Magnet Radius (mm)
mR = 2.5;
//Magnet inset (mm)
dM = 10;

_sideLength = metricPaperShort(a = A) + 2*T;

module magnet() {
    for(side = [-1,1]) {
        translate([0,side*(_sideLength/2-dM),0]) {
            $fn = 4*3.14*mR;
            cylinder(r = mR, h = mH, center = true);
        }
    }
}

module magnets() {
    union() {
        translate([(H-mH)/2,0,0]) {
            rotate([0,90,0]) {
                magnet();
            }
        }
        translate([-H/2+mR,0,(T-mH)/2]) {
            magnet();
        }
    }
}

module body(center = false) {
    translate([0,0,center ? 0 : T/2]) {
        difference() {
            cube(
                [H, _sideLength, T],
                center = true
            );
            magnets();
        }
    }
}

module alignmentCavity(height, center = true) {
    translate([0,0,T/2]) {
        difference() {
            union() {
                //tall cube
                cube(
                    [
                        height,
                        dA - 2*rA,
                        T
                    ],
                    center = true
                );
                for(side_z = [-1,1]) {
                    translate([0,0,side_z*(T-rA)/2]) {
                        cube(
                            [height,dA,rA],
                            center = true
                        );
                    }
                }
                //groves
                _triangleDistance = 2+sqrt(3);
                _triangleRadius = 2*gD/_triangleDistance;
                for(side_y = [-1,1]) {
                    translate([0,side_y*(dA-_triangleRadius-gD)/2,0]) {
                        rotate([0,90,0]) {
                        rotate([0,0,side_y<0?30:90]) {
                            cylinder(
                                h = height,
                                r = _triangleRadius,
                                $fn = 3,
                                center = true
                            );
                        }
                        }
                    }
                }
            }
            union() {
                //smoothings
                for(side_y = [-1,1]) {
                    for(side_z = [-1,1]) {
                        translate(
                            [
                                0,
                                side_y*(dA/2 ),
                                side_z*( T/2-rA)
                            ]
                        ) {
                            $fn = 4*3.14*rA;
                            rotate([0,90,0]) {
                                cylinder(r = rA, h = height, center = true);
                            }
                        }
                    }
                }
            }
        }
    }
}

module slicedBody() {
    difference() {
        body();
        union() {
            _shortLength = metricPaperShort(a = A);
            for(dy = [0:-dD:-_shortLength/2]) {
                translate([0,dy,0]) {
                    alignmentCavity(height = H-2*T, center = true);
                }
            }
            for(dy = [0:dD:_shortLength/2]) {
                translate([0,dy,0]) {
                    alignmentCavity(height = H-2*T, center = true);
                }
            }
        }
    }
}

slicedBody();
