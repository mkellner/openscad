$fn = 10;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

clipit = 0;    // Trim extra

//boardW = 146;
//boardH = 63.7;     // was 63.45 - tight

// Eagle dimensions of v.2 board
//  + slop to fit
eagleBoardW = 76.2 + .25; // 84; // (33 * 2.54);      // 83.82;
eagleBoardH = 30.48 + .25; // 40;   // (15.55 * 2.54); // 39.37;
eagleBoardD = 1.8; // 1.8;
boardW = eagleBoardW;
boardH = eagleBoardH;
boardD = eagleBoardD + skinBreak;

echo ("boardW: ", boardW);
echo ("boardH: ", boardH);
echo ("boardD: ", boardD);

boardFrameW = 3;
boardFrameX = 0;
boardFrameY = 0;

reflectorWidth = boardW;
reflectorHeight = boardH + boardFrameW;
reflectorDepth = eagleBoardD + 8;

dsg = 0.5; // digitSegmentGap
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


module digitDividers() {
    linear_extrude(height=digitDepth) {
        // left
        hull() {
          translate(ptz[4]) circle(dsg);
          translate(ptz[34]) circle(dsg);
        }
        hull() {
          translate([ptz[36][0]+xdsg, ptz[36][1]+xdsg]) circle(dsg);
          translate(ptz[35]) circle(dsg);
        }
        hull() {
          translate(ptz[35]) circle(dsg);
          translate(ptz[33]) circle(dsg);
        }
        hull() {
          translate(ptz[33]) circle(dsg);
          translate([ptz[32][0]+xdsg, ptz[32][1]-xdsg]) circle(dsg);
        }
        // right
        hull() {
          translate(ptz[41]) circle(dsg);
          translate(ptz[19]) circle(dsg);
        }
        hull() {
          translate([ptz[39][0]-xdsg, ptz[39][1]+xdsg]) circle(dsg);
          translate(ptz[40]) circle(dsg);
        }
        hull() {
          translate(ptz[40]) circle(dsg);
          translate(ptz[42]) circle(dsg);
        }
        hull() {
          translate(ptz[42]) circle(dsg);
          translate([ptz[43][0]-xdsg, ptz[43][1]-xdsg]) circle(dsg);
        }
        // topLeft
        hull() {
          translate(ptz[9]) circle(dsg);
          translate([ptz[37][0]+xdsg, ptz[37][1]-xdsg]) circle(dsg);
        }
        // topRight
        hull() {
          translate(ptz[14]) circle(dsg);
          translate([ptz[38][0]-xdsg, ptz[38][1]-xdsg]) circle(dsg);
        }
        // botLeft
        hull() {
          translate(ptz[29]) circle(dsg);
          translate([ptz[31][0]+xdsg, ptz[31][1]+xdsg]) circle(dsg);
        }
        // botRight
        hull() {
          translate(ptz[24]) circle(dsg);
          translate([ptz[44][0]-xdsg, ptz[44][1]+xdsg]) circle(dsg);
        }

        
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
digitDepth = reflectorDepth + 1;
digitOffsetZ = digitDepth / 2;

module digits() {
    digit(digitOffset1);
    digit(digitOffset2);
    digit(digitOffset3);
    digit(digitOffset4);
}

module colonDividers() {
    linear_extrude(height=digitDepth) {
        hull() {
          translate([cbx1, cby1]) circle(dsg);
          translate([cbx2, cby1]) circle(dsg);
        }
        hull() {
          translate([cbx1, cby2]) circle(dsg);
          translate([cbx2, cby2]) circle(dsg);
        }
        hull() {
          translate([cbx1, cby3]) circle(dsg);
          translate([cbx2, cby3]) circle(dsg);
        }
        hull() {
          translate([cbx1, cby4]) circle(dsg);
          translate([cbx2, cby4]) circle(dsg);
        }
        hull() {
          translate([cbx1, cby5]) circle(dsg);
          translate([cbx2, cby5]) circle(dsg);
        }
        hull() {
          translate([cbx1, cby6]) circle(dsg);
          translate([cbx2, cby6]) circle(dsg);
        }
        hull() {
          translate([cbx1, cby7]) circle(dsg);
          translate([cbx2, cby7]) circle(dsg);
        }
        hull() {
          translate([cbx1, cby8]) circle(dsg);
          translate([cbx2, cby8]) circle(dsg);
        }
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

module pixels() {
        for (xy=pixels) {
            translate([-pixW/2 + xy[0], -pixH/2 + xy[1], -1])
                #cube([pixW,pixH,1]);
        }
}

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
centersOffsetZ = -digitDepth+2;

module centers() {
    for (center = centersLoc) {
        translate([center[0], center[1], centersOffsetZ])
 #           cube([centerW, centerH, centerD]);
    }
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


esp32CutoutX1 = 72.3265;
esp32CutoutX2 = eagleBoardW; // 76.2;
esp32CutoutY1 = 5.9055;
esp32CutoutY2 = 24.13;
esp32CutoutW = esp32CutoutX2 - esp32CutoutX1;
esp32CutoutH = esp32CutoutY2 - esp32CutoutY1;
esp32CutoutD = eagleBoardD;

module esp32Cutout() {
    translate([esp32CutoutX1, esp32CutoutY1, 0])
#        cube([esp32CutoutW, esp32CutoutH, esp32CutoutD]);
}

pcbGap = .3;

module pcb(withCutout=0) {
    difference() {
        union() {
            translate([-pcbGap, -pcbGap, 0])
            cube([eagleBoardW+pcbGap*2, eagleBoardH+pcbGap*2, eagleBoardD]);
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

module microclock_reflector() {
   difference() { 
        translate([-frameW, -frameH, -reflectorDepth + eagleBoardD])
           cube([boardW+frameW*2, boardH+frameH*2, reflectorDepth]);
     translate([0, 0, 1])
       microclock_reflector_neg();
       centers();
   }
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
        microclock_reflector();
    }
}







// old crap
/*--------------------------------------

digX1 = 1.778;
digX2 = 3.81;
digX3 = 5.842;
digX4 = 13.208;
digX5 = 15.24;
digX6 = 17.272;
digX7 = 35.052;
digX8 = 38.608;

digY1 = 1.778;
digY2 = 5.842;
digY3 = 13.208;
digY4 = 14.732;
digY5 = 15.748;
digY6 = 17.272;
digY7 = 24.638;
digY8 = 28.448;

digX = [ digX1, digX1, digX2, digX2, digX1, digX1, digX3, digX4,
         digX6, digX6, digX5, digX5, digX6, digX6, digX4, digX3,
         digX3, digX3, digX4, digX4, digX3, digX3, digX4, digX4,
         digX7, digX7, digX8, digX8 ];
digY = [ digY2, digY3, digY4, digY5, digY6, digY7, digY8, digY8,
         digY7, digY6, digY5, digY4, digY3, digY2, digY1, digY1,
         digY2, digY3, digY3, digY2, digY6, digY7, digY7, digY6,
         digY1, digY8, digY8, digY1 ];

digitOutlineStart = 1;
digitOutlineEnd = 16;
digitCenter1Start = 17;
digitCenter1End = 20;
digitCenter2Start = 21;
digitCenter2End = 24;

digitPath = [
    [digX[0],digY[0]], [digX[1],digY[1]], [digX[2],digY[2]], [digX[3],digY[3]],
    [digX[4],digY[4]], [digX[5],digY[5]], [digX[6],digY[6]], [digX[7],digY[7]],
    [digX[8],digY[8]], [digX[9],digY[9]], [digX[10],digY[10]], [digX[11],digY[11]],
    [digX[12],digY[12]], [digX[13],digY[13]], [digX[14],digY[14]], [digX[15],digY[15]],
    [digX[0],digY[0]]
    ];

digitOffset1 = 0;
digitOffset2 = 18.288 - digX1;
digitOffset3 = 39.878 - digX1;
digitOffset4 = 56.134 - digX1;
digitDepth = 10;
digitOffsetZ = digitDepth / 2;

module xdigit(x) {
    translate([x, 0, -digitOffsetZ])
        linear_extrude(height = digitDepth, center=true, scale=1)
            polygon(digitPath);
}
*/