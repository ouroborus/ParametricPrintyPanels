module tabBoundary() {
  translate([0,panelClearance + error])
  mirror([0,1])
  for(i=[0:1]){
    mirror([i,0])
    polygon([
      [0,panelThickness + panelClearance],
      [(panelThickness + slotGap)/2 - tabSlotChamfer - tabClearance, panelThickness + panelClearance],
      [(panelThickness + slotGap)/2 - tabSlotChamfer - tabClearance, panelThickness - tabSlotChamfer + panelClearance],
      [slotGap/2 + tabSlotChamfer - tabClearance, panelThickness/2+tabSlotChamfer + panelClearance],
      [slotGap/2 + tabSlotChamfer - tabClearance, panelThickness/2-tabSlotChamfer + panelClearance],
      [(panelThickness + slotGap)/2 + panelClearance - tabClearance, 0],
      [0, 0]
    ]);
  }
}

module tab() {
  difference(){
    linear_extrude(tabLength)
    tabBoundary();
    for(i=[0:1]){
      mirror([i,0,0])
      translate([(slotGap + panelThickness)/2 - tabChamfer - tabClearance, -panelThickness*1.5, tabLength])
      rotate([0,45,0])
      cube([tabChamfer*2, panelThickness, tabChamfer*2]);
    }
  }
}

module tombstone() {
  translate([0,panelClearance,0]){
    translate([panelRound-bracketHeight/2, 0,0])
    cube([bracketHeight - panelRound*2, panelThickness, bracketHeight - panelRound]);
    translate([bracketHeight/2-panelRound,0,bracketHeight - panelRound])
    rotate([0,-90,0])
    linear_extrude(bracketHeight - panelRound*2)
    bracketBoundaryShort();
    for(i=[0:1]){
      mirror([i,0,0])
      translate([bracketHeight/2-panelRound,0,0]){
        linear_extrude(bracketHeight - panelRound)
        bracketBoundaryShort();
        translate([0,0,bracketHeight - panelRound])
        rotate([90,-90,180])
        rotate_extrude(angle=90)
        bracketBoundaryShort();
      }
    }
  }
}

module testTab() {
  tab();
  tombstone();
}
