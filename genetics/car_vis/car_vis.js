function car(x,y){
  this.w = 71.4;
  this.l = 190;
  this.x = x;
  this.y = y;
  this.draw = function(){};
  this.update = function(){};
}

var slider1;

function setup() {
  createCanvas(650,650);
  slider1 = createSlider(100,100000000,100);
}

function draw() {
  background(51);
  var sliderVal = slider1.value();
  text("Cars: "+sliderVal, 50, 50);
  for(var i = 0; i <= sliderVal; i++){
    var tempCar = new car(i,
  }
}