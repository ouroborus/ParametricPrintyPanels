function calc_() = 
  let(
    a = (gridSize + slotGap)/2 - panelRound,
    b = a - tabClearance,
    c = panelThickness + panelRound,
    d = octEdge(c)/2
  )
  [a,b,c,d];

module bracketBoundary(height) {
  polygon([
    [0,0],
    [height, 0],
    [height, panelThickness-bracketChamfer],
    [height-bracketChamfer, panelThickness],
    [0,panelRound]
  ]);
}

module bracketBoundaryShort() {
  bracketBoundary(panelRound);
}

module bracketBoundaryLong() {
  bracketBoundary(bracketHeight);
}

module bracketEnd() {
  linear_extrude(bracketHeight-panelRound)
  bracketBoundaryShort();
  translate([0, 0, bracketHeight-panelRound])
  rotate([-90, 0, 0])
  rotate_extrude(angle = -90)
  bracketBoundaryShort();
}

module bracketArm(size) {
  a = (gridSize - panelThickness)/2;
  b = a - panelClearance;
  c = (panelThickness + slotGap)/2 + panelClearance - tabClearance;
  d = b + c - panelRound + gridSize * (size-1);
  translate([d + panelClearance, panelClearance, 0]){
    rotate([0,-90,0])
    linear_extrude(d)
    bracketBoundaryLong();
    bracketEnd();
  }
  for(i=[0:size-1]){
    translate([a + gridSize*i, 0, 0])
    tab();
  }
}

module braceBoundary(height = bracketHeight) {
  polygon([
    [0, 0],
    [height - bracketChamfer, 0],
    [height, bracketChamfer],
    [height, panelThickness - bracketChamfer],
    [height - bracketChamfer, panelThickness],
    [0, panelThickness]
  ]);
}

module bracketBrace(offset) {
  translate([panelClearance, panelClearance, 0])
  intersection(){
    rotate([0, 0, -45])
    cube(offset*2);
    translate([octEdge(panelRound + panelThickness)/2 + offset, panelRound + panelThickness, 0])
    rotate([0, 0, -45]){
      rotate([0, 0, 90])
      rotate_extrude(angle = 45)
      translate([-panelRound, 0])
      rotate([0, 0, 90])
      braceBoundary();
      rotate([0, -90, 0])
      translate([0, -(panelRound + panelThickness), 0])
      linear_extrude(offset*2)
      braceBoundary();
    }
  }
}

module braceInnerFillet(offset) {
  a = panelRound + panelThickness/2;
  b = invLen45(a*2);
  c = a + b;
  d = panelRound + panelThickness;
  translate([panelClearance - d - len45(panelThickness) + offset + error, panelClearance + d, 0]){
    linear_extrude(bracketHeight)
    difference(){
      polygon([
        [0, 0],
        [0, b],
        [0, -a],
        [c, -a],
        [b/2, b/2]
      ]);
      circle(a);
    }
    rotate([0, 0, 90])
    rotate_extrude(angle = 135)
    translate([-panelRound, 0])
    rotate([0, 0, 90])
    braceBoundary();
  }
}

module bracketInnerFillet() {
  translate([panelRound + panelThickness + panelClearance, panelRound + panelThickness + panelClearance, 0])
  rotate([0,0,180])
  rotate_extrude(angle = 90)
  translate([panelRound*2,0])
  rotate([0, 0, 90])
  bracketBoundaryLong();
}

module bracketCornerMask() {
  a = bracketSmallRound + error;
  translate([bracketSmallRound + panelClearance, bracketSmallRound + panelClearance, 0])
  difference(){
    translate([-a, -a, 0])
    cube([a, a, bracketHeight]);
    cylinder(bracketHeight, bracketSmallRound, bracketSmallRound);
  }
}

module bracketInner(size, offset, innerFillet = false) {
  difference(){
    group(){
      for(i=[0:1]) {
        mirror([i,-i,0]){
          if(innerFillet) braceInnerFillet(offset);
          bracketBrace(offset);
          bracketArm(size);
        }
      }
      if(innerFillet) bracketInnerFillet();
    }
    bracketCornerMask();
  }
}

module bracketInnerSmall() {
  bracketInner(1, (gridSize - panelThickness)/2 - len45(panelThickness));
}

module bracketInnerLarge() {
  bracketInner(2, (gridSize - panelThickness)/2 - len45(panelThickness*2) + gridSize, true);
}

