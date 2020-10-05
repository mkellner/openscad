$fn = 10;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

//boardW = 146;
//boardH = 63.7;     // was 63.45 - tight

// Eagle dimensions of v.2 board
//  + slop to fit
eagleBoardW = 84; // (33 * 2.54);      // 83.82;
eagleBoardH = 40;   // (15.55 * 2.54); // 39.37;
eagleBoardD = 2.8; // 1.8;
eagleBoardX = .5;       // offset into board hole (1/2 of fudge value)
eagleBoardY = .5;
eagleBoardZ = 0;
boardW = eagleBoardW + (eagleBoardX*2);
boardH = eagleBoardH + (eagleBoardY*2);
boardD = eagleBoardD + skinBreak;

echo ("boardW: ", boardW);
echo ("boardH: ", boardH);
echo ("boardD: ", boardD);

boardFrameW = 3;
boardFrameX = 0;
boardFrameY = 0;

reflectorWidth = boardW;
reflectorHeight = boardH + boardFrameW;
reflectorDepth = 10;

refOffZ = reflectorDepth / 2;

strokeWidth = 0.3;



segMul = 1.27;


headerHeight = 2.7;
headerYOffset = 34.8;
headerAOffset = 6;
headerAWidth = 20;
headerY1Offset = 35;
headerBOffset = 55;
headerBWidth = 20;
headerY2Offset =  2.5;
headerCOffset = 50;
headerCWidth = 20;
headerY3Offset = 11.5;
headerDOffset = 1.5;
headerDHeight = 16;
headerDepth = 10;
headerBackDepth = 4;

module xpinClearance() {
    // pixel I/O header
        translate([headerAOffset, headerYOffset, -headerBackDepth])
            cube([headerAWidth, headerHeight, headerDepth]);
    // I2C header
        translate([headerBOffset, headerY1Offset, -headerBackDepth])
            cube([headerBWidth, headerHeight, headerDepth]);
    // prog header
        translate([headerCOffset, headerY2Offset, -headerBackDepth])
            cube([headerCWidth, headerHeight, headerDepth]);
    // pwr/spk header
        translate([headerDOffset, headerY3Offset, -headerBackDepth])
            cube([headerHeight, headerDHeight, headerDepth]);
}

cutoutZ = -9;
cutoutDepth = 10;

cutoutL = [ [6, 35.2, cutoutZ], [43, 35.2, cutoutZ], 
    [6, 0, cutoutZ], [30.5, 0, cutoutZ], [47, 0, cutoutZ], 
    [-.5,6.5,cutoutZ],
    [79.5, 6.5, cutoutZ], [ 79.5, 20.5, cutoutZ], 
    ];
cutoutD = [ [35, 5, cutoutDepth], [35, 5, cutoutDepth], 
    [23, 4.75, cutoutDepth], [15, 4.75, cutoutDepth], [31, 4.75, cutoutDepth],
    [4,27,cutoutDepth],
    [4,13,cutoutDepth], [4,13.5,cutoutDepth],
     ];
cutoutNum = 7;

centerL = [ [10.67,12,cutoutZ], [10.67,23.25,cutoutZ],
            [28.5,12,cutoutZ], [28.5,23.25,cutoutZ],
            [49.75,12,cutoutZ], [49.75,23.25,cutoutZ],
            [68,12,cutoutZ], [68,23.25,cutoutZ],
];
centerD = [5,5,cutoutDepth];

centerNum = 7;

module pinClearance() {
    for (i=[0:1:cutoutNum])
        translate(cutoutL[i])
            cube(cutoutD[i]);
    for (i=[0:1:centerNum])
        translate(centerL[i])
            cube(centerD);
}


segMul = .254 * 2.54;

adgOffX = 8;
adgOffY = 2;
aOffX = 3.75;
aOffY = 33.25;
dOffY = -1.5;
gOffY = 15.8;
adgSeg = [ [-8.75,-1.5], [-8.75,1.5], [-5.75,5], [5.75,5],
           [8.75,1.5], [8.75,-1.5], [5.75,-4.5], [-5.75,-4.5] ];

bcOffX = 20.5;
bcOffY = 7.5;
bOffY = 19;
cOffY = 1.5;
bcSeg = [ [-4,-6], [-4,6.5], [-.5,10.75], [2,10.75],
          [4,8.5], [4,-8.5], [2.5,-10.75], [-.5,-10.75] ];

efOffX = 3;
efOffY = 7.5;
eOffY = 1.5;
fOffY = 19;
efSeg = [ [.5,-10.5], [-2,-10.5], [-4,-8.5], [-4,8.5],
          [-2,11],  [.5,11],  [4,6.5],  [4,-6.5] ];

colonCenterX = 3;
colonCenterY = 3;
colonOffY = 9.25;
colonOffY2 = 21;
colonSeg = [ [-3.75,-2.75], [-3.75,2.75],  [-2.75,3.75],  [2.75,3.75],
             [3.75,2.75],  [3.75,-2.75],  [2.75,-3.75],  [-2.75,-3.75] ];

segScale = .72;
module segment(path) {
    scale([segScale, segScale, 1])
    linear_extrude(height = reflectorDepth+1, center=true, scale=1)
        polygon(path);
}


