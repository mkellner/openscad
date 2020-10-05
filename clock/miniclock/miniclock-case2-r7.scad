$fn = 75;

shimsAndRelief = 2;     // 1==both, 2==just relief

doFoot = 1;


// micro Tv: buttons = 1, ease = .15, acrylicGrowth = 1.5
// micro Tv: reflector x/y: 87/44 + ease*2+acrylicGrowth
// micro Tv: revlectorD = 10, coreClockD = 22
buttons = 0;    // needs to be redone for micro
ease = .15;
acrylicGrowth = 1.5;
reflectorW = 87 + ease*2 + acrylicGrowth;
reflectorH = 44 + ease*2 + acrylicGrowth;
reflectorD = 10;
clockCoreD = 22; // 18;  7 - 22
cornersReliefR = 1;

// mini frame
// mini Tv: buttons = 1, ease = .15, acrylicGrowth = 1.5
// mini Tv: reflector x/y: 87/44 + ease*2+acrylicGrowth
// mini Tv: revlectorD = 10, coreClockD = 22
bigButtons = 0;     // arcade style (25mm?) buttons at bottom
topButtons = 1;
wallMount = 0;
ease = .15;
acrylicGrowth = 1.5;
reflectorW = 151.78 + ease*2 + acrylicGrowth;
reflectorH = 76.74 + ease*2 + acrylicGrowth;
reflectorD = 12;
clockCoreD = 30; // 22; // 18;  7 - 22
cornersReliefR = 1.2;

coreOffset = [ 0, 0, -.5 ];

acrylicDepth = 3.175 + .3;

footInsetX = 0;
footInsetY = 0.85;

minkowskiR = 5;
wallThickness = 3;

reflectorOffset = [-wallThickness/2, -wallThickness/2, -acrylicDepth];

buttonsH = (30 * bigButtons);
bottomAddtl = (10 * bigButtons);

coreCubeDim = [ reflectorW-wallThickness, reflectorH-wallThickness + buttonsH + bottomAddtl, clockCoreD ];



module arcadeButtonKnub() {
	knubW = 6;
	knubL = 9;
	knubH = 6; // 2.75;
	translate([0, -knubH/2, 0])
		rotate([0, 180 -15, 0])
            cube([knubW, knubH, knubL]);
}

module arcadeButton() {
	coreR = 15.1;
	coreH = 17.2;

	knubOffset = 1;

	ringH = 3.75;
	ringR = (32.88 / 2);
	ringZOffset = -ringH;

	buttonH = 3.75;
	buttonR = (24.75 / 2);
	buttonZOffset = ringZOffset - buttonH;

	cylinder(r=coreR, h=coreH);
	translate([0, 0, ringZOffset])
		cylinder(r=ringR, h=ringH);

	translate([0, 0, buttonZOffset])
		cylinder(r=buttonR, h=buttonH);

	translate([coreR, 0, 10 + knubOffset])
		arcadeButtonKnub();

	rotate([0, 0, 180])
	translate([coreR, 0, 10 + knubOffset])
		arcadeButtonKnub();
}



module reflector(depth = reflectorD) {
    translate(reflectorOffset)
        cube([reflectorW, reflectorH, depth]);
}

//reflectorShimLoc = [0, 0, 0];
aclp = .8;
reflectorShimLoc = [reflectorW/2, acrylicGrowth-1, reflectorD/2+acrylicDepth];
shimPath = [ [ -acrylicGrowth/2, -reflectorD/2+aclp ],
             [ -acrylicGrowth/2+aclp, -reflectorD/2 ],
             [  acrylicGrowth/2+1,  -reflectorD/2 ],
             [  acrylicGrowth/2+1,  reflectorD/2 ],
             [ -acrylicGrowth/2+aclp, reflectorD/2 ],
             [ -acrylicGrowth/2, reflectorD/2-aclp ]
            ];

