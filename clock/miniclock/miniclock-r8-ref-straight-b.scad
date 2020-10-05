$fn = 10;

// miniclock r8/b
// straight reflector segments (vs. drafted (ie. larger at face than pixel))
// topButtons adds a cutout for top buttons
// adjust depth with "reflectorDepth" - larger than 7
// flooredCenters set to 0 has the centers of digits without a floor
//   -- for future pixels in centers
// cubeHeight adds a rim (in mm) above the pcb level
//   -- if using cubeHeight, turn off topButtons and use a board
//      with vertical headers

topButtons = 0;
reflectorDepth = 12;         // 6 shows pixels
flooredCenters = 1;
cubeHeight = 15;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

//boardW = 146;
//boardH = 63.7;     // was 63.45 - tight

skootchRightTwo = -0.75;                // push right two digits over a little

// Eagle dimensions of v.3 board
//  + slop to fit
eagleBoardW = 144.78;
eagleBoardH = 56.45;        // previous was 63.74;
eagleBoardX = 0;       // offset into board hole (1/2 of fudge value)
eagleBoardY = 0;
boardW = eagleBoardW + (eagleBoardX*2);
boardH = eagleBoardH + (eagleBoardY*2);
boardD = 1.8 + skinBreak;

boardX = 0;
boardY = 0;

wallW = 5;  // 1.5;     // margin
wallH = 5;  // 1.5;

boardGap = .5;

boardFrameW = 3;
boardFrameX = -8;
boardFrameY = -2;


refOffZ = reflectorDepth / 2;   // offset x for reflector segement chunks

strokeWidth = 0.3;


segMul = 1.27;

adgOffX = 8;
adgOffY = 3;
aOffX = 4;
aOffY = 34;
dOffY = 0;
gOffY = 17;
adgSeg = [ [-7.5,-1], [-7.5,1], [-4.5,4], [4.5,4], [7.5,1], [7.5,-1], [4.5,-4], [-4.5,-4] ];

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
    if (scaled) {
        scale([.97, .98, 1])
            linear_extrude(height = reflectorDepth+1, center=true, scale=.85)
                polygon(path);
    }
    else {
        scale([.95, .95, 1])
            linear_extrude(height = reflectorDepth+1, center=true)
                polygon(path);
    }
}

ssZ = -2;               // offsets segment to adjust segment division width
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
}


module voids() {
    // voids
svPD = [  [18, 5, 14], [12, 5, 10], [12, 5, 10],
          [18, 5, 10], [12, 5, 10], [12, 5, 10],
          [18, wallH+1, 10],
    [134, 9, 10],
    [147, 6, 12], 
];
svPL = [ [63.5, 51, -7], [27, 51, -7], [105, 51, -7],
         [63.5, 0, -7], [27, 0, -7], [105, 0, -7],
         [12.5, 57.4, -5 ],
    [6, -56, -7], 
    [-.5, -8, -7], 
];
svPNum = 5;

for (i=[0:1:svPNum])
    translate(svPL[i])
       cube(svPD[i]);

// centers
    centZ = -reflectorDepth+(1*flooredCenters);
    centD = [ 10, 10, 14 ];
    centL = [ [11.75, 12.5, centZ], [11.75, 34.25, centZ],
              [46, 12.5, centZ], [46, 34.25, centZ],
              [88.75-skootchRightTwo, 12.5, centZ], [88.75-skootchRightTwo, 34.25, centZ],
              [123-skootchRightTwo, 12.5, centZ], [123-skootchRightTwo, 34.25, centZ],
    ];
    centNum = 7;

    for (i=[0:1:centNum])
        translate(centL[i])
            cube(centD);
    
    if (topButtons) {
        translate([12.5, 57.4, -5 ])
    #        cube([18, wallH+1, 10]);
        translate([7.8, 57.4, 0])
            rotate([0,45,0])
    #           cube([7, wallH+1, 7]);
        translate([25.5, 57.4, 0])
            rotate([0,45,0])
    #           cube([7, wallH+1, 7]);
    }
}

module mounting_holes() {
    // rotated here. direction isn't obvious
holeX1 = eagleBoardX + 2.7;
holeX1a = eagleBoardX + 2.7;
holeXBR = eagleBoardX + 142.22 + .5;
holeXTR = eagleBoardX + 142.22;
holeYBL = eagleBoardY + 2.8;
holeYBR = eagleBoardY + 2.8 + .85;
holeYTL = eagleBoardY + 53.8 + .85;   // 1.2;
holeYTR = eagleBoardY + 53.8 + .85;
holeZ = 0;
holeR = 2.4/2;      // 2.6 is too big
holeD = 10;
    // mounting holes
    translate([holeX1, holeYBL, holeZ])             // btm lt
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeX1a, holeYTL, holeZ])              // top lt
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeXBR, holeYBR, holeZ])          // btm rt
        cylinder(r=holeR, h=holeD, center=true);
    translate([holeXTR, holeYTR, holeZ])              // top rt
  #      cylinder(r=holeR, h=holeD, center=true);

}

reflectorDim = [ boardW + (wallW + boardGap)*2 , boardH + (wallH + boardGap)*2, reflectorDepth ];

module miniclock_reflector() {
    difference() {
        // base to carve everything out of
        translate([-wallW-boardGap, -wallH-boardGap, -reflectorDepth])
            cube(reflectorDim);
        
        translate([boardW+boardGap, boardH+boardGap, 0])
            rotate([0, 0, 180])
        union() {
            // pcb
           translate([0, 0, -boardD+skinBreak])
                cube([boardW+boardGap*2, boardH+boardGap*2, boardD]);
            
            // header pins
            translate([boardX, boardY, 0])
                voids();
    
            mounting_holes();
            
            // seven segments (* 4) + colon
            translate([boardX - 1.5, boardY + 3, 0]) {
                scale([segMul, segMul, 1])
                    union() {
            
                    translate([1, 0, -refOffZ]) {
                        translate([1.5, 0, 0])
         #                   sevenSeg();
                        translate([28.5, 0, 0])
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

}



sectL = [ -5, -5, -3 ];
sectD = [boardW+boardFrameW*2+10, boardH+boardFrameW*2+6+10, 3];

takeSlice = 0;

if (takeSlice) {
    intersection() {
        miniclock_reflector();
        translate(sectL)
            cube(sectD);
   }
}
else {
   miniclock_reflector();
    if (cubeHeight) {
        difference() {
            // top walls to carve the board out of
            translate([-wallW-boardGap, -wallH-boardGap, 0])
                cube([ boardW + (wallW + boardGap)*2 , boardH + (wallH + boardGap)*2, cubeHeight ]);

 //               cube(reflectorDim);
                        // pcb
           translate([0, 0, -skinBreak])
                cube([boardW+boardGap*2, boardH+boardGap*2, cubeHeight+2*skinBreak]);
        }
    }
}