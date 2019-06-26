
LIBRARY = 1;

use <microclock-ref.scad>;

split_it = 0;                   // half sized deep
use_minkowski = 0;              // round edges or not
wallmount = 1;

acrylicDepth = 3.175 + .3;
//acrylicDepth = (3.175*2) + .3;      // double acrylic for mirrored finish


skinBreak = 0.01;       // extra depth to poke a hole through a surface

boardFrameW = 3;
boardFrameX = 0;
boardFrameY = -2;

// from miniclock-ref - begin
boardW = 89;
boardH = 45.5;     // was 63.45 - tight
boardD = 1.8 + skinBreak;

subsysShift = 3;

reflectorWidth = boardW; // boardW;
reflectorHeight = boardH + boardFrameW; // boardH + boardFrameW*2;
reflectorDepth = 7;
// from miniclock-ref - end

echo("Reflector[", reflectorWidth, reflectorHeight, reflectorDepth, "]");

fudge = 0.5;
reflectorW = reflectorWidth + fudge;
reflectorH = reflectorHeight + fudge;
reflectorD = reflectorDepth + fudge;

caseMinkowskiR = 5;
caseW = reflectorW;
caseH = 20+acrylicDepth;                 // really depth
caseD = reflectorH+caseMinkowskiR-2;
caseX = 0;
caseY = -acrylicDepth/2;
caseZ = -boardH/2 - caseMinkowskiR + subsysShift;

caseBackLip = 3;

//glassW = 148.26 + fudge;
//glassH = 65.8 + fudge;
glassAdd = 1;
glassW = reflectorW + glassAdd;
glassH = reflectorH + glassAdd;
glassD = acrylicDepth;
glassX = (reflectorW - glassW) / 2;
glassY = 0;
glassZ = -glassH/2-1 + subsysShift;

glassLipDepth = 2;
glassLipSide = caseMinkowskiR + 1.5;
glassLipBottom = caseMinkowskiR + 3 + subsysShift;

topBottomSplit = 0;

reflectorX = 0;
reflectorY = 0;
reflectorZ = reflectorH/2-1 + subsysShift;

voidW = reflectorW;
voidH = reflectorH;
voidD = caseH - glassD - glassLipDepth +1 -caseBackLip;
voidAX = 0;
voidAY = reflectorD + 2;
voidAZ = -reflectorH/2-2.5 + subsysShift;

module reflector() {
   translate([reflectorX, reflectorY, reflectorZ])
        rotate([-90, 0, 0])
            cube([reflectorW, reflectorH, reflectorD]);
}

module glass() {
    translate([glassX, glassY-glassD, glassZ])
        #cube([glassW, glassD+skinBreak, glassH]);
}

module internalVoid() {
    // main volume
    translate([voidAX, voidAY, voidAZ+2])
        cube([voidW, voidD, voidH]);
    //additional around board retaining lip
    translate([voidAX+6, voidAY-4, voidAZ+2])
        cube([voidW-12, voidD, voidH-4]);
    //additional around board retaining lip
*    translate([voidAX+3, voidAY-4, voidAZ+1])
        #cube([voidW-6, voidD, voidH-4]);
}

//    translate([7, -10, -topBottomSplit-(boardH/2)+9])

viewPortX = (reflectorW - glassW)/2;
viewPortY = -acrylicDepth-5;
viewPortZ = -glassH/2;
smallenW = glassLipSide * 2;
smallenH = glassLipBottom * 2;
smallenBW = glassLipSide*2;
smallenBH = glassLipSide;

module frontView() {
    if (use_minkowski) {
       translate([viewPortX+smallenW/2, viewPortY, viewPortZ+smallenH/2])
            minkowski() {
                cube([glassW-smallenW, glassH/4+10, glassH-smallenH]);
                sphere(r=caseMinkowskiR);
            }
    }
   else {
        translate([viewPortX+smallenW/2-caseMinkowskiR, viewPortY, viewPortZ+smallenH/2-2])
            cube([glassW-smallenW+caseMinkowskiR*2, glassH/4+10, glassH-smallenH]);
    }
}
module backView() {
    if (use_minkowski) {
        translate([viewPortX+smallenBW/2, viewPortY+caseH-1, viewPortZ+smallenBH])
            minkowski() {
                cube([glassW-smallenBW, glassH/4, glassH-smallenBH]);
                sphere(r=caseMinkowskiR);
            }
    }
    else {
        translate([viewPortX+smallenBW/2-caseMinkowskiR, viewPortY+caseH, viewPortZ+smallenBH-caseMinkowskiR])
            cube([glassW-smallenBW+caseMinkowskiR*2, glassH/4, glassH-smallenBH]);
    }
}

