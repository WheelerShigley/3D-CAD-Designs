include<paper.scadh>;
include<common.scadh>;

//Paper Standard
A = 7;
//Alignment-Plate Insertion-Height (mm)
pH = 10-5;

//Height (mm)
H = 10;
//Thickness (mm)
T = 10;
//lattice_aligner_thickness (mm)
lT = 10;

//Magnet Offset (mm)
dM = 5;

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
        //rounding
        difference() {
            translate([0,0,dimensions.z/4]) {
                cube(
                    [
                        dimensions.x+dimensions.z,
                        dimensions.y,
                        dimensions.z/2
                    ],
                    center = center
                );
            }
            roundedEdgePair(
                distance = dimensions.x,
                width = dimensions.y,
                radius = dimensions.z/2
            );
        }
    }
}

module mainCavity(
    a,
    outside_height, inside_height,
    thickness,
    magnet_distance, magnet_height, magnet_radius,
    center = true
) {
    _length = metricPaperLong( a = a)+2*thickness;
    _width =  metricPaperShort(a = a)+2*thickness;
    _bottomHeight = outside_height-inside_height;
    _radius = thickness/4;
    union() {
        //top section
        _topHeight = outside_height-inside_height/2;
        translate([0,0,_topHeight]) {
            cube([_width, _length, inside_height], center = center);
            //rounding cavity
            translate([0,0,inside_height/2 - _radius/2]) {
                cube([_width+2*_radius,_length+2*_radius,_radius], center = center);
            }
        }
        //bottom section
        translate([0,0,_bottomHeight/2]) {
            metricPaper(a = a, height = _bottomHeight, center = true);
        }
        //magnet holes for alignment-plate
        union() {
            for(side_x = [-1,1]) {
                for(side_y = [-1,1]) {
                    translate(
                        [
                            side_x*( _width/2  - magnet_distance ),
                            side_y*( _length/2 - magnet_distance ),
                            _bottomHeight - magnet_height/2
                        ]
                    ) {
                        magnet(h = magnet_height, r = magnet_radius, center = center);
                    }
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
    _width =  metricPaperShort(a = a);
    _length = metricPaperLong( a = a);
    _bottomHeight = outside_height-inside_height;
    union() {
        difference() {
            union() {
                //body
                translate([0,0,outside_height/2]) {
                    cube(
                        [
                            _width+4*thickness,
                            _length+6*thickness+2*lattice_aligner_thickness,
                            outside_height
                        ],
                        center = center
                    );
                }
            }
            union() {
                mainCavity(
                    a = a,
                    outside_height = outside_height, inside_height = inside_height,
                    thickness = thickness,
                    magnet_distance = magnet_distance, magnet_height = magnet_height, magnet_radius = magnet_radius,
                    center = center
                );
                //side-alignments
                union() {
                    for(side_y = [-1,1]) {
                        translate(
                            [
                                0,
                                side_y*( metricPaperLong(a = a)/2 + lattice_aligner_thickness/2 + 2*thickness),
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
        
        //central rounding (paper guide)
        _radius = thickness/4;
        translate([0,0,outside_height - _radius/2]) {
            roundedEdgeFace(
                [_width+2*thickness, _length+2*thickness, _radius],
                center = true
            );
        }
    }
}

mainBody(
    a = A,
    outside_height = H, inside_height = pH,
    thickness = T,
    lattice_aligner_thickness = lT,
    magnet_distance = dM, magnet_height = 3, magnet_radius = 2.5,
    center = true
);