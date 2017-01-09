import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
 
import shapes3d.utils.*;
import shapes3d.*;
 
import processing.opengl.*;
 
Box[] box = new Box[10];
float a;
PeasyCam pcam;
boolean mouseClicked = false;
 
void setup(){
  size(200,200,OPENGL);
  pcam = new PeasyCam(this,0,0,0,100);
 
  cursor(CROSS);
  float size;
  for (int i = 0; i < box.length; i++) {
    size = 5 + (int)random(15);
    box[i] = new Box(this,size,size,size);
    box[i].moveTo(random(-18,18), random(-18,18), random(-18,18));
    box[i].fill(randomColor());
  }
}
 
void draw(){
  background(255);
  pushMatrix();
  ambientLight(200,200,200);
  directionalLight(128, 128, 128, -1, 0, -1);
 
  for (int i = 0; i < box.length; i++) {
    box[i].draw();
  }
    if(mouseClicked){
    Shape3D picked = Shape3D.pickShape(this,mouseX, mouseY);
    if(picked != null)
      picked.fill(randomColor());
    mouseClicked = false;
  }
 
  popMatrix();
  a += 0.002;
}
 
void mouseClicked(){
  mouseClicked = true;
}
 
int randomColor(){
  return color(random(60,200), random(60,200), random(60,200));
}