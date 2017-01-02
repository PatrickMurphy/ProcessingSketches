class CircleObj {
  int x, y, level;
  float radius;
  color col;
  int colorOffset = 0;

  CircleObj(float maxRad, int padding) {
    this((int)random(padding+maxRad, cols-(padding+maxRad)), (int)random(padding+maxRad, rows-(padding+maxRad)), random(maxRad-15, maxRad), color(255), 0);
  }

  CircleObj(int _x, int _y, float rad, color col, int level) {
    this.col = col;
    this.x = _x;
    this.y = _y;
    this.radius = rad;
    this.level = level;
    this.colorOffset = 0;
  }  
  void display() {
    this.colorOffset = this.colorOffset+1;

    fill(lerpColor(color(100, (150+this.colorOffset)%255, 100), color(100, 100, (this.colorOffset)%255), this.level/(float)lps));
    ellipse(this.x, this.y, this.radius, this.radius);
  }

  float distance(CircleObj c2) {
    return sqrt(sq(c2.x-this.x)+sq(c2.y-this.y));
  }

  boolean collide(CircleObj c2) {
    return distance(c2) <= c2.radius + this.radius;
  }

  boolean validate(ArrayList<CircleObj> circs) {
    boolean valid = true;
    for (Iterator<CircleObj> it = circs.iterator(); it.hasNext(); ) {
      CircleObj c2 = it.next();
      if (this.collide(c2)) {
        valid = false;
        break;
      }
    }
    return valid;
  }

  // add surrounding circles
  ArrayList<CircleObj> surround(int loops) {
    ArrayList<CircleObj> newCircles = new ArrayList<CircleObj>();
    float totalRadius = this.radius;
    float lastRadius = this.radius;
    int n = 1;
    for (int l = 0; l < loops; l++) {
      float newRadius = lastRadius*random(.77, .89);
      float angleInDegrees = random(0, 360);

      n = n+3;

      float step = 360/n;
      for (int i = 0; i < n; i++) {
        float u = (float)(totalRadius * cos(angleInDegrees * PI / 180.0)) + this.x;
        float v = (float)(totalRadius * sin(angleInDegrees * PI / 180.0)) + this.y;
        CircleObj tempc = new CircleObj((int)u, (int)v, newRadius, color(255), l);
        if (tempc.validate(circles)) {
          newCircles.add(tempc);
        }
        angleInDegrees += step;
      }
      lastRadius = newRadius;
      totalRadius += newRadius;
    }
    return newCircles;
  }
}