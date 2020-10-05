$fn = 50;

skinBreak = 0.02;
gDepth = 12;

// stix
nudge = 0.25;

stixW = 100.25 + nudge;
stixH = 10.25 + nudge;
stixD = gDepth;

centerKind = 4;     // 1=hartz, 2=starz, 3=hartz&starz, 4=text

font = "Arial Rounded MT Bold:style=Regular";

// for centerKind == 4 -- * == star, % == heart
// to support centers, use - for things like O, = for doubles like B
//centerText = "%%*DR%B*%%";
//textSupport = "   || |   ";
 centerText = "%MODDABLE%";
 textSupport = "  |||-|   ";

letterY = 5.4;
letterZ = 4.2;
letterXOffset = -.5;

letSupZ = 7.7; // 8;
supSize = .34;
supVMult = 1.25;
supDeep = .6;

wall = 2;

dsg = .4;


pcbD = 1.53;
boardCapD = 3.52;
boardLedD = 2.44;

ledOffsetD = wall + boardLedD + stixD;

capW = 3.7;
capH = 2.9;
capD = boardCapD - pcbD;

capX = 12.08 - capW;
capY = 6.89 - capH;
capZ = pcbD;

ledW = 2;
ledH = 2;
ledD = boardLedD - pcbD;

ledY = 5 - ledW / 2;
ledZ = pcbD;

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

/*
module line(x1, y1, x2, y2, d=10, th=dsg) {
    linear_extrude(height=d) {
        // left
        hull() {
          translate([x1, y1]) circle(th);
          translate([x2, y2]) circle(th);
        }
    }
}
*/

module letter(l, sz=1, deep=ledOffsetD) {
    echo ("letter:", l);
    rotate([0, 180, 0])
	linear_extrude(height = deep) {
		text(l, size = sz, font = font, halign = "center", valign = "center", $fn = 16);
	}
}

module board() {
    cube([stixW, stixH, pcbD]);
    translate([capX, capY, capZ])
        cube([capW, capH, capD]);
    for (a =[5:10:95])
        translate([a, ledY, ledZ])
            cube([ledW, ledH, ledD]);
}

module corePos() {
   translate([-wall, -wall, -wall])
        cube([stixW + wall*2, stixH + wall*2, ledOffsetD]);
}

module coreNeg() {
    zoff = 3;
    translate([0, 0, -zoff])
        cube([stixW, stixH, stixD+zoff]);
    if (centerKind == 3) {      // alternating
        for (a =[5:20:95])
            translate([a-hartXOffset, hartY, hartZ])
                heart(0.11);
        for (a =[15:20:95])
            translate([a-starXOffset, starY, starZ])
                star(0.13);

    }
    else if (centerKind == 4) {
        for (a=[0:1:9]) {
            translate([(a*10)+5 -letterXOffset, letterY, letterZ]) {
                if (centerText[9-a] == "*") {
                    translate([0, 0, -letterZ*3])
                    star(0.13);
                }
                else if (centerText[9-a] == "%") {
                    translate([0, 0, -letterZ*3])
 #                   heart(0.11);
                }
                else {
                    letter(centerText[9-a], 7);
                }
            }
        }
    }
    else {
        for (a =[5:10:95])
            if (centerKind == 1)
                translate([a-hartXOffset, hartY, hartZ])
                    heart(0.11);
            else if (centerKind == 2)
                translate([a-starXOffset, starY, starZ])
                    star(0.13);
    }
}

module supports(deep=ledOffsetD) {
    if (centerKind == 4) {
        for (a=[0:1:9]) {
            translate([(a*10)+5 -letterXOffset, letterY, letSupZ]) {
                if (textSupport[9-a] == "-") {
                    translate([0, 0, -letterZ*2])
                        line(-5, 0, 5, 0, supDeep, supSize);
                }
                else if (textSupport[9-a] == "=") {
                    translate([0, 0, -letterZ*2]) {
                        line(-5, 1.7, 5, 1.7, supDeep, supSize);
                        line(-5, -1.7, 5, -1.7, supDeep, supSize);
                    }
                }
                else if (textSupport[9-a] == "|") {
                    translate([0, 0, -letterZ*2]) 
                        line(0, -5, 0, 5, supDeep, supSize*supVMult);
                }
            }
        }
    }
}

