include<paper.scadh>;
include<common.scadh>;

//Paper Size (metric)
A = 7;

//well height (depth; mm)
H = 30;
//wall thickness (mm)
T = 10;

//alignment-thickness (mm)
aT = 10;

//magnet offset from center (mm)
dM = 5;
//magnet height (mm)
mH = 3;
//magnet radius (mm)
mR = 5;

module guide(sphere_radius, hole_radius, center = true) {
    $fn = 4*3.14*sphere_radius;
    difference() {
        sphere(r = sphere_radius);
        cylinder(h = 2*sphere_radius+0.2, r = hole_radius, center = center);
    }
}

module container(a, height, thickness, alignment_thickness, center) {
    _cavityHeight = height-thickness;
    difference() {
        cube(
            [
                metricPaperShort(a = a) + 4*thickness,
                metricPaperLong( a = a) + 6*thickness + 2*alignment_thickness,
                height
            ],
            center = center
        );
        translate([0,0,_cavityHeight/-2 + height/2]) {
            cube(
                [
                    metricPaperShort(a = a) + 2*thickness,
                    metricPaperLong( a = a) + 4*thickness + 2*alignment_thickness,
                    _cavityHeight
                ],
                center = center
            );
        }
    }
}

difference() {
    union() {
        translate([0,0,H/2]) {
            container(
                a = A,
                height = H,
                thickness = T, alignment_thickness = aT,
                center = true
            );
        }
        //guides
        _sphereRadius = 5;
        for(side_x = [-1,1]) {
            translate(
                [
                    side_x*(
                        metricPaperShort(a = A)/2 + 2*T
                    ),
                    0,
                    H - _sphereRadius
                ]
            ) {
                guide(sphere_radius = _sphereRadius, hole_radius = 1, center = true);
            }
        }
    }
    //magnet holes
    union() {
        for(side_x = [-1,1]) {
            for(side_y = [-1,1]) {
                translate(
                    [
                        side_x*(
                            metricPaperShort(a = A)/2 + 2*T - mR/2 - dM
                        ),
                        side_y*(
                            metricPaperLong(a = A)/2 + 3*T + aT - mR/2 - dM
                        ),
                        mH/-2 + H
                    ]
                ) {
                    magnet(center = true);
                }
            }
        }
    }
}