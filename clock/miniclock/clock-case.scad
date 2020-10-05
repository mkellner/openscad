$fn=32;
LIBRARY = 1;

use <miniclock-ref.scad>;

split_it = 0;                   // half sized deep

doCardHolder = 0;
    withCutout = 0;
doSwitches = 0;
doLED = 0;

acrylicDepth = 3.175 + .3;

skinBreak = 0.01;       // extra depth to poke a hole through a surface

boardFrameW = 3;
boardFrameX = 0;
boardFrameY = -2;

// from miniclock-ref - begin
boardW = 146;
boardH = 63.7;     // was 63.45 - tight
boardD = 1.8 + skinBreak;

reflectorWidth = 152.8; // boardW;
reflectorHeight = 73.6; // boardH + boardFrameW*2;
reflectorDepth = 10;
// from miniclock-ref - end

echo("Reflector[", reflectorWidth, reflectorHeight, reflectorDepth, "]");

fudge = 0.5;
reflectorW = reflectorWidth + fudge;
reflectorH = reflectorHeight + fudge;
reflectorD = reflectorDepth + fudge;

caseMinkowskiR = 6;
caseW = reflectorW;
caseH = 40;                 // really depth
caseD = reflectorH+caseMinkowskiR-2;
caseX = 0;
caseY = 0;
caseZ = -boardH/2 - caseMinkowskiR;

caseBackLip = 3;

//glassW = 148.26 + fudge;
//glassH = 65.8 + fudge;
glassW = 153.5 + fudge;
glassH = 76 + fudge;
glassD = acrylicDepth;
glassX = (reflectorW - glassW) / 2;
glassY = 0;
glassZ = -glassH/2-1;

glassLipDepth = 2;
glassLipSide = caseMinkowskiR + 1.5;
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
    translate([voidAX+1, voidAY, voidAZ])
        cube([voidW-2, voidD, voidH]);
    //additional around board retaining lip
    translate([voidAX+3, voidAY-6, voidAZ+2])
        cube([voidW-6, voidD-2, voidH-4]);
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

rx = 0;
rz = -2;
module caseCore() {
    translate([caseX-rx, caseY, caseZ-rz])
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
tabZin = -2.7;

tabAX = -connW;
tabAY = 5;
tabBX = reflectorW+connW;
tabBY = 20;
tabCX = reflectorW+connW;
tabCY = 35;
tabBZ = tabZout;

tabNegDepthAdd = .5;
tabNegScale = [ 1.15, 1.15, 1.4 ];

module connectorPositive() {
    translate([tabAX, tabBY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);
    translate([tabBX, tabAY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);
    translate([tabCX, tabCY, tabBZ])
        rotate([0, 0, 0])
        linear_extrude(height = tabD, center=true, scale=.8)
            polygon(connPoly);
}

module connectorNegative() {
    color("blue") {
    translate([tabAX, tabAY, tabZin])
        rotate([180, 0, 0])
            scale(tabNegScale)
            linear_extrude(height = tabD+tabNegDepthAdd, center=true, scale=.8)
                polygon(connPoly);
    translate([tabBX, tabBY, tabZin])
        rotate([180, 0, 0])
            scale(tabNegScale)
            linear_extrude(height = tabD+tabNegDepthAdd, center=true, scale=.8)
                polygon(connPoly);
    translate([tabAX, tabCY, tabZin])
        rotate([180, 0, 0])
            scale(tabNegScale)
            linear_extrude(height = tabD+tabNegDepthAdd, center=true, scale=.8)
                polygon(connPoly);
    }
}

cardW = 106; // 92;
cardH = 51;
cardD = 10;

cardX = (reflectorW -cardW)/2+2;
cardY = 51;
cardZ = -70;

cardWall = 1.7;

cardR = [ 90+7.5, 0, 0 ];

cardTopL = [cardX-cardWall*2, 27.1, -21.5];
cardTopD = [ cardW+cardWall*2, 13.8, 3 ];

module cardHolderPositive() {
    translate([cardX-cardWall*2, cardY-cardWall*2, cardZ-cardWall*2])
        rotate(cardR)
           cube([cardW+cardWall*2, cardH+cardWall*2, cardD+cardWall*2]);
}

cardCutoutL = [cardX+13-2, -10, -27];
cardCutoutD = [cardW-26, cardH, cardD];
cardCutoutR = [ 90, 0, 0 ];
module cardHolderNegative() {
    translate([cardX-cardWall, cardY-cardWall*3, cardZ-cardWall])
        rotate(cardR)
           cube([cardW, cardH+5, cardD]);
    if (withCutout)
    translate(cardCutoutL)
        minkowski() {
            cube(cardCutoutD);
            sphere(r=caseMinkowskiR);
        }
}

module ledMountSm() {
    ledSlop = 0.4;
    ledMountR = (7 + ledSlop) / 2;
    ledMountD = 6.75;
    ledMountBaseR = 7.9 / 2;
    ledMountBaseH = 0.9;
    
    rotate([0, 180, 0])
        union() {
            cylinder(r = ledMountBaseR, h = ledMountBaseH);
            translate([0, 0, -ledMountD]) 
                cylinder(r = ledMountR, h = ledMountD);
        }
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
                translate([-20, -50, 1])
                    cube([200, 200, 200]);
            }
            
            // tabs positive
            translate([0, 0, 1])
                connectorPositive();
 
            if (doCardHolder)
                cardHolderPositive();
       }
        // tabs negative
        translate([0, 0, 1])
            connectorNegative();
        
       // switch holes
       swOffset1 = 7.5;
       swOffset2 = 19;
       swOffsetY1 = 35;
       swOffsetY2 = 22;
       swOffsetY3 = 22;
      if (doSwitches) {
            translate([reflectorW-swOffset1, swOffsetY1, -42])
#              ledMountSm();
            translate([swOffset1, swOffsetY1, -42])
#              ledMountSm();
#          translate([reflectorW-swOffset2, swOffsetY2, -42])
               ledMountSm();
#          translate([swOffset2, swOffsetY2, -42])
               ledMountSm();
        }
        
        // hole for IR receiver
       if (doLED) {
            translate([reflectorW/2, swOffsetY3, -42])
#              ledMountSm();
        }
        
        // card holder
        if (doCardHolder)
            cardHolderNegative();
        
                // clean bottom
                translate([-20, -50, -141])
                    cube([200, 200, 100]);
    }
    
    // flat cardholder bottom
    if (doCardHolder) {
        difference() {
            translate(cardTopL)
                cube(cardTopD);
           if (withCutout)
            translate(cardCutoutL)
                minkowski() {
                    cube(cardCutoutD);
                    sphere(r=caseMinkowskiR);
                }
        }
    }
}

// 
splitItL = [ -150, 20, -50 ];


module doIt() {
    if (split_it) {
        difference() {
            translate([0, 0, 0])
                oneSide();
            translate(splitItL)
                cube([500, 500, 500]);
        }
    }
    else {
        oneSide();
    }
}

testCardHolder = 0;
testConnectors = 0;

if (testCardHolder) {
    intersection([10, 10, 10]) {
        translate([23, 20, -50])
            cube([100,200,100]);
        doIt();
    }
}
else if (testConnectors) {
    translate([140, 0, 0])
    intersection([10, 10, 10]) {
        translate([-127, -20, -5])
            cube([200,200,100]);
        doIt();
    }
    translate([0, 0, 0])
    intersection([10, 10, 10]) {
        translate([127, -20, -5])
            #cube([200,200,100]);
        doIt();
    }
}
else {
    doIt();
}