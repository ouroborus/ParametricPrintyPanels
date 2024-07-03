module panelBoundary() {
  polygon([
    [0,0],
    [panelRound - panelChamfer, 0],
    [panelRound, panelChamfer],
    [panelRound, panelThickness - panelChamfer],
    [panelRound - panelChamfer, panelThickness],
    [0,panelThickness]
  ]);
}

module panelEdge(x, y, gridDistance) {
  translate([-x, -y, 0]){
    rotate([0, 0, 180])
    rotate_extrude(angle=90)
    panelBoundary();
    rotate([90, 0, 180])
    linear_extrude(gridSize * gridDistance - panelThickness - panelRound*2)
    panelBoundary();
  }
}

module panelBlank() {
  a = gridSize * gridXDistance - panelThickness;
  b = a/2 - panelRound;
  c = a - panelRound*2;
  d = gridSize * gridYDistance - panelThickness;
  e = d/2 - panelRound;
  f = d - panelRound*2;
  panelEdge(b, e, gridYDistance);
  rotate([0,0,90])
  panelEdge(e, b, gridXDistance);
  rotate([0,0,180])
  panelEdge(b, e, gridYDistance);
  rotate([0,0,270])
  panelEdge(e, b, gridXDistance);
  translate([-b,-e,0])
  cube([c, f, panelThickness]);
}

module punch(){
  n = slotGap * 2 * sqrt2;
  translate([0, 0, panelThickness/2]){
    rotate([0, 0, 45])
    cube([n, n, panelThickness + slotGap], center=true);
    for(j=[0:1]){
      rotate([j*180, 0, 0])
      for(i=[0:1]){
        rotate([0,0,i*90])
        translate([-slotDiameter/2, 0, -slotGap/2])
        rotate([45,0,0])
        cube([slotDiameter, panelThickness*2, panelThickness*2]);
      }
    }
  }
}

module punchGrid() {
  translate([-gridSize*(gridXDistance-1)/2, -gridSize*(gridYDistance-1)/2,0])
  for(y=[0:gridYDistance-1]){
    for(x=[0:gridXDistance-1]){
      translate([gridSize*x, gridSize*y, 0])
      punch();
    }
  }
}

module panel(){
  difference(){
    panelBlank();
    punchGrid();
  }
}
