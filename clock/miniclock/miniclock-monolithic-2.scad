$fn = 35;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

clipit = 0;    // Trim extra
scaled = 0;

buttonTabs = 0;         // press locations on top to match onboard buttons
trySupports = 0;

font = "Arial Rounded MT Bold:style=Regular";

doCenters = 1;      // 1 hearts, 2 stars
// for centerKind == 4 -- * == star, % == heart
// to support centers, use - for things like O, = for doubles like B
//centerText  = "SCtaalym";
centerText  = "SCTAALYM";
textSupport = "   --   ";
// centerText = "%MODDABLE%";
// textSupport = "  |||-|   ";

halfBarriers = 1;   // put a partial light barrier mid-segment

innerCubeZ = 100;
channelDepth = 2;
deep = 12 + channelDepth;  // 12

skootchRightTwo = 0.25;                // push right two digits over a little

// Eagle dimensions of v.3 board
//  + slop to fit
eagleBoardW = .5 + 144.78;
eagleBoardH = .5 + 56.45;        // previous was 63.74;
eagleBoardD = 1.8;
boardW = eagleBoardW;
boardH = eagleBoardH;
boardD = 1.8 + skinBreak;

boardX = 0;
boardY = 0;

frameW = 1.5;
frameH = 1.5;

wallW = 1.5;     // margin
wallH = 1.5;  // 1.5;

boardGap = .5;

boardFrameW = 3;
boardFrameX = -8;
boardFrameY = -2;

reflectorDepth = eagleBoardD + deep;         // 6 shows pixels


refOffZ = reflectorDepth / 2;   // offsetx for reflector segement chunks

digitDepth = reflectorDepth + 1;
barrierZ = digitDepth - 2.8;
barrierDepth = digitDepth-eagleBoardD;

dsg = 0.4; // 0.5; // digitSegmentGap
xdsg = 0.1;

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
            linear_extrude(height = reflectorDepth+5, center=true, scale=.85)
                polygon(path);
    }
    else {
        scale([.95, .95, 1])
            linear_extrude(height = reflectorDepth+5, center=true)
                polygon(path);
    }
}


