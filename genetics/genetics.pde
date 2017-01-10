import java.util.Iterator;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.Arrays;

int popSize = 20;
int width = 800;
int height = 800;
CopyOnWriteArrayList<human> humans = new CopyOnWriteArrayList<human>(); 
CopyOnWriteArrayList<human> alivehumans = new CopyOnWriteArrayList<human>(); 
int tick = 0;
int humanID =0;
int numberAlive = popSize;
int maxKillCount = 0;
int years = 0;
int daySpeed=7;//week at a time
float day = 0.00273972602*daySpeed;
float timeElapsed = 0;
int maxGen = 0;
int male = 0;
int female = 0;
double maxTrend = popSize;
double minTrend = 0;
boolean trendRecorded = false;
LinearRegression lr;

double[] popTrend = {popSize, popSize, popSize, popSize, popSize, popSize, popSize, popSize, popSize, popSize};

int[][] genderAge = new int[2][6];

void setup() {  
  size(800, 800);                      
  for (int i = 0; i<popSize; i++) {
    human t = new human(random(85), random(2, 5), random(width), random(height), random(360), random(1000));
    humans.add(t);
    alivehumans.add(t);
  }
  maxTrend = Math.max(popTrend[0], Math.max(popTrend[1], Math.max(popTrend[2], Math.max(popTrend[3], Math.max(popTrend[4], Math.max(popTrend[5], Math.max(popTrend[6], Math.max(popTrend[7], Math.max(popTrend[8], popTrend[9])))))))));
  minTrend = Math.min(popTrend[0], Math.min(popTrend[1], Math.min(popTrend[2], Math.min(popTrend[3], Math.min(popTrend[4], Math.min(popTrend[5], Math.min(popTrend[6], Math.min(popTrend[7], Math.min(popTrend[8], popTrend[9])))))))));
  lr = new LinearRegression(popTrend);
}

