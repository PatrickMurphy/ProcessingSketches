class CircleObj {
  int x, y;
  float radius;
  color col;

  CircleObj(float maxRad, int padding) {
    this((int)random(padding+maxRad, cols-(padding+maxRad)), (int)random(padding+maxRad, rows-(padding+maxRad)), random(maxRad-15, maxRad), color(255));
  }

  CircleObj(int _x, int _y, float rad, color col) {
    this.col = col;
    this.x = _x;
    this.y = _y;
    this.radius = rad;
  }  
  void display() {
    fill(this.col);
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
    stroke(255);
    noFill();
    float totalRadius = this.radius;
    float lastRadius = this.radius;
    int n = 6;
    for (int l = 0; l < loops; l++) {
      float newRadius = lastRadius*random(.77, .89);
      //ellipse(this.x, this.y, this.radius+newRadius, this.radius+newRadius);
      float angleInDegrees = random(0, 360);

      n = n+2;

      float step = 360/n;
      for (int i = 0; i < n; i++) {
        float u = (float)(totalRadius * cos(angleInDegrees * PI / 180.0)) + this.x;
        float v = (float)(totalRadius * sin(angleInDegrees * PI / 180.0)) + this.y;
        //point(u, v);
        //ellipse(u, v, newRadius, newRadius);
        newCircles.add(new CircleObj((int)u, (int)v, newRadius, color(255)));
        angleInDegrees += step;
      }
      lastRadius = newRadius;
      totalRadius += newRadius;
    }
    /*
    for (int i = 100; i>=0; i--) { 
     ArrayList<CircleObj> tempList = new ArrayList<CircleObj>();
     float step = (2*PI)/i;
     float newRadius = this.radius*random(.77, .89);
     float angle = 0;
     int x1 = round(this.x + this.radius * cos(angle+step));
     int y1 = round(this.y + this.radius * sin(angle+step));//(int)(this.y+this.radius+newRadius)
     CircleObj testCircle1 = new CircleObj(x1, y1, newRadius, color(0, 225, 0));
     int x2 = round(this.x + this.radius * cos(angle+step+step));
     int y2 = round(this.y + this.radius * sin(angle+step+step));
     CircleObj testCircle2 = new CircleObj(x2, y2, newRadius, color(0, 0, 225));
     int x3 = round(this.x + this.radius * cos(angle+step+step+step));
     int y3 = round(this.y + this.radius * sin(angle+step+step+step));
     CircleObj testCircle3 = new CircleObj(x3, y3, newRadius, color(255, 0, 0));
     int x4 = round(this.x + this.radius * cos(angle+(step+step+step+step)));
     int y4 = round(this.y + this.radius * sin(angle+step+step+step+step));
     CircleObj testCircle4 = new CircleObj(x4, y4, newRadius, color(128, 128, 128));
     if (testCircle1.collide(testCircle2)) {
     newCircles.add(testCircle1);
     newCircles.add(testCircle2);
     newCircles.add(testCircle3);
     newCircles.add(testCircle4);
     }
     }
     */
    return newCircles;
  }
}