include<trig.scad>;

SIDES = 6;
LENGTH = 24.8+4;
RADIUS = 2;
HEIGHT = 4/4;


base_male(
    sides = SIDES,
    length = LENGTH,
    radius = RADIUS,
    height = HEIGHT
);


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

module base_male(length, height, radius, sides) {
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
    }
}

module base_female(length, height, radius, sides) {
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
            translate([0,0,height/2]) {
                _radius = length/4.6;
                $fn = 4*3.14*_radius;
                cylinder(
                    h = height,
                    r = _radius,
                    center = true
                );
            }
        }
    }
}
