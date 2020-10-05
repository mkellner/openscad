$fn = 10;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

//boardW = 146;
//boardH = 63.7;     // was 63.45 - tight

skootchRightTwo = 0.25;                

// Eagle dimensions of v.3 board
//  + slop to fit
eagleBoardW = 144.78;
eagleBoardH = 63.74;
eagleBoardX = .5;       // offset into board hole (1/2 of fudge value)
eagleBoardY = .5;
boardW = eagleBoardW + (eagleBoardX*2);
boardH = eagleBoardH + (eagleBoardY*2);
boardD = 1.8 + skinBreak;

boardX = 0;
boardY = 4;

boardFrameW = 3;
boardFrameX = 0;
boardFrameY = -2;

reflectorWidth = boardW;
reflectorHeight = boardH + boardFrameW*2 -1;
reflectorDepth = 10;
refOffZ = reflectorDepth / 2;

strokeWidth = 0.3;

echo("Reflector[", reflectorWidth, reflectorHeight, reflectorDepth, "]");

segMul = 1.27;

adgOffX = 8;
adgOffY = 3;
aOffX = 4;
aOffY = 34;
dOffY = 0;
gOffY = 17;
adgSeg = [ [-8,-1], [-8,1], [-5,4], [5,4], [8,1], [8,-1], [5,-4], [-5,-4] ];

bcOffX = 21;
bcOffY = 8.5;
bOffY = 20;
cOffY = 3;
bcSeg = [ [-4,-4.5], [-4,4.5], [-1,7.5], [-1,8.5], [1.5,8.5], [3.5,6.5], [3.5,-6.5], [1.5,-8.5], [-1,-8.5], [-1,-7.5] ];

efOffX = 3;
efOffY = 8.5;
eOffY = 3;
fOffY = 20;
efSeg = [ [1,-8.5], [-1.5,-8.5], [-3.5,-6.5],  [-3.5,6.5],  [-1.5,8.5],  [1,8.5],  [1,7.5],  [4,4.5],  [4,-4.5],  [1,-7.5] ];

colonCenterX = 3;
colonCenterY = 3;
colonSeg = [ [-3.5,-2.5], [-3.5,2.5],  [-2.5,3.5],  [2.5,3.5],  [3.5,2.5],  [3.5,-2.5],  [2.5,-3.5],  [-2.5,-3.5] ];

module segment(path) {
    scale([.97, .98, 1])
    linear_extrude(height = reflectorDepth+1, center=true, scale=.85)
        polygon(path);
}

ssZ = -2;
module sevenSeg() {
    
    translate([adgOffX + aOffX, adgOffY + aOffY, ssZ])
        segment(adgSeg);
    translate([adgOffX + aOffX, adgOffY + dOffY, ssZ])
        segment(adgSeg);
    translate([adgOffX + aOffX, adgOffY + gOffY, ssZ])
        segment(adgSeg);

    translate([bcOffX, bcOffY + bOffY, ssZ])
        segment(bcSeg);
    translate([bcOffX, bcOffY + cOffY, ssZ])
        segment(bcSeg);
    translate([efOffX, efOffY + eOffY, ssZ])
        segment(efSeg);
    translate([efOffX, efOffY + fOffY, ssZ])
        segment(efSeg);
}

module colons() {
    translate([colonCenterX, colonCenterY + 10, 0])
        segment(colonSeg);
    translate([colonCenterX, colonCenterY + 24, 0])
        segment(colonSeg);
}

module board(depth = boardD) {
    cube([boardW, boardH, depth]);
}

headerHeight = 6.5;
headerYOffset = 1;
headerAOffset = 7;
headerAWidth = 53;
headerBOffset = 77;
headerBWidth = 28.5;
headerDepth = 10;
headerBackDepth = 4;

