int count = 0;
int screenW = 800;
int screenH = 450;
boolean chemotaxis = false;
class Bolt {
  float myX, myY;
  float myT = 0;
  float oldX, oldY;
  float centerX, centerY, myRadius, myVelocity, mySize; 
  color light;
  Bolt(boolean fromMouse) {
    if (fromMouse) {
      centerX = anchorX;
      centerY = anchorY;
    } else {
      centerX = screenW/2;
      centerY = screenH/2;
    }
    light = color((int)(Math.random()*200+55), (int)(Math.random()*200+55), (int)(Math.random()*200+55));
    myRadius = (float)(Math.random()*2)+1;
    myT =(int)(Math.random()*360);
    myVelocity = (float)(Math.random()+0.5) * myRadius;
    mySize = (float)(Math.random()*2)+1;

    myX = centerX+myRadius;
    myY = centerY+myRadius;
    oldX = myX;
    oldY = myY;
  }
  void flash() {
    if (Math.random() < abs(myVelocity*myRadius)/360) {
      myVelocity *= -1;
    }

    oldX = myX + (float)(Math.random()-0.5)*5;
    oldY = myY + (float)(Math.random()-0.5)*5;

    myX += -sin(radians(myT + (float)(Math.random()-0.5))) * myRadius + (float)(Math.random()-0.5);
    myY += cos(radians(myT + (float)(Math.random()-0.5))) * myRadius + (float)(Math.random()-0.5);
    myT += myVelocity;
  }
  void converge() {
    //needs testing
    float holdX = oldX, holdY = oldY;
    if (dist(holdX,holdY,screenW/2,screenH/2) > dist(myX,myY,screenW/2,screenH/2)) {
      myVelocity *= -1;
    }
    if (Math.random() < abs(myVelocity*myRadius)/360) {
      myVelocity *= -1;
    }
    oldX = myX + (float)(Math.random()-0.5)*5;
    oldY = myY + (float)(Math.random()-0.5)*5;

    //program homing here
    myX += -sin(radians(myT + (float)(Math.random()-0.5))) * myRadius + (float)(Math.random()-0.5);
    myY += cos(radians(myT + (float)(Math.random()-0.5))) * myRadius + (float)(Math.random()-0.5);
    myT += myVelocity;
  }  
  void show() {
    strokeWeight(mySize);
    stroke(light);
    line(myX, myY, oldX, oldY);
  }
}
Bolt [] tempBolts;
Bolt [] bolts;
void setup() {
  size(800,450);
  background(0);
  bolts = new Bolt[count];
}

float anchorX, anchorY;

void draw() {
  resetMatrix();
  if (mousePressed) {
    translate(mouseX-anchorX, mouseY-anchorY);
    fill(0, 99);
  } else {
    anchorX = screenW/2;
    anchorY = screenH/2;
    fill(0, 10);
  }
  noStroke();
  rect(-width, -height, width*3, height*3);

  for (int i = 0; i < bolts.length; i++) {
    if (!chemotaxis) {
      bolts[i].flash();
    }
    if (mouseButton == RIGHT) {
      bolts[i].converge();
    }
    bolts[i].show();
  }
  
  //strokeWeight(10);  
  //stroke(255);
  //point(anchorX,anchorY);  
}

void mousePressed() {
  anchorX = mouseX;
  anchorY = mouseY;
}
void keyPressed() {
  
  if (key == 'w') {
    tempBolts = new Bolt[count];
    for (int i = 0; i < bolts.length; i++) {
      tempBolts[i] = bolts[i];
    }
    count++;
    bolts = new Bolt[count];
    for (int i = 0; i < tempBolts.length; i++) {
      bolts[i] = tempBolts[i];
    }    
    bolts[bolts.length-1] = new Bolt(true);
  }
  
  if (key == 's' && count > 0) {
    tempBolts = new Bolt[count];
    for (int i = 0; i < bolts.length; i++) {
      tempBolts[i] = bolts[i];
    }
    count--;
    bolts = new Bolt[count];
    for (int i = 0; i < bolts.length; i++) {
      bolts[i] = tempBolts[i+1];
    }
  }
  
  if (key == ' ') {
    chemotaxis = !chemotaxis;
  }
  
}
//maybe UI for total fireworks and coords and stuff
//event when collide? create new array to store firework, delete  & shift array? or if lazy set new mode for individual firework
