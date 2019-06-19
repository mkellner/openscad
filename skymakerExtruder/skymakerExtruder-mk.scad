doLands = 0;            // step ups from  x-carriage to extruder mount

skinBreak = 0.01;       // extra depth to poke a hole through a surface

mountWall = 2;

baseW = 86.75;
baseH = 91.5;
baseD = 21;

cutoutFront = 20.39;
cutoutBack = 20.22;
cutoutLeft = 12.33;
cutoutRight = 12.33;

cutoutW = baseW - cutoutLeft - cutoutRight;
cutoutH = baseH - cutoutFront - cutoutBack;
cutoutD = baseD + 1;

A = 20.22;
B = 28.5;
C = 28.5 + 6.5;
C2 = C + 7.6;

F = 91.5;
E = F - 20.39;
D = F - 30.65;

depth1 = 9.1;
depth2 = 10.89;
dOff1 = -1.64;
dOff2 = dOff1 - 2.44;
dOff3 = dOff2 + 2;
dOff4 = -2.19;


module baseframe() {
    translate([0, 0, -baseD])
        cube([baseW, baseH, baseD]);
}

module centercutout() {
    translate([cutoutLeft, cutoutFront, -baseD-skinBreak/2])
        cube([cutoutW, cutoutH, cutoutD+skinBreak]);
}

module sidecutout() {
    translate([-skinBreak/2,D,dOff1])
        cube([baseW+skinBreak, E-D, 10]);
    
    translate([-skinBreak/2,C2-skinBreak/2,dOff2])
        cube([baseW+skinBreak, D-C2+skinBreak, 10]);

    translate([-skinBreak/2,C-skinBreak/2,dOff3])
        cube([baseW+skinBreak, C2-C+skinBreak, 10]);

    // above belt
    translate([-skinBreak/2,B-skinBreak/2,dOff3 - .5])
        cube([baseW+skinBreak, C2-C+skinBreak, 10]);

    translate([-skinBreak/2,A-skinBreak/2,dOff4])
        cube([baseW+skinBreak, B-A+skinBreak, 10]);

}

beltX1 = -20;
beltX2 = -20;
beltY1 = B;
beltY2 = beltY1;
beltZ1 = dOff2;
beltZ2 = dOff2 - 15;    // ?

beltW = baseW + 40;
beltH = 6.5;
beltD = 3.5;

module belts() {
    translate([beltX1, beltY1, beltZ1])
        cube([beltW, beltH, beltD]);
    translate([beltX2, beltY2, beltZ2])
        cube([beltW, beltH, beltD]);
}

module x_carriage() {
    difference() {
        union() {
            baseframe();
        }
        union() {
            centercutout();
            sidecutout();
        }
    }
 #   belts();
}

exBoltX1 = 5.4;
exBoltX2 = baseW - 6.18;
exBoltY =  57;
exBoltZ =  -10;

module extruderMountHoles() {
    // holes to mount extruder assembly
    translate([exBoltX1, exBoltY, exBoltZ])
 #       cylinder(h=20, r=boltHoleR);
    
    translate([exBoltX2, exBoltY, exBoltZ])
 #       cylinder(h=20, r=boltHoleR);
    
}

module moreHoles() {
    translate([80, 40, 35])
        rotate([90, 0, 0])
            cylinder(h=25, r=2);
    translate([80, 40, 15])
        rotate([90, 0, 0])
            cylinder(h=25, r=2);
    translate([65, 40, 35])
        rotate([90, 0, 0])
            cylinder(h=25, r=2);
    translate([65, 40, 15])
        rotate([90, 0, 0])
            cylinder(h=25, r=2);
    translate([7, 19, 10])  // hole in endstop block
        rotate([0, 0, 0])
            cylinder(h=25, r=3.2);
    translate([3, 31, 20])   // holes through endstop block
        rotate([90, 0, 0])
            #cylinder(h=25, r=2.5);
    translate([9, 31, 30])
        rotate([90, 0, 0])
            cylinder(h=25, r=2.5);
    translate([79.3, 40, -15])        // mounting bolt holes
        rotate([0, 0, 0])
            #cylinder(h=25, r=2);
    translate([6.1, 40, -15])        // mounting bolt holes
        rotate([0, 0, 0])
            cylinder(h=25, r=2);

}

module cleanBottom() {
    translate([0, -1, -10])
        #cube([baseW, baseH, 10]);    
}

difference() {
    union() {
    translate([26, 40, -3])
        rotate([90, 0, 90])
            import ("CTC_Aero_bracket.stl", convexity=4);
    translate([-1, 10, 0])      // x-endstop block
        cube([13, 16, 26]);
    translate([0, 25, -1])      // strengthen
        #cube([10.4, 38, 10]);
    translate([74, 25, -1])      // strengthen
        #cube([12, 38, 10]);
    }
    union() {
    translate([0, 0, 0])
       # x_carriage();
 *       extruderMountHoles();
        cleanBottom();
        moreHoles();
    }
}