ssZ = -1;               // offsets segment to adjust segment division width
module digitPos(x) {
#    translate([adgOffX + aOffX, adgOffY + aOffY, ssZ])
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

module line(x1, y1, x2, y2, d=digitDepth, dim=dsg) {
    linear_extrude(height=d) {
        // left
        hull() {
          translate([x1, y1]) square([dim, dim]); // circle(dsg);
          translate([x2, y2]) square([dim, dim]);
        }
    }
}

sepWid = .5;
module digitNeg(x) {
    translate([sepWid/2, sepWid/2, -channelDepth-6]) {
        line(adgOffX + 3.5, adgOffY + aOffY+3.7, adgOffX+3.5, adgOffY + aOffY - 4.5, reflectorDepth+1, sepWid);
        line(adgOffX + 3.5, adgOffY + dOffY+3.7, adgOffX+3.5, adgOffY + dOffY - 4.5, reflectorDepth+1, sepWid);
        line(adgOffX + 3.5, adgOffY + gOffY+3.7, adgOffX+3.5, adgOffY + gOffY - 4.5, reflectorDepth+1, sepWid);

        line(bcOffX + 3.5, bcOffY + bOffY - .5, bcOffX - 4.5, bcOffY + bOffY - .5, reflectorDepth+1, sepWid);
        line(bcOffX + 3.5, bcOffY + cOffY - .5, bcOffX - 4.5, bcOffY + cOffY - .5, reflectorDepth+1, sepWid);
        
        line(efOffX + 3.8, efOffY + eOffY - .5, efOffX - 3.8, efOffY + eOffY - .5, reflectorDepth+1, sepWid);
        line(efOffX + 3.8, efOffY + fOffY - .5, efOffX - 3.8, efOffY + fOffY - .5, reflectorDepth+1, sepWid);
    }
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

centZ = -6;
centD = [ 10, 10, 15 ];
centL = [ [11.9, 12.5, centZ], [11.9, 34.25, centZ],
          [46.23, 12.5, centZ], [46.23, 34.25, centZ],
          [88.7-skootchRightTwo, 12.5, centZ], [88.7-skootchRightTwo, 34.25, centZ],
          [123-skootchRightTwo, 12.5, centZ], [123-skootchRightTwo, 34.25, centZ],
];
centNum = 7;


module voids() {
    translate([0,0,-channelDepth-5]) {
        voidz = -2;
            // voids
        svPD = [  [18, 5, 14], [12, 5, 10], [12, 5, 11],
                  [18, 5, 10], [12, 5, 10], [12, 5, 10],
                  [18, wallH+1, 10],
            [134, 9, 10],
            [147, 6, 12], 
        ];
        svPL = [ [63.5, 51, voidz], [27, 51, voidz], [105, 51, voidz],
                 [63.5, 0, voidz], [27, 0, voidz], [105, 0, -voidz],
                 [12.5, 57.4, voidz ],
            [6, -56, voidz], 
            [-.5, -8, voidz], 
        ];
        svPNum = 5;
        
        // outside bits
        for (i=[0:1:svPNum])
            translate(svPL[i])
  #             cube(svPD[i]);
        
        // gap for supercap pins
        translate([109.75,24,-2])
            cube([1.5,9,10]);
        translate([33.25,24,-2])
           # cube([1.5,9,10]);
        
        
        for (i=[0:1:centNum])
            translate(centL[i]) {
                cube(centD);
                center(i);
            }
        
        btnCtr1X = 16.3;
        btnCtr2X = 25.3;
        
        /*
        translate([7.8, 57.4, 0])
            rotate([0,45,0])
        #       cube([7, wallH+1, 7]);
        translate([25.5, 57.4, 0])
            rotate([0,45,0])
        #       cube([7, wallH+1, 7]);
        */
        }
}

hartY = 4.8;
hartZ = -5;
hartXOffset = -.5;

starY = 5.4;
starZ = -5;
starXOffset = -.5;

module star(sz = 1, deep=ledOffsetD) {
scale([sz, sz, 1]) {
cX = 69.85 / 2;
cY = 68.58 / 2;

ztar = [
[33.02 -cX,68.32 -cY],
[36.70 -cX,68.32 -cY],
[44.07 -cX,43.56 -cY],
[68.20 -cX,44.83 -cY],
[69.47 -cX,40.00 -cY],
[49.02 -cX,26.80 -cY],
[59.82 -cX,3.30 -cY],
[55.75 -cX,0.00 -cY],
[34.93 -cX,16.38 -cY],
[14.99 -cX,0.00 -cY],
[11.05 -cX,2.67 -cY],
[21.08 -cX,26.67 -cY],
[0.00 -cX,40.89 -cY],
[2.54 -cX,46.23 -cY],
[26.80 -cX,43.94 -cY]];
    
    rotate([180,0,180])
    translate([0, 0, -deep/2])
            linear_extrude(height = deep, center=true)
                polygon(ztar);
}
}

module heart(sz=1, deep=ledOffsetD) {
rotate([0, 0, 180])
scale([sz, sz, 1]) {
    hTopR = 20;
    hY = -20;
    hInset = 1;
    
        translate([-hTopR+hInset, hY, 0])
            cylinder(r=hTopR, h=deep);
        translate([hTopR-hInset, hY, 0])
            cylinder(r=hTopR, h=deep);
            
     triPoly = [[ -hTopR*2+hInset+1.7, hY ], [hTopR*2-hInset-1.7, hY], [0, hY+hTopR*2.7]];
     
     sc = 1;
     cX = 0;
     cY = -8.3;
     
         translate([-cX, -cY, deep/2])
                linear_extrude(height = deep, center=true, scale=sc)
                    polygon(triPoly);
}
}

boardCapD = 3.52;
boardLedD = 2.44;

ledOffsetD = wallW + boardLedD + deep;

letterY = 5.4;
letterZ = 4.2;
letterXOffset = -.5;

supSize = .5;
supVMult = 1.25;

module letter(l, sz=1, deep=ledOffsetD) {
    echo ("letter:", l);
    rotate([0, 180, 0])
	linear_extrude(height = deep) {
		text(l, size = sz, font = font, halign = "center", valign = "center", $fn = 16);
	}
}

centerX = 5;
centerY = 5;
module center(a) {
    translate([centerX, centerY, 0]) {
        letr = centerText[7-a];
         if (letr == "*") {
            translate([0, 0, -letterZ*3])
            star(0.13);
        }
        else if (letr == "%") {
            translate([0, 0, -letterZ*3])
             heart(0.11);
        }
        else {
            letter(letr, 9);
        }
    }
}


letSupX = 4.8;
letSupY = 5;
letSupZ = -7.6 - channelDepth;
supDeep = 3;

module centSupport(a) {
    letr = textSupport[7-a];
    translate([letSupX, letSupY, letSupZ])
    if (letr == "-") {
        line(-5, 0, 5, 0, supDeep, supSize);
    }
    else if (letr == "=") {
        line(-5, 1.7, 5, 1.7, supDeep, supSize);
        line(-5, -1.7, 5, -1.7, supDeep, supSize);
    }
    else if (letr == "|") {
        line(0, -5, 0, 5, supDeep, supSize*supVMult);
    }
}

module centerSupports() {
for (i=[0:1:centNum])
    translate(centL[i]) {
#        centSupport(i);
    }
        
}

tabOuterR = 4.2;
tabInnerR = 3.7;
tabD = 2.5;
tab1X = 15.3;
tab2X = 26.3;

tab1Y = 56.4 + tabD;
tab1Ys = 57.4;
tab1Z = 6;

tabBar = 2;
tabBarD = 2.5;
tabBarHole = 4;
tabBarL = 5;

module tabs_neg() {
    // holes around balls
    translate([tab1X, tab1Y, tab1Z])
        rotate([90, 0, 0])
            cylinder(h=tabD, r=tabOuterR);
    translate([tab2X, tab1Y, tab1Z])
        rotate([90, 0, 0])
            cylinder(h=tabD, r=tabOuterR);
    //bars
    translate([tab1X-tabInnerR+1-tabBarL, tab1Y-tabBarD, tab1Z-tabBarHole/2])
        cube([tabBarL, tabBarD, tabBarHole]);
    translate([tab2X-tabInnerR+1+tabBarL, tab1Y-tabBarD, tab1Z-tabBarHole/2])
        cube([tabBarL, tabBarD, tabBarHole]);
}

module tabs_pos() {
    
