$fn = 30;

test = 1;
doLid = 2;
doBase = 3;

ACTION = doBase;

fudge = 0.3;
breakSkin = .005;

holeScale = 1.02;

coilR = 50 / 2;
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
    cube([pcbW, pcbH, pcbD]);
}

wiregapW = 15;
wiregapH = 20;
wiregapD = coilH + pcbD;
wiregapX = -2 + coilR -wiregapW / 2;
wiregapY = -wiregapH / 2;
wiregapZ = 0;

usbW = 30;
usbH = 10 + 5;
usbD = 8 + 1;
usbX = -45;
usbY = -usbH/2;
usbZ = 0;

module wiregap() {
    translate([wiregapX, wiregapY, wiregapZ])
        cube([wiregapW, wiregapH, wiregapD]);
}

module usbgap() {
   translate([usbX, usbY, usbZ])
        cube([usbW, usbH, usbD]);
}

module s6() {
    translate([-s6W/2, -s6H/2, 0])  
        #cube([s6W, s6H, s6D]);
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

lidW = baseW;
lidH = baseH;
lidD = 3;
lidX = baseX;
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
    translate([-pcbW/2, -pcbH/2, coilH])
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


module lid() {
    difference() {
        translate([lidX, lidY, lidZ])
            minkowski() {
                cube([lidW, lidH, lidD]);
                cylinder(r=minkR, h=1, center=true);
            }
        lidScrews();
    }
}

if (ACTION == doTest) {
    lid();
    difference() {
        base();
        lidScrews();
    }
}
else if (ACTION == doBase)
    #base();
else if (ACTION == doLid)
    lid();


* #s6();