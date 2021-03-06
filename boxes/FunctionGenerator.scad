// @2014 - mkellner@robotranch.orog
$fn=25;

use <lib/parts.scad>;
use <lib/shapes.scad>;

doBox = 1;
doFoot = 2;
doLabelSlice = 3;


perform = doBox;			// doBox, doFoot or doLabelSlice

crossHatch = 0;

textDepth = (perform == doFoot) ? 2.5 : 0.7;		// 3 with crosshatch

wallD = 3;

inBoxW = 62;			// Altoids 58.5
inBoxH = 98;			// Altoids 93.5
inBoxD = 29.5;			// Altoids 21.5

outBoxW = inBoxW; // + wallD * 2;
outBoxH = inBoxH; // + wallD * 2;
outBoxD = inBoxD + wallD;

footD = 4.2;
footWallD = 3;

quarterR = 26.5 / 2;
quarterH = 2;


module quarter() {
	cylinder(r=quarterR,h=quarterH+5,center=true);
}

module PCB(width, height, pcbZ=1, componentZ=16, traceZ = 3) {
translate([3, inBoxH - height, 13]) {
//	cube([width, height, pcbZ]);
//	translate([5, 5, pcbZ])
//		cube([width - 10, height - 10, componentZ]);
//	translate([5, 5, -traceZ])
//		cube([width - 10, height - 10, traceZ]);
}
	difference() {
		union() {
		translate([wallD-3.5, inBoxH - height, 0])
			cube([13.5, 8.5, 13]);
		translate([wallD + 46.50, inBoxH - height, 0])
			cube([12.5, 8.5, 13]);
		}
		translate([wallD + 3.85, inBoxH - height + 3.85, 5])
			#cylinder(r=1, h=16);
		translate([wallD + 3.85 + 46.50, inBoxH - height + 3.85, 5])
			#cylinder(r=1, h=16);
	}
}
//PCB(56, 51);


module label(tx = "label", sz = 5, depth=1, font = "Courier", halign = "center", valign = "center") {
	linear_extrude(height = depth)
		text(tx, size=sz, font=font, halign=halign, valign=valign);

}
module foot() {
	difference()
		{
		translate([0, 0, -wallD + inBoxD])
			minkowski() {
				cube([outBoxW, outBoxH, footD + wallD]);
				cylinder(r=3,h=.5);
			}
		translate([-wallD, -wallD, -wallD/2-.2])
			rotate([2,0,0])
				cube([outBoxW + 2*wallD, wallD+1, outBoxD]);
		translate([-wallD, outBoxH-1, -wallD/2-.2])
			rotate([-2,0,0])
				cube([outBoxW + 2*wallD, wallD+1, outBoxD]);
		translate([-wallD, -wallD, -wallD/2-.2])
			rotate([0,-2,0])
				cube([wallD+1, outBoxH + 2*wallD, outBoxD]);
		translate([outBoxW-1, -wallD, -wallD/2-.2])
			rotate([0,2,0])
				cube([wallD+2, outBoxH + 2*wallD, outBoxD]);

		translate([0, -11, outBoxD-10-wallD/2-.2])
			rotate([0, 0, 45])
				cube([10, 20, 10]);
		translate([-10.5, outBoxH, outBoxD-10-wallD/2-.2])
			rotate([0, 0, -45])
				cube([10, 20, 10]);
		translate([outBoxW-5, -1, outBoxD-10-wallD/2-.2])
			rotate([0, 0, -45])
				cube([10, 20, 10]);
		translate([outBoxW+1, outBoxH-5, outBoxD-10-wallD/2-.2])
			rotate([0, 0, 45])
				cube([10, 20, 10]);

		//config1();
		box();
		translate([outBoxW/2, -11, inBoxD+2.5-wallD])
			quarter();

		translate([wallD+footWallD, wallD+footWallD, wallD-3])
			minkowski() {
				cube([inBoxW-(2*footWallD + 6), inBoxH-(2*footWallD + 6), inBoxD+1-wallD]);
				sphere(r=3);
			}

if (crossHatch == 1) {
	for (i = [-60 : 10 : 60 ]) {
		translate([-i, -15, inBoxD+wallD+2.2])
			rotate([0, 0, -30])
				minkowski() {
					cube([1, outBoxH*2, 1]);
					sphere(r=1);
				}
	}
	for (i = [-120 : 10 : 0 ]) {
		translate([-i, -5, inBoxD+wallD+2.2])
			rotate([0, 0, 30])
				minkowski() {
					cube([1, outBoxH*2, 1]);
					sphere(r=1);
				}
	}
}
if (1) {
		rotate([0, 0, 90])
			{
				translate([50, -30, outBoxD + wallD -textDepth+.9])
					label(tx="robotranch", sz=14, font="Futura", depth=textDepth);
				translate([50, -50, outBoxD + wallD -textDepth+.9])
					label(tx=".org", sz=14, font="Futura", depth=textDepth);
				translate([50, -10, outBoxD + wallD -textDepth+.9])
					label(tx="2014", sz=14, font="Futura", depth=textDepth);
			}
}
	}
}

