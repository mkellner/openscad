// @2014 - mkellner@robotranch.orog
$fn=30;

use <lib/parts.scad>;

wallD = 3;

inBoxW = 60;			// Altoids 58.5
inBoxH = 94;			// Altoids 93.5
inBoxD = 22;			// Altoids 21.5

outBoxW = inBoxW; // + wallD * 2;
outBoxH = inBoxH; // + wallD * 2;
outBoxD = inBoxD + wallD;


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
	offsetStompX = 15;
	offsetStompY = 15;
	offsetLEDX = inBoxW - 15;
	offsetLEDY = 15;
	offsetPotX = inBoxW - 10;
	offsetPotY = inBoxH - 10;
	offsetDCX = 15;
	offsetDCY = inBoxH-.1;
	offsetDCZ = 10;
	offsetJackInX = inBoxW;
	offsetJackInY = 40;
	offsetJackInZ = 10.5;
	offsetJackOutX = 0;
	offsetJackOutY = 40;
	offsetJackOutZ = 10.5;

	difference() {
		#box();
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

	}
}

config1();
