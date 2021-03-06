
// stix
nudge = 0.25;

// numBox = 11;

stixBoxW = 20;
stixBoxH = 20;

// stixW = numBox * stixBoxW + .25 + nudge;
stixWex = .25 + nudge;
stixHex = .25 + nudge;
stixH = stixBoxH + .25 + nudge;
stixD = 10; // 14;

textFont = "Arial Rounded MT Bold:style=Bold";
bioFont = "Menlo:style=Bold";

// for centerKind == 4 -- * == star, % == heart
// to support centers, use - for things like O, = for doubles like B
bioSize = 25;
letrSize = 19;
letrExpand = .1;

//centerText = "%%*DR%B*%%";
//textSupport = "   || |   ";
// centerText = "%MODDABLE%";

// textSupport = "  |||-|   ";

letterY = stixH / 2; // 5.4;
letterZ = 4.2;
letterXOffset = -.5;

letSupZ = 6.7; // 8;
supSize = .34;
supVMult = 1.25;
supDeep = 1.6;

wall = 2;
skinBreak = 0.01;

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

dsg = 0.4; // 0.5; // digitSegmentGap

module line(x1, y1, x2, y2, d=10, th=dsg) {
    linear_extrude(height=d) {
        // left
        hull() {
          translate([x1, y1]) circle(th);
          translate([x2, y2]) circle(th);
        }
    }
}

module letter(l, sz=1, deep=ledOffsetD, font=textFont) {
    echo ("letter:", l);
    rotate([0, 180, 0])
	linear_extrude(height = deep) {
        offset(r=letrExpand)
		text(l, size = sz, font = font, halign = "center", valign = "center", $fn = 16);
	}
}

module board(num) {
    stixW = stixBoxW * num + stixWex;
    cube([stixW, stixH, boardD]);
    translate([capX, capY, capZ])
        cube([capW, capH, capD]);
    for (a =[stixBoxW:stixBoxW:(num-1)*stixBoxW])
        translate([a, ledY, ledZ])
            cube([ledW, ledH, ledD]);
}

module corePos(num) {
    stixW = stixBoxW * num + stixWex;
    translate([-wall, -wall, -wall])
        cube([stixW + wall*2, stixH + wall*2, ledOffsetD]);
}

module coreNeg(num, text, textCenters) {
    zoff = 3;
    stixW = stixBoxW * num + stixWex;
    translate([0, 0, -zoff])
        cube([stixW, stixH, stixD+zoff]);
    for (a=[0:1:num-1]) {
        translate([(a*stixBoxW)+stixBoxW/2 -letterXOffset, letterY, letterZ]) {
            if (text[num-a-1] == "*") {
                translate([0, 0, -letterZ*3])
                star(0.013*stixBoxW);
            }
            else if (text[num-a-1] == "%") {
                translate([0, 0, -letterZ*3])
#                   heart(0.011*stixBoxW);
            }
            else if (text[num-a-1] == "☣")
                letter("☣", bioSize, ledOffsetD, bioFont);
            else {
                letter(text[num-a-1], letrSize);
            }
        }
    }
}

halfboxW = stixBoxW/2;

module supports(num, textCenters, deep=ledOffsetD) {
    for (a=[0:1:num-1]) {
        translate([(a*stixBoxW)+halfboxW -letterXOffset, letterY, letSupZ]) {
            if (textCenters[num-a-1] == "-") {
                translate([0, -1.8, -letterZ*2])
            #        line(-halfboxW, 0, halfboxW, 0, supDeep, supSize);
            }
            else if (textCenters[num-a-1] == "=") {
                translate([0, 0, -letterZ*2]) {
                    line(-halfboxW, 1.7, halfboxW, 1.7, supDeep, supSize);
                    line(-halfboxW, -1.7, halfboxW, -1.7, supDeep, supSize);
                }
            }
            else if (textCenters[num-a-1] == "|") {
                translate([0, 0, -letterZ*2]) 
                    line(0, -halfboxW, 0, halfboxW, supDeep, supSize*supVMult);
            }
        }
    }
}

dividerW = 1;

module coreDividers(num) {
    for (a=[stixBoxW:stixBoxW:num*stixBoxW-stixBoxW])
        translate([a, 0, 0])
            cube([dividerW, stixH, stixD]);
}

module core(num, text, textCenters) {
    difference() {
        corePos(num);
        translate([0, 0, wall + ledD + skinBreak])
            coreNeg(num, text, textCenters);
    }
    difference() {
        coreDividers(num);
        translate([capX, capY, capZ+6.2])
            cube([capW, capH, capD+1]);

    }
}

module gridPos(col, row) {
    stixW = stixBoxW * col + stixWex;
    stixH = stixBoxH * row + stixHex;
    translate([-wall, -wall, -wall])
        cube([stixW + wall*2, stixH + wall*2, ledOffsetD]);
}

module gridNeg(col, row, symbol, size) {
    zoff = 3;
    stixW = stixBoxW * col + stixWex;
    stixH = stixBoxH * row + stixHex;
    translate([0, 0, -zoff])
        cube([stixW, stixH, stixD+zoff]);
    translate([stixW/2 -letterXOffset, stixH/2, letterZ]) {
            if (symbol == "*") {
                translate([0, 0, -letterZ*3])
                star(0.013*stixBoxW);
            }
            else if (symbol == "%") {
                translate([0, 0, -letterZ*3])
#                   heart(0.011*stixBoxW);
            }
            else if (symbol == "☣")
                letter("☣", size, ledOffsetD, bioFont);
            else {
                letter(symbol, letrSize);
            }
        }
}

module grid(col, row, symbol, size, dividers = 0) {
    difference() {
        gridPos(col, row);
        translate([0, 0, wall + ledD + skinBreak])
            gridNeg(col, row, symbol, size);
    }
    dividerW = 1 + (dividers == 0 ? .5 : 0);
    difference() {
        union() {
            for (a=[0:1:col])
                translate([(a*stixBoxW)-(dividerW/2), 0, 0])
                    cube([dividerW, stixBoxH*row, stixD]);
            for (b=[0:1:row])
                translate([0, (b*stixBoxH)-(dividerW/2), 0])
                    cube([stixBoxW*col, dividerW, stixD]);
        }
        inset = 1.5;
        if (dividers == 0) {
            translate([dividerW/2+1, dividerW/2+inset, 0])
#                cube([stixBoxW*col-dividerW/2-2*inset, stixBoxH*row-dividerW/2-2*inset, stixD]);
   
        }
    }
}

module strip(num, text, textCenters) {
    union() {
        core(num, text, textCenters);
        supports(num, textCenters, 1);
    }
}

module stayCalm() {
    translate([0, -stixH-wall, 0])
        strip(5, "PANIC", "|-   ");
    strip (5, "DON’T", "||   ");
}

module twoBy() {
     grid(2, 2, "☣", 50, 1);

}

twoBy();
* stayCalm();