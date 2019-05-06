
$fn = 45;

fudge = 0.1;

//hubR = 38/2;         // large white spool
//hubR = 50/2;            // small blue spool
hubR = 53/2;      // SkyTech

deltaR = 2.5/2;

hubH = 15;

//hubR1 = 45/2;
//hubR2 = 55/2;

bearingOuterR = 11 + fudge;
bearingH = 7;

module hub() {
difference()
{
    // hub
    cylinder(h = hubH, r1 = hubR-deltaR, r2 = hubR+deltaR, center=true);

    union() {
        // bearing hole
        translate([0, 0, -((bearingH/2) - hubH/2)])
            cylinder(h = bearingH, r1 = bearingOuterR, r2 = bearingOuterR, center=true);
        
        // smaller cylinder for retaining rim
        translate([0, 0, hubH/2])
        #cylinder(h = hubH * 2, r1 = bearingOuterR-2, r2 = bearingOuterR-2, center=true);
 
 /*       
        for (i=[30,60,90,120,150,180,210,240,270,300,330,360]) {
            rotate([0, 0, i])
            translate([13, 0, -20])
            #cube([6, 6, 40]);
        }
*/
        for (i=[45,90,135,180,225,270,315,360]) {
            rotate([0, 5, i])
                translate([19, 0, 0])
                    #cylinder(h=hubH*2, r1=5.5, r2=6.5, center=true);
        }
    }
}
}

hub();

translate([(hubR+deltaR)*2+5, 0, 0])
hub();