void draw() {
  background(0);
  stroke(255);
  tick++;
  if (second()%5==0) {
    if (!trendRecorded) {
      popTrend[0] = popTrend[1];
      popTrend[1] = popTrend[2];
      popTrend[2] = popTrend[3];
      popTrend[3] = popTrend[4];
      popTrend[4] = popTrend[5];
      popTrend[5] = popTrend[6];
      popTrend[6] = popTrend[7];
      popTrend[7] = popTrend[8];
      popTrend[8] = popTrend[9];
      popTrend[9] = numberAlive;
      trendRecorded = true;
      maxTrend = Math.max(popTrend[0], Math.max(popTrend[1], Math.max(popTrend[2], Math.max(popTrend[3], Math.max(popTrend[4], Math.max(popTrend[5], Math.max(popTrend[6], Math.max(popTrend[7], Math.max(popTrend[8], popTrend[9])))))))));
      minTrend = Math.min(popTrend[0], Math.min(popTrend[1], Math.min(popTrend[2], Math.min(popTrend[3], Math.min(popTrend[4], Math.min(popTrend[5], Math.min(popTrend[6], Math.min(popTrend[7], Math.min(popTrend[8], popTrend[9])))))))));
      lr = new LinearRegression(popTrend);
    }
  } else {
    trendRecorded = false;
  }

  male = 0;
  female = 0;
  Arrays.fill(genderAge[0], 0);
  Arrays.fill(genderAge[1], 0);


  for (Iterator<human> it = humans.iterator(); it.hasNext(); ) {
    human h = it.next();
    h.update();
    h.display();
    genderAge[(h.gender?0:1)][h.getAgeGroup()]++;
    male += (h.gender?0:1);
    female += (h.gender?1:0);
  }



  textSize(11);
  fill(255, 255, 255);
  text("Most Kills: "+maxKillCount, 10, 13); 
  text("Population: "+numberAlive, 10, 24); 
  timeElapsed += day;
  text("Years: "+timeElapsed, 10, 35); 
  text("Highest Generation: "+maxGen, 10, 46); 
  fill(255, 255, 255);
  text("Male: "+male + " Female: " + female, 10, 57); 

  int offset_genderbars = 150;
  textSize(8);
  text("0-9: ", width-offset_genderbars, 11); 
  text("10-18: ", width-offset_genderbars, 23); 
  text("19-36: ", width-offset_genderbars, 36); 
  text("37-54: ", width-offset_genderbars, 48); 
  text("55-72: ", width-offset_genderbars, 60); 
  text("73+: ", width-offset_genderbars, 72); 


  noStroke();
  fill(255, 255, 255, 80);
  rect((float)((width/2.0)-75.0), 0, 150.0, 50);
  fill(255, 255, 255, 255);
  text(maxTrend+"", ((width/2.0)-75.0)-20, 8);
  text(minTrend+"", ((width/2.0)-75.0)-15, 50);
  //first point 
  float xOff = 150.0/9.0;
  float xx1 = (width/2.0)-75.0;
  float yy1 = (float)(50-((popTrend[0]-minTrend)/(maxTrend-minTrend))*50);
  float xx2 = xx1+xOff;
  float yy2 = (float)(50-((popTrend[1]-minTrend)/(maxTrend-minTrend))*50);
  float xx3 = xx2+xOff;
  float yy3 =  (float)(50-((popTrend[2]-minTrend)/(maxTrend-minTrend))*50);
  float xx4 = xx3+xOff;
  float yy4 = (float)(50-((popTrend[3]-minTrend)/(maxTrend-minTrend))*50);
  float xx5 = xx4+xOff;
  float yy5 = (float)(50-((popTrend[4]-minTrend)/(maxTrend-minTrend))*50);
  float xx6 = xx5+xOff;
  float yy6 = (float)(50-((popTrend[5]-minTrend)/(maxTrend-minTrend))*50);
  float xx7 = xx6+xOff;
  float yy7 = (float)(50-((popTrend[6]-minTrend)/(maxTrend-minTrend))*50);
  float xx8 = xx7+xOff;
  float yy8 = (float)(50.0-((popTrend[7]-minTrend)/(maxTrend-minTrend))*50);
  float xx9 = xx8+xOff;
  float yy9 = (float)(50.0-((popTrend[8]-minTrend)/(maxTrend-minTrend))*50);
  float xx10 = xx9+xOff;
  float yy10 = (float)(50.0-((popTrend[9]-minTrend)/(maxTrend-minTrend))*50);

  stroke(255);
  line(xx1, yy1, xx2, yy2);
  line(xx2, yy2, xx3, yy3);
  line(xx3, yy3, xx4, yy4);
  line(xx4, yy4, xx5, yy5);
  line(xx5, yy5, xx6, yy6);
  line(xx6, yy6, xx7, yy7);
  line(xx7, yy7, xx8, yy8);
  line(xx8, yy8, xx9, yy9);
  line(xx9, yy9, xx10, yy10);
  stroke(255/2);
  line(xx1, (float)(50-((lr.getValue(1)-minTrend)/(maxTrend-minTrend))*50), xx10, (float)(50-((lr.getValue(10)-minTrend)/(maxTrend-minTrend))*50));
  noStroke();
  fill(255, 105, 180, 255*.75);
  float barScale = (-50.0/(numberAlive/2.0));
  float barScale2 = (50.0/(numberAlive/2.0));
  rect(width-65, 10-3.5, barScale*((float)genderAge[0][0]), 5);
  rect(width-65, 22-3.5, barScale*((float)genderAge[0][1]), 5);
  rect(width-65, 34-3.5, barScale*((float)genderAge[0][2]), 5);
  rect(width-65, 46-3.5, barScale*((float)genderAge[0][3]), 5);
  rect(width-65, 58-3.5, barScale*((float)genderAge[0][4]), 5);
  rect(width-65, 70-3.5, barScale*((float)genderAge[0][5]), 5);
  // boy
  fill(0, 191, 255, 255*.75);
  rect(width-63, 10-3.5, barScale2*(genderAge[1][0]), 5);
  rect(width-63, 22-3.5, barScale2*(genderAge[1][1]), 5);
  rect(width-63, 34-3.5, barScale2*(genderAge[1][2]), 5);
  rect(width-63, 46-3.5, barScale2*(genderAge[1][3]), 5);
  rect(width-63, 58-3.5, barScale2*(genderAge[1][4]), 5);
  rect(width-63, 70-3.5, barScale2*(genderAge[1][5]), 5);
  stroke(255);
}