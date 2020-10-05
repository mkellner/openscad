module arrow(width=4, height=4, depth=1) {
	x = width / 4;
	y = height / 4;
	linear_extrude(height = depth)
		polygon(points=[[0, -2*y], [2*x, 0], [0, 2*y], [0, y], [-2*x, y], [-2*x, -y], [0, -y], [0, -2*y]]);
}

module centerPos(size=8, depth=1) {
	i = size / 10;

rotate([0, 0, -90]) {
	difference() {
		cylinder(r=size, h=depth);
		translate([0, 0, -.1])
			cylinder(r=8*i, h=depth+.2);
			translate([-3*i,0,-.1])
				cube([6*i,15*i,depth+.2]);
		}
		cylinder(r=3*i,h=depth);
		translate([-i,0,0])
			cube([2*i,13*i,depth]);
		translate([-i, 16*i, 0])
			cube([2*i, 8*i, depth]);
		translate([-4*i, 19*i, 0])
			cube([8*i, 2*i, depth]);
}
}

