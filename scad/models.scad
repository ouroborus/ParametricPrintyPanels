// 1 unit = 1mm

/* [Model/Grid] */
// Select model
model = "xxx"; // [xxx, Panel, Test Tab, Bracket Inner Small, Bracket Inner Large, Frame]
gridXDistance = 2; // [1:32]
gridYDistance = 2; // [1:32]
gridSize = 32; //

/* [Panel] */
panelThickness = 3; //
panelClearance = 0.1; // 0.1
panelChamfer = 0.6; // 0.1
panelRound = 3; // 0.1

/* [Slot] */
slotDiameter = 18; //
slotGap = 3; // 0.1

/* [Tab] */
tabSlotChamfer = 0.1; // 0.1
tabLength = 6; //
tabChamfer	= 1; // [0.1:0.1:1]
tabClearance = 0.05; // 0.01

/* [Bracket] */
bracketHeight = 12; // 
bracketSmallRound = 1; // 
bracketChamfer = 0.4; // 0.1

/* [Frame] */
frameBraced = true; // [true, false]
frameTabStride = 2; // [1, 2]
frameHeight = 12; //
frameFillet = 3; //
frameRound = 1; //
frameBraceHeight = 9; //
frameBraceFillet = 4; //

/* [OpenSCAD] */
// Curve density
$fn = 32; // [8,16,32,64,128,256,512]

/* [Hidden] */
error = 0.000005;

include <util.scad>;
include <panel.scad>;
include <tab.scad>;
include <bracket.scad>;
include <frame.scad>;

if (model == "Panel") {
  panel();
} else if (model == "Test Tab") {
  testTab();
} else if (model == "Bracket Inner Small") {
  bracketInnerSmall();
} else if (model == "Bracket Inner Large") {
  bracketInnerLarge();
} else if (model == "Frame") {
  frame();
}

/*
color("red",0.1)
rotate(-45)
square([panelThickness, 100], center=true);

color("yellow",0.1)
square([gridSize * gridXDistance - panelThickness - panelClearance*2, gridSize * (frameBraced ? gridXDistance : gridYDistance) - panelThickness - panelClearance*2], center=true);

color("blue",0.1)
square([gridSize * gridXDistance - panelThickness*3 - panelClearance*2, gridSize * (frameBraced ? gridXDistance : gridYDistance) - panelThickness*3 - panelClearance*2], center=true);
*/