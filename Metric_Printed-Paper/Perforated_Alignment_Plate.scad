//Metric-Paper Number
A = 7;
//Paper Thickness (mm)
thickness = 0.5;
//distance between points (mm)
dd = 10;
//height of board (mm)
H = 10;
//excess length on (each) sides (mm)
B = 10;
//Hole Radius (mm)
R = 1;

$fn = 4*3.14*R;

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

module perferations(a, distance, height, radius, center = true) {
    short_side = metricPaperShort(a)/2;
    long_side  = metricPaperLong(a)/2;
    // Square-Lattice (Circlar) Perferations
    union() {
        //(+,+), including zeros
        for(dx = [0:distance:short_side]) {
            for(dy = [0:distance:long_side]) {
                translate([dx, dy, 0]) {
                    cylinder(h = height, r = radius, center = center);
                }
            }
        }
        //(-,+)
        for(dx = [-distance:-distance:-short_side]) {
            for(dy = [distance:distance:long_side]) {
                translate([dx, dy, 0]) {
                    cylinder(h = height, r = radius, center = center);
                }
            }
        }
        //(+,-)
        for(dx = [distance:distance:short_side]) {
            for(dy = [-distance:-distance:-long_side]) {
                translate([dx, dy, 0]) {
                    cylinder(h = height, r = radius, center = center);
                }
            }
        }
        //(-,-), including zeros
        for(dx = [0:-distance:-short_side]) {
            for(dy = [0:-distance:-long_side]) {
                translate([dx, dy, 0]) {
                    cylinder(h = height, r = radius, center = center);
                }
            }
        }
    }
}
module metricPerferatedPlate(a, distance, height, radius, border, center = true) {
    difference() {
        translate([0,0,height/-2]) {
            cube([metricPaperShort(a)+border, metricPaperLong(a)+border, height], center = center);
        }
        union() {
            metricPaper(a = A, height = thickness, center = center);
            perferations(a = A, distance = dd, height = 2*height, radius = R, center = center);
        }
    }
}

translate([0,0,H/2]) {
    metricPerferatedPlate(
        a = A,
        distance = dd,
        height = H,
        radius = R,
        border = B
    );
}