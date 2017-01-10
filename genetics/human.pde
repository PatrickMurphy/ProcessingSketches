import java.util.Iterator;

class human {
  //float day = 0.00273972602;
  //population[i][1] = population[i][1]+(day*7); // add about a day to age
  boolean gender;
  float age = 18;
  float speed = 10;
  float x = 0;
  float y = 0;
  float heading = 0;
  boolean alive;
  int id =0;
  int lastBaby = 0;
  int strengthMod = 1;
  float aggression;
  float babyCount = 0;
  int killCount = 0;
  ArrayList<human> removelist = new ArrayList<human>();

  int generation = 0;
  float babyThreshold = 16;
  float oldAgeThreshold = 85;



  human(float age, float speed, float x, float y, float heading, float agg) {
    this.gender = (random(50) >= 25? true : false);
    this.age = age;
    this.speed =speed;
    this.x = x;
    this.y = y;
    this.heading = heading;
    this.alive = true;
    this.id = humanID++;
    this.lastBaby = -1;
    this.strengthMod = 1;
    this.aggression = agg;
    numberAlive++;
  }

  boolean isAdult() {
    return age>=18;
  }

  float getSpeed() {
    float mod =1;
    if (!isAdult()) {
      mod = 1.4;
    } else if (age>=60) {
      mod = 0.3;
    }
    return (speed*mod);
  }

  float getRadius() {
    return this.age/1.5;
  }
  
  int getAgeGroup(){
    int group = 0;
    //0-9
    //10-18
    if(this.age > 9){
      group = 1;
    }
    //19-36
    if(this.age > 18){
      group = 2;
    }
    //37-54
    if(this.age > 36){
      group = 3;
    }
    //55-72
    if(this.age > 54){
      group = 4;
    }
    //73+
    if(this.age > 72){
      group = 5;
    }
    return group;
  }

  float getStrength() {
    float mod =1;
    if (!isAdult()) {
      mod = 1.4;
    } else if (age>=60) {
      mod = 0.3;
    } else if (age < 25) {
      mod = 1.7; // prime of life
    }
    return (float)Math.pow((age*mod)-(speed/2), 2)*strengthMod;
  }
  boolean checkCollision(human h) {
    float dist = (float)Math.sqrt(Math.pow(this.x-h.x, 2)+Math.pow(this.y-h.y, 2));
    return dist<(this.getRadius()+h.getRadius());
  }

  void breed(human h2) {
    human mom = h2;
    if (this.gender) {
      mom = this;
    }
    if (mom.lastBaby == -1 || millis()-mom.lastBaby>((babyThreshold*1000))) {
      mom.babyCount++;
      h2.babyCount++;
      mom.lastBaby = millis();
      human t = new human(1, (h2.getSpeed()+this.getSpeed())/2+random(-.5,1), mom.x, mom.y, random(360), (h2.aggression+this.aggression)/2+random(-50, 150));
      t.generation = (mom.generation>h2.generation?mom.generation:h2.generation)+1;
      if(t.generation >= maxGen){
        maxGen = t.generation;
      }
      System.out.println("Mom: "+mom + " child: " + t);
      humans.add(t);
      alivehumans.add(t);
    }
  }

  void interact(human h2) {
    if (h2.isAdult() && this.isAdult()) {
      if (h2.gender ^ this.gender) {
        // not same gender && adult, breed
        this.breed(h2);
      } else {
        // same gender adult
        if (this.aggression > 750 || (this.aggression > 400 && h2.aggression > 400)) {//750 dont matter, ima kill you, either less than 400 leave eachother alone
          if (h2.getStrength()>=this.getStrength()) {
            h2.speed += .3;
            h2.strengthMod += .1;
            h2.killCount++;
            if (h2.killCount > maxKillCount) {
              maxKillCount = h2.killCount;
            }
            println("Aggressor: "+h2+" killed " + this);
            die();
          }
        }
      }
    }
  }

  void die() {
    numberAlive--;
    if (maxKillCount <= this.killCount) {
        maxKillCount = 1;
    }
    this.alive = false;
    removelist.add(this);
  }


  void checkBounds() {
    this.x = this.x % width;
    this.y = this.y % height;
    if (this.y < 0) {
      this.y = height;
    }
    if (this.x <= 0) {
      this.x = width;
    }
  }

  void update() {
    if (alive) {
      for (Iterator<human> it = alivehumans.iterator(); it.hasNext(); ) {
        human h2 = it.next();
        if (h2.id!=this.id && h2.alive && this.checkCollision(h2)) {
          this.interact(h2);
        }
      }

      if (random(100)<3) {
        this.heading = (this.heading + random(-6, 12))%360;
      }
      float vx = getSpeed() * cos(radians(heading));
      float vy = getSpeed() * sin(radians(heading));


      this.x += vx;
      this.y += vy;

      this.checkBounds();

      this.age += (day); // add about a day to age

      if (this.age >= oldAgeThreshold) {
        if (random(100)<=(20/(killCount/1.5))) {
          die();
        }
      }
    }
    humans.removeAll(removelist);
    alivehumans.removeAll(removelist);
  }

  void display() {
    float alpha = 255;
    if (alive) {   
      if (age >= oldAgeThreshold) {
        alpha = 255-((age-oldAgeThreshold)*40);
      } else if (age >= 60) {
        alpha = 220;
      }
      if (this.gender) {
        //girl
        fill(255, 105, 180, alpha);
      } else {
        fill(0, 191, 255, alpha);
      }

      if (!this.isAdult()) {
        fill(255, 255, 255);// white childs
      }

      pushMatrix();
      translate(this.x, this.y);
      rotate(radians(this.heading-90));

      float x1 =0;
      float y1 =0;
      float radius = getRadius();

      float cx = x1;
      float cy = (float) (y1+((Math.sqrt(3)/3)*radius));
      float bx = x1-(radius/2);
      float by = (float)(y1-((Math.sqrt(3)/6)*radius));
      float ax = x1+(radius/2);
      float ay = (float)(y1-((Math.sqrt(3)/6)*radius));

      triangle(cx, cy, bx, by, ax, ay);
      ellipse(x1, y1, 3, 3);
      ellipse(cx, cy, 3, 3);
      if (maxKillCount <= this.killCount) {
        fill(224, 193, 1, 255/2);
        ellipse(x1, y1, radius, radius);
      }
      popMatrix();
    }
  }


  String toString() {
    return "#"+this.id+ " a "+ this.age +" yrold " + (this.gender?"female":"male") + " with a speed of " + this.getSpeed() + " and strength of " + this.getStrength() + " agg: " + this.aggression;
  }
}