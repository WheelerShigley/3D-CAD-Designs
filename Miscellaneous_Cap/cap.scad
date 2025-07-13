//include <threads.scad>;

module roundCylinder(height, radius, center = true) {
    $fn = 4*PI*radius;
    cylinder(h = height, r = radius, center = center);
}

TAU = 2*PI;
RADIAN_TO_DEGREE = 180/PI;
module grips(radius, height, thickness, count, center = true) {
    for(i = [0:1:count]) {
        translate(
            [
                radius/2 * sin(RADIAN_TO_DEGREE * TAU*i/count),
                radius/2 * cos(RADIAN_TO_DEGREE * TAU*i/count),
                center ? 0 : height/2
            ]
        ) {
            rotate([0,0,90-i*360/count]) {
                cube([thickness,thickness,height], center = true);
            }
        }
    }
}

module object(
    inner_diameter,
    outer_diameter,
    outermost_diameter,
    grip_diameter,
    maximum_height,
    stopper_height,
    grip_count,
    threads_per_inch,
    thread_height
) {
    difference() {
        union() {
            roundCylinder(height = maximum_height, radius = outer_diameter/2,       center = false);
            roundCylinder(height = stopper_height, radius = outermost_diameter/2,   center = false);
            
            grips(
                radius = outer_diameter, height = maximum_height, thickness = grip_diameter,
                count = grip_count, center = false
            );
            //TODO: threads
        }
        roundCylinder(height = maximum_height, radius = inner_diameter/2, center = false);
    }
}

object(
    inner_diameter      = 2*25.4,
    outer_diameter      = 2.5*25.4,
    outermost_diameter  = 3*25.4,
    grip_diameter       = 25.4/10,

    maximum_height      = 25.4/2,
    stopper_height      = 25.4/8,

    grip_count          = 12,

    threads_per_inch    = 5,
    thread_height       = 25.4/4
);
