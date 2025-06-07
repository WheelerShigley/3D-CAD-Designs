length = 60;
width = 95;
height = 20.25;
//wall thickness (in addition to dimensions)
thickness = 5;

$fn = 4*3.14*height;

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
    difference() {
        union() {
            cube([width,length,thickness], center = center);
            translate([width/2-thickness,0,thickness*3/2]) {
                cube([_radius,length,_radius], center = center);
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
                            center = center
                        );
                    }
                }
            }
            //cut into transition "step"
            translate([width/2-height/2,0, height/2+thickness/2]) {
                rotate([90,0,0]) {
                    cylinder(h = length+2*thickness, r = height/2, center= center);
                }
            }
            //cut into side (for transition)
            translate([-width/2+thickness/2,0,0]) {
                difference() {
                    translate([thickness/-4,0,thickness/4]) {
                        cube([thickness/2, length+2*thickness, thickness/2], center = center);
                    }
                    rotate([90,0,0]) {
                        cylinder(h = length+2*thickness, r = thickness/2, center = center);
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
    translate([0,0,height/2+thickness]) {
        body(
            dimensions = [length, width, height],
            thickness = thickness,
            center = true
        );
    }
    //sides
    for(side = [1,-1]) {
        translate([side*(width*3/4+thickness),0,thickness/2]) {
            rotate([0,0,0 < side ? 180 : 0]) {
                side([length+2*thickness, width/2, height], thickness);
            }
        }
    }
}
