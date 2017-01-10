import peasy.*; //<>//
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;


PeasyCam camera;
PVector lookAtPoint;

final int OVERALL_SCALE = (int)(800/9);
final int CELL_SCALE = 1*OVERALL_SCALE;
final int GRID_WIDTH = 10*OVERALL_SCALE;
final int GRID_HEIGHT = 10*OVERALL_SCALE;
final int ROAD_WIDTH = (int)(((CELL_SCALE+CELL_SCALE)/2)*.12);
// Numbers of Columns and Rows for cell grid, (over all width / width of one cell)
final int GRID_COLUMNS = (GRID_WIDTH/CELL_SCALE);
final int GRID_ROWS = (GRID_HEIGHT/CELL_SCALE);

// Settings
final int MAX_BUILDINGS = 900;
final int MAX_TREES = 175;
final int MAP_HEIGHT_SCALE = 20*CELL_SCALE;

final boolean FULLSCREEN = false;
final boolean USE_BUILDING_TEXTURES = true;

CompiledMap cMap;

PImage testTexture = (new TextureGenerator(CELL_SCALE, CELL_SCALE, color(75, 147, 65))).getTexture(new boolean[]{true, true, true, true});

boolean displayCity = false; // colors terrain with grey where the population map says we should have a city
Boolean showVisAid = true; // default state, toggled with "q"
int mapPopFilter = 15; // this will effect how much of the map is categorized as "city"
// End settings


Car car;

void setup() {
  size(800, 800);
  // start other thread for generating map so loading screen is displayed
  thread("startLoading"); // string of function name below
}

// thread for initializing the map
void startLoading() {
  noStroke();

  println(GRID_COLUMNS, GRID_ROWS, GRID_COLUMNS*GRID_ROWS); // print the grid width and length, and the total number of cells

  // texture mode for buildings
  // textureWrap(REPEAT);
  textureMode(NORMAL);

  generateNewMap();
}

void generateNewMap() {
  cMap = new CompiledMap(OVERALL_SCALE, GRID_COLUMNS, GRID_ROWS); // random terrain and buildings 
  car = new Car(cMap.getCell(7, 4), null, Direction.NORTH);
  car.setTarget(3, 5, Direction.getEnum((int)random(0, 400)%4), random(0, 1));
}

void mousePressed() {
  Direction newDir;
  switch (car.heading) {
  case NORTH: 
    newDir = Direction.EAST;
    break;

  case EAST: 
    newDir = Direction.SOUTH;
    break;

  case SOUTH:
    newDir = Direction.WEST;
    break;

  case WEST: 
    newDir = Direction.NORTH;
    break;

  default: 
    newDir = Direction.NORTH;      
    break;
  }
  car = new Car(cMap.getCell((int)random(GRID_ROWS-1), (int)random(GRID_ROWS-1)), null, newDir, random(1));
  car.setTarget((int)random(GRID_ROWS-1), (int)random(GRID_ROWS-1), Direction.getEnum((int)random(0, 400)%4), random(0, 1));
}


// Main Draw loop, called every frame
void draw() {
  background(15);
  cMap.display2D();
  car.display();
}