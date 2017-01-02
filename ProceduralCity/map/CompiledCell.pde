class CompiledCell {
  float cellPopulation;
  color cellColor;
  Vector3 v1, v2;
  
  CompiledCell(Vector3 cv1, Vector3 cv2, color cColor, float cPop) {
    this.v1 = cv1;
    this.v2 = cv2;
    this.cellColor = cColor;
    this.cellPopulation = cPop;
  }
  
  Vector3 getVector1(){
    return this.v1;
  }
  Vector3 getVector2(){
    return this.v2;
  }
  float getPopulation(){
    return this.cellPopulation;
  }
  color getColor(){
    return this.cellColor;
  }
}