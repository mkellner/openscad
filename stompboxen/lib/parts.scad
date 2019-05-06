// @2014 - mkellner@robotranch.org
//module potentiometer(angle = 0);
//module sw3pdt();
//module swdp3t();
//module swspst(angle = 0);
//module socket(angle = 90);
//module socketEnclosed(angle = 90);
//module DcJack();
//module smDcJack();
//module ledMount();
//module ledMountSm();

slop = 0.4;

module rotarySwitch(angle = 0) {
	outerCylR = (26 + slop) / 2;
	outerCylD = 12;
	outerRectW = 31;
	outerRectH = 10;
	connectorsR = 20 / 2;
	connectorsD = 6.8;
	shaftR = (8.76 + slop) / 2;
	shaftD = 15;

	tabW = 3.4;
	tabH = 2.6;
	tabD = 2;

	rotate([0, 180, angle])
	translate([0, 0, -outerCylD/2])

	union() {
		cylinder(r = outerCylR, h = outerCylD, center = true);
		translate([0, 0, outerCylD])
			cylinder(r = shaftR, h = shaftD, center = true);
		translate([0, 0, 0])
			cube([outerRectH, outerRectW, outerCylD], center = true);
		rotate([0, 0, 90])
			translate([-tabW/2, -outerCylR-2+tabH/2, outerCylD / 2])
				#cube([tabW, tabH, tabD]);

		translate([0, 0, -outerCylD + connectorsD / 2])
			cylinder(r = connectorsR, h = connectorsD, center = true);
	}
}

module potentiometer(angle = 0) {

	potCylR = (17 + slop) / 2;
	potCylD = 9.3;
	potShaftR = (6.76 + slop) / 2;
	potShaftD = 15;
	potBoard = 12;
	potBoardD = 6.3;
	potTabW = 3.3;
	potTabH = 2.0;
	potTabD = 2;

	rotate([0, 180, angle])
	translate([0, 0, -potCylD/2])

	union() {
		cylinder(r = potCylR, h = potCylD, center = true);
		translate([0, 0, potCylD])
			cylinder(r = potShaftR, h = potShaftD, center = true);
		translate([0, -potCylR, potCylD/2 - potBoardD])
			cube([potBoard, potCylR * 2, potBoardD]);
		translate([-potTabW/2, -potCylR-0.5, potCylD / 2])
			#cube([potTabW, potTabH, potTabD]);
	}
}

module sw3pdt() {
	swBodyW = 18;
	swBodyH = 17;
	swBodyD = 20;
	swShaftR = (11.72 + slop) / 2;
	swShaftD = 12.5;
	swShaft2R = 8 / 2;
	swShaft2D = 5.11;
	swShaft3D = 5;

	rotate([0, 180, 0])
		union() {
			translate([-swBodyW/2, -swBodyH/2, -swBodyD])
				#cube([swBodyW, swBodyH, swBodyD]);
			translate([0, 0, swShaftD / 2]) //  swBodyD + swShaftD/2])
				cylinder(r = swShaftR, h = swShaftD, center = true);
			translate([0, 0, swShaftD + swShaft2D / 2]) //  swBodyD + swShaftD/2])
				cylinder(r = swShaft2R, h = swShaft3D, center = true);
			translate([0, 0, swShaftD + swShaft2D + swShaft3D / 2]) //  swBodyD + swShaftD/2])
				cylinder(r = swShaftR, h = swShaft3D, center = true);
		}
}

module swdp3t(angle = 0) {
    swBodyW = 12.62;
    swBodyH = 13;
    swBodyD = 14.5;
    swShaftR = (5.8 + slop) / 2;
    swShaftD = 8.5;

	tabW = 2.5 + 0.25;
	tabH = 0.75 + 1.25;
	tabD = 2;

	rotate([0, 180, angle])
	union() {
	    translate([-swBodyW/2, -swBodyH/2, -swBodyD])
			#cube([swBodyW, swBodyH, swBodyD]);
		translate([0, 0, swShaftD / 2]) //  swBodyD + swShaftD/2])
			cylinder(r = swShaftR, h = swShaftD, center = true);
		translate([-tabW/2, -6 - tabH/2, 0])
			#cube([tabW, tabH, tabD]);
	}
}