module reflectorShim(depth = reflectorD) {
*    translate(reflectorShimLoc)
#        cube([reflectorW, acrylicGrowth, depth]);

    translate(reflectorOffset)
    translate(reflectorShimLoc)
    rotate([90, 180, 90])
    linear_extrude(height = reflectorW, center=true)
#        polygon(shimPath);
}

module acrylic(depth = acrylicDepth) {
    translate(reflectorOffset)
           cube([reflectorW, reflectorH, acrylicDepth]);
}

module ledMountSm(d=7) {
    ledSlop = 0.6;      // was .4
    ledMountR = (d + ledSlop) / 2;
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

xbuttonsNegLoc = [ [ 0, 48, 0 ], [ 0, 45, acrylicDepth + 7 ] ];
buttonsNegLoc = [ [ 0, reflectorH + buttonsH - bottomAddtl - 17, 0 ], [ 0, reflectorH + buttonsH - bottomAddtl - 21, acrylicDepth + 16 ] ];
buttonsNegDim = [ [ reflectorW, buttonsH+bottomAddtl-3, 20 ], [ reflectorW, buttonsH + bottomAddtl + 1, 20 ], ];
buttonsNegNum = 1;

xbuttonsLoc = [ [ 15, 55, -5 ], [ reflectorW - 15, 55, -5 ] ];
buttonsLoc = [ [ 30, reflectorH + buttonsH - 9, -2 ], [ reflectorW - 30, reflectorH + buttonsH -9, -2 ] ];
buttonsNum = 1;

topButtonsOffset = [ 0, 0, 22 ];
topButtonsRot = [ 90, 0, 0 ];
topButtonsNum = 1;
topButtonsLoc = [ [ 25, 0, 0 ], [ reflectorW - 25, 0, 0 ] ];

module buttonsNeg() {
    if (bigButtons) {
        translate(reflectorOffset) {
            for (i=[0:1:buttonsNegNum])
                translate(buttonsNegLoc[i])
                    cube(buttonsNegDim[i]);
    
            for (i=[0:1:buttonsNum])
                translate(buttonsLoc[i])
                    arcadeButton();
        }
    }
    if (topButtons) {
        translate(topButtonsOffset) {
/*            
            for (i=[0:1:topButtonsNegNum])
                translate(topButtonsNegLoc[i])
 #                   cube(topButtonsNegDim[i]);
 */
            
            for (i=[0:1:topButtonsNum])
                translate(topButtonsLoc[i])
                    rotate(topButtonsRot)
#                        ledMountSm(12);
        }
    }
}

module baseBlock() {
    translate(coreOffset)
        minkowski()
        {
            cube(coreCubeDim);
            cylinder(r=minkowskiR, h=reflectorD, center=true);
        }
}

module core() {
    difference() {
        baseBlock();
        reflector(reflectorD+acrylicDepth+clockCoreD);
    }
}

retainerRadius = 2;
retainerLoc = [ 0, 0, reflectorD + retainerRadius ];

retainerGap = .5;
retainerGapThrow = 1.7;
retainerGapLoc = [ -6, - retainerGapThrow, reflectorD -.2 ];
retainerGapDim = [ 9, retainerGapThrow, 5 ];

retainerBarLocPos = [ -6, 0, -.65 ];
retainerBarDimPos = [ 6, 1, 1.3 ];
retainerBarLocNeg = [ -6, -1, -.65 - retainerGap ];
retainerBarDimNeg = [ 6, 2.5, 1.3 + 2*retainerGap ];

retainerWeldLoc = [ -.25, 0, -2.4 ];
retainerWeldLoc2 = [ -.25, 0, 2.0 ];
retainerWeldDim = [ .5, 1, .5 ];

module retainerNeg() {
    translate(retainerLoc)
        intersection() {
            union() {
                translate([0, .25, 0])
                sphere(r = retainerRadius+retainerGap);
                translate(retainerBarLocNeg)
                    cube(retainerBarDimNeg);
            }
            translate([-10+retainerRadius+retainerGap,0,-5])
                cube([10,10,10]);
        }
     translate(retainerGapLoc)
        cube(retainerGapDim);
}

module retainerPos() {
    translate(retainerLoc)
        difference() {
            intersection() {
                union() {
                 translate([0, .25, 0])
                   sphere(r = retainerRadius);
                    translate(retainerBarLocPos)
                        cube(retainerBarDimPos);
                    translate(retainerWeldLoc)
   #                     cube(retainerWeldDim);
                    translate(retainerWeldLoc2)
   #                     cube(retainerWeldDim);
                }
                translate([-10+retainerRadius+retainerGap,0,-5])
                    cube([10,2,8]);
            }
        }
}

retainersLoc = [ [ 20, -1.18, -6 ], [ reflectorW - 23, -1.18, -6 ],
                [ 20, reflectorH - .5, -13], [reflectorW - 23, reflectorH - .5, -13],
                [ 20, reflectorH - .5, -6 ], [ reflectorW - 23, reflectorH - .5, -6 ],
//                [ 15, 45.3, -13], [65, 45.3, -13],
];
retainerRot = [ [ 0, 0, 0], [0, 0, 0], 
            [ 0, 0, 180], [0, 0, 180],
            [ 0, 0, 180], [0, 0, 180] ];
retainersNum = 5;

module retainersNeg() {
    if (1 == shimsAndRelief)
    
