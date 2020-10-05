

refDepth = 14;
skinBreak = 0.05;

cX = 69.85 / 2;
cY = 68.58 / 2;

ztar = [
[33.02 -cX,68.32 -cY],
[36.70 -cX,68.32 -cY],
[44.07 -cX,43.56 -cY],
[68.20 -cX,44.83 -cY],
[69.47 -cX,40.00 -cY],
[49.02 -cX,26.80 -cY],
[59.82 -cX,3.30 -cY],
[55.75 -cX,0.00 -cY],
[34.93 -cX,16.38 -cY],
[14.99 -cX,0.00 -cY],
[11.05 -cX,2.67 -cY],
[21.08 -cX,26.67 -cY],
[0.00 -cX,40.89 -cY],
[2.54 -cX,46.23 -cY],
[26.80 -cX,43.94 -cY]];

bcX = 35.56;
bcY = 31.75;
xbarz = [
[33.02,33.02],
[24.13,44.45],
[26.67,44.45],
[34.29,33.02],
[35.56,33.02],
[43.18,44.45],
[44.45,43.18],
[36.83,33.02],
[36.83,30.48],
[49.53,27.94],
[49.53,25.40],
[36.83,30.48],
[35.56,30.48],
[35.56,16.51],
[34.29,15.24],
[34.29,30.48],
[33.02,30.48],
[20.32,25.40],
[20.32,27.94],
[33.02,31.75],
[33.02,33.02]
];


barzPoly = [
[33.02,32.51],
[24.64,44.20],
[27.18,44.70],
[33.40,33.91],
[36.32,33.91],
[43.69,44.20],
[44.83,43.56],
[37.47,34.04],
[37.47,30.99],
[49.91,27.43],
[49.40,25.65],
[37.33,29.72],
[35.31,29.72],
[35.43,16.13],
[34.16,16.13],
[34.29,29.60],
[31.37,29.72],
[20.57,25.40],
[20.07,27.69],
[32.26,30.99],
[32.26,33.66]
];

barzNeg = [
[ /* top */
[33.27,67.31],
[36.50,67.31],
[42.93,43.69],
[35.81,33.53],
[33.78,33.53],
[27.94,43.43] ],
[ /* right */
[44.32,42.93],
[67.44,44.20],
[68.58,40.51],
[48.77,27.81],
[36.45,31.62],
[36.45,32.51] ],
[ /* bot right */
[35.31,30.48],
[48.26,25.78],
[58.55,3.69],
[55.63,1.52],
[35.69,17.15]],
[ /* bot left */
[22.23,26.54],
[33.66,30.35],
[34.04,17.27],
[15.11,1.02],
[12.32,3.05]],
[ /* left */
[3.30,45.47],
[25.78,43.05],
[33.15,32.64],
[33.15,31.37],
[21.72,28.07],
[1.65,41.15]]

];

//    translate([-cX, -cY, 0])

module arms(d, sc=1) {
    rotate([180,0,0])
    translate([-cX, -cY, -d/2])
            linear_extrude(height = d, center=true, scale=sc)
                polygon(barzPoly);
}

module armsNeg(d, sc=1) {
    rotate([180,0,0])
        translate([-cX, -cY, -d/2-skinBreak]) {
            for (seg = barzNeg) {
                linear_extrude(height = d, center=true, scale=sc)
                    polygon(seg);
            }
        }
}


module star(d, sc = 1) {
    rotate([180,0,0])
    translate([0, 0, -d/2])
            linear_extrude(height = d, center=true, scale=sc)
                polygon(ztar);
}

module xstar(d, sc = 1, sc2) {
    rotate([180,0,0])
    translate([0, 0, -d/2])
        scale([sc2, sc2, 1])
            linear_extrude(height = d, center=true, scale=sc)
                polygon(ztar);
}

boardD = 2.5;

hW = 15;
hH = 15;
hD = boardD;
hX = -hW/2;
hY = -45;
hZ = refDepth - hD;
module casedStar() {
    union() {
    difference() {
        scale([1.1, 1.1, 1])
            star(refDepth);
        union() {
            // inner gap for board support
            translate([0, 0,refDepth +skinBreak-boardD])
                scale([1.01, 1.01, 1])
               star(boardD);
            // arm holes
            translate([0, 0, -skinBreak*2])
             armsNeg(refDepth);

            //reflector hole
         translate([0, 0, -skinBreak])
                scale([1.01, 1.01, 1])
#               xstar(boardD, 1.01, .95);

        }
    }
//    translate([0, 0, boardD])
//        arms(refDepth - boardD);
}
}

h2W = 15;
h2H = 10;
h2D = refDepth;
h2X = -h2W/2;
h2Y = -46;
h2Z = refDepth - h2D;

module frame() {
    difference() {
        casedStar();
        // space for mount to come off of top arm
        translate([hX, hY-2, hZ])
 #           cube([hW, hH, hD]);
        // clip off end of mounting arm
        translate([h2X, h2Y, h2Z-skinBreak])
           cube([h2W, h2H, h2D+skinBreak*2]);

    }
}

intersection() {
    frame();
    translate([0, 0, -5])
    cylinder(h=25, r=43);
}

//star();
/*
barH = 3;
translate([0, 0, 0])
    scale([1.05, 1.05, 1])
        arms(barH);
*/