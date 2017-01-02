var NoiseMap = { 
    NoiseField: [],
    cols: 10,
    rows: 10,
    octaves: 1,
    seed: Math.random(500, 5000),
    scale: 0.02,
    persistance: .3,
    lacunarity: 2,

  setSettings: function setSettings(c, r, s, seed, oct, pers, lacu) {
    NoiseMap.cols = Util.defaultValue(c,10);
    NoiseMap.rows = Util.defaultValue(r,10);
    NoiseMap.scale = Util.defaultValue(s,0.02);
    NoiseMap.octaves = Util.defaultValue(oct,1);
    NoiseMap.persistance = Util.defaultValue(pers,.3);
    NoiseMap.lacunarity = Util.defaultValue(lacu,2);
    NoiseMap.seed = Util.defaultValue(seed,Math.random(500, 5000));
  
     
    NoiseMap.NoiseField = new Array(NoiseMap.cols);
    for (var i = 0; i < NoiseMap.cols; i++) {
      NoiseMap.NoiseField[i] = new Array(NoiseMap.rows);
    }
    NoiseMap.generateMap();
  },
  
  generateMap: function generateMap() {
    var yoff = NoiseMap.seed;
    for (var y = 0; y<NoiseMap.rows; y++) {
      var xoff = NoiseMap.seed;
      for (var x = 0; x<NoiseMap.cols; x++) {
        //float amplitude = 1;
        //float frequency = 1;
        //float noiseHeight = 0;
        for (var o = 0; o<=NoiseMap.octaves; o++) {
          if(o == 0){
            NoiseMap.NoiseField[x][y] = noise(xoff, yoff);
          }else{
            NoiseMap.NoiseField[x][y] = lerp(noise(xoff+o*5, yoff+o*5),NoiseMap.NoiseField[x][y],NoiseMap.persistance);
          }
          //xoff = x/scale * frequency;
          //yoff = y/scale * frequency;
          //noiseHeight += terrain[x][y] * amplitude;
  
          //amplitude *= persistance;
          //frequency *= lacunarity;
        }
        xoff += NoiseMap.scale;
      }
      yoff += NoiseMap.scale;
    }
  },
  
  getValue: function getValue(x, y) {
    return NoiseMap.NoiseField[x][y];
  }
}