dividerW = 1;

module coreDividers() {
    for (a=[10:10:90])
        translate([a, 0, 0])
            cube([dividerW, stixH, stixD]);
}

module core() {
    difference() {
        corePos();
        translate([0, 0, wall + ledD + skinBreak])
            coreNeg();
    }
    difference() {
        coreDividers();
        translate([capX, capY, capZ+6.2])
  #          cube([capW, capH, capD+1]);

    }
}



//------





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
gapCubeH = 18.5;
gapCubeD = gDepth;
gapCubeX = -gapCubeW/2;
gapCubeY = -10.2;
gapCubeZ = 0;

module ringCenter(offsetX, offsetY) {    
    translate([offsetX + gapCubeX, offsetY + gapCubeY, gapCubeZ-skinBreak/2])
        cube([gapCubeW, gapCubeH, gapCubeD+skinBreak]);
}

module ringDividers(r1, r2, start = 15, len = 330, adjust = 0) {
    for (a = [start:30:start + len])
//    for (a = [135:30:425])        
#        rotate([0, 0, a])
            line(0, r1, 0, r2-.5 +adjust);
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
    [ 40, 72.5, 40, 68 ],
    [ 40, 53.5, 40, 58 ]
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
//        ringDividers(lInnerR, lOuterR);
        ringDividers(lInnerR, lOuterR, -45, 270, 0);
        ringDividers(lInnerR, lOuterR, -105, 30, -1.3);
    }
    
    translate([rCircleX, rCircleY, 0]) {
        centerCross(rInnerR);
//        ringDividers(rInnerR, rOuterR);
        ringDividers(rInnerR, rOuterR, 135, 270, 0);
        ringDividers(rInnerR, rOuterR, 75, 30, -1.3);
    }
    hartLinez();
}


module bigHartz() {
    difference() {
        framePos1();
        frameNeg1();
    }
    framePos2();
}

supportShift = 2.3;
supportLines = [
    [ -supportShift+2.1, 54.5, -supportShift+39.7, 0 ],
    [ supportShift+40.3, 0, supportShift+76.9, 54.5 ],
];

supX = 27;
supY = -1;
supW = 26;
supH = 20;
module hartzSupports(d = gDepth+3) {
    intersection() {
        union() {
            for (a = supportLines) {
 #              line(a[0], a[1], a[2], a[3], d, 2);
            }
        }
        translate([supX, supY, 0])
#            cube([supW, supH, d]);
    }    
}

module hartzNstix() {
    bigHartz();
    hartzSupports();

// board();
    translate([-10, -12, 2]) {
        union() {
            core();
            supports(1);
        }
    }
}




clipit = 0;    // Trim extra

buttonTabs = 0;         // press locations on top to match onboard buttons
trySupports = 0;

doCenters = 1;      // 1 hearts, 2 stars

halfBarriers = 1;   // put a partial light barrier mid-segment

deep = 6;

//boardW = 146;
//boardH = 63.7;     // was 63.45 - tight

// Eagle dimensions of v.2 board
//  + slop to fit
eagleBoardW = 76.2 + .25; // 84; // (33 * 2.54);      // 83.82;
eagleBoardH = 30.48 + .25; // 40;   // (15.55 * 2.54); // 39.37;
eagleBoardD = 1.8;
boardW = eagleBoardW;
boardH = eagleBoardH;
boardD = deep + eagleBoardD + skinBreak;

echo ("boardW: ", boardW);
echo ("boardH: ", boardH);
echo ("boardD: ", boardD);

boardFrameW = 3;
boardFrameX = 0;
boardFrameY = 0;

reflectorWidth = boardW;
reflectorHeight = boardH + boardFrameW;
reflectorDepth = eagleBoardD + 8;

digitDepth = reflectorDepth + 1;
barrierZ = digitDepth - 2.8;
barrierDepth = digitDepth-eagleBoardD;

xdsg = 0.1;

strokeWidth = 0.3;

px1 = 1.778;
px2 = 3.042;
px3 = 3.302;
px4 = 4.064;
px5 = 4.572;
px6 = 5.842;
px7 = 6.096;
px8 = 12.954;
px9 = 13.208;
px10 = 14.478;
px11 = 14.748;
px12 = 14.986;
px13 = 15.748;
px14 = 16.256;
px15 = 17.272;

