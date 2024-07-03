
module frameUnbraced() {
  frameInnerCorners();
  frameOuter();
}

module framePanel() {
  hull()
  mirrorXY()
  translate([
    (gridSize * gridXDistance - panelThickness)/2 - panelClearance - frameRound,
    (gridSize * (frameBraced ? gridXDistance : gridYDistance) - panelThickness)/2 - panelClearance - frameRound,
    0
  ]){
    cylinder(frameHeight - panelChamfer, frameRound, frameRound);
    translate([0,0,frameHeight - panelChamfer])
    cylinder(panelChamfer, frameRound, frameRound - panelChamfer);
    }
}

module frameCutoutSimple() {
  tX = (gridSize * gridXDistance - panelThickness)/2 - panelThickness - frameFillet - panelClearance;
  tY = frameBraced ? tX : (gridSize * gridYDistance - panelThickness)/2 - panelThickness - frameFillet - panelClearance;

  hull()
  mirrorXY()
  translate([tX, tY, 0])
  cylinder(frameHeight - panelChamfer, frameFillet, frameFillet);

  hull()
  mirrorXY()
  translate([tX, tY, frameHeight - panelChamfer])
  cylinder(panelChamfer, frameFillet, frameFillet + panelChamfer);
}

module frameBraceCutoutRoughFragment() {
  t = (gridSize * gridXDistance - panelThickness)/2 - panelClearance - panelThickness - frameBraceFillet;
  hull(){
    for(i=[0:1]){
      mirror([i, 0, 0])
      translate([t - len45(panelThickness/2 + frameBraceFillet), t])
      children();
    }
    rotate(45)
    translate([frameBraceFillet + panelThickness/2, frameBraceFillet + panelThickness/2])
    children();
  }
}

module frameBraceCutoutFragment() {
  frameBraceCutoutRoughFragment()
  cylinder(frameBraceHeight - panelChamfer, frameBraceFillet, frameBraceFillet);
  difference(){
    frameBraceCutoutRoughFragment()
    translate([0, 0, frameBraceHeight - panelChamfer])
    cylinder(panelChamfer, frameBraceFillet, frameBraceFillet + panelChamfer);
    translate([-gridSize * gridXDistance/2, (gridSize * gridXDistance - panelThickness)/2 - panelThickness - panelClearance, 0])
    cube([gridSize * gridXDistance, panelChamfer, frameHeight]);
  }
}

module frameBrace() {
  t = gridSize * gridXDistance - panelThickness - (panelClearance + panelThickness)*2;
  difference(){
    translate([0, 0, frameBraceHeight/2])
    cube([t,t,frameBraceHeight], center=true);
    for(i=[0:3]){
      rotate([0, 0, i*90])
      frameBraceCutoutFragment();
    }
  }
}

module frameTabs() {
  if(frameBraced) {
    tX = gridSize * gridXDistance / 2;
    tY = tX - panelThickness/2;
    oddMode = gridXDistance % 2 == 1 && frameTabStride == 2 ? 1 : 0;
    for(j=[0:1]){
      rotate([0,0,j*90]){
        for(i=[0:frameTabStride:gridXDistance-1]){
          translate([-tX + gridSize/2 + i*gridSize, -tY, 0])
          tab();
        }
        rotate([0,0,180])
        for(i=[oddMode:frameTabStride:gridXDistance-1-oddMode]){
          translate([-tX + gridSize/2 + i*gridSize, -tY, 0])
          tab();
        }
      }
    }
  }
  else {
    uX = (gridSize * gridXDistance)/2;
    uY = (gridSize * gridYDistance)/2 - panelThickness/2;
    uOddMode = gridXDistance % 2 == 1 && frameTabStride == 2 ? 1 : 0;
    vX = (gridSize * gridYDistance)/2;
    vY = (gridSize * gridXDistance)/2 - panelThickness/2;
    vOddMode = gridYDistance % 2 == 1 && frameTabStride == 2 ? 1 : 0;
    for(i=[0:frameTabStride:gridXDistance-1]){
      translate([-uX + gridSize/2 + i*gridSize, -uY, 0])
      tab();
    }
    rotate([0,0,90])
    for(i=[0:frameTabStride:gridYDistance-1]){
      translate([-vX + gridSize/2 + i*gridSize, -vY, 0])
      tab();
    }
    rotate([0,0,180])
    for(i=[uOddMode:frameTabStride:gridXDistance-1]){
      translate([-uX + gridSize/2 + i*gridSize, -uY, 0])
      tab();
    }
    rotate([0,0,270])
    for(i=[vOddMode:frameTabStride:gridYDistance-1]){
      translate([-vX + gridSize/2 + i*gridSize, -vY, 0])
      tab();
    }
  }
}

module frame() {
  mirror([1,0,0]){
    if (frameBraced) frameBrace();
    difference(){
      framePanel();
      frameCutoutSimple();
    }
    frameTabs();
  }
}
