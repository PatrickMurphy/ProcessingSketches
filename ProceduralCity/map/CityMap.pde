class CityMap {
  float[][] cityMap;
  int cols, rows;


  CityMap(int c, int r) {
    cols = c;
    rows = r;
    cityMap = new float[c][r];
  }

  void setValue(int x, int y, float val) {
    cityMap[x][y] = val;
  }

  Vector3[] getNHighest(int n) {
    Vector3[] high = {
                new Vector3(0, 0, -1),
                new Vector3(0, 0, -2),
                new Vector3(0, 0, -3),
                new Vector3(0, 0, -4),
                new Vector3(0, 0, -5)
        };
    for (int y = 0; y<rows; y++) {
      for (int x = 0; x<cols; x++) {
        int lowestIndex = -1;
        float lowestHigh = -1;
        // for every city value find n highest
        for(int i = 0; i<n; i++){
          float temp = high[i].getZ();
          if(cityMap[x][y] > temp){
            if(temp<lowestHigh){
              lowestHigh = temp;
              // so confused
            }
          }
        }
        if(lowestIndex > -1){
          high[lowestIndex] = new Vector3(x,y,cityMap[x][y]);
        }
      }
    }
    return high;
  }

  float getValue(int x, int y) {
    return cityMap[x][y];
  }
}