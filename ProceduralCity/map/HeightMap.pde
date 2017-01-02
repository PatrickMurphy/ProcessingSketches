class HeightMap {
  NoiseMap terrain;
  int cols, rows, octaves;
  float scale, persistance, lacunarity;
  int heightScale;

  HeightMap(int c, int r) {
    this(c, r, 100, 0.008, int(random(500, 5000)), 1, .5, 2);
  }
  HeightMap(int c, int r, int hs, float s) {
    this(c, r, hs, s, int(random(500, 5000)), 1, .5, 2);
  }
  HeightMap(int c, int r, int hs, float s, int _seed) {
    this(c, r, hs, s, _seed, 1, .5, 2);
  }

  HeightMap(int c, int r, int hs, float s, int _seed, int oct, float pers, float lacu) {
    cols = c;
    rows = r;
    scale = s;
    octaves = oct;
    persistance = pers;
    lacunarity = lacu;
    heightScale = hs;
    println(_seed);
    terrain = new NoiseMap(cols, rows, scale, _seed);
  }

  float getValue(int x, int y) {
    return terrain.getValue(x, y)*heightScale;
  }
}