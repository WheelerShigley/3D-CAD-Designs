include<base.scad>;

SIDES = 6;
LENGTH = 24.8+2;
RADIUS = 2;
HEIGHT = 4;

//Top
/*
base_female(
    length = LENGTH,
    height = HEIGHT/4,
    radius = RADIUS,
    sides = SIDES
);
*/

//Bottom
/*
base_male(
    length = LENGTH,
    height = HEIGHT/4,
    radius = RADIUS,
    sides = SIDES
);
*/

//Middle

middle();


module prism(sides, height, radius) {
    rotate([0,0,180/sides]) {
        $fn = sides;
        cylinder(
            h = height,
            r = radius
        );
    }
}

module wall(length, height, width, sides) {
    difference() {
        prism(
            sides = sides,
            height = height,
            radius = length/4 + width
        );
        prism(
            sides = sides,
            height = height,
            radius = length/4
        );
    };
}

module middle() {
    _base_height = HEIGHT/4;
    difference() {
        union() {
            rotate([180,0,0]) {
                translate([0,0,-_base_height]) {
                    base_female(
                        length = LENGTH,
                        height = _base_height,
                        radius = RADIUS,
                        sides = SIDES
                    );
                }
            }
            translate([0,0,HEIGHT+_base_height]) {
                base_male(
                    length = LENGTH,
                    height = _base_height,
                    radius = RADIUS,
                    sides = SIDES
                );
            }
            translate([0,0,_base_height]) {
                wall(
                    length = LENGTH,
                    height = HEIGHT,
                    width = LENGTH*sqrt(3)/15,
                    sides = SIDES
                );
            }
        }
        prism(
            sides = SIDES,
            height = HEIGHT + 2*20,
            radius = LENGTH/4
        );
    }
}