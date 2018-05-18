epsilon = 0.1;
$fn = 30;

module handle(r1 = 4, h1 = 2.5, r2 = 6) {
  rotate_extrude() {
    square([r1, h1]);

    translate([0, h1 + sqrt(pow(r2, 2) - pow(r1, 2)), 0])
    intersection() {
      circle(r=r2, center=true);
      translate([0, -r2, 0]) square([r2, 2 * r2]);
    }
  }
}

module montessori_cylinder(h, d) {
  translate([0, 0, -h]) cylinder(h=h, d=d);
}

module montessori_cylinders(n = 10, origin = [0,0,0], h, d, margin = 5, on_base = true, play = 0) {
  hn = lookup(n, h);
  dn = lookup(n, d);

  translate(origin + (on_base ? [0, 0, hn] : [0, 0, 0])) {
    montessori_cylinder(hn, dn + play);
    handle();
  }

  if (n > 1) {
    montessori_cylinders(n = n - 1,
                         origin = origin + [ dn + margin, 0, 0 ],
                         h = h,
                         d = d,
                         margin = margin,
                         on_base = on_base,
                         play = play);
  }
}

module montessori_cylinder_set(heights, diameters, bloc_base, bloc_height, play = 2) {
  translate([ 0, -100, 0 ])
    montessori_cylinders(h = heights, d = diameters);

  difference() {
      linear_extrude(bloc_height)
        polygon(bloc_base);
    translate([ 0, 0, bloc_height + epsilon ])
    montessori_cylinders(h = heights, d = diameters, on_base = false, play = play);
  }
}
