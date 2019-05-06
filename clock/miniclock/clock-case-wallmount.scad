$fn=30;
LIBRARY = 1;

use <miniclock-ref.scad>;

wallmount = 1;              // hole on side for power, hook placement

acrylicDepth = 3.175 + .3;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

boardW = 146;
boardH = 63.7;     // was 63.45 - tight
boardD = 1.8 + skinBreak;

boardFrameW = 3;
boardFrameX = 0;
boardFrameY = -2;

// from miniclock-ref - begin
boardW = 146;
boardH = 63.7;     // was 63.45 - tight
boardD = 1.8 + skinBreak;

reflectorWidth = 152.8; // boardW;
reflectorHeight = 75.6; // boardH + boardFrameW*2;
reflectorDepth = 10;
// from miniclock-ref - end

echo("Reflector[", reflectorWidth, reflectorHeight, reflectorDepth, "]");

fudge = 0.5;
reflectorW = reflectorWidth + fudge;
reflectorH = reflectorHeight + fudge;
reflectorD = reflectorDepth + fudge;

caseMinkowskiR = 5;
caseW = reflectorW;
caseH = 40;                 // really depth
caseD = reflectorH+caseMinkowskiR-2;
caseX = 0;
caseY = 0;
caseZ = -boardH/2 - caseMinkowskiR;

caseBackLip = 3;

// glassW = 148.26 + fudge;
// glassH = 65.8 + fudge;
glassW = reflectorW;
glassH = reflectorH;
glassD = acrylicDepth;
glassX = (reflectorW - glassW) / 2;
glassY = 0;
glassZ = -glassH/2-1;

glassLipDepth = 2;
glassLipSide = caseMinkowskiR + 3; // 1.5;
glassLipBottom = caseMinkowskiR + 3;

topBottomSplit = 0;

reflectorX = 0;
reflectorY = 0;
reflectorZ = reflectorH/2-1;

voidW = reflectorW;
voidH = reflectorH;
voidD = caseH - glassD - glassLipDepth -2 -caseBackLip;
voidAX = 0;
voidAY = reflectorD + 2;
voidAZ = -reflectorH/2-1;

module reflector() {
   translate([reflectorX, reflectorY, reflectorZ])
        rotate([-90, 0, 0])
            cube([reflectorW, reflectorH, reflectorD]);
}

module glass() {
    translate([glassX, glassY-glassD, glassZ])
        cube([glassW, glassD+skinBreak, glassH]);
}

module internalVoid() {
    // main volume
    translate([voidAX, voidAY, voidAZ])
        cube([voidW, voidD, voidH]);
    //additional around board retaining lip
    translate([voidAX+2, voidAY-4, voidAZ+2])
        cube([voidW-4, voidD, voidH-4]);
}

//    translate([7, -10, -topBottomSplit-(boardH/2)+9])

viewPortX = (reflectorW - glassW)/2;
viewPortY = -5;
viewPortZ = -glassH/2;
smallenW = glassLipSide * 2;
smallenH = glassLipBottom * 2;

module frontView() {
    translate([viewPortX+smallenW/2, viewPortY, viewPortZ+smallenH/2])
        minkowski() {
            cube([glassW-smallenW, glassH, glassH-smallenH]);
            sphere(r=caseMinkowskiR);
        }
}

module caseCore() {
    translate([caseX, caseY, caseZ])
    minkowski() {
        cube([caseW, caseH, caseD]);
            sphere(r=caseMinkowskiR);
    }
}


connW = 2.5;
connW2 = connW/2;
connH = 10;
connH2 = connH/2;

connPoly = [ [-connW2,-connH2], [connW2,-connH2], [connW2,connH2], [-connW2,connH2] ];

tabW = 2.5;
tabD = 4;

tabZout = 1.5;
tabZin = -2;

tabAX = -connW;
tabAY = 5;
tabBX = reflectorW+connW;
tabBY = 20;
tabCX = reflectorW+connW;
tabCY = 35;
tabBZ = tabZout;

