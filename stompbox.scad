// @2014 - mkellner@robotranch.orog
$fn=30;

use <lib/parts.scad>;
use <lib/shapes.scad>;

wallD = 3;

inBoxW = 62;			// Altoids 58.5
inBoxH = 98;			// Altoids 93.5
inBoxD = 26;			// Altoids 21.5

outBoxW = inBoxW; // + wallD * 2;
outBoxH = inBoxH; // + wallD * 2;
outBoxD = inBoxD + wallD;

module label(tx = "label", sz = 5, depth=1, font = "Courier", halign = "center", valign = "center") {
	linear_extrude(height = depth)
		text(tx, size=sz, font=font, halign=halign, valign=valign);

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

module config1() {		// good for HogsFoot, Screaming Bird
	offsetStompX = 12;
	offsetStompY = 15;
	offsetLEDX = inBoxW - 12;
	offsetLEDY = 15;
	offsetPotX = inBoxW - 12;
	offsetPotY = inBoxH - 12;
	offsetDCX = 18;
	offsetDCY = inBoxH-.1;
	offsetDCZ = 10;
	offsetJackInX = inBoxW-.1;
	offsetJackInY = 37;
	offsetJackInZ = 10.5;
	offsetJackOutX = .1;
	offsetJackOutY = 37;
	offsetJackOutZ = 10.5;

	difference() {
		box();
		translate([offsetStompX, offsetStompY, 0])
			#color([0,0,1]) sw3pdt();
		translate([offsetLEDX, offsetLEDY, -wallD])
			#ledMount();
		translate([offsetPotX, offsetPotY, 0])
			#potentiometer(angle = 50);
		translate([offsetDCX, offsetDCY, offsetDCZ])
			#smDcJack();
		translate([offsetJackInX, offsetJackInY, offsetJackInZ])
			#socket(angle = 90);
		translate([offsetJackOutX, offsetJackOutY, offsetJackOutZ])
			#socket(angle = 270);

		// inside
		#rotate([0, 0, 90]) {
			translate([61, -6, -1])
				rotate([0, 0, 180])
					label(tx="@2014 pyreman", sz=7.2, font="Futura");
			translate([50, -30, -1])
				rotate([0, 0, 180])
					label(tx="robotranch.org", sz=10, font="Futura");
		}


		// back face
		rotate([-90, 0, 180]) {
			translate([-(outBoxW/2), -(outBoxD/3)+2, wallD-1])
				label(tx="Orange", sz=7.5, font="Futura");
			translate([-(outBoxW/2), -2*(outBoxD/3)+2, wallD-1])
				label(tx="Squeeze", sz=7.5, font="Futura");
		}

		// front face
		rotate([-90, 0, 0]) {
			translate([(offsetDCX)-12, -offsetDCZ, (outBoxH + wallD) -1])
				label(tx="9v", sz=7, font="Futura");
			translate([(offsetDCX)+12, -offsetDCZ, (outBoxH + wallD) -1])
				centerPos(size=5);
//				label(tx="center", sz=3.5, font="Futura");
//			translate([(offsetDCX)+7, -19.5, (outBoxH + wallD) -1])
//				label(tx="+", sz=3.5, font="Futura");
		}

		// right face
		rotate([90, 180, 270]) {
			translate([offsetJackOutY + 16, -offsetJackOutZ, wallD-0.95])
				label(tx="out", sz=9, font="Futura");
			translate([offsetJackOutY + 39, -offsetJackOutZ, wallD-0.95])
				arrow(width=20, height=10, depth=1);
		}

		// left face
		rotate([90, 180, 90]) {
			translate([-offsetJackInY -37, -offsetJackInZ, offsetJackInX+wallD-1])
				label(tx="in", sz=9, font="Futura", depth=2);
			translate([-offsetJackInY -19, -offsetJackInZ-1, offsetJackInX+wallD-1])
				arrow(width=20, height=10, depth=2);
		}

	}

}

config1();
