include<trig.scad>;

SIDES = 6;
LENGTH = 24.8+4;
RADIUS = 2;
HEIGHT = 4/4;

/*
base_male(
    sides = SIDES,
    length = LENGTH,
    radius = RADIUS,
    height = HEIGHT
);
*/

module base(length, height, radius, sides) {
	hull() {
		$fn = 64;
		for(n = [0:sides]) {
			N = n/sides;
			translate(
				[x(length/2-radius,N),y(length/2-radius,N),height/2]
			) {
                union() {
                    sphere(r = height/2);
                    cylinder(r = height/2, h = height/2);
                }
			}
		}
	}
};

module balls(length, radius, sides) {
    _radius = 0.895*radius;
    $fn = 32;
    for(n = [0:sides]) {
        N = n/sides;
        distance = length * 3/4;
        translate(
            [x(distance,N),y(distance,N),0]
        ) {
            sphere(r = _radius);
        }
    }
}

module tubes(length, radius, sides, height) {
    _radius = 0.9*radius;
    $fn = 32;
    for(n = [0:sides]) {
        N = n/sides;
        distance = length * 3/4;
        translate(
            [x(distance,N),y(distance,N),0]
        ) {
            cylinder(r = _radius, h = height);
        }
    }
}

module torus(inner_radius, outer_radius) {
    _radius = outer_radius - inner_radius;
    $fn = 16;
    rotate_extrude(convexity = 8)
        translate([outer_radius, 0, 0])
            circle(r = _radius);
}

module relief(height, length, sides) {
    _radius = height/2;
    difference() {
        $fn = sides;
        cylinder(
            r = length/2 + 2*height,
            h = height/2
        );
        union() {
            $fn = 64;
            for(n = [0:sides]) {
                N = (n+0.5)/sides;
                _length = length/2;
                translate([x(_length,N),y(_length,N),height/2]) {
                    rotate([90,0,360*N]) {
                        cylinder(
                            h = ( sqrt(3)/3 ) * length,
                            r = _radius,
                            center = true
                        );
                    }
                }
            }
            for(n = [0:sides/2]) {
                N = n/sides + 30;
                translate([0,0,height/2]) {
                    rotate([90,0,360*N]) {
                        union() {
                            cylinder(
                                h = length,
                                r = _radius,
                                center = true
                            );
                            cylinder(
                                h = length,
                                r = _radius,
                                center = true
                            );
                        }
                    }
                }
            }
        }
    }
}

module base_male(length, height, radius, sides, reliefs = true) {
    difference() {
        union() {
            base(
                length = length,
                height = height,
                radius = radius,
                sides = sides
            );
            translate([0,0,height]) {
                balls(
                    length = length/2,
                    radius = radius/2,
                    sides = sides
                );
            }
        }
        if(reliefs) {
            relief(
                length = length/2,
                height = height/2,
                sides = sides
            );
        }
    }
}

module base_female(length, height, radius, sides, reliefs = true) {
    difference() {
        base(
            length = length,
            height = height,
            radius = radius,
            sides = sides
        );
        union() {
            tubes(
                length = length/2,
                radius = radius/2,
                height = height,
                sides = sides
            );
            if(reliefs) {
                relief(
                    length = length/2,
                    height = height/2,
                    sides = sides
                );
            }
        }
    }
}
