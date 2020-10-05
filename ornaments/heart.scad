
module heart() {
    
    hTopR = 20;
    hY = -20;
    coreD = 10;
    
    hInset = 2;
    
        translate([-hTopR+hInset, hY, 0])
   #         cylinder(r=hTopR, h=coreD);
        translate([hTopR-hInset, hY, 0])
            cylinder(r=hTopR, h=coreD);
            
     triPoly = [[ -hTopR*2+hInset+1.7, hY ], [hTopR*2-hInset-1.7, hY], [0, hY+hTopR*2.7]];
     
     sc = 1;
     cX = 0;
     cY = -8.3;
     
         translate([-cX, -cY, coreD/2])
                linear_extrude(height = coreD, center=true, scale=sc)
                    polygon(triPoly);

}

difference() {
    scale([1.1, 1.1, 1])
        heart();
    translate([0, 0, 0])
        heart();
};