py1 = 1.778;
py2 = 3.048;
py3 = 4.064;
py4 = 4.572;
py5 = 5.842;
py6 = 6.096;
py7 = 13.208;
py8 = 14.732;
py9 = 15.240;
py10 = 15.748;
py11 = 17.272;
py12 = 24.384;
py13 = 24.638;
py14 = 25.654;
py15 = 26.162;
py16 = 27.178;
py17 = 28.448;

ptz = [ [0,0],
/* 1*/  [ px1, py6 ], [ px1, py7 ], [ px3, py8 ], [ px3, py9 ], [ px3, py10],
/* 6*/  [ px1, py11], [ px1, py12], [ px2, py14], [ px4, py15], [ px5, py16],
/*11*/  [ px7, py17], [ px8, py17], [ px11, py16], [px12, py15], [px14, py14],
/*16*/  [px15, py13], [px15, py11], [px13, py10], [px13, py9 ], [px13, py8 ],
/*21*/  [px15, py7 ], [px15, py6 ], [px14, py4 ], [px12, py3 ], [px10, py2 ],
/*26*/  [ px8, py1 ], [ px7, py1 ], [ px5, py2 ], [ px4, py3 ], [ px2, py4 ],
/*31*/  [ px6, py5 ], [ px6, py7 ], [ px5, py8 ], [ px5, py9 ], [ px5, py10],
/*36*/  [ px6, py11], [ px6, py13], [ px9, py13], [ px9, py11], [px10, py10],
/*41*/  [px10, py9 ], [px10, py8 ], [ px9, py7 ], [ px9, py5 ]
];

segA = [ ptz[10], ptz[11], ptz[12], ptz[13], ptz[14], ptz[38],
        ptz[37], ptz[9] ];
segB = [ ptz[39], ptz[38], ptz[14], ptz[15], ptz[16], ptz[17],
        ptz[18], ptz[19], ptz[41], ptz[40] ];
segC = [ ptz[44], ptz[43], ptz[42], ptz[41], ptz[19], ptz[20],
        ptz[21], ptz[22], ptz[23], ptz[24] ];
segD = [ ptz[28], ptz[29], ptz[31], ptz[44], ptz[24], ptz[25],
        ptz[26], ptz[27] ];
segE = [ ptz[1], ptz[2], ptz[3], ptz[4], ptz[34], ptz[33], ptz[32],
        ptz[31], ptz[29], ptz[30] ];
segF = [ ptz[6], ptz[7], ptz[8], ptz[9], ptz[10], ptz[37], ptz[36], ptz[35],
        ptz[34], ptz[4], ptz[5] ];
segG = [ ptz[33], ptz[35], ptz[36], ptz[39], ptz[40], ptz[42], ptz[43],
        ptz[32] ];
segments = [ segA, segB, segC, segD, segE, segF, segG ];

module digitPos(x) {
    translate([x, 0, -digitOffsetZ]) {
        for (seg = segments) {
            linear_extrude(height = digitDepth, center=true, scale=1)
                polygon(seg);
        }
    }
}

// segment centers
ptCAx  = (ptz[38][0] - ptz[37][0]) / 2 + ptz[37][0];
ptCAy1 = ptz[11][1]; // py11;
ptCAy2 = ptz[37][1]; // py37;
ptCBx1 = ptz[38][0]; // px38;
ptCBx2 = ptz[16][0]; // px16;
ptCBy  = (ptz[38][1] - ptz[39][1]) / 2 + ptz[39][1]; // (py38 - py39) / 2 + py39;
ptCCx1 = ptCBx1;
ptCCx2 = ptCBx2;
ptCCy  = (ptz[43][1] - ptz[44][1]) / 2 + ptz[44][1]; // (py43 - py44) / 2 + py44;
ptCDx  = ptCAx;
ptCDy1 = ptz[31][1]; // py31;
ptCDy2 = ptz[27][1]; // py27;
ptCEx1 = ptz[2][0];  // px2;
ptCEx2 = ptz[31][0]; // px31;
ptCEy  = (ptz[32][1] - ptz[31][1]) / 2 + ptz[31][1]; // (py32 - py31) / 2 + py31;
ptCFx1 = ptCEx1;
ptCFx2 = ptCEx2;
ptCFy  = (ptz[37][1] - ptz[36][1]) / 2 + ptz[36][1]; // (py37 - py36) / 2 + py36;
ptCGx  = ptCAx;
ptCGy1 = ptz[32][1]; // py32;
ptCGy2 = ptz[36][1]; // py36;