segOffZ = -2.5;
module sevenSeg() {
    
    translate([adgOffX + aOffX, adgOffY + aOffY, segOffZ])
        segment(adgSeg);
    translate([adgOffX + aOffX, adgOffY + dOffY, segOffZ])
        segment(adgSeg);
    translate([adgOffX + aOffX, adgOffY + gOffY, segOffZ])
        segment(adgSeg);

    translate([bcOffX, bcOffY + bOffY, segOffZ])
        segment(bcSeg);
    translate([bcOffX, bcOffY + cOffY, segOffZ])
        segment(bcSeg);
    translate([efOffX, efOffY + eOffY, segOffZ])
        segment(efSeg);
    translate([efOffX, efOffY + fOffY, segOffZ])
        segment(efSeg);
}

module colons() {
    translate([colonCenterX, colonCenterY + colonOffY, segOffZ])
        segment(colonSeg);
    translate([colonCenterX, colonCenterY + colonOffY2, segOffZ])
        segment(colonSeg);
}

pixelArray = [ [3,5], [3,6.5], [3,9.5], [3,11],
    [4.5,3.5], [4.5,8], [4.5,12.5], 
    [6,3.5], [6,8], [6,12.5],
    [7.5,5], [7.5,6.5], [7.5,9.5], [7.5,11],
    [10,5], [10,6.5], [10,9.5], [10,11],
    [11.5,3.5], [11.5,8], [11.5,12.5], 
    [13,3.5], [13,8], [13,12.5],
    [14.5,5], [14.5,6.5], [14.5,9.5], [14.5,11],
    [16.5,6.5], [16.5,9.5],
    [18.5,5], [18.5,6.5], [18.5,9.5], [18.5,11],
    [20,3.5], [20,8], [20,12.5],
    [21.5,3.5], [21.5,8], [21.5,12.5],
    [23,5], [23,6.5], [23,9.5], [23,11],
    [25.5,5], [25.5,6.5], [25.5,9.5], [25.5,11],
    [27,3.5], [27,8], [27,12.5],
    [28.5,3.5], [28.5,8], [28.5,12.5],
    [30,5], [30,6.5], [30,9.5], [30,11],
 ];

pixelW = 2.5;
pixelH = 2.5;

module pixels() {
        for (i=pixelArray) {
 //           echo(2.54*i[0], 2.54*i[1]);
            translate([2.54*i[0]-pixelW/2, 2.54*i[1]-pixelH/2, -1])
                #cube([pixelW,pixelH,1]);
        }
}

module miniMountingHoles() {
holeX1 = .93 * 2.54;
holeX2 = 32.05 * 2.54;
holeY1 = .95 * 2.54;
holeY2 = 14.6 * 2.54;
holeZ = 0;
holeR = 2.5/2;
holeD = 10;
    // mounting holes
    translate([holeX1, holeY1, holeZ])
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeX1, holeY2, holeZ])
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeX2, holeY1, holeZ])
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeX2, holeY2, holeZ])
        cylinder(r=holeR, h=holeD, center=true);

}

boardOffsetX = 1;
boardOffsetY = 1;
module miniboard() {
   translate([0, .5, 0])    // to fix sloppiness in board area
        cube([boardW-.8, boardH-.5, boardD]);
   translate([boardOffsetX, boardOffsetY, 0]) {
*        pixels();
        miniMountingHoles();
        pinClearance();
    }
}

module segments() {
    refX = 5.5+eagleBoardX;
    refY = 9.5+eagleBoardY;
        translate([refX, refY, 0]) {
            scale([segMul, segMul, 1])
                union() {
        
                translate([1, 0, -refOffZ]) {
          if (0) {
                    translate([1, 0, 0])
                        sevenSeg();
                    translate([28.5, 0, 0])
                        sevenSeg();
                    
                    translate([54, 0, 0])
                        colons();
                    
                    translate([62, 0, 0])
                        sevenSeg();
                    translate([89.5, 0, 0])
                        sevenSeg();
            }
            else {
                    translate([.7, 0, 0])
                        sevenSeg();
                    translate([28.2, 0, 0])
                        sevenSeg();
                    
                    translate([53.25, 0, 0])
                        colons();
                    
                    translate([61.25, 0, 0])
                        sevenSeg();
                    translate([89.5, 0, 0])
                        sevenSeg();
            }
                }
            }
        }

}

module microclock_reflector() {

    difference() {
        union() {
            // base to carve everything out of
            translate([boardFrameX-boardFrameW/4, boardFrameY-boardFrameW/4, -reflectorDepth])
                cube([boardW+boardFrameW-1, boardH+boardFrameW, reflectorDepth]);
echo("total w:", boardW+boardFrameW-1, " h:", boardH+boardFrameW, " d:", reflectorDepth );
        }
        union() {
            translate([eagleBoardX, eagleBoardY, -boardD+skinBreak*2])
                miniboard();
            segments();
        }
    }
}


sectL = [ -5, -5, -5 ];
sectD = [boardW+boardFrameW*2+10, boardH+boardFrameW*2+6+10, 2];

takeSlice = 0;

if (takeSlice) {
    intersection() {
        microclock_reflector();
        translate(sectL)
            cube(sectD);
   }
}
else {
        microclock_reflector();
}