module swspst(angle = 0) {
    swBodyW = 8;
    swBodyH = 13;
    swBodyD = 14.5;
    swShaftR = (5.8 + slop) / 2;
    swShaftD = 8.5;

	tabW = 2.5 + 0.25;
	tabH = 0.75 + 1.25;
	tabD = 2;

	rotate([0, 180, angle])
	union() {
	    translate([-swBodyW/2, -swBodyH/2, -swBodyD])
			#cube([swBodyW, swBodyH, swBodyD]);
		translate([0, 0, swShaftD / 2]) //  swBodyD + swShaftD/2])
			cylinder(r = swShaftR, h = swShaftD, center = true);
		translate([-tabW/2, -6 - tabH/2, 0])
			#cube([tabW, tabH, tabD]);
	}
}

module socket(angle = 90) {
	sktR = (8.67 + slop) / 2;
	sktD = 7.6;
	sktBaseR = 20.40 / 2;
	sktBaseH = 23.6;

	rotate([angle, 0, 90])
		union() {
			cylinder(r = sktR, h = sktD);
			translate([0, 0, -sktBaseH])
			cylinder(r = sktBaseR, h = sktBaseH);
		}
}

module socketEnclosed(angle = 90) {
	sktR = (8.67 + slop) / 2;
	sktD = 5.8;
//	sktBaseR = 20.40 / 2;
	sktBaseR = 15.75;
	sktBaseH = 26;

	rotate([angle, 0, 90])
		union() {
			cylinder(r = sktR, h = sktD);
			translate([-sktBaseR/2, -sktBaseR/2, -sktBaseH])
				cube([sktBaseR, sktBaseR, sktBaseH]);
		}
}

module DcJack(angle = -90) {
	dcJackR = (11.75 + slop) / 2;
	dcJackD = 8;
	dcJackBaseR = 15.50 / 2;
	dcJackBaseH = 11;

	rotate([angle, 0, 0])
		union() {
		    cylinder(r = dcJackR, h = dcJackD);
		    translate([0, 0, -dcJackBaseH])
		    cylinder(r = dcJackBaseR, h = dcJackBaseH);
		}
}

module smDcJack() {
	dcJackR = (7.75 + slop) / 2;
	dcJackD = 5.5;
	dcJackBaseR = 10.75 / 2;
	dcJackBaseH = 15.65;

	rotate([-90, 0, 0])
		union() {
		    cylinder(r = dcJackR, h = dcJackD);
		    translate([0, 0, -dcJackBaseH])
		    cylinder(r = dcJackBaseR, h = dcJackBaseH);
		}
}

module ledMount() {
	ledMountR = (7.75 + slop) / 2;
	ledMountD = 10;
	ledMountBaseR1 = 9 / 2;
	ledMountBaseR2 = 8 / 2;
	ledMountBaseH = 3.8;

	rotate([0, 180, 0])
		union() {
		    cylinder(r1 = ledMountBaseR1, r2 = ledMountBaseR2, h = ledMountBaseH);
		    translate([0, 0, -ledMountD])
			    cylinder(r = ledMountR, h = ledMountD);
		}
}

module ledMountSm() {
	ledMountR = (7 + slop) / 2;
	ledMountD = 6.7;
	ledMountBaseR = 7.9 / 2;
	ledMountBaseH = 0.9;

	rotate([0, 180, 0])
		union() {
		    cylinder(r = ledMountBaseR, h = ledMountBaseH);
		    translate([0, 0, -ledMountD])
			    cylinder(r = ledMountR, h = ledMountD);
		}
}

module 9vBattery() {
	9vW = 26.1;
	9vH = 43.9;
	9vD = 16.9;
	neg = 8.2 / 2;
	pos = 5.7 / 2;
	termD = 3.4;
	termOffset = 6.5;
	capD = 4;
	

	cube([9vW, 9vH, 9vD]);
	translate([termOffset, 0, 9vD / 2])
		rotate([90, 90, 0])
			#cylinder(r = neg, h = termD);
	translate([9vW - termOffset, 0, 9vD / 2])
		rotate([90, 90, 0])
			#cylinder(r = pos, h = termD);
    translate([3, -termD, 3])
        rotate([90, 0, 0])
			minkowski() {
	            cube([9vW-6, 9vD-6, capD]);
				cylinder(r=3);
			}

}

