// @2014 - mkellner@robotranch.orog
$fn=25;

use <lib/parts.scad>;
use <lib/shapes.scad>;

doBox = 1;
doFoot = 2;
doLabelSlice = 3;


perform = doBox;			// doBox, doFoot or doLabelSlice



textDepth = 3.5;

wallD = 3;			// 2.5 == !!!! SMALLER WALL DEPTH ATTEMPT

inBoxW = 62;			// Altoids 58.5
inBoxH = 98;			// Altoids 93.5
inBoxD = 29.5;			// Altoids 21.5

outBoxW = inBoxW; // + wallD * 2;
outBoxH = inBoxH; // + wallD * 2;
outBoxD = inBoxD + wallD;

footD = 4;
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
		translate([outBoxW/2, -11.5, inBoxD+2-wallD])
			#quarter();

		translate([wallD+footWallD+.5, wallD+footWallD+.5, wallD-3])
			minkowski() {
				cube([inBoxW-(2*footWallD + 6), inBoxH-(2*footWallD + 6), inBoxD+1-wallD]);
				sphere(r=3);
			}

if (0) {
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
				translate([50, -30, outBoxD + wallD +1.5 -textDepth])
					#label(tx="robotranch", sz=14, font="Futura", depth=textDepth);
				translate([50, -50, outBoxD + wallD +1.5 -textDepth])
					#label(tx=".org", sz=14, font="Futura", depth=textDepth);
				translate([50, -10, outBoxD + wallD +1.5 -textDepth])
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
				cylinder(r=wallD,h=.5);
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

module config1() {		// good for HogsFoot, Screaming Bird
	offsetStompX = 12;
	offsetStompY = 15;
	offsetLEDX = inBoxW - 12;
	offsetLEDY = 15;
	offsetPotX = inBoxW - 12;
	offsetPotY = inBoxH - 12;
	offsetPot2X = 12;
	offsetPot2Y = inBoxH - 12;
	offsetPot3X = inBoxW / 2;
	offsetPot3Y = inBoxH - 35;
	offsetSWX = 8;
	offsetSWY = inBoxH - 43;
	offsetDCX = inBoxW / 2;
	offsetDCY = inBoxH-.1;
	offsetDCZ = 10;
	offsetJackInX = inBoxW-.1;
	offsetJackInY = 37;
	offsetJackInZ = 12.5;
	offsetJackOutX = .1;
	offsetJackOutY = 37;
	offsetJackOutZ = 12.5;

	difference() {
		box();
		translate([offsetStompX, offsetStompY, 0])
			#color([0,0,1]) sw3pdt();
		translate([offsetLEDX, offsetLEDY, -wallD])
			#ledMount();
		translate([offsetPotX, offsetPotY, 0])
			#potentiometer(angle = 90);
		translate([offsetPot2X, offsetPot2Y, 0])
			#potentiometer(angle = 90);
		translate([offsetPot3X, offsetPot3Y, 0])
			#potentiometer(angle = 270);
//		translate([offsetSWX, offsetSWY, 0])
//			#swspst();
		translate([offsetDCX, offsetDCY, offsetDCZ])
			#DcJack();
		translate([offsetJackInX, offsetJackInY, offsetJackInZ])
			#socket(angle = 90);
		translate([offsetJackOutX, offsetJackOutY, offsetJackOutZ])
			#socket(angle = 270);


		// back face
		rotate([-90, 0, 180]) {
			translate([-(outBoxW/2), -(outBoxD/3)+3, wallD-1])
				#label(tx="Deep Blue", sz=8, font="Futura");
			translate([-(outBoxW/2), -2*(outBoxD/3)+2, wallD-1])
				label(tx="Delay", sz=8, font="Futura");
		}

		// front face
		rotate([-90, 0, 0]) {
			translate([(offsetDCX)-15, -offsetDCZ, (outBoxH + wallD) -1])
				label(tx="9v", sz=7, font="Futura");
			translate([(offsetDCX)+15, -offsetDCZ, (outBoxH + wallD) -1])
				centerPos(size=4.8);
//				label(tx="center", sz=3.5, font="Futura");
//			translate([(offsetDCX)+7, -19.5, (outBoxH + wallD) -1])
//				label(tx="+", sz=3.5, font="Futura");
		}

		// right face
		rotate([90, 180, 270]) {
			translate([offsetJackOutY + 16, -offsetJackOutZ, wallD-1])
				label(tx="out", sz=8, font="Futura");
			translate([offsetJackOutY + 39, -offsetJackOutZ, wallD-1])
				arrow(width=20, height=10, depth=1);
		}

		// left face
		rotate([90, 180, 90]) {
			translate([-offsetJackInY -37, -offsetJackInZ, offsetJackInX+wallD-1])
				label(tx="in", sz=8, font="Futura", depth=2);
			translate([-offsetJackInY -19, -offsetJackInZ-1, offsetJackInX+wallD-1])
				arrow(width=20, height=10, depth=2);
		}

	}

}

if (perform == doBox) {
	config1();
} else if (perform == doFoot) {
	foot();
} else if (perform == doLabelSlice) {
	translate([0, 0, 2])
	projection(cut = false)
		config1();
}