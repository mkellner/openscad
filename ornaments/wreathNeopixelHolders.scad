$fn = 40;

fudge = 0.2;
fast = 1;

ledClearance = .5;
neopixelOffsetD = 0; // -wall;

LEDr = 4;
LEDh = 7;
LEDoffset = 0;

barrelR = 6 + fudge;
barrelH = 25;
barrelOffset = LEDh - LEDr;

tabW = 3;
tabOffsetZ = 7.5;

ledGap = 1.5;
holeGap = 1;    // Adds to barrel radius

module neopixel() {
    translate([0, 0, neopixelOffsetD]) {
        translate([0, 0, LEDh])
            translate([0, 0, -barrelOffset - barrelH])
                cylinder(r=barrelR, h=barrelH);
    if (ledClearance) {
        translate([0, 0, ledGap])
            cylinder(r=barrelR+holeGap, h=barrelH);
        translate([0, 0, -barrelH])
            cylinder(r=barrelR+holeGap, h=barrelH);
  if (0) {
        translate([0, 0, barrelH+holeGap]) // wall-barrelH+ledGap-7])
            rotate([0, 180, 0])
            cylinder(r1=barrelR+holeGap+2, r2=barrelR, h=barrelH);
  }
    }

    if (!fast) {
        translate([0, 0, LEDh]) {
            sphere(LEDr);
            translate([0, 0, -LEDh])
                cylinder(r=LEDr, h=LEDh);
            translate([0, 0, -barrelOffset - barrelH])
                cylinder(r=barrelR, h=barrelH);
            for (az = [0,90,180,270])
                rotate(a = az, v=[0, 0, 1])
            translate([LEDr, -tabW/2, -LEDr-tabOffsetZ])
                cube(tabW, tabW*2, 7);
        }
    }
}
}


numHolders = 3;
specWidth = 85;
holdersLoc = [0, 29, 58];
holderMargin = 10;
holderH = 15;
holderR = 8.5;
holderW = holderR*2;
baseW = (holderW+holderMargin) * numHolders;
baseH = (holderR*2) + holderMargin;
baseD = 2;
holderHoleR = 2.5;

module holderPos() {
        translate([0, 0, -holderH+2])
            cylinder(h=holderH, r=holderR);
}

holderGapW = 5;
module holderNeg() {
    translate([0, 0, -holderH+3])
        #neopixel();
    translate([-holderGapW/2, 0, -holderH+baseD-1])
#        cube([holderGapW, holderH, 20]);
a=0;
                translate([a - holderR-.5, a - holderR-.5, -5])
                    cylinder(r=holderHoleR, h=10);
                translate([a + holderR+.5, a - holderR-.5, -5])
                    cylinder(r=holderHoleR, h=10);
                translate([a + holderR+.5, a + holderR+.5, -5])
                    cylinder(r=holderHoleR, h=10);
                translate([a - holderR-.5, a + holderR+.5, -5])
                    cylinder(r=holderHoleR, h=10);

}

module holder(num=1, wid=baseW, pos=[0]) {
    difference() {
        union() {
            translate([-holderR-holderMargin/2, -baseH/2, 0])
                cube([wid, baseH, baseD]);
            for (a=pos)
                translate([a, 0, 0])
                    holderPos();
        }
        union() {
            for (a=pos) {
                translate([a, 0, 0])
                    holderNeg();

            }
        }
    }
}

//holder();
rotate([0, 180, 0])
holder(numHolders, specWidth, holdersLoc);

/*
translate([-holderR-2, -baseH/2, 0])
    cube([baseW, baseH, baseD]);
xholderXPos = [ 0, (holderW+5), (holderW+5)*2 ];
holderXPos = [ 0 ];
for (a = holderXPos)
    translate([a, 0, 0])
        holder();
*/