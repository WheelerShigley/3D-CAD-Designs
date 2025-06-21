include<common.scadh>;

//Wheel[-Cavity] Diameter (mm)
wD = 1.5+0.02;
//Wheel[-Cavity] Height (mm)
wH = 1+0.01;
//height (mm)
T = 5;
//Wheel-Axel-Holder Radius
wAR = 1;
//Wheel-Axel Radius (mm)
wR = 0.5;

//Inset Depth (mm)
iD = 3;
//Inset Radius (mm)
iR = 2;
//Inset Width (mm)
iW = 1;

//Screw-Hole Radius (mm)
sR = 1;

module adapterCavity(center = false) {
    _iDiameter= 2*iR;
    union() {
        rotate([90,0,0]) {
            $fn = 4*3.14*sR;
            cylinder(r = sR, h = T, center = true);
        }
        translate([0,(T-iD)/2,center?iR:0]) {
            difference() {
                rotate([90,0,0]) {
                    $fn = 4*3.14*iR;
                    cylinder(r = iR, h = iD, center = true);
                }
                difference() {
                    cube([_iDiameter,_iDiameter,_iDiameter], center = true);
                    cube([iW,_iDiameter,_iDiameter], center = true);
                }
            }
        }
    }
}

module carriageAparatus(center = false) {
    translate([0,0,center ? 0: T/2]) {
        difference() {
            union() {
                cube([T-2*wAR,T,T], center = true);
                //Axel Attachment
                for(side_x = [-1,1]) {
                    translate([side_x*(T-2*wAR)/2,0,0]) {
                        rotate([90,0,0]) {
                            $fn = 4*3.14*wAR;
                            difference() {
                                cylinder(r = wAR, h = T, center = true);
                                cylinder(r = wAR, h = wH, center = true);
                            }
                        }
                    }
                }
            }
            union() {
                //wheel slots
                for(side_x = [-1,1]) {
                    translate([side_x*(T-2*wAR)/2,0,0]) {
                        rotate([90,0,0]) {
                            scale([1,1,wH/wD]) {
                                torus(inner_diameter = 0, outer_diameter = wD);
                            }
                            $fn = 4*3.14*(wD/2);
                            cylinder(r = wD/2, h = wH, center = true);
                            $fn = 4*3.14*1;
                            cylinder(r = wR, h = T, center = true);
                        }
                    }
                }
                //adapter
                adapterCavity();
                //string-attachment-point (TODO)
                translate([0,0,T/2]) {
                    rotate([0,90,0]) {
                        torus(inner_diameter = 1/3, outer_diameter = 1, center = true);
                    }
                }
            }
        }
    }
}

carriageAparatus();
//adapterCavity();