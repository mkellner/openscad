
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


boardD = 1.53;
boardCapD = 3.52;
boardLedD = 2.44;

ledOffsetD = wall + boardLedD + stixD;

capW = 3.7;
capH = 2.9;
capD = boardCapD - boardD;

capX = 12.08 - capW;
capY = 6.89 - capH;
capZ = boardD;

ledW = 2;
ledH = 2;
ledD = boardLedD - boardD;

ledY = 5 - ledW / 2;
ledZ = boardD;

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

module line(x1, y1, x2, y2, d=10, th=dsg) {
    linear_extrude(height=d) {
        // left
        hull() {
          translate([x1, y1]) circle(th);
          translate([x2, y2]) circle(th);
        }
    }
}

module letter(l, sz=1, deep=ledOffsetD) {
    echo ("letter:", l);
    rotate([0, 180, 0])
	linear_extrude(height = deep) {
		text(l, size = sz, font = font, halign = "center", valign = "center", $fn = 16);
	}
}

module board() {
    cube([stixW, stixH, boardD]);
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


module bigHartz() {
    difference() {
        framePos1();
        frameNeg1();
    }
    framePos2();
}

supportShift = 2.3;
supportLines = [
    [ -supportShift+2.1, 54.5, -supportShift+39.7, 0.25 ],
    [ supportShift+40.5, 0.25, supportShift+76.9, 54.5 ],
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

bigHartz();
hartzSupports();

// board();
translate([-10, -12, 2])
union() {
    core();
    supports(1);
}