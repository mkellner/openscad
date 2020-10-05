

skinBreak = .02;

gDepth = 10;

dsg = .4;

lInnerR = 14;
lOuterR = 20.5;
lCircleX = 22;
lCircleY = 62.8;
rInnerR = 14;
rOuterR = 20.5;
rCircleX = 58;
rCircleY = 62.8;

module line(x1, y1, x2, y2, d=gDepth, th=dsg) {
    linear_extrude(height=d) {
        // left
        hull() {
          translate([x1, y1]) circle(th);
          translate([x2, y2]) circle(th);
        }
    }
}

module ring(rad, wid=dsg) {
    difference() {
        cylinder(r=rad+wid, h=gDepth);
        translate([0, 0, -skinBreak/2])
            cylinder(r=rad-wid, h=gDepth+skinBreak);
    }
}

gapCubeW = 7.0;
gapCubeH = 17;
gapCubeD = gDepth;
gapCubeX = -gapCubeW/2;
gapCubeY = -9.4;
gapCubeZ = 0;

module ringCenter(offsetX, offsetY) {    
    translate([offsetX + gapCubeX, offsetY + gapCubeY, gapCubeZ-skinBreak/2])
        cube([gapCubeW, gapCubeH, gapCubeD+skinBreak]);
}

module ringDividers(r1, r2) {
    for (a = [15:30:345])
#        rotate([0, 0, a])
            line(0, r1, 0, r2-.5);
}

module centerCross(rad, wid=dsg) {
    for (a = [45,135,225,315])
        rotate([0, 0, a])
            line(0, 0, 0, rad);
}

dx = .5;

lineArray = [
    [ -dx+3.7, 54.5, 40, 0.25 ],
    [ 40, 0.25, dx+76.5, 54.5 ],
    [ -dx+20.32, 42.5, 45.72, 8.89 ],
    [ 29.51, 43.9, 51.5, 17.98 ],
    [ 59.69, 29.21, 36., 47.76 ],
    [ -dx+60.96, 42.18, 34.29, 8.89 ],
    [ dx+27.94, 17.78, 50.67, 43.94 ],
    [ dx+20.32, 29.21, 44., 48. ],
    [ 40, 71.5, 40, 68 ],
    [ 40, 54, 40, 58 ]
];

module hartLinez(d=gDepth) {
    for (a = lineArray) {
        line(a[0], a[1], a[2], a[3], d);
    }
}


module framePos1() {
    // rings
    translate([lCircleX, lCircleY, 0]) {
        ring(lInnerR);
        ring(lOuterR);
    }
    translate([rCircleX, rCircleY, 0]) {
        ring(rInnerR);
        ring(rOuterR);
    }
}

module frameNeg1() {
    heartCenterX = 40;
    heartCenterY = 63.75;
    ringCenter(heartCenterX, heartCenterY);
}

module framePos2() {
    // subdividers
    translate([lCircleX, lCircleY, 0]) {
        centerCross(lInnerR);
        ringDividers(lInnerR, lOuterR);
    }
    
    translate([rCircleX, rCircleY, 0]) {
        centerCross(rInnerR);
        ringDividers(rInnerR, rOuterR);
    }
    hartLinez();
}


difference() {
    framePos1();
    frameNeg1();
}
framePos2();