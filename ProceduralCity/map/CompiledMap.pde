class CompiledMap {
  int cols, rows;
  int popFilter;
  int hSeed;
  int pSeed;
  int heightScale;
  HeightMap hMap;
  PopulationMap pMap;
  CityMap cMap;
  boolean displayCity = false;
  CompiledCell[][] compiledCells;

  CompiledMap(int overall_scale, int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    //this.hSeed = 3540;
    //this.pSeed = 2981;
    this.hSeed = int(random(500, 15000));
    this.pSeed = int(random(500, 15000));
    this.heightScale = 250*overall_scale;
    noiseSeed(50);

    this.hMap = new HeightMap(cols, rows, this.heightScale, 0.004, this.hSeed); // lower scale = more zoomed in
    this.pMap = new PopulationMap(cols, rows, 0.01, this.pSeed);
    this.cMap = new CityMap(cols, rows);

    //  popFilter = (int)random(12, 20);// max of 80, lower = more people
    this.popFilter = 15;
    compiledCells = new CompiledCell[cols][rows-1];
    this.setupMap();
  }

  void setupMap() {
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols; x++) {
        float cellHeight = hMap.getValue(x, y);
        float nextCellHeight = hMap.getValue(x, y+1);
        if (cellHeight<=.32*heightScale) {
          cellHeight = .32*heightScale;
        }
        if (nextCellHeight <= .32*heightScale) {
          nextCellHeight = .32*heightScale;
        }
        float cellPopulation = pMap.getValue(x, y);
        color tempColor = getTerrain(cellHeight, cellPopulation, x, y);

        Vector3 v1 = new Vector3(x*cellScale, y*cellScale, cellHeight);
        Vector3 v2 = new Vector3(x*cellScale, (y+1)*cellScale, nextCellHeight);
        compiledCells[x][y] = new CompiledCell(v1, v2, tempColor, cellPopulation);
      }
    }
  }

  void drawMap() {
    for (int y = 0; y<rows-1; y++) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x<cols; x++) {
        fill(compiledCells[x][y].getColor());
        vertex(compiledCells[x][y].getVector1().getX(), compiledCells[x][y].getVector1().getY(), compiledCells[x][y].getVector1().getZ());
        vertex(compiledCells[x][y].getVector2().getX(), compiledCells[x][y].getVector2().getY(), compiledCells[x][y].getVector2().getZ());
      }
      endShape();
    }
  }

  void getTerrainAreaStats() {
    float waterCount = 0;
    int beachCount = 0;
    int lowLandsCount = 0;
    int hillsCount = 0;
    int footHillsCount = 0;
    int mountainStartCount = 0;
    int mountainMidCount = 0;
    int peakCount = 0;
    float cityCount = 0;
    float totalCount = 0;
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols; x++) {
        totalCount++;
        float heightValue = hMap.getValue(x, y);
        float populationDensity = pMap.getValue(x, y);

        if (heightValue <= .32*heightScale) { // water
          waterCount++;
        } else if (heightValue > .32*heightScale && heightValue <= .35*heightScale) {
          // beach
          if (populationDensity >= (popFilter+33)) {
            cityCount++;
          } else {
            beachCount++;
          }
        } else if (heightValue > .35*heightScale && heightValue <= .5*heightScale) {
          // low lands
          if (populationDensity >= (popFilter+12)) {
            cityCount++;
          } else {
            lowLandsCount++;
          }
        } else if (heightValue > .50*heightScale && heightValue <= .60*heightScale) {
          // hills
          if (populationDensity >=  (popFilter+20)) {
            cityCount++;
          } else {
            hillsCount++;
            // println(populationDensity);
            if (populationDensity <= 25 && random(0, 1000)>990)
              forest.addTree(new Tree(x*cellScale, y*cellScale, heightValue, random(0, 3)));
          }
        } else if (heightValue>.60*heightScale && heightValue <= .65*heightScale) {
          // foot hills
          if (populationDensity >=  (popFilter+30)) {
            cityCount++;
          } else {
            footHillsCount++;
          }
        } else if (heightValue > .65*heightScale && heightValue <= .70*heightScale) {
          // mountain start
          if (populationDensity >=  (popFilter+42)) {
            cityCount++;
          } else {
            mountainStartCount++;
          }
        } else if (heightValue > .70*heightScale && heightValue <= .75*heightScale) {
          mountainMidCount++;
        } else {
          //peaks
          peakCount++;
        }
      }
    }
    println("total: "+totalCount);
    println("water: "+(waterCount/totalCount)); //iff water less than 35%
    println("city: "+(cityCount/totalCount)); // if city greater than 33%
  }

  color getTerrain(float heightValue, float populationDensity, int x, int y) {
    color tempcolor = color(0, 0, 0);
    if (heightValue <= .32*heightScale) { // water
      tempcolor = color(30, 144, 255);
    } else if (heightValue > .32*heightScale && heightValue <= .35*heightScale) {
      // beach
      if (displayCity && populationDensity >= (popFilter+33)) {
        tempcolor = color(160, 160, 160);
        cMap.setValue(x, y, populationDensity);
      } else {
        tempcolor = color(222, 184, 135);
      }
    } else if (heightValue > .35*heightScale && heightValue <= .5*heightScale) {
      // low lands
      if (displayCity && populationDensity >= (popFilter+12)) {
        tempcolor = color(100, 100, 100);
        cMap.setValue(x, y, populationDensity);
      } else {
        tempcolor = color(50, 200, 15);
      }
    } else if (heightValue > .50*heightScale && heightValue <= .60*heightScale) {
      // hills
      if (displayCity && populationDensity >=  (popFilter+20)) {
        tempcolor = color(140, 140, 140);
        cMap.setValue(x, y, populationDensity);
      } else {
        tempcolor = color(28, 165, 94);
      }
    } else if (heightValue>.60*heightScale && heightValue <= .65*heightScale) {
      // foot hills
      if (displayCity && populationDensity >=  (popFilter+30)) {
        tempcolor = color(80, 80, 80);
        cMap.setValue(x, y, populationDensity);
      } else {
        tempcolor = color(6, 109, 51);
      }
    } else if (heightValue > .65*heightScale && heightValue <= .70*heightScale) {
      // mountain start
      if (displayCity && populationDensity >=  (popFilter+42)) {
        tempcolor = color(20, 20, 20);
        cMap.setValue(x, y, populationDensity);
      } else {
        tempcolor = color(155, 105, 12);
      }
    } else if (heightValue > .70*heightScale && heightValue <= .75*heightScale) {
      // mountain mid
      tempcolor = color(124, 83, 7);
    } else {
      //peaks
      //other
      tempcolor = color(map(heightValue, 0, heightScale, 0, 255));
    }

    return tempcolor;
  }
}