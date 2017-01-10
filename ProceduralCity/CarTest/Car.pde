import java.util.*;

class Car {
  CompiledCell position_cell; // a reference to the current cell that the car is in (a cell of the terrain grid)
  CompiledCell target_cell; // a reference to the current target cell that the car is pathing to, null if no path
  PVector position_offset, target_offset; // a x,y vector for the position within the cell for the target and the current position of the car
  float currentRoadPct, targetRoadPct; // these percentage floats (0.0-1.0) determine how far along the road to place the car, and what point along the road the 
  Direction heading, target_heading; // the direction that the car is currently facing, and the direction the car should be facing when it reaches the target (used to place the target on one of 4 roads)
  LinkedList<PathEdge> nav_path; // a list of path edges(two position vectors (PathPoints)) for the car to follow, calculated in the calculatePath() function

  boolean player_controlled = false; // true or false if the unit is owned by the player, useless for now
  float speed = 2; // the speed of the car

  float centerOfRoad = (ROAD_WIDTH*0.8)/2; // the asphalt on the texture is 80% of the road with, then halved for center
  PShape model; // a variable to hold the 3d model of the car, but working in 2d for now so not used

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

  // based on the direction of travel determine the edge the car is on, and the percentage of that edge it has completed based on the pctRoad variable
  PVector getPositionOffset(Direction d, float pctRoad) {
    switch (d) {
    case NORTH: 
      // bottom left to top left
      return new PVector(centerOfRoad, CELL_SCALE-(CELL_SCALE*pctRoad));
    case EAST: 
      // top left to top right
      return new PVector(CELL_SCALE*pctRoad, centerOfRoad);
    case SOUTH:
      // top right to bottom right
      return new PVector(CELL_SCALE-centerOfRoad, CELL_SCALE*pctRoad);
    case WEST: 
      // bottom right to bottom left
      return new PVector(CELL_SCALE-(CELL_SCALE*pctRoad), CELL_SCALE-centerOfRoad);
    default: 
      return new PVector(0, 0); // should never hit this
    }
  }

  // set target cell (at x,y), pctRoad percent along the road edge that travels in the direction d
  void setTarget(int x, int y, Direction d, float pctRoad) {
    this.setTarget(new PVector(x, y), d, pctRoad);
  }

  // set target cell (at vector target), pctRoad percent along the road edge that travels in the direction d
  void setTarget(PVector t, Direction d, float pctRoad) {
    this.target_cell = cMap.getCell(t.x, t.y); // set target cell
    this.target_heading = d; // set the heading of the car when it arrives, determines what side of the cell the target is on
    this.targetRoadPct = pctRoad; // the percentage along the road edge
    this.target_offset = getPositionOffset(this.target_heading, this.targetRoadPct); // calculate the target offset within the cell

    // if the nav_path is not null clear the current path
    if (this.nav_path != null) {
      this.nav_path.clear();
    }

    // calculate the new path to the target
    this.nav_path = this.calculatePath();

    // debug
    println(this.nav_path);
  }

