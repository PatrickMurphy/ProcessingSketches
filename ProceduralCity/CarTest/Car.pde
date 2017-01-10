import java.util.*;

class Car {
  CompiledCell position_cell;
  CompiledCell target_cell;
  PVector position_offset, target_offset;
  Direction heading, target_heading;
  float currentRoadPct, targetRoadPct;
  PShape model;
  boolean player_controlled = false;

  LinkedList<PathEdge> nav_path;

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
    this.nav_path = null;
    this.heading = d;
    this.currentRoadPct = pctRoad;
    this.position_offset = getPositionOffset(this.heading, this.currentRoadPct);
    this.target_offset = new PVector(0, 0);
  }

  PVector getPositionOffset(Direction d, float pctRoad) {
    switch (d) {
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

  LinkedList<PathEdge> calculatePath() {
    int stepCount = 0;
    LinkedList<PathEdge> path = new LinkedList<PathEdge>();
    // path from current position to nearest edge
    path.add(new PathEdge(new PathPoint(this.position_offset.copy().add(this.position_cell.v1)), position_cell.road_edges[(this.heading.getValue()+3)%4])); // add 1 mod 4 because cars move north along the west edge, east along the north etc, so it is offset by one 

    PVector path_position = new PVector(position_cell.x, position_cell.y);
    println("Initial path:" + path);

    // while not reached
    while (!(path_position.x == target_cell.x && path_position.y == target_cell.y)) {
      CompiledCell[] neighborCells = new CompiledCell[4];

      // get neighbors
      CompiledCell thisCell = cMap.getCell(path_position.x, path_position.y);
      neighborCells[Direction.NORTH.getValue()] = cMap.getCell(path_position.x, path_position.y-1);
      neighborCells[Direction.SOUTH.getValue()] = cMap.getCell(path_position.x, path_position.y+1);
      neighborCells[Direction.EAST.getValue()] = cMap.getCell(path_position.x+1, path_position.y);
      neighborCells[Direction.WEST.getValue()] = cMap.getCell(path_position.x-1, path_position.y);

      float[] distances = new float[4];

      for (int i = 0; i<4; i++) {
        if (neighborCells[i] != null) {
          distances[i] = neighborCells[i].distanceTo(this.target_cell);
        } else {
          distances[i] = Integer.MAX_VALUE;
        }
      }

      // find lowest distance to target
      float minDist = min(distances);

      // calculate position priority, continue in curr direction, take a right, then try left, then turn around
      int[] direction_priority = new int[]{this.heading.getValue(), (this.heading.getValue()+1)%4, (this.heading.getValue()+3)%4, (this.heading.getValue()+2)%4};

      println("");
      println("----------- STEP " + stepCount + " ------------");
      println("PathPosition: " + path_position);
      println("target: " + this.target_cell);
      println("Heading: " + this.heading);
      println("Closest Neighbor distance: " + minDist);
      println("Distances: " + Arrays.toString(distances));
      println("Direction Priority: " + Arrays.toString(direction_priority)); // straight, right, left, back

      // for each priority, if dist == minDist choose path, push and update offset
      for (int i = 0; i<4; i++) {
        println("Try "+direction_priority[i] + " ");
        if (neighborCells[direction_priority[i]] != null && neighborCells[direction_priority[i]].distanceTo(this.target_cell) == minDist) {
          println("choose: "+direction_priority[i]);
          // if next priority is lowest dist choose
          // add same direction path from neighbor cell

          // if not right turn or behind
          if (i == 0) {
            // straight
            path_position.x = (neighborCells[direction_priority[i]]).x;
            path_position.y = (neighborCells[direction_priority[i]]).y;
            path.push(neighborCells[direction_priority[i]].road_edges[(direction_priority[i]+3)%4]);
          } else if (i == 2) {
            // left, move over a cell and forward
            PVector mod = new PVector(0, 0);
            switch (this.heading) {
            case NORTH: 
              mod = new PVector(-1, -1);
            case EAST: 
              mod = new PVector(1, -1);
            case SOUTH:
              mod = new PVector(1, 1);

            case WEST: 
              mod = new PVector(-1, 1);
            default: 
              mod = new PVector(0, 0);
            }

            path_position.x = thisCell.x + mod.x;
            path_position.y = thisCell.y + mod.y;
            path.push(cMap.getCell(path_position.x, path_position.y).road_edges[(direction_priority[i]+3)%4]);
          } else {
            // right or back, this cell
            path.push(thisCell.road_edges[(direction_priority[i]+3)%4]);
          }
          println("Set heading: "+Direction.getEnum(direction_priority[i]));
          this.heading = Direction.getEnum(direction_priority[i]);
          break;
        }
      }
      println("Step "+stepCount+" path:" + path);
      stepCount++;
    }

    // add path to target point within cell


    Collections.reverse(path);
    path.removeLast();
    path.add(new PathEdge(target_cell.road_edges[(this.target_heading.getValue()+3)%4],new PathPoint(this.target_offset.copy().add(this.target_cell.v1)))); // add 1 mod 4 because cars move north along the west edge, east along the north etc, so it is offset by one 
    return path;
  }

  void display() {
    //pushMatrix();
    //translate(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y, cMap.getHeightAt(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y));
    // lights();
    //shape(model, 0, 0);
    // noLights();
    // popMatrix();
    stroke(10, 170, 120);
    if (this.nav_path != null) {
      int pathStep = 0;
      for (PathEdge e : this.nav_path) {
        stroke(lerpColor(color(255, 0, 50), color(0, 50, 255), (++pathStep/(float)this.nav_path.size())));
        strokeWeight(5);
        e.display2D();
        strokeWeight(1);
      }
    }
    fill(255, 0, 0);
    ellipse(position_cell.v1.x+position_offset.x, position_cell.v1.y+position_offset.y, 5, 5);
  }
  void setTarget(int x, int y, Direction d, float pctRoad) {
    this.setTarget(new PVector(x, y), d, pctRoad);
  }
  void setTarget(PVector t, Direction d, float pctRoad) {
    this.target_cell = cMap.getCell(t.x, t.y);
    this.target_heading = d;
    this.targetRoadPct = pctRoad;
    this.target_offset = getPositionOffset(this.target_heading, this.targetRoadPct);
    if (this.nav_path != null) {
      this.nav_path.clear();
    }
    this.nav_path = this.calculatePath();
    println(this.nav_path);
  }
}