// ©2019 Michael Kellner
// http://www.robotranch.org
//
// holder for a wireless phone charger (https://amzn.to/2I4xsDQ)
// thing: 3546610
$fn = 30;

// 3 actions. Pick one.
doTest = 1;                 // for trying things out
doLid = 2;                  // flat or with a cutout for S6 (see below)
doBase = 3;                 // base that holds the electronics

ACTION = doLid;

// for the lid, set this to 1 if you want the guide for the S6
optionS6Cutout = 1;

fudge = 0.3;
breakSkin = .005;

holeScale = 1.05;

coilR = 50 / 2 + 1;
coilH = 2+ 2 + fudge;

pcbW = 33 + fudge;
pcbH = 30 + fudge;
pcbD = 1 + 4;

s6W = 71 + fudge;
s6H = 143 + fudge;
s6D = 7.5;


module coil() {
    cylinder(r = coilR, h = coilH);
}

module pcb() {
    translate([0, 0, 0])
    rotate([0, 0, 90])
        #cube([pcbW, pcbH, pcbD]);
}

wiregapW = 15;
wiregapH = 30;
wiregapD = coilH + pcbD;
wiregapX = -2 + coilR -wiregapW / 2;
wiregapY = -wiregapH / 2;
wiregapZ = 0;

usbW = 30;
usbH = 10 + 5;
usbD = 7 + 4;
usbX = -40;
usbY = -usbH/2;
usbZ = -2.5;

module wiregap() {
    translate([wiregapX, wiregapY, wiregapZ])
        cube([wiregapW, wiregapH, wiregapD]);
}

module usbgap() {
   translate([usbX, usbY, usbZ])
        cube([usbW, usbH, usbD]);
}


screwHeadH = 2;
screwHeadD = 5;

module screw(size=2.5, length=10) {
    cylinder(r=(size/2)*holeScale, h=length);
    cylinder(r1=(screwHeadD/2)*holeScale, r2=(size/2)*holeScale, h=screwHeadH);
}

minkR = 5;
baseW = s6W - 2*minkR;
baseH = baseW;
baseD = 10 ;
baseX = -baseW/2;
baseY = -baseH/2;
baseZ = 1;

lidW = baseW + (2 * optionS6Cutout);
lidH = baseH;
lidD = 3;
lidX = baseX + (-1 * optionS6Cutout);
lidY = baseY;
lidZ = -lidD - .5;

screwOffset = baseW/2 - 5;
screwZ = -4 - breakSkin;

module lidScrews() {
#           translate([-screwOffset, -screwOffset, screwZ])
                screw();
            translate([ screwOffset, -screwOffset, screwZ])
                screw();
            translate([ screwOffset,  screwOffset, screwZ])
                screw();
            translate([-screwOffset,  screwOffset, screwZ])
                screw();
}

module positive() {
    translate([baseX, baseY, baseZ-.5])
        minkowski() {
            cube([baseW, baseH, baseD]);
            cylinder(r=minkR, h=1, center=true);
        }
}

module negative() {
    coil();
    translate([pcbW/2, -pcbH/2-2, coilH])
        pcb();
    wiregap();
    usbgap();
    lidScrews();
}

module base() {
    difference() {
        positive();
   #    negative();
    }
}

module s6() {
    translate([-s6W/2+2.5, -s6H/2, 0])
        minkowski() {
            cube([s6W-5, s6H-5, s6D-3]);
            sphere(r=2.5);
        }
}

module lid() {
    difference() {
        union() {
            translate([lidX, lidY, lidZ])
                minkowski() {
                    cube([lidW, lidH, lidD]);
                    if (optionS6Cutout)
                            sphere(r=minkR, h=1, center=true);
                    else
                        cylinder(r=minkR, h=1, center=true);
                }
        }
        union() {
            lidScrews();
            if (optionS6Cutout) {
                translate([0, 0, -11+breakSkin*2])
                    s6();
            }
            translate([-10-lidW/2, -10-lidH/2, 0])
                cube([lidW+20, lidH+20, lidD+20]);
        }
    }
}

rotate([180, 0, 0])
if (ACTION == doTest) {
    lid();
     difference() {
        base();
        lidScrews();
    }
 *   negative();
}
else if (ACTION == doBase)
    #base();
else if (ACTION == doLid)
        lid();



* #s6();