int count = 0;


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
      centerX = 1600/2;
      centerY = 800/2;
    }
    light = color((int)(Math.random()*200+55), (int)(Math.random()*200+55), (int)(Math.random()*200+55));
    myRadius = (float)(Math.random()*2)+1;
    myT =(int)(Math.random()*360);
    myVelocity = (float)(Math.random()+0.5);
    mySize = (float)(Math.random()*2)+1;

    myX = centerX+myRadius;
    myY = centerY+myRadius;
  }
  void flash() {
    if (Math.random() < 0.001) {
      myVelocity *= -1;
    }

    oldX = myX + (float)(Math.random()-0.5)*5;
    oldY = myY + (float)(Math.random()-0.5)*5;

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
  size(1600, 800);
  background(0);
  bolts = new Bolt[count];
  for (int i = 0; i < bolts.length; i++) {
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
    anchorX = width/2;
    anchorY = height/2;
    fill(0, 10);
  }

  noStroke();
  rect(-width, -height, width*3, height*3);

  for (int i = 0; i < bolts.length; i++) {
    bolts[i].flash();
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
  
}
