var b1, b2, c1, c2;
var Y_AXIS = 1;
var X_AXIS = 2;
var lvl1, lvl2, lvl3, lvl4;

var yStep = 0;

var topMargin =150;
var mouseMap;
var moveSpeed = 2;
var moveDir = 0;
var noiseMap1;
var randSeedX = Math.random(500, 5000);
var randSeedY = Math.random(500, 5000);
var lastRealX = 0;

var cols, depth;

var mouseMapScale = 100;

var perspectiveMode = true;

var maxGrey = 10;
var minGrey = 100;

var fogFlag = true;


// dom vars
var speedLabel;
var speedSlider;

var mountainLabel;
var mountainDwnBtn, mountainUpBtn;
var mountainSlider;
var mountainCount;

var fogCheckBox;

var scaleSlider, scaleLabel;

function setup() {
  var canv = createCanvas(800, 600);
  canv.parent("proc_canvas");

  depth = width; // really the depth
  cols = width*3; // total width, including off screen

  // Define colors
  c1 = color(8, 123, 206);
  b1 = color(66, 134, 244);
  c2 = color(89, 71, 22);
  b2 = color(255, 220, 117);

  lvl1 = height*.10;
  lvl2 = height*.6;
  lvl3 = height*.30;

  noiseMap1 = new NoiseMapClass(cols, depth, .004, randSeedX, randSeedY, 1);

  speedLabel = createSpan("Movement Speed: ");
  speedLabel.parent("proc_params");
  speedSlider = createSlider(0, 25, moveSpeed, 1);
  speedSlider.parent("proc_params");

  mountainLabel = createSpan("Mountain Count: ");
  mountainLabel.parent("proc_params");
  mountainDwnBtn = createButton("-");
  mountainDwnBtn.parent("proc_params");
  mountainDwnBtn.mousePressed(function() {
    mountainSlider.value(mountainSlider.value()-1);
  }
  );
  
  mountainSlider = createSlider(0, 7, 3, 1);
  mountainSlider.parent("proc_params");

  mountainUpBtn = createButton("+");
  mountainUpBtn.parent("proc_params");
  mountainUpBtn.mousePressed(function() {
    mountainSlider.value(mountainSlider.value()+1);
  }
  );
  scaleLabel = createSpan("Noise Scale: ");
  scaleLabel.parent("proc_params");
  scaleSlider = createSlider(0.001,.025,.004,.0005);
  scaleSlider.parent("proc_params");
  scaleSlider.changed(function(){
    noiseMap1 = new NoiseMapClass(cols, depth, scaleSlider.value(), randSeedX, randSeedY, 1);
    redraw();
  });

  fogCheckBox = createCheckbox(' Enable Fog', true);
  fogCheckBox.parent("proc_params");
  fogCheckBox.changed(function() {
    fogFlag = this.checked();
  }
  );
}

function draw() {
  background(color(255));

  // update camera
  mouseMap = max(-1*mouseMapScale, min(map(mouseX, 0, width, -1*mouseMapScale, 1*mouseMapScale), 1*mouseMapScale));
  yStep = abs((yStep+(speedSlider.value()*moveDir))%depth);

  drawSky();
  
  noStroke();
  if (mountainSlider.value()>0) {
    for (var m = 1; m <= mountainSlider.value(); m++) {
      var grey = map(m, 0, mountainSlider.value(), minGrey, maxGrey);
      var scl = map(m, 0, mountainSlider.value(), 0.2, .99);
      drawMountain(grey, yStep, scl);

      if (fogFlag) {
        drawFog(.1);
      }
    }
  }
  drawGUI();
}

function drawGUI() {
  // perspective gui
  fill(color('rgba(0%, 0%, 0%, .1)'));
  var barHeight = 75;
  var cameraHeight = 1;
  cameraHeight = -1*max(-1*mouseMapScale, min(map(mouseY, 0, height, -1*mouseMapScale, 1*mouseMapScale), 1*mouseMapScale));
  
  rect(width*0.625, barHeight/3, width*0.3125, 50);
  rect(map(mouseMap, -1*mouseMapScale, 1*mouseMapScale, width*0.625, width*0.625+(width*0.3125)-(width*0.3125)/3), map(cameraHeight,-1*mouseMapScale,1*mouseMapScale,50,25), width*0.3125/3, barHeight/3);
  fill(color(255, 0, 0));

  // text gui
  text(frameRate(), 10, 10);
  text(yStep, 10, 24);
  text("Move Speed: "+speedSlider.value(), 10, 34);
  text("Mountains: "+mountainSlider.value(), 10, 44);
  text("Noise Scale: " + scaleSlider.value(),10,54);
  text(mouseMap, 10, 64);
}

function drawSky() {
  setGradient(0, 0, width, lvl1, c1, b1, Y_AXIS, 10);
  setGradient(0, lvl1, width, lvl2, b1, b2, Y_AXIS, 10);
  setGradient(0, lvl2+lvl1, width, lvl3, color(216, 182, 86), c2, Y_AXIS, 20);
}

function drawFog(alphaPct) {
  alphaPct = Util.defaultValue(alphaPct, .2);
  push();
  //fill(color('rgba(25%, 52%, 96%, '+alphaPct+')'));
  fill(color('rgba(48%, 55%, 55%, '+alphaPct+')'));
  rect(0, 0, width, height);
  pop();
}


function keyPressed() {
  if (key == 'W') {
    moveDir = 1;
  }
  if (key == 'S') {
    moveDir = -1;
  }
  return false;
}

function keyReleased() {
  if (key == 'W') {
    moveDir = 0;
  }
  if (key == 'S') {
    moveDir = 0;
  }
  return false; // prevent any default behavior
}

function setGradient(x, y, w, h, c1, c2, axis, banding ) {
  banding = Util.defaultValue(banding, 1);
  noFill();
  strokeWeight(banding);
  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (var i = y; i <= y+h; i = i+banding) {
      var inter = map(i, y, y+h, 0, 1);
      var c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (var i = x; i <= x+w; i = i+banding) {
      var inter = map(i, x, x+w, 0, 1);
      var c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}