segCA = [ [ptCAx, ptCAy1], [ptCAx, ptCAy2] ];
segCB = [ [ptCBx1, ptCBy], [ptCBx2, ptCBy] ];
segCC = [ [ptCCx1, ptCCy], [ptCCx2, ptCCy] ];
segCD = [ [ptCDx, ptCDy1], [ptCDx, ptCDy2] ];
segCE = [ [ptCEx1, ptCEy], [ptCEx2, ptCEy] ];
segCF = [ [ptCFx1, ptCFy], [ptCFx2, ptCFy] ];
segCG = [ [ptCGx, ptCGy1], [ptCGx, ptCGy2] ];
segCenters = [ segCA, segCB, segCC, segCD, segCE, segCF, segCG ];

module light_effects_digit(x) {
    if (halfBarriers) {
        translate([x, 0, -barrierZ]) {
            for (seg = segCenters) {
              linear_extrude(height=barrierDepth)

                reflLine(seg[0][0], seg[0][1], seg[1][0], seg[1][1]);
        }
    }
   }
}


module reflLine(x1, y1, x2, y2, d=digitDepth, dim=dsg) {
 //   linear_extrude(height=d) {
        // left
        hull() {
          translate([x1, y1]) square([dim, dim]); // circle(dsg);
          translate([x2, y2]) square([dim, dim]);
        }
 //   }
}

module digitDividers() {
    linear_extrude(height=digitDepth) {
        // left
        reflLine(ptz[4][0]-dsg, ptz[4][1]-dsg, ptz[34][0], ptz[34][1]-dsg, digitDepth, dsg*2);
        reflLine(ptz[36][0], ptz[36][1]-xdsg, ptz[35][0]+dsg, ptz[35][1]-dsg);
//        reflLine(ptz[35][0], ptz[35][1], ptz[33][0], ptz[33][1]);
        reflLine(ptz[33][0]+dsg, ptz[33][1], ptz[32][0]+xdsg, ptz[32][1]-dsg);

         // right
        reflLine(ptz[41][0]-dsg, ptz[41][1]-dsg, ptz[19][0]-dsg, ptz[19][1]-dsg, digitDepth, dsg*2);
        reflLine(ptz[39][0]-dsg, ptz[39][1]-xdsg, ptz[40][0]-dsg, ptz[40][1]-dsg);
//        reflLine(ptz[40][0], ptz[40][1], ptz[42][0], ptz[42][1]);
        reflLine(ptz[42][0]-dsg, ptz[42][1], ptz[43][0]-dsg, ptz[43][1]-dsg);
    
        // topLeft
        reflLine(ptz[9][0]-xdsg, ptz[9][1], ptz[37][0]+xdsg, ptz[37][1]-dsg, digitDepth, dsg);
        // topRight
        reflLine(ptz[14][0]-xdsg, ptz[14][1], ptz[38][0]-dsg, ptz[38][1]-dsg);
        // botLeft
        reflLine(ptz[29][0]-dsg, ptz[29][1]-dsg, ptz[31][0]+xdsg, ptz[31][1]);
        
        // botRight
        reflLine(ptz[24][0]-xdsg, ptz[24][1]-dsg, ptz[44][0]-dsg, ptz[44][1]+xdsg);
        
    }
}


module digitNeg(x) {
    translate([x, 0, -digitDepth]) {
        digitDividers();
    }
}

module digit(x) {
    translate([0, 0, skinBreak])
    difference() {
        digitPos(x);
        digitNeg(x);
    }
}


digitOffset1 = 0;
digitOffset2 = 18.288 - px1;
digitOffset3 = 39.878 - px1;
digitOffset4 = 56.134 - px1;
digitOffsetZ = digitDepth / 2;

module digits() {
    digit(digitOffset1);
    digit(digitOffset2);
    digit(digitOffset3);
    digit(digitOffset4);
}

