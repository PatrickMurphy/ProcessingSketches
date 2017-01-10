class PathEdge {
  PathPoint p1, p2;
  Direction d;

  PathEdge(PathPoint p1, PathEdge partial) {
    this(p1, partial.p2, partial.d);
  }

  PathEdge(PathEdge partial, PathPoint p2) {
    this(partial.p1, p2, partial.d);
  }

  PathEdge(PathPoint p1, PathPoint p2, Direction d) {
    this.p1 = p1;
    this.p2 = p2;
    this.d = d;
  }

  void display2D() {
    line(p1.x, p1.y, p2.x, p2.y);
  }

  String toString() {
    return p1.toString() + p2.toString() + d.toString();
  }
}