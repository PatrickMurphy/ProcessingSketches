class TerrainType {
  color thisColor;
  TerrainType(float value) {
    color tempcolor = color(0,0,0);
    if (value <= 35) {
      tempcolor = color(30, 144, 255);
    } else if (value > 35 && value <= 40) {
       tempcolor = color(222, 184, 135);
    } else if (value > 40 && value <= 50) {
       tempcolor = color(50, 200, 15);
    } else {
       tempcolor = color(map(value, 0, 100, 0, 255));
    }
    
    thisColor = tempcolor;
  }
}