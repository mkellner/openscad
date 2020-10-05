$fn = 35;

buttons = 0;

ease = .15;
acrylicGrowth = 1.5;

reflectorW = 87 + ease*2 + acrylicGrowth;
reflectorH = 44 + ease*2 + acrylicGrowth;
reflectorD = 10;

clockCoreD = 22; // 18;  7 - 22
coreOffset = [ 0, 0, -.5 ];

acrylicDepth = 3.175 + .3;

minkowskiR = 5;
wallThickness = 3;

reflectorOffset = [-wallThickness/2, -wallThickness/2, -acrylicDepth];

buttonsH = 20 * buttons;

coreCubeDim = [ reflectorW-wallThickness, reflectorH-wallThickness + buttonsH, clockCoreD ];

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
 #      cube([reflectorW, reflectorH, acrylicDepth]);
}

module ledMountSm() {
    ledSlop = 0.6;      // was .4
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

buttonsNegLoc = [ [ 0, 48, 0 ], [ 0, 45, acrylicDepth + 7 ] ];
buttonsNegDim = [ [ reflectorW, buttonsH-2, 20 ], [ reflectorW, buttonsH, 20 ], ];
buttonsNegNum = 1;

buttonsLoc = [ [ 15, 55, -5 ], [ reflectorW - 15, 55, -5 ] ];
buttonsNum = 1;

module buttonsNeg() {
    translate(reflectorOffset) {
        for (i=[0:1:buttonsNegNum])
            translate(buttonsNegLoc[i])
                cube(buttonsNegDim[i]);
    
        for (i=[0:1:buttonsNum])
            translate(buttonsLoc[i])
 #               ledMountSm();
    }
}

module core() {
    difference() {
        translate(coreOffset)
        minkowski() {
            cube(coreCubeDim);
            cylinder(r=minkowskiR, h=reflectorD, center=true);
        }
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

retainersLoc = [ [ 20, -1.18, -6 ], [ 70, -1.18, -6 ],
                [ 15, 45.3, -13], [65, 45.3, -13],
];
retainerRot = [ [ 0, 0, 0], [0, 0, 0], 
            [ 0, 0, 180], [0, 0, 180] ];
retainersNum = 3;

module retainersNeg() {
    for (i=[0:1:retainersNum])
        translate(retainersLoc[i])
            rotate(retainerRot[i])
            retainerNeg();
}

module retainersPos() {
    for (i=[0:1:retainersNum])
        translate(retainersLoc[i])
            rotate(retainerRot[i])
            retainerPos();
}

module viewPort() {
    viewPortLoc = [ minkowskiR+2, minkowskiR+1.5, -2 ];
    viewPortDim = [ reflectorW-minkowskiR*2-7, reflectorH-minkowskiR*2-7, 12 ];
    translate(viewPortLoc)
        minkowski() {
            cube(viewPortDim);
            cylinder(r=minkowskiR, h=clockCoreD, center=true);
        }
}

cornersReliefH = clockCoreD + acrylicDepth + 2;
cornersReliefR = 1;
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

module doIt() {
    difference() {
        union() {
            core();
 *           #reflector();
 *           #acrylic();
            reflectorShim();
        }
        retainersNeg();
        viewPort();
        buttonsNeg();
        cornersRelief();
    }
    retainersPos();
}


// middle
// sectL = [ -5, -5, 5 ];
// sectD = [reflectorW*2+10, reflectorW*2+6+10, 2];
// vertical
sectL = [ 33, -5, -40 ];
sectD = [ 20, reflectorW*2+10, reflectorW*2+10];

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
                cube(sectD);
        }
    }
    else {
        doIt();
    }
}