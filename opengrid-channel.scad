// Parameters
channel_length = 8;

// private variables
_opengrid_width = 28;
_wall_thickness = 2;

_overall_width = 26.4;
_bevel_height = 0.42;
_overall_height = 13 + _bevel_height;
_corner_width = 4;
_corner_hypotenuse = sqrt(pow(_corner_width, 2) * 2);
_base_width = _overall_width - (2 * _corner_width);

module corner_angle(left = true) {
    color("#0f0")
    translate([
        left
            ? _corner_width
            : _overall_width - _corner_width,
        0,
        0])
    rotate([0, -45, 0])
    cube(left
        ? [
            _wall_thickness,
            channel_length * _opengrid_width,
            _corner_hypotenuse
        ] : [
            _corner_hypotenuse,
            channel_length * _opengrid_width,
            _wall_thickness
        ]);
}

module side_wall(left = true) {
    color("#0ff")
    rotate([90, 0, 0])
    translate([
        left ? 0 : _overall_width - _wall_thickness,
        0,
        -channel_length * _opengrid_width])
    linear_extrude(height = channel_length * _opengrid_width)
    polygon(points = [
        [0, _corner_width],
        [0, _overall_height - (left ? 0 : _bevel_height)],
        [_wall_thickness, _overall_height - (left ? _bevel_height : 0)],
        [_wall_thickness, _corner_width],
        [0, _corner_width]
    ]);
}

module tab() {
    color("#ccc")
    translate([_overall_width - 2, (28-15)/2, 12.82])
    difference() {
        cube([2, 15, 4]);
    
        // bottom cutout
        rotate([90, 0, 0])
        translate([0, 0, -20])
        linear_extrude(height = 20)
        polygon(points = [
            [1.3, 4],
            [2, 4],
            [2, 3.42],
            [1.3, 4]
        ]);
    
        // top cutout
        rotate([90, 0, 0])
        translate([0, 0, -20])
        linear_extrude(height = 20)
        polygon(points = [
            [1.3, 0],
            [2, 0],
            [2, 3],
            [1.3, 2],
            [1.3, 0]
        ]);
        
        // left angle
        rotate([90, 0, 90])
        translate([0, 0, -2])
        linear_extrude(height = 6)
        polygon(points = [
            [-2, 0],
            [2, 4],
            [-2, 4],
            [-2, 0]
        ]);
        
        // right angle
        rotate([90, 0, -90])
        translate([-15, 0, -4])
        linear_extrude(height = 6)
        polygon(points = [
            [-2, 0],
            [2, 4],
            [-2, 4],
            [-2, 0]
        ]);
    }
}

// Module to create the base channel
module channel() {
    // base
    color("#f00")
    translate([_corner_width, 0, 0])
    cube([
        _base_width,
        channel_length * _opengrid_width,
        _wall_thickness]);

    // angled corners
    corner_angle(true);
    corner_angle(false);
    
    // side walls
    side_wall(true);
    side_wall(false);
    
    // tabs
    for (i = [0:channel_length - 1]) {
        translate([0, i * _opengrid_width, 0])
        tab();
        
        mirror([1, 0, 0])
        translate([-_overall_width, i * _opengrid_width, 0])
        tab();
    }
}

// run
channel();
