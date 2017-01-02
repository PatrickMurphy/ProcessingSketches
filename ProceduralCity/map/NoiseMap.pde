class NoiseMap {
  float[][] NoiseField;
  int cols, rows, octaves, seed;
  float scale, persistance, lacunarity;

  NoiseMap(int c, int r) {
    this(c, r, 0.02, int(random(500, 5000)), 1, .5, 2);
  }
  NoiseMap(int c, int r, float s) {
    this(c, r, s, int(random(500, 5000)), 1, .5, 2);
  }

  NoiseMap(int c, int r, float s, int _seed) {
    this(c, r, s, _seed, 1, .5, 2);
  }

  NoiseMap(int c, int r, float s, int _seed, int oct, float pers, float lacu) {
    cols = c;
    rows = r;
    scale = s;
    octaves = oct;
    persistance = pers;
    lacunarity = lacu;
    seed = _seed;

    NoiseField = new float[cols][rows];
    generateMap();
  }

  void generateMap() {
    float yoff = seed;
    for (int y = 0; y<rows; y++) {
      float xoff = seed;
      for (int x = 0; x<cols; x++) {
        //float amplitude = 1;
        //float frequency = 1;
        //float noiseHeight = 0;
        for (int o = 0; o<=octaves; o++) {
          NoiseField[x][y] = noise(xoff, yoff);
          //xoff = x/scale * frequency;
          //yoff = y/scale * frequency;
          //noiseHeight += terrain[x][y] * amplitude;

          //amplitude *= persistance;
          //frequency *= lacunarity;
        }
        xoff += scale;
      }
      yoff += scale;
    }
  }

  float getValue(int x, int y) {
    return NoiseField[x][y];
  }
}