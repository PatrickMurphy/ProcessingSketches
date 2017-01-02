function NoiseMapClass(c, r, s, seedX, seedY, oct, pers, lacu) {
    
    this.generateMap = function generateMap() {
        var yoff = this.seed_y;
        var lerpMap;
        if(this.octaves > 0){
          lerpMap = new NoiseMapClass(cols, depth, .018, randSeedX, randSeedY, 0);
        }
        for (var y = 0; y < this.rows; y++) {
            var xoff = this.seed_x;
            for (var x = 0; x < this.cols; x++) {
                //float amplitude = 1;
                //float frequency = 1;
                //float noiseHeight = 0;
                for (var o = 0; o <= this.octaves; o++) {
                    if (o == 0) {
                        this.NoiseField[x][y] = noise(xoff, yoff);
                    }
                    else {
                        this.NoiseField[x][y] = lerp(lerpMap.getValue(x,y), this.NoiseField[x][y], this.persistance);
                    }
                    //xoff = x/scale * frequency;
                    //yoff = y/scale * frequency;
                    //noiseHeight += terrain[x][y] * amplitude;
                    //amplitude *= persistance;
                    //frequency *= lacunarity;
                }
                xoff += this.scale;
            }
            yoff += this.scale;
        }
    }
    this.getValue = function getValue(x, y) {
        return this.NoiseField[x][y];
    }
         
      this.cols = Util.defaultValue(c, 10);
      this.rows = Util.defaultValue(r, 10);
      this.scale = Util.defaultValue(s, 0.02);
      this.octaves = Util.defaultValue(oct, 0);
      this.persistance = Util.defaultValue(pers, .73);
      this.lacunarity = Util.defaultValue(lacu, 2);
      this.seed_x = Util.defaultValue(seedX, Math.random(500, 5000));
      this.seed_y = Util.defaultValue(seedY, Math.random(500, 5000));
      this.NoiseField = new Array(this.cols);
      for (var i = 0; i < this.cols; i++) {
          this.NoiseField[i] = new Array(this.rows);
      }
      this.generateMap();
}