module pinClearance() {
    // expansion header
*        translate([headerAOffset, boardH-headerHeight, -boardD])
            cube([headerAWidth, headerHeight, headerDepth]);
    // prog header
*        translate([headerBOffset, boardH-headerHeight, -boardD])
            cube([headerBWidth, headerHeight, headerDepth]);

switchAOffset = -.3;
switchBOffset = 138.6;
switchYOffset = 5.7;
switchWidth = 7.3;
switchHeight = 9.5;
switchPinDepth = boardD + headerBackDepth;
    // reset and boot switches
        translate([switchAOffset, boardH-switchHeight-switchYOffset, switchPinDepth-boardD - headerBackDepth])
            cube([switchWidth, switchHeight, switchPinDepth]);
        translate([switchBOffset, boardH-switchHeight-switchYOffset, switchPinDepth-boardD - headerBackDepth])
            cube([switchWidth, switchHeight, switchPinDepth]);

powerD = [ 13, 13, 15 ];
powerL = [ 104, boardH-14, -8];
powerL2 = [ 27, boardH-14, -8];
    // power jack pins
 #   translate(powerL) cube (powerD);
 #   translate(powerL2) cube (powerD);

neopixelOutD = [ 12, 7, 5 ];
neopixelOutL = [ 127, boardH-7-2.5, -2];
neopixelInD = [ 11, 7, 5 ];
neopixelInL = [ 8, boardH-7-2.5, -2];
    // neopixel out pins
*   translate(neopixelOutL) cube(neopixelOutD);
*    translate(neopixelInL) cube(neopixelInD);

holeX1 = eagleBoardX + 2.54 - .3;
holeX2 = eagleBoardX + eagleBoardW - 2.54 - .3;
holeY1 = eagleBoardY + 2.54 + .5;
holeY2 = eagleBoardY + eagleBoardH - 2.54 - .75;
holeZ = 0;
holeR = 2.6/2;
holeD = 10;
    // mounting holes
    translate([holeX1, holeY1, holeZ])
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeX1, holeY2, holeZ])
        #cylinder(r=holeR, h=holeD, center=true);
    translate([holeX2+.3, holeY1, holeZ])
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeX2, holeY2, holeZ])
        cylinder(r=holeR, h=holeD, center=true);

    // voids
svPD = [ [134, 9, 10], [147, 6, 12], [18, 12, 14],
          [15, 5, 10], [12, 5, 10], [12, 5, 10],
];
svPL = [ [6, 56, -7], [-.5, -8, -7], [63.5, 51, -7],
         [65, 0, -7], [27, 0, -7], [105, 0, -7],
];
svPNum = 5;

for (i=[0:1:svPNum])
    translate(svPL[i])
       cube(svPD[i]);

centZ = -9;
centD = [ 10, 10, 14 ];
centL = [ [11.25, 12.5, centZ], [11.25, 34.25, centZ],
          [45.5, 12.5, centZ], [45.5, 34.25, centZ],
          [88.75-skootchRightTwo, 12.5, centZ], [88.75-skootchRightTwo, 34.25, centZ],
          [123-skootchRightTwo, 12.5, centZ], [123-skootchRightTwo, 34.25, centZ],
];
centNum = 7;

for (i=[0:1:centNum])
    translate(centL[i])
        cube(centD);

}


module miniclock_reflector() {
    difference() {
        // base to carve everything out of
        translate([boardFrameX-boardFrameW, boardFrameY-boardFrameW, -reflectorDepth])
            cube([boardW+boardFrameW*2, boardH+boardFrameW*2+6, reflectorDepth]);
    echo("Total[", boardW+boardFrameW*2, boardH+boardFrameW*2+6, reflectorDepth, "]");
    
        translate([boardFrameX + boardW, boardFrameY + boardH + boardFrameW, 0])
            rotate([0, 0, 180])
        union() {
            // pcb
           translate([boardX-.25, boardY-.25, -boardD+skinBreak])
                cube([boardW+.5, boardH+.5, boardD]);
            
            // header pins
            translate([boardX, boardY, -headerBackDepth])
                pinClearance();
    
            // seven segments (* 4) + colon
            // was [boardX -1, boardY + 2, 0]
            translate([boardX - 1.5, boardY + 3, 0]) {
                scale([segMul, segMul, 1])
                    union() {
            
                    translate([1, 0, -refOffZ]) {
                        translate([1, 0, 0])
                            sevenSeg();
                        translate([28, 0, 0])
                            sevenSeg();
                        
                        translate([54-skootchRightTwo/2, 0, 0])
                            colons();
                        translate([62-skootchRightTwo, 0, 0])
                            sevenSeg();
                        translate([89-skootchRightTwo, 0, 0])
                            sevenSeg();
                    }
                }
            }
        }
    }
    attachL = [boardW/2-3, -4, -reflectorDepth];
    attachL2 = [boardW/3-3, 62, -reflectorDepth];
    attachL3 = [2*boardW/3-3, 62, -reflectorDepth];
    attachD = [ 3, 16, reflectorDepth-2 ];
    attachD2 = [ 3, 9, reflectorDepth ];
    translate(attachL)
    cube(attachD);
    translate(attachL2)
    cube(attachD2);
    translate(attachL3)
    cube(attachD2);
}

sectL = [ -5, -5, -5 ];
sectD = [boardW+boardFrameW*2+10, boardH+boardFrameW*2+6+10, 2];

takeSlice = 0;

if (takeSlice) {
    intersection() {
        miniclock_reflector();
        translate(sectL)
            cube(sectD);
   }
}
else {
if (!LIBRARY)
    miniclock_reflector();
}