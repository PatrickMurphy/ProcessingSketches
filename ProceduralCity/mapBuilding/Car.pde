class Car {
  CompiledCell position_cell;
  PVector position_offset;
  PShape model;
  boolean player_controlled = false;
  CompiledCell target_cell;
  float speed = 2;
  boolean sub_target_reached = false;


  Car(CompiledCell position, PShape model, boolean player) {
    this.position_cell = position;
    this.model = model;
    this.player_controlled = player;
    this.target_cell = null; // not moving
    this.position_offset = new PVector(0, 0);
  }

  void update() {
    navigate(this.position_cell);
  }

  void navigate(CompiledCell pos) {
    if (this.target_cell != null) {
      CompiledCell north = cMap.getCell(pos.x, pos.y-1);
      CompiledCell south = cMap.getCell(pos.x, pos.y+1);
      CompiledCell east = cMap.getCell(pos.x+1, pos.y);
      CompiledCell west = cMap.getCell(pos.x-1, pos.y);
      float nDist, sDist, eDist, wDist;
      if (north == null) {
        nDist = 1000000;
      } else {
        nDist = north.distanceTo(this.target_cell);
      }
      if (south == null) {
        sDist = 1000000;
      } else {
        sDist = south.distanceTo(this.target_cell);
      }
      if (east == null) {
        eDist = 1000000;
      } else {
        eDist = east.distanceTo(this.target_cell);
      }
      if (west == null) {
        wDist = 1000000;
      } else {
        wDist = west.distanceTo(this.target_cell);
      }

      float minDist = min(new float[]{nDist, sDist, eDist, wDist});

      CompiledCell newPos = null;
      //this.position_cell = cMap.getCellAt(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y);
      if (this.position_offset.x > CELL_SCALE || this.position_offset.x < -CELL_SCALE) {
        this.position_cell = cMap.getCellAt(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y);
        this.position_offset.x = 0;
        //this.position_offset.y = 0;
      }

      if (this.position_offset.y > CELL_SCALE || this.position_offset.y < (CELL_SCALE*(-1))) {
        this.position_cell = cMap.getCellAt(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y);
        //this.position_offset.x = 0;
        this.position_offset.y = 0;
      }
      if (this.position_cell.x == this.target_cell.x && this.position_cell.y == this.target_cell.y) {
        this.target_cell = null;
      } else {
        if (nDist == minDist) {
          newPos = north;
          this.position_offset.y -= this.speed;
        } else if (sDist == minDist) {
          newPos = south;
          this.position_offset.y += this.speed;
        } else if (eDist == minDist) {
          newPos = east;
          this.position_offset.x += this.speed;
        } else if (wDist == minDist) {
          newPos = west;
          this.position_offset.x -= this.speed;
        }
      }
      println(this.position_offset);

      //this.position;
    }
  }

  void display() {
    pushMatrix();
    translate(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y, cMap.getHeightAt(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y));
    lights();
    shape(model, 0, 0);
    noLights();
    popMatrix();
  }
  void setTarget(int x, int y) {
    this.setTarget(new PVector(x, y));
  }
  void setTarget(PVector t) {
    this.target_cell = cMap.getCell(t.x, t.y);
  }
}