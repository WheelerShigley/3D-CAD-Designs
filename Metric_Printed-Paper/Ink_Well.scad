include<paper.scadh>;

//Paper Size (metric)
A = 7;

//well height (depth; mm)
H = 30;
//wall thickness (mm)
T = 10;

//alignment-thickness (mm)
aT = 10;

//magnet offset from center (mm)
dM = 2;
//magnet height (mm)
mH = 3;
//magnet radius (mm)
mR = 2.5;

module magnet(r = 2.5, h = 3, center = true) {
    $fn = 4*3.14*r;
    cylinder(r = r, h = h, center = center);
}

module container(a, height, thickness, alignment_thickness, center) {
    _cavityHeight = height-thickness;
    difference() {
        cube(
            [
                metricPaperShort(a = a) + 2*thickness,
                metricPaperLong( a = a) + 4*thickness + 2*alignment_thickness,
                height
            ],
            center = center
        );
        translate([0,0,_cavityHeight/-2 + height/2]) {
            cube(
                [
                    metricPaperShort(a = a),
                    metricPaperLong( a = a) + 2*thickness + 2*alignment_thickness,
                    _cavityHeight
                ],
                center = center
            );
        }
    }
}

difference() {
    translate([0,0,H/2]) {
        container(
            a = A,
            height = H,
            thickness = T, alignment_thickness = aT,
            center = true
        );
    }
    //magnet holes
    union() {
        for(side_x = [-1,1]) {
            for(side_y = [-1,1]) {
                translate(
                    [
                        side_x*(
                            metricPaperShort(a = A)/2 + T - dM - mR
                        ),
                        side_y*(
                            metricPaperLong(a = A)/2 + 2*T + aT - dM - mR
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