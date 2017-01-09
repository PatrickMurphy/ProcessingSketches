class CompiledMap {
  int cols, rows;

  CompiledCell[][] compiledCells;

  CompiledMap(int overall_scale, int cols, int rows) {
    this.cols = cols;
    this.rows = rows;

    compiledCells = new CompiledCell[cols-1][rows-1];
    this.setupMap();
  }

  CompiledCell getCell(float x, float y) {
    return this.getCell((int) x, (int) y);
  }

  CompiledCell getCell(int x, int y) {
    if (x<0 || x>=GRID_COLUMNS-1 || y<0 || y>=GRID_ROWS-1) {
      return null;
    } else {
      return compiledCells[x][y];
    }
  }

  CompiledCell getCellAt(float x, float y) {
    return getCellAt((int)x, (int)y);
  }

  CompiledCell getCellAt(int x, int y) {
    int tempx = floor(map(x, 0, GRID_WIDTH, 0, GRID_COLUMNS-1));
    int tempy = floor(map(y, 0, GRID_HEIGHT, 0, GRID_ROWS-1));
    println(tempx, tempy);
    return getCell(tempx, tempy);
  }

  void setupMap() {

    // for all the cells compute location in 3D space, use height to assign terrain type, and popu lation density map to determine if it is a city
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols-1; x++) {

        float cellHeight = 0;
        float nextCellHeight = 0;
        float cellHeight2 = 0;
        float nextCellHeight2= 0;

        float cellPopulation = 50;


        // compute vectors for the corners of each cell according to scale
        PVector v1 = new PVector(x*CELL_SCALE, y*CELL_SCALE, cellHeight);
        PVector v2 = new PVector(x*CELL_SCALE, (y+1)*CELL_SCALE, nextCellHeight);
        PVector v3 = new PVector((x+1)*CELL_SCALE, y*CELL_SCALE, cellHeight2);
        PVector v4 = new PVector((x+1)*CELL_SCALE, (y+1)*CELL_SCALE, nextCellHeight2);

        // Create Cell, realPosition Vectors and X,Y on the grid, population
        CompiledCell newCell = new CompiledCell(v1, v2, v3, v4, x, y, cellPopulation);

        //println(newCell.getSlope());

        // Save Cell
        compiledCells[x][y] = newCell;
      }
    }
  }

  float getHeightAt(float x, float y) {
    return getHeightAt((int)x, (int)y);
  }
  float getHeightAt(int x, int y) {
    // takes real x and y
    x = min(x, GRID_WIDTH);
    y = min(y, GRID_HEIGHT);
    int tempx = floor(map(x, 0, GRID_WIDTH, 0, GRID_COLUMNS-1));
    int tempy = floor(map(y, 0, GRID_HEIGHT, 0, GRID_ROWS-1));

    return this.getCell(tempx, tempy).getHeightAt(x-(tempx*CELL_SCALE), y-(tempy*CELL_SCALE));
  }

  void display2D() {
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols-1; x++) {
        compiledCells[x][y].display2D();
      }
    }
  }
}