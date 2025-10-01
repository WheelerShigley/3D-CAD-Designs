//floor
$fn = 6;
difference() {
    cylinder(r = 6, h = 1);
    translate([0,0,1]) {
        $fn = 36;
        sphere(d = 0.5+0.01);
    }
}

//walls
$fn = 6;
difference() {
    cylinder(r = 7, h = 7);
    cylinder(r = 6, h = 7);
}