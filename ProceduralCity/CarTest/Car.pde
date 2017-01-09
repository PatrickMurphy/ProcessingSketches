import java.util.*;

class Car {
  CompiledCell position_cell;
  CompiledCell target_cell;
  PVector position_offset, target_offset;
  Direction heading;
  PShape model;
  boolean player_controlled = false;

  float speed = 2;
  float centerOfRoad = (ROAD_WIDTH*0.8)/2;

  Car(CompiledCell position, PShape model, Direction d) {
    this(position, model, d, (float)0);
  }

  Car(CompiledCell position, PShape model, Direction d, int realOffset) {
    this(position, model, d, realOffset/(float)CELL_SCALE);
  }

  Car(CompiledCell position, PShape model, Direction d, float pctRoad) {
    this.position_cell = position;
    this.model = model;
    //this.player_controlled = player;
    this.target_cell = null; // not moving
    this.heading = d;
    this.position_offset = getPositionOffset(pctRoad);
    //this.position_offset = new PVector(0, 0);
    this.target_offset = new PVector(0, 0);
  }

  PVector getPositionOffset(float pctRoad) {
    switch (this.heading) {
    case NORTH: 
      return new PVector(centerOfRoad, CELL_SCALE-(CELL_SCALE*pctRoad));
    case EAST: 
      return new PVector(CELL_SCALE*pctRoad, centerOfRoad);
    case SOUTH:
      return new PVector(CELL_SCALE-centerOfRoad, CELL_SCALE*pctRoad);

    case WEST: 
      return new PVector(CELL_SCALE-(CELL_SCALE*pctRoad), CELL_SCALE-centerOfRoad);
    default: 
      return new PVector(0, 0);
    }
  }

  void update() {
  }

  void calculatePath() {
    LinkedList<PathEdge> path = new LinkedList<PathEdge>();
    // current edge
    path.add(position_cell.road_edges[(this.heading.getValue()+1)%4]); // add 1 mod 4 because cars move north along the west edge, east along the north etc, so it is offset by one 

    CompiledCell north = cMap.getCell(position_cell.x, position_cell.y-1);
    CompiledCell south  = cMap.getCell(position_cell.x, position_cell.y+1);
    CompiledCell east  = cMap.getCell(position_cell.x+1, position_cell.y);
    CompiledCell west  = cMap.getCell(position_cell.x-1, position_cell.y);
    switch (this.heading) {
    case NORTH: 
      // IF Headed north, go to the cell with the lowest distance, if a tie prioritize north, then east or west, then U-turn south
      if (north != null) {
        print("null");
      }
      break;

    case EAST: 
      // IF Headed east, go to the cell with the lowest distance, if a tie prioritize east, then north or south, then U-turn west
      break;

    case SOUTH:
      // IF Headed south, go to the cell with the lowest distance, if a tie prioritize south, then east or west, then U-turn north
      break;

    case WEST: 
      // IF Headed west, go to the cell with the lowest distance, if a tie prioritize west, then north or south, then U-turn east
      break;

    default: 
      //this.position_offset = new PVector(0, 0);
      break;
    }
  }

  void display() {
    //pushMatrix();
    //translate(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y, cMap.getHeightAt(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y));
    // lights();
    //shape(model, 0, 0);
    // noLights();
    // popMatrix();
    fill(255, 0, 0);
    ellipse(position_cell.v1.x+position_offset.x, position_cell.v1.y+position_offset.y, 5, 5);
  }
  void setTarget(int x, int y) {
    this.setTarget(new PVector(x, y));
  }
  void setTarget(PVector t) {
    this.target_cell = cMap.getCell(t.x, t.y);
  }
}