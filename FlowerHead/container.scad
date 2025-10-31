include<base.scad>;

SIDES = 6;
LENGTH = 124+20;
RADIUS = 20;
HEIGHT = 80;

//Top
/*
base_female(
    length = LENGTH,
    height = 20,
    radius = RADIUS,
    sides = SIDES
);
*/

//Bottom
/*
base_male(
    length = LENGTH,
    height = 20,
    radius = RADIUS,
    sides = SIDES
);
*/

//Middle
/*
middle();
*/

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
            radius = length/2 + width
        );
        prism(
            sides = sides,
            height = height,
            radius = length/2
        );
    };
}

module middle() {
    _base_height = 20;
    difference() {
        union() {
            base_female(
                length = LENGTH,
                height = _base_height,
                radius = RADIUS,
                sides = SIDES
            );
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
                    width = 8,
                    sides = SIDES
                );
            }
        }
        prism(
            sides = SIDES,
            height = HEIGHT + 2*20,
            radius = LENGTH/2
        );
    }
}