    // left ball and bar
    translate([tab1X, tab1Ys, tab1Z])
        sphere(r=tabInnerR);
    
    translate([tab1X-tabInnerR+1-tabBarL, tab1Y-tabBarD, tab1Z-tabBar/2])
        cube([tabBarL, tabBarD-.5, tabBar]);

if (trySupports) {
    // support tabs;
    translate([tab1X-.3, tab1Y-tabD, tab1Z-tabInnerR-1])
        cube([.7, tabD, 1]);
    translate([tab1X+2, tab1Y-tabD, tab1Z-tabInnerR-.2])
        cube([.7, tabD, 1]);
*    translate([tab1X-2.6, tab1Y-tabD, tab1Z-tabInnerR-.2])
 #       cube([.7, tabD, 1]);
}

    // right ball and bar
    translate([tab2X, tab1Ys, tab1Z])
        sphere(r=tabInnerR);

    translate([tab2X-tabInnerR+1+tabBarL, tab1Y-tabBarD, tab1Z-tabBar/2])
        cube([tabBarL, tabBarD-.5, tabBar]);
 
if (trySupports) {
    translate([tab2X-.3, tab1Y-tabD, tab1Z-tabInnerR-1])
        cube([.7, tabD, 1]);
    translate([tab2X+2, tab1Y-tabD, tab1Z-tabInnerR-.15])
        cube([.7, tabD, 1]);
*    translate([tab2X-2.6, tab1Y-tabD, tab1Z-tabInnerR-.15])
#        cube([.6, tabD, 1]);
}

}


module mounting_holes() {
    // rotated here. direction isn't obvious
holeX1 = 2.7;
holeX1a = 2.7;
holeXBR = 142.22 + .5;
holeXTR = 142.22;
holeYBL = 2.8;
holeYBR = 2.8 + .85;
holeYTL = 53.8 + .85;   // 1.2;
holeYTR = 53.8 + .85;
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

PCBInsideHeight = 15;

pcbW = boardW + boardGap * 2;
pcbH = boardH + boardGap * 2;
pcbD = eagleBoardD + boardD + 4 + PCBInsideHeight;

module microclock_reflector_neg() {
  //  colonBar();
  //  microMountingHoles();
        digits();


}


coreW = boardW + (boardGap + frameW) * 2;
coreH = boardH + (boardGap + frameH) * 2;
coreD = reflectorDepth + boardD + PCBInsideHeight;

module miniclock_reflector() {
difference() {  // to clean inside
    union() {      // most of reflector - button tabs sticking inside
        difference() {
            // base to carve everything outeagleBoard of
            translate([-wallW-boardGap, -wallH-boardGap, -channelDepth -reflectorDepth + eagleBoardD])
                cube([coreW, coreH, coreD + channelDepth]);
       union() {     
            cube([boardW, boardH, PCBInsideHeight + 5]);
  *         rotate([0, 0, 180])
   *             microclock_reflector_neg();
            union() {    
                mounting_holes();
                voids();
                if (buttonTabs)
                    tabs_neg();
                    
                // seven segments (* 4) + colon
                // was [boardX -1, boardY + 2, 0]
                translate([boardX - 1.5, boardY + 3, 0]) {
                    scale([segMul, segMul, 1])
                        translate([1, 0, -refOffZ])
                            digits();
                }
            }
        }
        }
        if (buttonTabs)
            tabs_pos();
        centerSupports();
    }
                // inner cube
    translate([-boardGap/2, -boardGap/2, innerCubeZ])
    #   cube([boardW+boardGap, boardH+boardGap, PCBInsideHeight + 5]);
}
}

digitOffset1 = 1.5;
digitOffset2 = 28.5;
digitOffsetColon = 54 - skootchRightTwo/2 + .25;
digitOffset3 = 62 - skootchRightTwo;
digitOffset4 = 89 - skootchRightTwo;

module digit(x) {
   translate([x, 0, skinBreak])
        difference() {
           digitPos(x);
           digitNeg(x);
       }
}

module digits() {
    digit(digitOffset1);
    digit(digitOffset2);
    digit(digitOffset3);
    digit(digitOffset4);
   translate([digitOffsetColon, 0, skinBreak])
    colons();
}


sectL = [ -5, -5, -8 ];
sectD = [boardW+boardFrameW*2+10, boardH+boardFrameW*2+6+10, 19.5];

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
}