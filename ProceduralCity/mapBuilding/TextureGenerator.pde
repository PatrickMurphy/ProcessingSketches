class TextureGenerator {
  color baseColor;
  int wid, len;

  TextureGenerator(int wid, int len, color c) {
    this.baseColor = c;
    this.wid = wid;
    this.len = len;
  }

  PImage getTexture() {
    return this.getTexture(new boolean[]{false, false, false, false});
  }

  PImage getTexture(boolean[] neighbors) {
    PImage texture = createImage(wid, len, RGB);
    for (int x = 0; x<wid; x++) {
      for (int y = 0; y<len; y++) {
        texture.set(x, y, baseColor);
      }
    }

    addRoad(texture, neighbors);


    return texture;
  }

  void addRoad(PImage texture, boolean[] neighbors) {
    int startX = 0;
    int startY = 0;
    
    if (neighbors[0]) {
      //left
      for (int x = startX; x<=startX+ROAD_WIDTH; x++) {
        for (int y = 0; y<=len; y++) {
          if (x == startX && y%ROAD_WIDTH>0 && y%ROAD_WIDTH<5) {
            texture.set(x, y, color(255, 207, 13));
          } else if (x <= ROAD_WIDTH && x >= ROAD_WIDTH-(ROAD_WIDTH*.2)) {
            if (texture.get(x, y) != color(0) && texture.get(x, y) != color(255, 207, 13))
              texture.set(x, y, color(175));
          } else {
            texture.set(x, y, color(0));
          }
        }
      }
    }
    
    if (neighbors[1]) {
      // top
      startY = 0;
      for (int x = 0; x<=wid; x++) {
        for (int y = startY; y<=startY+ROAD_WIDTH; y++) {
          if  (y == startY && x%ROAD_WIDTH>0 && x%ROAD_WIDTH<5) {
            texture.set(x, y, color(255, 207, 13));
          } else if (y >= (startY+ROAD_WIDTH)-(ROAD_WIDTH*.2) && y <= startY+(ROAD_WIDTH)) {
            if (texture.get(x, y) != color(0) && texture.get(x, y) != color(255, 207, 13))
              texture.set(x, y, color(175));
          } else {
            texture.set(x, y, color(0));
          }
        }
      }
    }
    
    if (neighbors[2]) {
      // right
      startX = this.wid-(ROAD_WIDTH);
      for (int x = startX; x<=startX+(ROAD_WIDTH); x++) {
        for (int y = 0; y<=len; y++) {
          if (x <= startX+(ROAD_WIDTH*.2) && x >= ROAD_WIDTH) {
            if (texture.get(x, y) != color(0) && texture.get(x, y) != color(255, 207, 13))
              texture.set(x, y, color(175));
          } else {
            texture.set(x, y, color(0));
          }
        }
      }
    }
    
    // bottom
    if (neighbors[3]) {
      startY = this.len-ROAD_WIDTH;
      for (int x = 0; x<=wid; x++) {
        for (int y = startY; y<=startY+ROAD_WIDTH; y++) {
          if (y <= startY+(ROAD_WIDTH*.2) && y >= ROAD_WIDTH) {
            if (texture.get(x, y) != color(0) && texture.get(x, y) != color(255, 207, 13))
              texture.set(x, y, color(175));
          } else {
            texture.set(x, y, color(0));
          }
        }
      }
    }
  }
}