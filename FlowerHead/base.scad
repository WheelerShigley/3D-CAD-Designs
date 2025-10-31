include<trig.scad>;

SIDES = 6;
LENGTH = 124+20;
RADIUS = 20;
HEIGHT = 20;

module base(length, height, radius, sides) {
	hull() {
		$fn = 64;
		for(n = [0:sides]) {
			N = n/sides;
			translate(
				[x(length/2,N),y(length/2,N),0]
			) {
				cylinder(r = radius, h = height);
			}
		}
	}
};

module balls(length, radius, sides) {
    _radius = 0.895*radius;
    $fn = 32;
    for(n = [0:sides]) {
        N = n/sides;
        distance = _radius + length/2;
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
        distance = _radius + length/2;
        translate(
            [x(distance,N),y(distance,N),0]
        ) {
            cylinder(r = _radius, h = height);
        }
    }
}

module base_male(length, height, radius, sides) {
    union() {
        base(
            length = length,
            height = height,
            radius = radius,
            sides = sides
        );
        translate([0,0,height]) {
            balls(
                length = length,
                radius = radius/2,
                sides = sides
            );
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
        translate([0,0,0]) {
            tubes(
                length = length,
                radius = radius/2,
                height = height,
                sides = sides
            );
        }
    }
}