    for (i=[0:1:retainersNum])
        translate(retainersLoc[i])
            rotate(retainerRot[i])
                retainerNeg();
}

module retainersPos() {
    if (1 == shimsAndRelief)
    for (i=[0:1:retainersNum])
        translate(retainersLoc[i])
            rotate(retainerRot[i])
            retainerPos();
}

module viewPort() {
    viewPortLoc = [ minkowskiR+2, minkowskiR+1.5, -2 ];
    viewPortDim = [ reflectorW-minkowskiR*2-7, reflectorH-minkowskiR*2-7, 2 ];
    translate(viewPortLoc)
        minkowski() {
            cube(viewPortDim);
            cylinder(r=minkowskiR, h=clockCoreD, center=true);
        }
}

cornersReliefH = clockCoreD + acrylicDepth + 2;
    cornersLoc = [ [ -wallThickness/2, 0, cornersReliefH/2 - acrylicDepth ],
                   [ -wallThickness/2, reflectorH  -wallThickness/2, cornersReliefH/2 - acrylicDepth ],
                   [ -wallThickness/2 + reflectorW, 0, cornersReliefH/2 - acrylicDepth ],
                   [ -wallThickness/2 + reflectorW, reflectorH  -wallThickness/2, cornersReliefH/2 - acrylicDepth ] ];
cornerReliefNum = 3;
cornersRot = [ 0, 0, 0 ];

module cornersRelief() {
    for (i=[0:1:cornerReliefNum])
        translate(cornersLoc[i])
            rotate(cornersRot)
#                cylinder(h=cornersReliefH, r=cornersReliefR, center=true);
}

pinFudge = 0.1;
pushPinR1 = 2.25 + pinFudge;
pushPinR2 = 3.9 + pinFudge;
pushPinBarrelH = 5;

pinSpacing = (reflectorW/10);

module mountPos() {
    translate([-wallThickness,-wallThickness,clockCoreD-wallThickness/2]) {    
        for (i=[0:1:4]) {
            difference() {
            translate([(reflectorW/10)*((i*2)+1)+wallThickness/2-pushPinR1-2, 0, -4+pushPinBarrelH])
                cube([pushPinR1*2+4, 10, pushPinBarrelH]);
                
            translate([(reflectorW/10)*((i*2)+1)+wallThickness/2, 6, 2])
                cylinder(r=pushPinR1, h=20, center=true);
            translate([(reflectorW/10)*((i*2)+1)+wallThickness/2-pushPinR1, 6, -4+pushPinBarrelH-.5])
                cube([pushPinR1*2, 10, pushPinBarrelH+1]);
            }
 //       }
     }
    }
}

cableOutR = 4;
cableOutRot = [[ 0, 90, 0], [ 0, 90, 0], [ 90, 0, 0]];
cableOutH = wallThickness * 2;
cableOutL = [ [ -wallThickness*2, reflectorH + (buttonsH + bottomAddtl)/2, clockCoreD+wallThickness+1 ],
              [ reflectorW-wallThickness, reflectorH + (buttonsH + bottomAddtl)/2, clockCoreD+wallThickness+1 ],
              [ (reflectorW-wallThickness)/2, reflectorH + (buttonsH + bottomAddtl)+wallThickness, clockCoreD+wallThickness+1 ] ];
module cableOut() {
    for (i=[0:1:2])
        translate(cableOutL[i])
        rotate(cableOutRot[i])
         cylinder(h=cableOutH,r=cableOutR);
}


footWall = 2;
footH = buttonsH+reflectorH;

module footStep(step) {
    if (step == 1) {        // main lump
        translate([0, 0, -28])
            difference() {
                 translate([0, 0, -5])
                    baseBlock();
  *              core();
                translate([-5, -10, -12])
                    cube([reflectorW+10, footH+15, 40]);      
            }
        translate([footInsetX, footInsetY, 0])
            translate(reflectorOffset)
               cube([reflectorW-2*footInsetX, footH-2*footInsetY, 5]);
    }
    else if (step == 2) {       // cable cutout
        translate([(reflectorW-8)/2, reflectorH+buttonsH-6, -5]) {  // 14
           cube([8, 8, 18]);
            translate([4, 0, 0])
                cylinder(r=4, h=18);
    #        translate([4, 2.5, 0])
                rotate([0, 0, 45])
                    cube([8, 8, 18]);
        }
    }
    else if (step == 3) {       //hollow
        translate(reflectorOffset)
            translate([footInsetX+footWall, footInsetY+footWall, -1.5]) {
                cube([reflectorW-2*footInsetX-2*footWall, (footH-2*footInsetY-2*footWall)/2-3, 5]);
            translate([0, 36 + (buttons*10), 0]) { // [0, 30, 0] for footed
    #           cube([(reflectorW-2*footInsetX-2*footWall)/2-5, (footH-2*footInsetY-2*footWall)/2, 5]);
                translate([(reflectorW-2*footInsetX-2*footWall)/2-3, 0, 0])
                    #           cube([9, (footH-2*footInsetY-2*footWall)/2-8, 5]);
                translate([(reflectorW-2*footInsetX-2*footWall)/2+8, 0, 0])
                    #           cube([(reflectorW-2*footInsetX-2*footWall)/2-8, (footH-2*footInsetY-2*footWall)/2, 5]);

            }
        }
    }
}

module foot() {
    difference() {
        footStep(1);
       footStep(2);
        footStep(3);
    }
}



module doIt() {
    difference() {
        union() {
            core();
        }
        union() {
            if (wallMount)
                retainersNeg();
            viewPort();
#            reflector();
             acrylic();
           buttonsNeg();
            if (shimsAndRelief)
                cornersRelief();
            if (wallMount)
                cableOut();
        }
    }
             if (shimsAndRelief)
                reflectorShim();
   retainersPos();
    if (wallMount)
        mountPos();
}


// middle
// sectL = [ -5, -5, 5 ];
// sectD = [reflectorW*2+10, reflectorW*2+6+10, 2];
// vertical
sectL = [ -5, -8, 23];
sectD = [ 58, 15, 20];

takeSlice = 0;
test = 0;

if (test) {
    reflector();
}
else {
    if (takeSlice) {
        intersection() {
            doIt();
            translate(sectL)
                #cube(sectD);
        }
    }
    else {
        if (doFoot)
            foot();
        else
            doIt();
    }
}