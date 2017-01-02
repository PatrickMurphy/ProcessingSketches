var displayHeightScale = .5;
var mountainScaleStretchMode = true;

function drawMountain(fillF, stepS, scaleS) {
  fillF = int(Util.defaultValue(fillF, 50));
  stepS = int(Util.defaultValue(stepS, 0));
  scaleS = Util.defaultValue(scaleS, 1);
  
  var substep = parseInt(depth*scaleS);
  
  stepS = (stepS+substep)%depth;
    
  fill(fillF);
  noStroke();
  var cameraHeight = 1;
  cameraHeight = -1*max(-1*mouseMapScale, min(map(mouseY, 0, height, -1*mouseMapScale, 1*mouseMapScale), 1*mouseMapScale));
  if (perspectiveMode) {
    
    beginShape();
    var frontOffset = int(map(mouseMap*scaleS, -1*mouseMapScale, 1*mouseMapScale, 0, (width*2)-2));
    for (var x = frontOffset; x < frontOffset+width; x++) {
      if (x==frontOffset) {
        vertex(0, height);
      }
      if(mountainScaleStretchMode){
        var heightValue = (noiseMap1.getValue(x, stepS)*((cameraHeight)+(height*(scaleS*displayHeightScale))))+topMargin;
      }else{
        var heightValue = topMargin+(noiseMap1.getValue(x, stepS)*75)+((cameraHeight*2)*(scaleS*displayHeightScale));//(cameraHeight+(height*(scaleS*displayHeightScale))));
      }
      vertex(x-frontOffset, heightValue);

      if (x==(frontOffset+width)-1) {
        vertex(width, height);
      }
    }
    endShape(CLOSE);
  } else {
    beginShape();
    for (var x = 0; x < width; x++) {
      if (x==0) {
        vertex(0, height);
      }
      
      vertex(x, (noiseMap1.getValue(x, stepS)*(height*(scaleS*displayHeightScale)))+topMargin);
      
      if (x==width-1) {
        vertex(width, height);
      }
    }
    endShape(CLOSE);
  }
}