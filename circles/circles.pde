import java.util.*;
int cols, rows;
ArrayList<CircleObj> circles = new ArrayList<CircleObj>();
int startCirclesToPlace;
float maxCircleRadius;
int padding;
int lps = 15;

void setup() {
  size(800, 800);
  frameRate(100);
  background(15);
  cols = width;
  rows = height;
  noStroke();
  ellipseMode(CENTER);
  maxCircleRadius = random(55, 75);
  padding = 0;

  startCirclesToPlace = 2;
  setupCircles(maxCircleRadius, padding, startCirclesToPlace);
}

void setupCircles(float maxRad, int pad, int n) {
  circles.clear();
  // start circles
  while (n > 0) {
    CircleObj tempCircle = new CircleObj(random(20,maxRad), pad);
    if (tempCircle.validate(circles)) {
      circles.add(tempCircle);
      n--;
    }
  }

  ArrayList<CircleObj> newCircles = new ArrayList<CircleObj>();
  for (Iterator<CircleObj> it = circles.iterator(); it.hasNext(); ) {
    CircleObj c = it.next();
    newCircles.addAll(c.surround(lps));
  }
  circles.addAll(newCircles);
}

void mousePressed() {
  setupCircles(maxCircleRadius, padding, startCirclesToPlace);
}

void draw() {
  background(15);
  for (Iterator<CircleObj> it = circles.iterator(); it.hasNext(); ) {
    CircleObj c = it.next();
    c.display();
  }
}