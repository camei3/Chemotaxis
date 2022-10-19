int count = 100;

int screenW = 1200;
int screenH = 875;

boolean chemotaxis = true;

class Bolt {
  float oldX, oldY;  
  float myX, myY;
  
  float myT = 0;
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

    oldX = myX = centerX+myRadius;
    oldY = myY = centerY+myRadius;
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
    float anchorRadius = (float)Math.random()*myRadius;
    float anchorAngle = atan((centerY-myY)/(centerX-myX));
    if (myX > centerX) {
      anchorAngle += PI;
    }
    float anchX = myX + cos(anchorAngle)*anchorRadius;
    float anchY = myY + sin(anchorAngle)*anchorRadius;
    oldX = myX;
    oldY = myY;
    
    myX = anchX + cos(radians(myT));
    myY = anchY + sin(radians(myT));
    myT += myVelocity;
    resetMatrix();
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
  size(1200, 875);
  background(0);

  bolts = new Bolt[count];
  for (int i = 0; i < count; i++) {
    bolts[i] = new Bolt(false);
  }
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
    } else {
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

  if (key == 'w' || keyCode == UP) {
    addBolt(1);
  }

  if ((key == 's' || keyCode == DOWN) && count > 0) {
    removeBolt(1);
  }

  if (key == ' ') {
    chemotaxis = !chemotaxis;
  }
}

void addBolt(int amount) {
    tempBolts = new Bolt[count];
    for (int i = 0; i < bolts.length; i++) {
      tempBolts[i] = bolts[i];
    }
    count += amount;
    bolts = new Bolt[count];
    for (int i = 0; i < tempBolts.length; i++) {
      bolts[i] = tempBolts[i];
    }    
    bolts[bolts.length-1] = new Bolt(true);
}

void removeBolt(int amount) {
    tempBolts = new Bolt[count];
    for (int i = 0; i < bolts.length; i++) {
      tempBolts[i] = bolts[i];
    }
    count -= amount;
    bolts = new Bolt[count];
    for (int i = 0; i < bolts.length; i++) {
      bolts[i] = tempBolts[i+1];
    }
}

//maybe UI for total fireworks and coords and stuff
//click will change the range of colors you can get? thatll make each core more consistent
