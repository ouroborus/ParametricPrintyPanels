sqrt2 = sqrt(2);

function len45(value) = sqrt(value^2*2);
function invLen45(value) = sqrt(value^2/2);
// octagon outer radius from inner radius
function octOuter(inner) = sqrt(2 * (2 - sqrt2)) * inner;
// octagon side length from inner radius
function octEdge(inner) = 2 * sqrt(3 - 2 * sqrt2) * inner;

module mirrorXY(){
  for(y=[0:1])
  mirror([0,y,0])
  for(x=[0:1])
  mirror([x,0,0])
  children();
}
