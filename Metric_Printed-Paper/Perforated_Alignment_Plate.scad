//Metric-Paper Number
A = 7;
//Paper Thickness (mm)
thickness = 0.5;
//distance between points (mm)
dd = 10;
//height of board (mm)
H = 10;
//Hole Radius (mm)
R = 1;
//Hole-Rounding Radius (mm)
rR = 1;

//excess length on (each) sides (mm)
B = 10;
//magnet radius
mR = 2.5;
//magnet height
mH = 3;
//distance to offset magnets from edges
mD = 1;

fn_constant = 4*PI;

function metricPaperShort(a) = 1000*sqrt(
    (2^-a)/sqrt(2)
);
function metricPaperLong(a) = 1000*sqrt(
    (2^-a)*sqrt(2)
);

module metricPaper(a, height = 0.5, center = true) {
    cube(
        [metricPaperShort(a), metricPaperLong(a), height],
        center
    );
}

module torus(inner_diameter, outer_diameter, center = true) {
    distance = (outer_diameter+inner_diameter)/2;
    diameter = (outer_diameter-inner_diameter);
    $fn = fn_constant*diameter;
    rotate_extrude() {
        translate([distance,0,0]) {
            circle(d = diameter);
        }
    }
}

module innerCylinder(column_radius, height, rounding_radius, center = true) {
    union() {
        //central column
        $fn = 4*fn_constant*column_radius;
        cylinder(h = height, r = column_radius, center = center);
        
        //top inverse-torus
        difference() {
            translate([0,0,height/-2 + rounding_radius/2]) {
                $fn = fn_constant*rounding_radius;
                cylinder(h = rounding_radius, r = column_radius+rounding_radius, center = center);
            }
            translate([0,0,height/-2 + rounding_radius]) {
                torus(
                    inner_diameter = column_radius,
                    outer_diameter = column_radius+2*rounding_radius,
                    center = center
                );
            }
        }
        
        //bottom inverse-torus
        difference() {
            translate([0,0,height/2 - rounding_radius/2]) {
                $fn = fn_constant*rounding_radius;
                cylinder(h = rounding_radius, r = column_radius+rounding_radius, center = center);
            }
            translate([0,0,height/2 - rounding_radius]) {
                torus(
                    inner_diameter = column_radius,
                    outer_diameter = column_radius+2*rounding_radius,
                    center = center
                );
            }
        }
    }
}

//TODO: convert to single double-loop
module perferations(a, distance, height, radius, rounding_radius, center = true) {
    short_side = metricPaperShort(a)/2;
    long_side  = metricPaperLong(a)/2;
    // Square-Lattice (Circlar) Perferations
    union() {
        //(+,+), including zeros
        for(dx = [0:distance:short_side]) {
            for(dy = [0:distance:long_side]) {
                translate([dx, dy, 0]) {
                    innerCylinder(
                        column_radius = radius,
                        height = height,
                        rounding_radius = rounding_radius,
                        center = center
                    );
                }
            }
        }
        //(-,+)
        for(dx = [-distance:-distance:-short_side]) {
            for(dy = [distance:distance:long_side]) {
                translate([dx, dy, 0]) {
                    innerCylinder(
                        column_radius = radius,
                        height = height,
                        rounding_radius = rounding_radius,
                        center = center
                    );
                }
            }
        }
        //(+,-)
        for(dx = [distance:distance:short_side]) {
            for(dy = [-distance:-distance:-long_side]) {
                translate([dx, dy, 0]) {
                    innerCylinder(
                        column_radius = radius,
                        height = height,
                        rounding_radius = rounding_radius,
                        center = center
                    );
                }
            }
        }
        //(-,-), including zeros
        for(dx = [0:-distance:-short_side]) {
            for(dy = [0:-distance:-long_side]) {
                translate([dx, dy, 0]) {
                    innerCylinder(
                        column_radius = radius,
                        height = height,
                        rounding_radius = rounding_radius,
                        center = center
                    );
                }
            }
        }
    }
}

module metricPerferatedPlate(a, distance, height, radius, rounding_radius, border, center = true) {
    difference() {
        translate([0,0,height/-2]) {
            cube([metricPaperShort(a)+border, metricPaperLong(a)+border, height], center = center);
        }
        union() {
            translate([0,0,thickness/-2]) {
                metricPaper(a = A, height = thickness, center = center);
            }
            translate([0,0,height/-2 + thickness/-2]) {
                perferations(
                    a = A,
                    distance = dd,
                    height = height-thickness,
                    radius = R,
                    rounding_radius = rounding_radius,
                    center = center
                );
            }
        }
        
        //magnet holes
        for(x_side = [-1,1]) {
            for(y_side = [-1,1]) {
                translate(
                    [
                        ( x_side*(metricPaperShort(a) + border/2 - 2*mD) )/2,
                        ( y_side*(metricPaperLong(a) + border/2 - 2*mD) )/2,
                        -1*height + mH/2
                    ]
                ) {
                    $fn = fn_constant*mR;
                    cylinder(h = mH, r = mR, center = center);
                }
            }
        }
    }
}

//TODO: improve render-times (redo edge-rounding?)
translate([0,0,H]) {
    metricPerferatedPlate(
        a = A,
        distance = dd,
        height = H,
        radius = R,
        rounding_radius = rR,
        border = B
    );
}