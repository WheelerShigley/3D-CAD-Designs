length = 60;
width = 95;
height = 20.25;

module shape(length, width, height, capped, center = false) {
    _width = width-height;
    union() {
        translate([0,0,center ? height/-2 : 0]) {
            cube([_width,length,height],true);
            rotate([90,0,0]) {
                translate([_width/2,0,0]) {
                    cylinder(h = length, r = height/2, center = true);
                }
                translate([_width/-2,0,0]) {
                    cylinder(h = length, r = height/2, center = true);
                }
            }
        }
        if(capped) {
            translate([0,0,height/-4]) {
                cube([width,length,height/2],true);
            }
        };
    }
};

module side(length, width, height, thickness) {
    _radius = height/2 - thickness;
    echo(_radius);
    difference() {
        union() {
            translate([0,0,thickness/-2]) {
                cube([width,length,thickness], true);
            }
            //inner ramp
            translate([width/-2+_radius/2,0,-thickness+_radius/-2]) {
                difference() {
                    translate([_radius/-4,0,_radius/4]) {
                        cube([_radius/2,length,_radius/2], true);
                    }
                    rotate([90,0,0]) {
                        cylinder(h = 100, r = _radius/2, center = true);
                    }
                }
            }
        }
        union() {
            //(expandable) screw-holes
            for(side = [-1,1]) {
                translate([0,side*(width-thickness)/2,-thickness/2]) {
                    rotate([90,0,0]) {
                        shape(thickness,width/2,thickness,false, false);
                    }
                }
            }
            //outer ramp
            translate([width/2-_radius/2,0,_radius/-2]) {
                difference() {
                    translate([_radius/4,0,_radius/-4]) {
                        cube([_radius/2,length,_radius/2],true);
                    }
                    rotate([90,0,0]) {
                        cylinder(h = 100, r = _radius/2, center = true);
                    }
                }
            }
        }
    }
}

$fn = 4*3.14*height;
thickness = 5;

union() {
    //body
    difference() {
        shape(length+thickness, width+thickness, height+thickness, true, true);
        union() {
            shape(length, width, height, true, true);
            translate([0,0,thickness/-2]) {
                shape(length+2*thickness, width, height, false, true);
            }
        }
    }
    //sides
    for(side = [1,-1]) {
        translate([side*(width*3/4+thickness/2),0,0]) {
            rotate([0,0,0 < side ? 0 : 180]) {
                side(length+thickness, width/2, height, thickness);
            }
        }
    }
}