module lightEffects() {
    light_effects_digit(digitOffset1);
    light_effects_digit(digitOffset2);
    light_effects_digit(digitOffset3);
    light_effects_digit(digitOffset4);
}

module colonDividers() {
    linear_extrude(height=digitDepth) {
        reflLine(cbx1, cby1, cbx2, cby1);
        reflLine(cbx1, cby2, cbx2, cby2);
        reflLine(cbx1, cby3, cbx2, cby3);
        reflLine(cbx1, cby4, cbx2, cby4);
        reflLine(cbx1, cby5, cbx2, cby5);
        reflLine(cbx1, cby6, cbx2, cby6);
        reflLine(cbx1, cby7, cbx2, cby7);
        reflLine(cbx1, cby8, cbx2, cby8);
    }
}

cby1 = 1.778;
cby2 = 5.842;
cby3 = 9.652;
cby4 = 13.462;
cby5 = 17.272;
cby6 = 21.082;
cby7 = 24.892;
cby8 = 28.448;
cbx1 = 35.052;
cbx2 = 38.608;

cbW = cbx2-cbx1;
cbH = cby8-cby1;
cbD = digitDepth;
cbX = cbx1;
cbY = cby1;
cbZ = -digitDepth + skinBreak;

module colonBarPos() {
    translate([cbX, cbY, cbZ])
        cube([cbW, cbH, cbD]);
}

module colonBarNeg() {
    translate([0, 0, cbZ])
        colonDividers();
}

module colonBar() {
    difference() {
        colonBarPos();
        colonBarNeg();
    }
}


module pixels() {
    pixW = 2;
    pixH = 2;
    pr1 = 26.67;
    pr2 = 22.86;
    pr3 = 19.05;
    pr4 = 15.24;
    pr5 = 11.43;
    pr6 = 7.62;
    pr7 = 3.81;
    
    pc1 = 3.81;
    pc2 = 7.62;
    pc3 = 11.43;
    pc4 = 15.24;
    pc5 = 20.32;
    pc6 = 24.13;
    pc7 = 27.94;
    pc8 = 31.75;
    pc9 = 36.83;
    pc10 = 41.91;
    pc11 = 45.72;
    pc12 = 49.53;
    pc13 = 53.34;
    pc14 = 58.42;
    pc15 = 62.23;
    pc16 = 66.04;
    pc17 = 69.85;
    
    pixels = [ [pc1, pr2], [pc1, pr3], [pc1, pr5], [pc1, pr6],
                    [ pc2, pr1], [pc2, pr4], [pc2, pr7],
                    [ pc3, pr1], [pc3, pr4], [pc3, pr7],
               [pc4, pr2], [pc4, pr3], [pc4, pr5], [pc4, pr6],
               [pc5, pr2], [pc5, pr3], [pc5, pr5], [pc5, pr6],
                    [ pc6, pr1], [pc6, pr4], [pc6, pr7],
                    [ pc7, pr1], [pc7, pr4], [pc7, pr7],
               [pc8, pr2], [pc8, pr3], [pc8, pr5], [pc8, pr6],
      [pc9, pr1], [pc9, pr2], [pc9, pr3], [pc9, pr4], [pc9, pr5], [pc9, pr6], [pc9, pr7],
               [pc10, pr2], [pc10, pr3], [pc10, pr5], [pc10, pr6],
                    [ pc11, pr1], [pc11, pr4], [pc11, pr7],
                    [ pc12, pr1], [pc12, pr4], [pc12, pr7],
               [pc13, pr2], [pc13, pr3], [pc13, pr5], [pc13, pr6],
               [pc14, pr2], [pc14, pr3], [pc14, pr5], [pc14, pr6],
                    [ pc15, pr1], [pc15, pr4], [pc15, pr7],
                    [ pc16, pr1], [pc16, pr4], [pc16, pr7],
               [pc17, pr2], [pc17, pr3], [pc17, pr5], [pc17, pr6] ];

        for (xy=pixels) {
            translate([-pixW/2 + xy[0], -pixH/2 + xy[1], -1])
                #cube([pixW,pixH,1]);
        }
}



