import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam camera;

int downScale = 5;

//top left: 47.406657,-121.132507
//bot right: 46.726565,-119.833374
PVector v1, v2;
JSONObject json;
int resolution = 10;
float[][] heightMap;

boolean save = false;

void setup() {
  camera = new PeasyCam(this, 800/2, 800/2, 100, 4000);
  size(800, 800, P3D);
  v1 = new PVector(47.406657, -121.132507);
  v2 = new PVector(46.726565, -119.833374);
  float step_x = abs(v1.x-v2.x)/resolution;
  float step_y = abs(v1.y-v2.y)/resolution;

  heightMap = new float[resolution][resolution];

  float i = v1.x;
  float j = v1.y;

  PrintWriter output = createWriter("map_"+resolution+".csv"); 

  for (int x = 0; x < resolution; x++) {
    j = v1.y;
    for (int y = 0; y < resolution; y++) {
      delay(500);
      json = loadJSONObject("http://maps.googleapis.com/maps/api/elevation/json?locations="+i+","+j);
      JSONArray results = json.getJSONArray("results");
      JSONObject point1 = results.getJSONObject(0);
      float elevation = point1.getFloat("elevation");
      heightMap[x][y] = elevation;
      println(x, y, i, j, elevation);
      j = j+step_y;
    }
    i = i-step_x;
    output.println(join(str(heightMap[x]),","));
  }
  output.flush(); // Writes the remaining data to the file
  output.close();
}

void draw() {
  background(25);
  fill(100);
  stroke(255);
  float stepx = ((float)gps2m(v1, new PVector(v2.x, v1.y))/downScale)/resolution;
  float stepy = ((float)gps2m(v1, new PVector(v1.x, v2.y))/downScale)/resolution;
  //stepx /= downScale;
  //stepy /= downScale;

  for (int y = 0; y<resolution-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x<resolution; x++) {
      vertex(x*stepx, y*stepy, heightMap[x][y]);
      vertex(x*stepx, (y+1)*stepy, heightMap[x][y+1]);
    }
    endShape();
  }
}

double gps2m(PVector v1, PVector v2) {
  float lat_a = v1.x;
  float lng_a = v1.y;
  float lat_b = v2.x;
  float lng_b = v2.y;

  float pk = (float) (180/3.14169);

  float a1 = lat_a / pk;
  float a2 = lng_a / pk;
  float b1 = lat_b / pk;
  float b2 = lng_b / pk;

  float t1 = cos(a1)*cos(a2)*cos(b1)*cos(b2);
  float t2 = cos(a1)*sin(a2)*cos(b1)*sin(b2);
  float t3 = sin(a1)*sin(b1);
  double tt = acos(t1 + t2 + t3);

  return 6366000*tt;
}