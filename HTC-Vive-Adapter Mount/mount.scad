//dimensions, in mm(s)
dimensions = [
    60,
    95,
    20.25
];
//wall thickness (in addition to dimensions)
thickness = 5;

$fn = 4*3.14*dimensions.z;

module shape(dimensions, capped, center = false) {
    length = dimensions.x;
    width  = dimensions.y;
    height = dimensions.z;
    _width = width-height;

    union() {
        translate([0,0,center ? 0 : height/2]) {
            cube([_width,length,height],true);
            rotate([90,0,0]) {
                translate([_width/2,0,0]) {
                    cylinder(h = length, r = height/2, center = true);
                }
                translate([_width/-2,0,0]) {
                    cylinder(h = length, r = height/2, center = true);
                }
            }
            if(capped) {
                translate([0,0,height/-4]) {
                    cube([width,length,height/2],true);
                }
            };
        }
    }
};

module side(dimensions, thickness, center = true) {
    length = dimensions.x;
    width  = dimensions.y;
    height = dimensions.z;

    _radius = height/2;
    translate([0,0, center ? thickness/2 - (thickness + _radius)/2 : thickness/2]) {
        difference() {
            union() {
                cube([width,length,thickness], center = true);
                translate([width/2-thickness,0,thickness*3/2]) {
                    cube([_radius,length,_radius], center = true);
                }
            }
            union() {
                //(expandable) screw-holes
                for(side = [-1,1]) {
                    translate([0,side*(width-thickness)/2,0]) {
                        rotate([90,0,0]) {
                            shape(
                                dimensions = [thickness,width/2,thickness],
                                capped = false,
                                center = true
                            );
                        }
                    }
                }
                //cut into transition "step"
                translate([width/2-height/2,0, height/2+thickness/2]) {
                    rotate([90,0,0]) {
                        cylinder(h = length+2*thickness, r = height/2, center = true);
                    }
                }
                //cut into side (for transition)
                translate([-width/2+thickness/2,0,0]) {
                    difference() {
                        translate([thickness/-4,0,thickness/4]) {
                            cube([thickness/2, length+2*thickness, thickness/2], center = true);
                        }
                        rotate([90,0,0]) {
                            cylinder(h = length+2*thickness, r = thickness/2, center = true);
                        }
                    }
                }
            }
        }
    }
}

module body(dimensions, thickness, center = true) {
    length = dimensions.x;
    width  = dimensions.y;
    height = dimensions.z;

    difference() {
        shape(
            dimensions = [length+2*thickness, width+2*thickness, height+2*thickness],
            capped = true,
            center = center
        );
        union() {
            shape(
                dimensions = [length+2*thickness, width, height],
                capped = false,
                center = center
            );
            shape(
                dimensions = [length, width, height],
                capped = true,
                center = center
            );
            translate([0,0,thickness/-2- height/2]) {
                cube([width, length, thickness], center = center);
            }
        }
    }
}

union() {
    translate([0,0,dimensions.z/2+thickness]) {
        body(
            dimensions = dimensions,
            thickness = thickness,
            center = true
        );
    }
    //sides
    for(side = [1,-1]) {
        translate([side*(dimensions.y*3/4+thickness),0,0]) {
            rotate([0,0,0 < side ? 180 : 0]) {
                side([dimensions.x+2*thickness, dimensions.y/2, dimensions.z], thickness, false);
            }
        }
    }
}