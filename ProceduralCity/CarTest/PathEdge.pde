class PathEdge {
  PathPoint p1,p2;
  Direction d;
  
  PathEdge(PathPoint p1, PathPoint p2, Direction d){
    this.p1 = p1;
    this.p2 = p2;
    this.d = d;
  }
  
  void display2D(){
    line(p1.x, p1.y, p2.x, p2.y);
  }
}