module box() {
	difference() {
//		translate([-wallD, -wallD, -wallD])
		translate([0, 0, -wallD])
			minkowski() {
				cube([outBoxW, outBoxH, outBoxD]);
				cylinder(r=3,h=.5);
			}
		cube([inBoxW, inBoxH, inBoxD+1]);

	}
}

//translate([0, 0, 0])
//	potentiometer();
// sw3pdt();
//socket();
//smDcJack();
//ledMount();
//swdp3t();

module config1() {
	offsetOnX = 7;
	offsetOnY = 33;
	offsetSWX = 20;
	offsetSWY = 33;

	offsetLEDX = offsetOnX; //  + (offsetSWX - offsetOnX) / 2;
	offsetLEDY = 48;

	offsetPotX = inBoxW - 22;
	offsetPotY = inBoxH - 18.5;
	offsetPot2X = 12;
	offsetPot2Y = inBoxH - 25;

	offsetPot3X = inBoxW - 12;
	offsetPot3Y = inBoxH - 40;
	offsetPot4X = offsetPot3X - 20;
	offsetPot4Y = inBoxH - 40;

	offsetSqX = inBoxW - 9;
	offsetSqY = 33;
	offsetTriX = offsetSqX - 17;
	offsetTriY = offsetSqY;

	offsetDCX = inBoxH / 3;
	offsetDCY = inBoxH-.1;
	offsetDCZ = 6;

	offsetJackInX = inBoxW-.1;
	offsetJackInY = 37;
	offsetJackInZ = 10.5;
	offsetJackOutX = .1;
	offsetJackOutY = 37;
	offsetJackOutZ = 10.5;

	batX = 15;
	batY = 18;
	batZ = 27;

	difference() {
		box();
		translate([offsetOnX, offsetOnY, 0])
			#swspst(180);
		translate([offsetLEDX, offsetLEDY, -wallD])
			#ledMount();
		translate([offsetSWX, offsetSWY, 0])
			#swdp3t(180);
		translate([offsetPotX, offsetPotY, 0])
			#rotarySwitch(angle = 90);
		translate([offsetPot2X, offsetPot2Y, 0])
			#potentiometer(angle = 90);
		translate([offsetPot3X, offsetPot3Y, 0])
			#potentiometer(angle = 90);
		translate([offsetPot4X, offsetPot4Y, 0])
			#potentiometer(angle = 90);
		translate([offsetSqX, offsetSqY, 0])
			#DcJack(180);
		translate([offsetTriX, offsetTriY, 0])
			#DcJack(180);
*		translate([offsetDCX, offsetDCY, offsetDCZ])
			#smDcJack();
*		translate([offsetJackInX, offsetJackInY, offsetJackInZ])
			#socket(angle = 90);
*		translate([offsetJackOutX, offsetJackOutY, offsetJackOutZ])
			#socket(angle = 270);
		translate([batX, batY, batZ])
			rotate([90, 90, 0])
				#9vBattery();

		// top face
*		rotate([180, 0, 180]) {
			#translate([-(outBoxW/2), 19, wallD-textDepth])
				label(tx="Function", sz=8, font="Futura");
			translate([-(outBoxW/2), 9, wallD-textDepth])
				label(tx="Generator", sz=8, font="Futura");
		}

		// back face
		rotate([-90, 0, 180]) {
			#translate([-(outBoxW/2), -(outBoxD/3)+2.8, wallD-textDepth])
				label(tx="Function", sz=8, font="Futura");
			translate([-(outBoxW/2), -2*(outBoxD/3)+2, wallD-textDepth])
				label(tx="Generator", sz=8, font="Futura");
		}

		// front face
*		rotate([-90, 0, 0]) {
			translate([(offsetDCX)-12, -offsetDCZ, (outBoxH + wallD) -textDepth])
				label(tx="9v", sz=7, font="Futura");
			translate([(offsetDCX)+12, -offsetDCZ, (outBoxH + wallD) -textDepth])
				centerPos(size=4.8);
//				label(tx="center", sz=3.5, font="Futura");
//			translate([(offsetDCX)+7, -19.5, (outBoxH + wallD) -1])
//				label(tx="+", sz=3.5, font="Futura");
		}

		// right face
*		rotate([90, 180, 270]) {
			translate([offsetJackOutY + 16, -offsetJackOutZ, wallD-textDepth])
				label(tx="out", sz=8, font="Futura");
*			translate([offsetJackOutY + 39, -offsetJackOutZ, wallD-textDepth])
				arrow(width=20, height=10, depth=1);
		}

		// left face
		*rotate([90, 180, 90]) {
			translate([-offsetJackInY -37, -offsetJackInZ, offsetJackInX+wallD-textDepth])
				label(tx="in", sz=8, font="Futura", depth=2);
			translate([-offsetJackInY -19, -offsetJackInZ-1, offsetJackInX+wallD-textDepth])
				arrow(width=20, height=10, depth=2);
		}

	}

	translate([-wallD, 19, 0])
		rotate([0, 0, 0])
			cube([outBoxW + 2*wallD, 4, outBoxD/2]);
}

if (0) {
	swspst();
} else {
	if (perform == doBox) {
		config1();
	} else if (perform == doFoot) {
		foot();
	} else if (perform == doLabelSlice) {
		translate([0, 0, 2])
		projection(cut = false)
			config1();
	}
}