_outer_height = 4.2 + 0.05;
_inner_height = 1;
 _outer_diameter = 7.1;
_center_diameter = 3.8;
 _inner_diameter = 2.1;

_torus_radius = (_outer_diameter/2 - _center_diameter/2)/2;
_outer_height_truncated = _outer_height - _torus_radius;
translate([0,0,_outer_height_truncated/2]) {
    difference() {
        $fn = 4*3.14*_outer_height_truncated;
        cylinder(h = _outer_height_truncated, r = _outer_diameter/2, center = true);
        
        $fn = 4*3.14*_outer_height_truncated;
        cylinder(h = _outer_height_truncated, r = _center_diameter/2, center = true);
    }
}
translate([0,0,_inner_height/2]) {
    difference() {
        $fn = 4*3.14*_outer_diameter;
        cylinder(h = _inner_height, r = _outer_diameter/2, center = true);
        
        $fn = 4*3.14*_inner_diameter;
        cylinder(h = _inner_height, r = _inner_diameter/2, center = true);
    }
}


module torus(inner_diameter, outer_diameter) {
  _r = inner_diameter/2;
  _rr = outer_diameter/2 - inner_diameter/2;
    
    rotate_extrude(convexity = 10, $fn = 16*3.14*inner_diameter) {
        translate([_rr, 0, 0]) {
            circle(r = _r, $fn = 16*3.14*inner_diameter);
        }
    }
}

translate([0,0,_outer_height - _torus_radius]) {
    echo(0.8*_inner_diameter);
    echo(_center_diameter);
    torus(inner_diameter = 0.78*_inner_diameter, outer_diameter = _outer_diameter);
}
