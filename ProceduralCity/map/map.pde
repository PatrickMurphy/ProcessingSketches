import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam camera;
int cols, rows;
int overall_scale = 5;
int cellScale = 1*overall_scale;
int w = 800*overall_scale;
int h = 800*overall_scale;

Forest forest;

CompiledMap cMap;

void setup() {
  camera = new PeasyCam(this, w/2, h/2, 100, 4000);
  size(800, 800, P3D);
  noSmooth();
  cols = w/cellScale;
  rows = h/cellScale;
  cMap = new CompiledMap(overall_scale, cols, rows);
  //forest = new Forest();
  //getTerrainAreaStats();
  noStroke();
}

void draw() {
  background(15);
  cMap.drawMap();
}