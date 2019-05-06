
nineVW = 53 + 1;
nineVH = 17 + 1;
nineVD = 10;

wallD = 2.3;

innerW = 82 + 1.3;
innerH = 57.5 + 1.75;
innerD = 6;

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

