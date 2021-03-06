class CompiledMap {
  int cols, rows;
  int popFilter;
  int hSeed;
  int pSeed;
  int heightScale;
  PImage[] row_textures;
  NoiseMap hMap;
  NoiseMap pMap;

  CompiledCell[][] compiledCells;

  String textName;

  CompiledMap(int overall_scale, int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    this.hSeed = int(random(500, 15000));
    this.pSeed = int(random(500, 15000));
    //this.hSeed = 2025;
    //this.pSeed = 11399;
    this.heightScale = MAP_HEIGHT_SCALE;
    // generates same noise map for same seed
    noiseSeed(50);

    // generates same buildings on each map
    randomSeed(pSeed+hSeed);

    this.hMap = new NoiseMap(cols, rows, this.heightScale, 0.05, this.hSeed); // lower scale = more zoomed in
    this.pMap = new NoiseMap(cols, rows, 100, 0.08, this.pSeed);

    //  popFilter = (int)random(12, 20);// max of 80, lower = more people
    this.popFilter = mapPopFilter;
    compiledCells = new CompiledCell[cols-1][rows-1];
    this.setupMap();
    this.generateRowTextures();
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
    println(tempx,tempy);
    return getCell(tempx, tempy);
  }

  void setupMap() {
    loadStep = "Generate Terrain";
    // for all the cells compute location in 3D space, use height to assign terrain type, and popu lation density map to determine if it is a city
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols-1; x++) {
        loadPCT = float(y*(rows-1)+x)/(float)((rows-1)*cols);
        float cellHeight = hMap.getValue(x, y);
        float nextCellHeight = hMap.getValue(x, y+1);
        float cellHeight2 = hMap.getValue(x+1, y);
        float nextCellHeight2= hMap.getValue(x+1, y+1);

        float cellPopulation = pMap.getValue(x, y);

        // If lower than 32 percent, it is water, set it at 32 percent height
        cellHeight = max(cellHeight, .32*heightScale);
        nextCellHeight = max(nextCellHeight, .32*heightScale);
        cellHeight2 = max(cellHeight2, .32*heightScale);
        nextCellHeight2 = max(nextCellHeight2, .32*heightScale);

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

  void generateRowTextures() {
    row_textures = new PImage[this.rows-1];
    for (int y = 0; y< this.rows-1; y++) {
      PImage temp = createImage(CELL_SCALE*(this.cols-1), CELL_SCALE, RGB);
      for (int x = 0; x< this.cols-1; x++) {
        int isCity = compiledCells[x][y].isCity() ? 1 : 0;
        temp.set(x*CELL_SCALE, 0, compiledCells[x][y].texture);
      }
      this.row_textures[y] = temp;
    }
  }

  void display2D() {
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols-1; x++) {
        compiledCells[x][y].drawCell2D();
      }
    }
  }

  void drawCellDetails() {
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols-1; x++) {
        compiledCells[x][y].drawCellDetail();
      }
    }
  }

  void drawMap() {
    //stroke(60);
    for (int y = 0; y<rows-1; y++) {
      //fill(lerpColor(0,255,y/float(rows-1)));
      beginShape(TRIANGLE_STRIP);
      texture(this.row_textures[y]);
      for (int x = 0; x<cols-1; x++) {
        compiledCells[x][y].drawCell();
      }
      endShape();
    }
    //noStroke();
  }
}