include<paper.scadh>;

//Paper Thickness (mm)
dz = 5;
//insertin tolerance
t = 0.1;

//Conversion Paper (mm)
p_dx = inToMm(8.5/2);
p_dy = inToMm( 11/2);

primary_dimensions = [p_dx,p_dy,dz];

//Resulting Paper Standard (metric)
A = 7;

s_dx = metricPaperShort(a = A);
s_dy = metricPaperLong( a = A);
secondary_dimensions = [s_dx, s_dy, dz];

function inToMm(in) = 25.4*in;

module paper(dimensions, center = true) {
    translate([0,0, center ? -dz/2 : 0]) {
        cube([dimensions.x, dimensions.y, dimensions.z], center = true);
    }
}

module standardPapers() {
    union() {
        translate(
            [
                s_dx/2 - p_dx/2,
                p_dy/2,
                0
            ]
        ) {
            paper(dimensions = secondary_dimensions, center = false);
        }
        
        translate(
            [
                (s_dy - p_dx)/2,
                (s_dx - p_dy)/2,
                0
            ]
        ) {
            paper(
                dimensions = [
                    secondary_dimensions.y,
                    secondary_dimensions.x,
                    secondary_dimensions.z
                ],
                center = false
           );
        }
    }
}

module sides(radius = dz/2) {
    _length = p_dx - s_dx;
    $fn = 4*3.14*dz/2;
    union() {
        translate(
            [
                p_dx/2 - _length/2,
                p_dy/2,
                0
            ]
        ) {
            rotate([90,0,90]) {
                cylinder(h = _length, r = radius, center = true);
            }
        }
        translate([p_dx/2,0,0]) {
            rotate([90,0,0]) {
                cylinder(h = p_dy, r = radius, center = true);
            }
        }
    }
}


translate([0,0,dz/2]) {
    difference() {
        paper(dimensions = primary_dimensions, center = false);
        union() {
            standardPapers();
            sides(radius = dz/10);
        }
    }
}