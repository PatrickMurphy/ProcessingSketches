class PopulationMap {
  NoiseMap population;
  int cols, rows, octaves;
  float scale, persistance, lacunarity;
  
  PopulationMap(int c, int r){
    this(c,r,0.02,int(random(500,5000)),1, .5, 2);
  }
  PopulationMap(int c, int r, float s){
    this(c,r,s,int(random(500,5000)),1, .5, 2);
  }

  PopulationMap(int c, int r, float s, int _seed){
    this(c,r,s,_seed,1, .5, 2);
  }

  PopulationMap(int c, int r, float s,int _seed, int oct, float pers, float lacu) {
    cols = c;
    rows = r;
    scale = s;
    octaves = oct;
    persistance = pers;
    lacunarity = lacu;
    println(_seed);
    population = new NoiseMap(cols, rows, scale,_seed);
  }

  float getValue(int x, int y) {
    return population.getValue(x,y)*100;
  }
}