module connectorPositive() {
#    translate([tabAX, tabBY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);
#    translate([tabBX, tabAY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);
#    translate([tabCX, tabCY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);

}

module connectorNegative() {
    #translate([tabAX, tabAY, tabZin])
        rotate([180, 0, 0])
            scale([1.05, 1.05, 1])
            linear_extrude(height = tabD, center=true, scale=.8)
                polygon(connPoly);
    #translate([tabBX, tabBY, tabZin])
        rotate([180, 0, 0])
            scale([1.05, 1.05, 1])
            linear_extrude(height = tabD, center=true, scale=.8)
                polygon(connPoly);
    #translate([tabAX, tabCY, tabZin])
        rotate([180, 0, 0])
            scale([1.05, 1.05, 1])
            linear_extrude(height = tabD, center=true, scale=.8)
                polygon(connPoly);
}

pinFudge = 0.3;
pushPinR1 = 2.5 + pinFudge;
pushPinR2 = 4 + pinFudge;

pinMountW = pushPinR2*2;
pinMountH = 6;
pinMountD = pushPinR2*2;

pinMountX1 = 20;
pinMountX2 = 28;
pinMountY = 20 - pinMountH;
pinMountZ = -reflectorH/2-1;

pinX1 = 30;
pinY = 23;
pinZ = -reflectorH/2 +2.4;

module pinMountPositive() {
    translate([pinMountX1, pinMountY, pinMountZ])
        rotate([0, 45, 0])
            cube([pinMountW, pinMountH, pinMountD]);
    #translate([pinMountX2, pinMountY, pinMountZ])
        rotate([0, 45, 0])
            cube([pinMountW, pinMountH, pinMountD]);
    translate([reflectorW - pinMountX1 - pinMountW*2, pinMountY, pinMountZ])
        rotate([0, 45, 0])
            cube([pinMountW, pinMountH, pinMountD]);
    #translate([reflectorW - pinMountX2, pinMountY, pinMountZ])
        rotate([0, 45, 0])
            cube([pinMountW, pinMountH, pinMountD]);
}

module pinMountNegative() {
    #translate([pinX1, pinY, pinZ])
        rotate([90, 0, 0])
            cylinder(r=pushPinR1, h=20, center=true);
    #translate([reflectorW-pinX1+3.5, pinY, pinZ])
        rotate([90, 0, 0])
            cylinder(r=pushPinR1, h=20, center=true);
}

cableHoleX = reflectorW+2;
cableHoleY = 20;
cableHoleZ = -30;

module powerCableHole() {
    #translate([cableHoleX, cableHoleY, cableHoleZ])
        rotate([0, 90, 0])
            cylinder(r=4, h=10, center=true);
}

module oneSide() {
    // remove negative tab bits
    difference() {
        // from a halved
        union() {
            // with added positive tab bits
            difference() {
                // voided internal bits
                difference() {
                    // full core
                    union() {
//                    color("blue", 0.2);
                        difference() {
                            caseCore();
                        }
                    }
                    // (internal bits to void)
                    union() {
                        reflector();
                        glass();
                        internalVoid();
                        frontView();
                   }
                }
    
            
                // cut in half
                translate([-150, -50, 1])
                    cube([500, 500, 500]);
            }
            
            // tabs positive
            translate([0, 0, 1])
                connectorPositive();
            
            if (wallmount) {
                pinMountPositive();
            }
       }
        // tabs negative
        translate([0, 0, 1])
            connectorNegative();
        if (wallmount) {
           pinMountNegative();
           powerCableHole();
        }
   }
}

// 

split_it = 1;
splitX = -150;
splitY = 20;
splitZ = -50;

if (split_it) {
    difference() {
        translate([0, 0, -1])
            oneSide();
        translate([splitX, splitY, splitZ])
           cube([500, 500, 500]);
        // clean bottom
        translate([splitX, -100, -500-caseD/2-3])
           cube([500, 500, 500]);
    }
}
else {
    oneSide();
}