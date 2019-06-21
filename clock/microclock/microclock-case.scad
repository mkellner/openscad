
LIBRARY = 1;

use <microclock-ref.scad>;

split_it = 0;                   // half sized deep


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

subsysShift = 3.5;

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
glassW = reflectorW;
glassH = reflectorH;
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
        cube([glassW, glassD+skinBreak, glassH]);
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
   # translate([viewPortX+smallenW/2, viewPortY, viewPortZ+smallenH/2])
        minkowski() {
            cube([glassW-smallenW, glassH/4+10, glassH-smallenH]);
            sphere(r=caseMinkowskiR);
        }
}
module backView() {
    translate([viewPortX+smallenBW/2, viewPortY+caseH-1, viewPortZ+smallenBH])
        minkowski() {
            cube([glassW-smallenBW, glassH/4, glassH-smallenBH]);
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

module connectorPositive() {
#    translate([tabAX, tabBY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);
#    translate([tabBX, tabAY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);
*#    translate([tabCX, tabCY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);

}

connNegScale = 1.07;

module connectorNegative() {
    #translate([tabAX, tabAY, tabZin])
        rotate([180, 0, 0])
            scale([connNegScale, connNegScale, connNegScale])
            linear_extrude(height = tabD, center=true, scale=.8)
                polygon(connPoly);
    #translate([tabBX, tabBY, tabZin])
        rotate([180, 0, 0])
            scale([connNegScale, connNegScale, connNegScale])
            linear_extrude(height = tabD, center=true, scale=.8)
                polygon(connPoly);
 *   #translate([tabAX, tabCY, tabZin])
        rotate([180, 0, 0])
            scale([connNegScale, connNegScale, connNegScale])
            linear_extrude(height = tabD, center=true, scale=.8)
                polygon(connPoly);
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
        }
        // tabs negative
        translate([0, 0, 1])
            connectorNegative();
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