
module potentiometer(angle = 0) {

	potCylR = 17.04 / 2;
	potCylD = 9.3;
	potShaftR = 6.76 / 2;
	potShaftD = 15;
	potBoard = 12;
	potBoardD = 6.3;
	potTabW = 2.8;
	potTabH = 1.2;
	potTabD = 2.5;

	rotate([0, 180, angle])
	translate([0, 0, -potCylD/2])

	union() {
		cylinder(r = potCylR, h = potCylD, center = true);
		translate([0, 0, potCylD])
			cylinder(r = potShaftR, h = potShaftD, center = true);
		translate([0, -potCylR, potCylD/2 - potBoardD])
			cube([potBoard, potCylR * 2, potBoardD]);
		translate([-potTabW/2, -potCylR, potCylD / 2])
			#cube([potTabW, potTabH, potTabD]);
	}
}

module sw3pdt() {
	swBodyW = 18;
	swBodyH = 17;
	swBodyD = 20;
	swShaftR = 11.72 / 2;
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

module swdp3t() {
    swBodyW = 12.62;
    swBodyH = 13;
    swBodyD = 14.5;
    swShaftR = 5.8 / 2;
    swShaftD = 8.5;

	rotate([0, 180, 0])
	union() {
	    translate([-swBodyW/2, -swBodyH/2, -swBodyD])
			#cube([swBodyW, swBodyH, swBodyD]);
		translate([0, 0, swShaftD / 2]) //  swBodyD + swShaftD/2])
			cylinder(r = swShaftR, h = swShaftD, center = true);
	}
}

module socket(angle = 90) {
	sktR = 8.67 / 2;
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

module smDcJack() {
	dcJackR = 7.75 / 2;
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
	ledMountR = 7.75 / 2;
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

