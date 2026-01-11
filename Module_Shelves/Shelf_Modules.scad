MODULE_SIZE = 500; //mm, half a meter
MODULE_DEPTH = inchesToMillimetes(inches = 12-0.25);

function inchesToMillimetes(inches) = 25.4*inches;

module shelf(width, height) {
    difference() {
        _width  = width*MODULE_SIZE;
        _height = height*MODULE_SIZE;
        translate([0,0,_height/2]) {
            cube([_width,MODULE_DEPTH,_height],center = true);
        }

        _thickness = inchesToMillimetes(inches = 0.75);
        _height_2 = _height - 2*_thickness;
        _width_2  = _width  - 2*_thickness;
        translate([0,0,_height_2/2+_thickness]) {
            cube(
                [_width_2, MODULE_DEPTH, _height_2],
                center = true
            );
        }
    }
}

module peg(width, height, inset, radius) {
    for(_width = [0:0.5:width-0.5] ) {
        translate([MODULE_SIZE*_width,0,0]) {
            _dx = (width-0.5)*MODULE_SIZE/2;
            hull() {
                for(x_side = [-1, 1]) {
                    for(z_side = [-1, 1]) {
                        translate(
                            [
                                ( MODULE_SIZE/4  - inset )  *  x_side - _dx,
                                ( MODULE_DEPTH/2 - inset )  *  z_side,
                                height/2
                            ]
                        ) {
                            cylinder(h = height, r = radius, center = true);
                        }
                    }
                }
            }
        }
    }
}

module shelf_module(width = 1, height = 1) {
    board_thickness = inchesToMillimetes(0.75);
    insert_height = inchesToMillimetes(0.25);
    difference() {
        union() {
            shelf(width = width, height = height);
            translate([0,0,MODULE_SIZE*height]) {
                peg(width = width, height = insert_height, inset = board_thickness+0.5, radius = 10);
            }
        }
        peg(width = width, height = insert_height, inset = board_thickness+0.5, radius = 10);
    }
};

module shelves() {
    translate([0,0,0]) {
        shelf_module(width = 1, height = 1);
    }
    translate([3/2*MODULE_SIZE,0,0]) {
        shelf_module(width = 2, height = 1);
    }
    translate([-3/2*MODULE_SIZE,0,0]) {
        shelf_module(width = 2, height = 1);
    }
    
    translate([-7/4*MODULE_SIZE,0,MODULE_SIZE]) {
        shelf_module(width = 0.5, height = 1);
    }
    translate([-9/4*MODULE_SIZE,0,MODULE_SIZE]) {
        shelf_module(width = 0.5, height = 1);
    }
    translate([-1/2*MODULE_SIZE,0,MODULE_SIZE]) {
        shelf_module(width = 2, height = 1);
    }
    translate([MODULE_SIZE,0,MODULE_SIZE]) {
        shelf_module(width = 1, height = 1);
    }
    translate([2*MODULE_SIZE,0,MODULE_SIZE]) {
        shelf_module(width = 1, height = 0.5);
    }
    translate([2*MODULE_SIZE,0,3/2*MODULE_SIZE]) {
        shelf_module(width = 1, height = 0.5);
    }
    
    translate([2*MODULE_SIZE,0,2*MODULE_SIZE]) {
        shelf_module(width = 1, height = 1);
    }
    translate([1/2*MODULE_SIZE,0,2*MODULE_SIZE]) {
        shelf_module(width = 2, height = 1);
    }
    translate([-3/2*MODULE_SIZE,0,2*MODULE_SIZE]) {
        shelf_module(width = 2, height = 1);
    }
    
    translate([-2*MODULE_SIZE,0,3*MODULE_SIZE]) {
        shelf_module(width = 1, height = 1);
    }
    translate([-1/2*MODULE_SIZE,0,3*MODULE_SIZE]) {
        shelf_module(width = 2, height = 1);
    }
    translate([3/2*MODULE_SIZE,0,3*MODULE_SIZE]) {
        shelf_module(width = 2, height = 1);
    }
    
    translate([-7/4*MODULE_SIZE,0,4*MODULE_SIZE]) {
        shelf_module(width = 0.5, height = 1);
    }
    translate([-9/4*MODULE_SIZE,0,4*MODULE_SIZE]) {
        shelf_module(width = 0.5, height = 1);
    }
    translate([-1*MODULE_SIZE,0,4*MODULE_SIZE]) {
        shelf_module(width = 1, height = 1);
    }
    translate([1/2*MODULE_SIZE,0,4*MODULE_SIZE]) {
        shelf_module(width = 2, height = 1);
    }
    translate([2*MODULE_SIZE,0,4*MODULE_SIZE]) {
        shelf_module(width = 1, height = 1);
    }
}

//shelves();
shelf_module();