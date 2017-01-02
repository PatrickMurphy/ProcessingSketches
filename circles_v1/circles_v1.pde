import java.util.*;
int cols, rows;
ArrayList<CircleObj> circles = new ArrayList<CircleObj>();
int startCirclesToPlace;
float maxCircleRadius;
int padding;

void setup() {
  size(800, 800);
  background(15);
  cols = width;
  rows = height;
  noStroke();
  ellipseMode(CENTER);
  fill(115);
  maxCircleRadius = random(35, 65);
  padding = 0;

  startCirclesToPlace = 1;
  setupCircles(maxCircleRadius, padding, startCirclesToPlace);
}

void setupCircles(float maxRad, int pad, int n) {
  circles.clear();
  // start circles
  while (n > 0) {
    CircleObj tempCircle = new CircleObj(maxRad, pad);
    if (tempCircle.validate(circles)) {
      circles.add(tempCircle);
      n--;
    }
  }

  ArrayList<CircleObj> newCircles = new ArrayList<CircleObj>();
  for (Iterator<CircleObj> it = circles.iterator(); it.hasNext(); ) {
    CircleObj c = it.next();
    newCircles.addAll(c.surround(15));
  }
  circles.addAll(newCircles);
}

void mousePressed() {
  setupCircles(maxCircleRadius, padding, startCirclesToPlace);
}

void draw() {
  background(15);
  //background(15);
  for (Iterator<CircleObj> it = circles.iterator(); it.hasNext(); ) {
    CircleObj c = it.next();
    c.display();
  }
}