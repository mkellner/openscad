$fn = 10;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

//boardW = 146;
//boardH = 63.7;     // was 63.45 - tight

// Eagle dimensions of v.3 board
//  + slop to fit
eagleBoardW = 144.78;
eagleBoardH = 62.74;
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
reflectorHeight = boardH + boardFrameW*2;
reflectorDepth = 10;
refOffZ = reflectorDepth / 2;

strokeWidth = 0.3;



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

module sevenSeg() {
    
    translate([adgOffX + aOffX, adgOffY + aOffY, 0])
        segment(adgSeg);
    translate([adgOffX + aOffX, adgOffY + dOffY, 0])
        segment(adgSeg);
    translate([adgOffX + aOffX, adgOffY + gOffY, 0])
        segment(adgSeg);

    translate([bcOffX, bcOffY + bOffY, 0])
        segment(bcSeg);
    translate([bcOffX, bcOffY + cOffY, 0])
        segment(bcSeg);
    translate([efOffX, efOffY + eOffY, 0])
        segment(efSeg);
    translate([efOffX, efOffY + fOffY, 0])
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
        translate([headerAOffset, boardH-headerHeight, -boardD])
            cube([headerAWidth, headerHeight, headerDepth]);
    // prog header
        translate([headerBOffset, boardH-headerHeight, -boardD])
            cube([headerBWidth, headerHeight, headerDepth]);

switchAOffset = 0;
switchBOffset = 138;
switchYOffset = 5.7;
switchWidth = 7.3;
switchHeight = 10;
switchPinDepth = boardD + headerBackDepth;
    // reset and boot switches
        translate([switchAOffset, boardH-switchHeight-switchYOffset, switchPinDepth-boardD - headerBackDepth])
            cube([switchWidth, switchHeight, switchPinDepth]);
        #translate([switchBOffset, boardH-switchHeight-switchYOffset, switchPinDepth-boardD - headerBackDepth])
            cube([switchWidth, switchHeight, switchPinDepth]);

powerW = 12;
powerH = 13;
powerD = 7;
powerX = 107;
powerY = 0;
powerZ = -2;
    // power jack pins
    translate([powerX, boardH-powerH+powerY, powerZ])
        cube([powerW, powerH, powerD]);

npW = 11;
npH = 4;
npD = 5;
npX = 125;
npY = -1;
npZ = -1;
    // neopixel out pins
    translate([npX, boardH-npH+npY, npZ])
        cube([npW, npH, npD]);

holeX1 = eagleBoardX + 2.54;
holeX2 = eagleBoardX + eagleBoardW - 2.54;
holeY1 = eagleBoardY + 2.54;
holeY2 = eagleBoardY + eagleBoardH - 2.54;
holeZ = 0;
holeR = 2.9/2;
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


module miniclock_reflector() {
difference() {
    // base to carve everything out of
    translate([boardFrameX-boardFrameW, boardFrameY-boardFrameW, -reflectorDepth])
        cube([boardW+boardFrameW*2, reflectorHeight+boardFrameW*2, reflectorDepth]);

    translate([boardFrameX + boardW, boardFrameY + boardH + boardFrameW, 0])
        rotate([0, 0, 180])
    union() {
        // pcb
       translate([boardX, boardY, -boardD+skinBreak])
            cube([boardW, boardH, boardD]);
        
        // header pins
        translate([boardX, boardY, -headerBackDepth])
            pinClearance();

        // seven segments (* 4) + colon
        // was [boardX -1, boardY + 2, 0]
        translate([boardX - 1, boardY + 3, 0]) {
            scale([segMul, segMul, 1])
                union() {
        
                translate([1, 0, -refOffZ]) {
                    translate([1, 0, 0])
                        sevenSeg();
                    translate([28, 0, 0])
                        sevenSeg();
                    
                    translate([54, 0, 0])
                        colons();
                    
                    translate([62, 0, 0])
                        sevenSeg();
                    translate([89, 0, 0])
                        sevenSeg();
                }
            }
        }
    }
}
}

if (!LIBRARY)
    miniclock_reflector();