module centers() {
    csiz = .6;
    centerY1 = 5.842 + csiz;
    centerY2 = 17.272 + csiz;
    centerX1 = 5.842 + csiz;
    centerX2 = 22.352 + csiz;
    centerX3 = 43.942 + csiz;
    centerX4 = 60.198 + csiz;
    centerH = 24.638 - 17.272 - csiz*2;
    centerW = 13.208 - 5.842 - csiz*2;
    centerD = digitDepth;
    centersLoc = [
        [ centerX1, centerY1], [ centerX1, centerY2 ],
        [ centerX2, centerY1], [ centerX2, centerY2 ],
        [ centerX3, centerY1], [ centerX3, centerY2 ],
        [ centerX4, centerY1], [ centerX4, centerY2 ],
    ];
    if (doCenters) {
        centersOffsetZ = -digitDepth+4;
        for (center = centersLoc) {
            translate([center[0], center[1], centersOffsetZ])
          #       cube([centerW, centerH, centerD]);
            if (doCenters == 1)              // hearts
                translate([center[0]+centerW/2, center[1]+centerH/2+.05, centersOffsetZ-2])
          #           heart(.072);
            else if (doCenters == 2)         // stars
                translate([center[0]+centerW/2, center[1]+centerH/2, centersOffsetZ-2])
          #           star(.08);
        }
    }
    else {
        centersOffsetZ = -digitDepth+2;
        for (center = centersLoc) {
            translate([center[0], center[1], centersOffsetZ])
          #       cube([centerW, centerH, centerD]);
        }
    }

    espW = 3;
    espH = 30;
    espD = reflectorDepth - 2;
    espX = boardW - espW;
    espY = .5;
    espZ = -reflectorDepth/2+2;
    translate([espX, espY, espZ])
#        cube([espW, espH, espD]);
}


module microMountingHoles() {
holeX1 = 2.54;
holeX2 = 71.184;
holeY1 = 2.54;
holeY2 = 28;
holeZ = 0;
holeR = 2/2; // 2.4/2;
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



module esp32Cutout() {
    esp32CutoutX1 = 72.3265;
    esp32CutoutX2 = eagleBoardW; // 76.2;
    esp32CutoutY1 = 5.9055;
    esp32CutoutY2 = 24.13;
    esp32CutoutW = esp32CutoutX2 - esp32CutoutX1;
    esp32CutoutH = esp32CutoutY2 - esp32CutoutY1;
    esp32CutoutD = eagleBoardD;

    translate([esp32CutoutX1, esp32CutoutY1, 0])
#        cube([esp32CutoutW, esp32CutoutH, esp32CutoutD]);
}

pcbGap = .3;

module pcb(withCutout=0) {
    difference() {
        union() {
            translate([-pcbGap, -pcbGap, 0])
            cube([eagleBoardW+pcbGap*2, eagleBoardH+pcbGap*2, boardD]);
 *           pixels();
        }
        union() {
            if (withCutout)
                esp32Cutout();
        }
    }
}

module microclock_reflector_neg() {
    pcb();
    colonBar();
    microMountingHoles();
        digits();
}

frameW = 1.5;
frameH = 1.5;

tabOuterR = 4;
tabInnerR = 3.2;
tabD = 1.5;
tab1X = 17;
tab2X = 33;

tab1Y = 31 + tabD;
tab1Ys = 31;
tab1Z = 5;

tabBar = 2;
tabBarD = 1.3;
tabBarHole = 4;
tabBarL = 5;

module tabs_neg() {
    translate([tab1X, tab1Y, tab1Z])
        rotate([90, 0, 0])
            cylinder(h=tabD, r=tabOuterR);
    translate([tab2X, tab1Y, tab1Z])
        rotate([90, 0, 0])
            cylinder(h=tabD, r=tabOuterR);
    translate([tab1X-tabInnerR+1-tabBarL, tab1Y-tabD, tab1Z-tabBarHole/2])
        cube([tabBarL, tabBarD, tabBarHole]);
    translate([tab2X-tabInnerR+1-tabBarL, tab1Y-tabD, tab1Z-tabBarHole/2])
        cube([tabBarL, tabBarD, tabBarHole]);
}

module tabs_pos() {
//    translate([tab1X, tab1Y, tab1Z])
//        rotate([90, 0, 0])
//            cylinder(h=tabD, r=tabInnerR);
    translate([tab1X, tab1Ys, tab1Z])
        sphere(r=tabInnerR);
    
