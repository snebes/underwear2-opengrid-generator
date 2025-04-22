/*[Channel Size]*/
// Length of channel in openGrid units.
Channel_Length = 8;
assert(Channel_Length >= 1 && Channel_Length <= 10, "Channel Length must be at least 1 and at most 10");


// Width of channel in openGrid units.
//Channel_Width = 1;
//assert(Channel_Width >= 1 && Channel_Width <= 4, "Channel Width must be at least 1 and at most 4");

// Height of the channel
Channel_Depth = "Single";  // [Single, Double, Triple]
assert(Channel_Depth == "Single" || Channel_Depth == "Double" || Channel_Depth == "Triple", "Invalid Channel Depth");

// ------------------------------------------------------------------------------

/*[Hidden]*/
opengridSize = 28;
wallThickness = 2;
cornerWidth = 4;
cornerHypotenuse = sqrt(pow(cornerWidth, 2) * 2);
bevelHeight = 0.42;


opengridLength = Channel_Length;
channelLength  = Channel_Length * opengridSize;
channelHeight  = bevelHeight +
    (Channel_Depth == "Single" ? 13 : (Channel_Depth == "Double" ? 17.5 : 22.5));
channelWidth   = 26.4; // tbd how to span multiple

module base() {
    width = (channelWidth - (2 * cornerWidth)) / 2;
    depth = channelLength;
    height = wallThickness;

    translate([-width, 0, 0])
    cube([width, depth, height]);
}

// Build the angled corner
module cornerAngle() {
    width = wallThickness;
    depth = channelLength;
    height = cornerHypotenuse;

    offsetX = (channelWidth - (2 * cornerWidth)) / 2;

    color("#0f0")
    translate([-offsetX, 0, 0])
    rotate([0, -45, 0])
    cube([width, depth, height]);
}

// Build the side wall
module sideWall() {
    offsetX = channelWidth / 2;

    a = [0, cornerWidth];
    b = [wallThickness, cornerWidth];
    c = [wallThickness, channelHeight - bevelHeight];
    d = [0, channelHeight];

    color("#0ff")
    rotate([-90, 0, 0])
    translate([-offsetX, 0, 0])
    mirror([0, 1, 0])
    linear_extrude(channelLength)
    polygon([a, b, c, d, a]);

    for (i = [0:opengridLength - 1]) {
        translate([0, i * opengridSize, 0])
        tab();
    }
}

// Build a tab
module tab() {
    tabWidth = 15;
    tabHeight = 4;

    offsetX = channelWidth / 2;
    offsetY = (opengridSize - tabWidth) / 2;
    offsetZ = channelHeight - bevelHeight;

    color("#ccc")
    translate([-offsetX, offsetY, offsetZ])
    difference() {
        cube([wallThickness, tabWidth, tabHeight]);

        // side profile
        color("#f00")
        rotate([90, 0, 0])
        translate([0, 0, -opengridSize])
        linear_extrude(opengridSize)
        polygon([
            [0, 0],
            [0, tabHeight],
            [0.56, tabHeight],
            [0, tabHeight - 0.56],
            [0, tabHeight - 1],
            [0.56, tabHeight - 2],
            [0.56, 0],
            [0, 0]
        ]);

        // dog ears
        color("#f00")
        rotate([90, 0, 90])
        translate([0, 0, 0])
        linear_extrude(wallThickness)
        polygon([
            [-2, 0],
            [-2, tabHeight],
            [tabWidth + 2, tabHeight],
            [tabWidth + 2, 0],
            [tabWidth - 2, tabHeight],
            [2, tabHeight],
            [-2, 0]
        ]);
    }
}

// Build half sized channel that can be mirrored
module halfChannel() {
    base();
    cornerAngle();
    sideWall();
}

// Create the channel
module createChannel() {
    halfChannel();

    mirror([1, 0, 0])
    halfChannel();
}

createChannel();
