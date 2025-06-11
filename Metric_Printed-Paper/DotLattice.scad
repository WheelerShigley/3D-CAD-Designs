include<paper.scad>;

//Paper Standard
A = 7;
//Alignment-Plate Insertion-Height (mm)
pH = 10-5;

//Height (mm)
H = 10;
//Thickness (mm)
T = 10;

//Magnet Offset (mm)
dM = 2;

module magnet(h = 3, r = 2.5, center = true) {
    $fn = 4*3.14*r;
    cylinder(h = h, r = r, center = center);
}

module latticeAlignerCavity(dimensions, magnet_offset, magnet_height, magnet_radius, center) {
    union() {
        //body
        cube([dimensions.x, dimensions.y, dimensions.z], center = center);
        //magnets
        for(side_x = [-1,1]) {
            translate(
                [
                    side_x*( dimensions.x/2 - magnet_radius - magnet_offset),
                    0,
                    0
                ]
            ) {
                rotate([90,0,0]) {
                    magnet(h = dimensions.y+2*magnet_height, center = center);
                }
            }
        }
    }
}

module mainBody(
    a,
    outside_height, inside_height,
    thickness,
    magnet_distance, magnet_height, magnet_radius,
    lattice_aligner_thickness,
    center = true
) {
    _bottomHeight = outside_height-inside_height;
    difference() {
        //body
        translate([0,0,H/2]) {
            cube(
                [
                    metricPaperShort(a = a)+2*thickness,
                    metricPaperLong( a = a)+4*thickness+2*lattice_aligner_thickness,
                    outside_height
                ],
                center = center
            );
        }
        union() {
            //main inner-cavity
            translate([0,0,H-pH/2]) {
                cube(
                    [
                        metricPaperShort(a = a)+thickness,
                        metricPaperLong( a = a)+thickness,
                        pH
                    ],
                    center = center
                );
            }
            //bottom inner-cavity
            translate([0,0,_bottomHeight/2]) {
                metricPaper(a = A, height = _bottomHeight, center = true);
            }
            //magnet holes for alignment-plate
            union() {
                for(side_x = [-1,1]) {
                    for(side_y = [-1,1]) {
                        translate(
                            [
                                side_x*( metricPaperShort(a = a)/2+magnet_distance ),
                                side_y*( metricPaperLong( a = a)/2+magnet_distance ),
                                _bottomHeight - magnet_height/2
                            ]
                        ) {
                            magnet(h = magnet_height, r = magnet_radius, center = center);
                        }
                    }
                }
            }
            //side-alignments
            union() {
                for(side_y = [-1,1]) {
                    translate(
                        [
                            0,
                            side_y*( metricPaperLong(a = a)/2 + lattice_aligner_thickness/2 + thickness),
                            outside_height - inside_height/2
                        ]
                    ) {
                        latticeAlignerCavity(
                            [
                                metricPaperShort(a = a)+thickness,
                                lattice_aligner_thickness,
                                inside_height
                            ],
                            magnet_height = magnet_height, magnet_radius = magnet_radius,
                            magnet_offset = magnet_distance,
                            center = true
                        );       
                    }
                }
            }
            //bottom magnets
            union() {
                for(side_x = [-1,1]) {
                    for(side_y = [-1,1]) {
                        translate(
                            [
                                side_x*(
                                    metricPaperShort(a = a)/2 + thickness
                                    - magnet_radius - magnet_distance
                                ),
                                side_y*(
                                    metricPaperLong(a = a)/2 + 2*thickness + lattice_aligner_thickness
                                    - magnet_radius - magnet_distance
                                ),
                                magnet_height/2
                            ]
                        ) {
                            magnet(h = magnet_height, r = magnet_radius, center = center);
                        }
                    }
                }
            }
            
        }
    }
}

mainBody(
    a = A,
    outside_height = H, inside_height = pH,
    thickness = T,
    lattice_aligner_thickness = 10,
    magnet_distance = dM, magnet_height = 3, magnet_radius = 2.5,
    center = true
);