    translate([tab1X-tabInnerR+1-tabBarL, tab1Y-tabD, tab1Z-tabBar/2])
        cube([tabBarL, tabBarD, tabBar]);

if (trySupports) {
    // support tabs;
    translate([tab1X-.3, tab1Y-tabD, tab1Z-tabInnerR-1])
        cube([.7, tabD, 1]);
    translate([tab1X+2, tab1Y-tabD, tab1Z-tabInnerR-.2])
        cube([.7, tabD, 1]);
*    translate([tab1X-2.6, tab1Y-tabD, tab1Z-tabInnerR-.2])
 #       cube([.7, tabD, 1]);
}

//    translate([tab2X, tab1Y, tab1Z])
//        rotate([90, 0, 0])
//            cylinder(h=tabD, r=tabInnerR);
    translate([tab2X, tab1Ys, tab1Z])
        sphere(r=tabInnerR);

    translate([tab2X-tabInnerR+1-tabBarL, tab1Y-tabD, tab1Z-tabBar/2])
        cube([tabBarL, tabBarD, tabBar]);
 
if (trySupports) {
    translate([tab2X-.3, tab1Y-tabD, tab1Z-tabInnerR-1])
        cube([.7, tabD, 1]);
    translate([tab2X+2, tab1Y-tabD, tab1Z-tabInnerR-.15])
        cube([.7, tabD, 1]);
*    translate([tab2X-2.6, tab1Y-tabD, tab1Z-tabInnerR-.15])
#        cube([.6, tabD, 1]);
}

}


    prX1 = 22.5;    // 23;
    prX2 = 39;      // 38.5;
    prY = 0;
    prZ = 1.254 + eagleBoardD;
    prW = prX2 - prX1;
    prH = frameH*2;
    prD = 2;

module programmer_cutout() {
    translate([prX1, prY-frameH-skinBreak, prZ])
        cube([prW, prH, prD]);
}

module programmer_support() {
    // support tabs;
    translate([prX1 + 5, prY-frameH-skinBreak, prZ])
#        cube([.6, tabD, prD]);
    translate([prX1 + 10, prY-frameH-skinBreak, prZ])
#        cube([.6, tabD, prD]);
*    translate([prX1 + 4, prY-frameH-skinBreak, prZ])
#        cube([.6, tabD, prD]);

}


module pins_cutout() {
    pnY1 = 29.3;
    pins = [ [40,pnY1], [42.6,pnY1], [52.95,pnY1], [55.47,pnY1], [58.06,pnY1]];
    pnZ = -1;
    pnR = 1.2;   // 1.5;
    pnD = 3;
    
    for (xy=pins) {
        translate([xy[0], xy[1], pnZ])
                #cylinder(r=pnR, h=pnD);
    }
}

module microclock_reflector() {
    difference() {
        union() {
           difference() { 
                translate([-frameW, -frameH, -reflectorDepth + eagleBoardD])
                   cube([boardW+frameW*2, boardH+frameH*2, reflectorDepth + boardD - 1]);
             translate([0, 0, 1])
               microclock_reflector_neg();
               centers();
               if (buttonTabs)
                  tabs_neg();
           }
           if (buttonTabs)
                tabs_pos();
       }
       union() {
            translate([0, 0, 1])
                microclock_reflector_neg();
           programmer_cutout();
           pins_cutout();
       }
   }
   lightEffects();
   if (trySupports)
    programmer_support();
}

clipitL = [ 1, -boardFrameW+5, -10 ];
clipitD = [ boardW-1.4, boardH-2, reflectorDepth ];

sectL = [ -5, -5, -1.5 ];
//sectD = [boardW+boardFrameW*2+10, boardH+boardFrameW*2+6+10, 2];
sectD = [boardW+frameW*2+10, boardH+frameH*2+10, 2];

takeSlice = 0;

if (takeSlice) {
    intersection() {
        microclock_reflector();
        translate(sectL)
 #           cube(sectD);
   }
}
else {
   if (clipit) {
        intersection() {
            microclock_reflector();
            translate(clipitL)
                cube(clipitD);
        }
    }
    else {
        hartzNstix();
        translate([2, -45, 8])
            microclock_reflector();
    }
}