module caseCore() {
    if (use_minkowski) {
        translate([caseX, caseY, caseZ])
            minkowski() {
                cube([caseW, caseH, caseD]);
                sphere(r=caseMinkowskiR);
            }
    }
    else {
        translate([caseX-caseMinkowskiR, caseY-caseMinkowskiR, caseZ-caseMinkowskiR])
           cube([caseW+caseMinkowskiR*2, caseH+caseMinkowskiR*2, caseD]);
    }
}


connW = 2.5;
connW2 = connW/2;
connH = 8;
connH2 = connH/2;

connPoly = [ [-connW2,-connH2], [connW2,-connH2], [connW2,connH2], [-connW2,connH2] ];

tabW = 2.5;
tabD = 4;

tabZout = 1.5;
tabZin = -2;

tabAX = -connW;
tabAY = 4;
tabBX = reflectorW+connW;
tabBY = 16;
tabCX = reflectorW+connW;
tabCY = 35;
tabBZ = tabZout;

connPosScale = .8;

module connectorPositive() {
#    translate([tabAX, tabBY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=connPosScale)
            polygon(connPoly);
#    translate([tabBX, tabAY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=connPosScale)
            polygon(connPoly);
*#    translate([tabCX, tabCY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=connPosScale)
            polygon(connPoly);

}

connNegScale = 1.1; // 1.07;

module connectorNegative() {
    #translate([tabAX, tabAY, tabZin])
        rotate([180, 0, 0])
            scale([connNegScale, connNegScale, connNegScale])
            linear_extrude(height = tabD, center=true, scale=connNegScale)
                polygon(connPoly);
    #translate([tabBX, tabBY, tabZin])
        rotate([180, 0, 0])
            scale([connNegScale, connNegScale, connNegScale])
            linear_extrude(height = tabD, center=true, scale=connNegScale)
                polygon(connPoly);
 *   #translate([tabAX, tabCY, tabZin])
        rotate([180, 0, 0])
            scale([connNegScale, connNegScale, connNegScale])
            linear_extrude(height = tabD, center=true, scale=connNegScale)
                polygon(connPoly);
}

pinFudge = 0.3;
pushPinR1 = 2.5 + pinFudge;
pushPinR2 = 4 + pinFudge;

pinMountW = pushPinR2*2;
pinMountH = 6;
pinMountD = pushPinR2*2;

xpinMountX1 = 20;
xpinMountX2 = 28;
pinMountX1 = reflectorW*4/5;
pinMountX2 = reflectorW/5;
pinMountX3 = reflectorW/2;
pinMountY = 20.5; // caseD - pinMountH;
pinMountZ = -reflectorH/2+2.5;

xpinX1 = 30;
xpinX2 = reflectorW-pinX1+3.5;
xpinX3 = reflectorW/2+1.75;
pinX1 = pinMountX1;
pinX2 = pinMountX2;
pinX3 = pinMountX3;
pinY = 29;
pinZ = -reflectorH/2 +4.5;

module pinMount() {
    translate([-pushPinR1+.75, 0, 0])
        rotate([0, 45, 0])
            cube([pinMountW, pinMountH, pinMountD]);
    translate([pushPinR1-14+.5, 0, 0])
        rotate([0, 45, 0])
            cube([pinMountW, pinMountH, pinMountD]);
}

module pinMountPositive() {
        union() { 
            translate([pinMountX1, pinMountY, pinMountZ])
                pinMount();
            translate([pinMountX2, pinMountY, pinMountZ])
                pinMount();
            translate([pinMountX3, pinMountY, pinMountZ])
                pinMount();

        }
}
module pin() {
    union() {
        cylinder(r=pushPinR1, h=20, center=true);
        translate([0, 0, 10])
            cylinder(r=pushPinR2, h=2, center=true);
    }
}

module pinMountNegative() {
    translate([pinX1, pinY, pinZ])
        rotate([90, 0, 0])
            pin();
    translate([pinX2, pinY, pinZ])
        rotate([90, 0, 0])
            pin();

    translate([pinX3, pinY, pinZ])
        rotate([90, 0, 0])
            pin();

    translate([-250, -250, pinMountZ-6.2])
          cube([500, 500, 3]);

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
                            translate([0, 0, 4])
                            caseCore();
                        }
                    }
                    // (internal bits to void)
                    union() {
                        reflector();
                        glass();
                        internalVoid();
                        frontView();
                        backView();
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
        }
    }
}

// 

splitX = 20;
splitY = -120;
splitZ = -123;

if (split_it) {
    difference() {
        translate([0, 0, -1])
            oneSide();
        translate([splitX, splitY, splitZ])
            cube([500, 500, 500]);
    }
}
else {
    oneSide();
}