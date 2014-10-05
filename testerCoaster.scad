
nineVW = 53;
nineVH = 17;
nineVD = 8;

wallD = 3;

innerW = 82;
innerH = 57.5;
innerD = 4;

outerW = innerW + 2*wallD;
outerH = innerH + 2*wallD;
outerD = innerD + wallD;


difference() {
	cube([outerW, outerH, outerD]);
	translate([wallD, wallD, wallD])
		cube([innerW, innerH, innerD+1]);
	
}

translate([(outerW-nineVW-wallD*2)/2, -nineVH-wallD, 0])
difference() {
	cube([nineVW+2*wallD, nineVH+2*wallD, nineVD+wallD]);
	translate([wallD, wallD, wallD])
		cube([nineVW, nineVH, nineVD+1]);
}