  // pre-calculate the path when the target is set
  LinkedList<PathEdge> calculatePath() {

    LinkedList<PathEdge> path = new LinkedList<PathEdge>(); // return list

    int stepCount = 0; // for debug

    // add the offset to the cell's Top Left coord to get the cars position within the cell
    PathPoint currentPosition = new PathPoint(this.position_offset.copy().add(this.position_cell.v1));

    // add (1 mod 4) because cars move north along the western edge of the cell, move east along the northern edge of the cell, south on the eastern edge and move west on the southern edge, so it is rotated by one clockwise
    PathEdge currentEdge = position_cell.road_edges[(this.heading.getValue()+3)%4]; 

    // path from current position to the end of the edge it is sitting on
    path.add(new PathEdge(currentPosition, currentEdge));  

    PVector path_position = new PVector(position_cell.x, position_cell.y);
    println("Initial path:" + path);

    // while not reached the target cell
    while (!(path_position.x == target_cell.x && path_position.y == target_cell.y)) {

      // array to store neighbor cell references
      CompiledCell[] neighborCells = new CompiledCell[4];

      // get neighbors
      CompiledCell thisCell = cMap.getCell(path_position.x, path_position.y);
      neighborCells[Direction.NORTH.getValue()] = cMap.getCell(path_position.x, path_position.y-1);
      neighborCells[Direction.SOUTH.getValue()] = cMap.getCell(path_position.x, path_position.y+1);
      neighborCells[Direction.EAST.getValue()] = cMap.getCell(path_position.x+1, path_position.y);
      neighborCells[Direction.WEST.getValue()] = cMap.getCell(path_position.x-1, path_position.y);

      // store distance for each neighbor cell to the target cell
      float[] distances = new float[4];

      // if neighbor cell is null(off edge of map) return max int, (essentially ignore it when looking for lowest distance value)
      for (int i = 0; i<4; i++) {
        if (neighborCells[i] != null) {
          distances[i] = neighborCells[i].distanceTo(this.target_cell);
        } else {
          distances[i] = Integer.MAX_VALUE;
        }
      }

      // find lowest distance to target
      float minDist = min(distances);

      // calculate position priority directions, always follow these rules, continue in curr direction, take a right, then try left, then turn around if no other options
      int[] direction_priority = new int[]{this.heading.getValue(), (this.heading.getValue()+1)%4, (this.heading.getValue()+3)%4, (this.heading.getValue()+2)%4};

      // debug output
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
        println("Try "+direction_priority[i] + " "); // debug

        // if next priority cell has a distance to target equal to the lowest distance choose this cell
        if (neighborCells[direction_priority[i]] != null && neighborCells[direction_priority[i]].distanceTo(this.target_cell) == minDist) {
          println("choose: "+direction_priority[i], neighborCells[direction_priority[i]].distanceTo(this.target_cell) == minDist, neighborCells[direction_priority[i]].distanceTo(this.target_cell), minDist); // debug

          // if straight add path in neighbor cell
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

            // add modifier to get relative cell that is to the left of current direction
            path_position.x = thisCell.x + mod.x;
            path_position.y = thisCell.y + mod.y;

            // add that cell's road edge
            path.push(cMap.getCell(path_position.x, path_position.y).road_edges[(direction_priority[i]+3)%4]);
          } else {
            // right or back then the new edge is within this cell
            path.push(thisCell.road_edges[(direction_priority[i]+3)%4]);
          }

          println("Set heading: "+Direction.getEnum(direction_priority[i]));
          this.heading = Direction.getEnum(direction_priority[i]); // set new direction of travel
          break; // end loop
        }
      }

      // debug output code
      println("Step "+stepCount+" path:" + path);
      stepCount++;
    }

    // reverse the path so it starts with the first edge to traverse
    Collections.reverse(path);

    // remove last because it is within the target cell, and we need to path to the target point within that cell a little differently
    path.removeLast();

    // add the last path edge to target point within cell, (todo: add path from path edge that leads in to target cell to the path edge added bellow)
    path.add(new PathEdge(target_cell.road_edges[(this.target_heading.getValue()+3)%4], new PathPoint(this.target_offset.copy().add(this.target_cell.v1)))); // add 1 mod 4 because cars move north along the west edge, east along the north etc, so it is offset by one 

    // return the found path
    return path;
  }

  void update() {
    // this is where the car will update its position along the path so its display can be updated, called once per frame
  }

  // temporary 2D display method just a circle
  void display() {
    //pushMatrix();
    //translate(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y, cMap.getHeightAt(position_cell.v1.x+ROAD_WIDTH/2+position_offset.x, position_cell.v1.y+position_offset.y));
    // lights();
    //shape(model, 0, 0);
    // noLights();
    // popMatrix();

    //draw the calculated path
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

    // car represenation
    fill(255, 0, 0);
    ellipse(position_cell.v1.x+position_offset.x, position_cell.v1.y+position_offset.y, 5, 5);
  }
}