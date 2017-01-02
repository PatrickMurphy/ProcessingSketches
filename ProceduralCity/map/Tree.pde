class Tree {
  Vector3 pos;
  float age;
  float treeAngle;

  Tree(int x, int y,float z, float age) {
    this.age = age;
    this.pos = new Vector3(x,y,z);
    this.treeAngle = PI/((int) random(1,6));
  }
  void display(){
    fill(112,74,12);
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    rotateZ(treeAngle);
    // add cylindar
    box(age*4,age*4,age*20);
    // add branches
    // add leaves
    popMatrix();
  }
}