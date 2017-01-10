class PathPoint extends PVector {
  
  PathPoint(PVector v){
    this(v.x,v.y,v.z);
  }
  
  PathPoint(float x, float y, float z){
    super(x,y,z);
  }
  
  PathPoint(int x, int y, int z){
    super(x,y,z);
  }
}