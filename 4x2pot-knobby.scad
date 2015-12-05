// @2015 - mkellner@robotranch.orog
$fn=25;

use <lib/parts.scad>;
use <lib/shapes.scad>;

doBox = 1;
doFoot = 2;
doLabelSlice = 3;


perform = doFoot;			// doBox, doFoot or doLabelSlice



textDepth = perform == doFoot ? 3 : 0.7;

wallD = 3;

inBoxW = 44;			// Altoids 58.5
inBoxH = 94;			// Altoids 93.5
inBoxD = 20;			// Altoids 21.5

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
		translate([outBoxW/2, -11.5, inBoxD+2.5-wallD])
			#quarter();

		translate([wallD+footWallD, wallD+footWallD, wallD-3])
			minkowski() {
				cube([inBoxW-(2*footWallD + 6), inBoxH-(2*footWallD + 6), inBoxD+1-wallD]);
				sphere(r=3);
			}


if (0) {
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


module config1() {
	offsetPotX = inBoxW - 12;
	offsetPotY = inBoxH - 11;
	offsetPot2X = 12;
	offsetPot2Y = inBoxH - 11 - 23;
	offsetPot3Y = inBoxH - 11 - 23 - 23;
	offsetPot4Y = inBoxH - 11 - 23 - 23 - 23;
	offsetSWX = 8;
	offsetSWY = inBoxH - 43;
	offsetDCX = inBoxH / 3;
	offsetDCY = inBoxH-.1;
	offsetDCZ = 6;
	offsetJackInX = inBoxW-.1;
	offsetJackInY = 37;
	offsetJackInZ = 10.5;
	offsetJackOutX = .1;
	offsetJackOutY = 37;
	offsetJackOutZ = 10.5;

	difference() {
		box();
        translate([offsetPotX, offsetPotY, 0])
            #potentiometer(angle = 90);
        translate([offsetPotX, offsetPot2Y, 0])
            #potentiometer(angle = 90);
        translate([offsetPotX, offsetPot3Y, 0])
            #potentiometer(angle = 90);
        translate([offsetPotX, offsetPot4Y, 0])
            #potentiometer(angle = 90);
        translate([offsetPot2X, offsetPotY, 0])
            #potentiometer(angle = 90);
        translate([offsetPot2X, offsetPot2Y, 0])
            #potentiometer(angle = 90);
        translate([offsetPot2X, offsetPot3Y, 0])
            #potentiometer(angle = 90);
        translate([offsetPot2X, offsetPot4Y, 0])
            #potentiometer(angle = 90);

		// gap for wires on right
		rotate([90, 180, 270]) {
			translate([offsetJackOutY + 16, -outBoxD+2.3, wallD-5])
                #cube([10, 5, 5]);
		}

		// back face
		rotate([-90, 0, 180]) {
			translate([-(outBoxW/2), -(outBoxD/2)+3, wallD-textDepth])
				label(tx="knobby", sz=8, font="Futura");
		}

if (0) {
		// front face
		rotate([-90, 0, 0]) {
			translate([(offsetDCX)-12, -offsetDCZ, (outBoxH + wallD) -textDepth])
				label(tx="front", sz=7, font="Futura");
		}

		// right face
		rotate([90, 180, 270]) {
			translate([offsetJackOutY + 16, -offsetJackOutZ, wallD-textDepth])
				label(tx="right", sz=8, font="Futura");
		}

		// left face
		rotate([90, 180, 90]) {
			translate([-offsetJackInY -37, -offsetJackInZ, offsetJackInX+wallD-textDepth])
				label(tx="left", sz=8, font="Futura", depth=2);
		}

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