module shape(size,top) {
   hull() {
        translate([0,0,size.z/2]) {
            _radius = size.x/4;
            _diameter = 2*_radius;
            for(side = [-1,1]) {
                translate(
                    [
                        side*(size.x-3*_radius),
                        size.y/2-_radius,
                        0
                    ]
                ) {
                    $fn = 12*_radius;
                    cylinder(h=size.z,r=_radius,center=true);
                }
            }
            
            _distance_x = 1.5;
            translate([0,size.y/-4,0]) {
                cube([size.x-2*_distance_x,size.y/2,size.z],center=true);
            }
            _distance_y = 3;
            translate([0,size.y/-4+_distance_y/2,0]) {
                cube([size.x,size.y/2-_distance_y,size.z],center=true);
            }
        }
    }
    
    _dy = top.y/2+size.y/2;
   
    hull() {
        translate([0,0,2*size.z+top.z/2]) {
            cube([size.x,4*size.y,top.z],center = true);
        }
        translate([0,-size.y/2,size.z-top.z]) {
            rotate([4.4209072801,0,0]) {
                translate([0,_dy,top.z/2]) {
                    cube([size.x,size.y+top.y,top.z],center=true);
                }
            }
        }
    }
}

module centered_cube(size) {
    translate([0,0,size.z/2]) {
        cube(size,center=true);
    }
}

module adapter(thickness) {
    _main_size = [23,20,22.2];
    _secondary_size = [0,18,3];
    _distance_x = 1.5;
    difference() {
            union() {
            centered_cube(
                [
                    _main_size.x + 2*thickness,
                    _main_size.y + 2*thickness,
                    _main_size.z + 2*thickness
                ]
            );
            translate([0,_main_size.y/2-thickness,0]) {
                centered_cube(
                    [
                        _main_size.x + 2*thickness,
                        _main_size.y+_secondary_size.y - thickness,
                        _main_size.z + 2*thickness
                    ]
                );
            }
        }
        union() {
            translate([0,-thickness,0]) {
                centered_cube(
                    [
                        _main_size.x - 2*_distance_x,
                        _main_size.y,
                        _main_size.z
                    ]
                );
            }

            shape(_main_size, _secondary_size);
            
            _part = [1000,8.5,2.3];
            translate(
                [
                    0,
                    _main_size.y/2 + _secondary_size.y - 3/2*thickness - _part.y/2,
                    0
                ]
            ) {
                centered_cube(
                    [
                        _main_size.x + 2*thickness,
                        _part.y+thickness,
                        _part.z
                    ]
                );
            }
        }
    }
}

adapter(thickness = 2);