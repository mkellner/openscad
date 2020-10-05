$fn = 10;

skinBreak = .005;

// from eagle:
// boardW =
// boardH =
// holeR =
// holeX1 = 2.794
// holeX2 = 10.16
// holeX3 = 45.72
// holeX4 = 53.53

screwHoleR = 1.2;   // 1.15 was a bit tight

boardW = 56.5;
boardH = 31;
boardD = 6;     // 1.6 board depth + gap for power and header solder

holeR = 4/2;    // 3.75/2;

// header
hGap = .6;      // .5 was snug

hGap2 = hGap/2;
hLocX = 15-hGap2;
hLocY = 13-hGap2;
hW = 26+hGap;
hH = 5+hGap;
hD = 11.5;
headerLoc = [ hLocX, hLocY, boardD ];

xBoardW = .5;   // extra board width
xBoardH = 0;

module pcb() {
    translate([-xBoardW/2, -xBoardH/2, 0])
    cube([boardW + xBoardW, boardH + xBoardH, boardD+skinBreak]);
    translate([ hLocX, hLocY, boardD ])
        cube([ hW, hH, hD+skinBreak*2 ]);
}

holeX1 = 2.794;
holeX2 = 10.16;
holeX3 = 45.72;
holeX4 = 53.53;

holezL = [ 
    [-4, hLocY + hH/2, -skinBreak+hD/2],
    [ 4+ boardW, hLocY + hH/2, -skinBreak+hD/2],
    [holeX1, hLocY + hH/2, -skinBreak+hD/2],
    [holeX2, hLocY + hH/2, -skinBreak+hD/2],
    [holeX3, hLocY + hH/2, -skinBreak+hD/2],
    [holeX4, hLocY + hH/2, -skinBreak+hD/2],
];
holezR = [
    holeR, holeR,
    screwHoleR, screwHoleR, screwHoleR, screwHoleR,
];
holezNum = 5;

module holes() {
    for (i=[0:1:holezNum])
        translate(holezL[i])
  #          cylinder(r=holezR[i], h=hD+skinBreak*2, center=true);
}

mountX = -8;
mountY = -3;
mountZ = 0;
mountW = boardW + 16;
mountH = boardH + 6;
mountD = boardD + hD;

module mount() {
    translate([mountX, mountY, mountZ])
        cube([mountW, mountH, mountD]);
}

    // voids
svPD = [  [mountW - 16 +xBoardW, 15, mountD+skinBreak], // top center
        [mountW - 16 +xBoardW, 15, mountD+skinBreak],   // bottom center
        [13, mountH, mountD+skinBreak],        // left
        [15, mountH, mountD+skinBreak],        // right
        [3, mountH, 3],     // gap
];
svPL = [ [mountX + 8 -xBoardW/2, -4, -skinBreak], 
        [mountX + 8 -xBoardW/2, 20, -skinBreak], 
        [mountX, mountY, 10-skinBreak], 
        [mountW - 23, mountY, 10-skinBreak], 
        [(holeX2-holeX1)/2+holeX1-1.5, mountY, -skinBreak], 
];
svPNum = 3;

module cutaway() {
if (1) {
    for (i=[0:1:svPNum])
        translate(svPL[i])
           cube(svPD[i]);
    gapR = 1.8;
    translate([(holeX2-holeX1)/2+holeX1, mountH/2+mountY, boardD])
        rotate([90, 0, 0])
            cylinder(r=gapR,h=mountH, center=true);
}
else {
    translate([ hLocX-2, hLocY-2, boardD ])
  #      cube([ hW+4, hH+4, hD+skinBreak*2 ]);
}
}

module clipBottom() {
    translate([-20, -20, 17 ])
    cube([100,100,20]);
}

module lastAdds() {
    translate([holeX2, hLocY + hH/2, hD+6])
            cylinder(r=screwHoleR-.1, h=2, center=true);
    translate([holeX3, hLocY + hH/2, hD+6])
            cylinder(r=screwHoleR-.1, h=2, center=true);
}

 difference() {
    mount();
    union() {
        translate([0,0,-skinBreak])
        pcb();
        holes();
        cutaway();
        clipBottom();
    }
}
lastAdds();