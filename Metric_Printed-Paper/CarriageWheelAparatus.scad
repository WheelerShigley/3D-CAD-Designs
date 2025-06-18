include<common.scadh>;

//Wheel[-Cavity] Diameter (mm)
wD = 2+0.02;
//height (mm)
T = 5;
//Wheel-Axel Radius (mm)
wR = 0.5;

module carriageAparatus(center = false) {
    translate([0,0,center ? 0: T/2]) {
        difference() {
            union() {
                cube([T-wD,T,T], center = true);
                for(side_x = [-1,1]) {
                    translate([side_x*(T-wD)/2,0,0]) {
                        rotate([90,0,0]) {
                            $fn = 4*3.14*(wD/2);
                            cylinder(r = wD/2, h = T, center = true);
                        }
                    }
                }
            }
            //wheel slots
            union() {
                for(side_x = [-1,1]) {
                    translate([side_x*(T-wD)/2,0,0]) {
                        rotate([90,0,0]) {
                            torus(inner_diameter = 0, outer_diameter = wD);
                            $fn = 4*3.14*(wD/2);
                            cylinder(r = wD/2, h = wD, center = true);
                            $fn = 4*3.14*1;
                            cylinder(r = wR, h = T, center = true);
                        }
                    }
                }
            }
        }
    }
}

carriageAparatus();