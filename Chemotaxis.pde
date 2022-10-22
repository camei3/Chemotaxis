int count = 100;

int screenW = 1200;
int screenH = 875;

boolean chemotaxis = true;
int[] rgb;

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
    
    light = color(rgb[2]+(int)((Math.random()-0.5)*50), rgb[1]+(int)((Math.random()-0.5)*50), rgb[0]+(int)((Math.random()-0.5)*50));
    
    myRadius = (float)(Math.random()*2)+1;
    myT =(int)(Math.random()*360);
    myVelocity = (float)(Math.random()+0.5) * myRadius;
    mySize = (float)(Math.random()*2)+1;

    oldX = myX = centerX+myRadius;
    oldY = myY = centerY+myRadius;
  }
  void flash() {
    
    //flips rotation average every 360 degrees
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
    
    oldX = myX + (float)(Math.random()-0.5)*2;
    oldY = myY + (float)(Math.random()-0.5)*2;
    
    myX = anchX + cos(radians(myT));
    myY = anchY + sin(radians(myT));
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
  size(1200, 875);
  background(0);

  rgb = newColorRange();
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
  rgb = newColorRange();
  anchorX = mouseX;
  anchorY = mouseY;
}

void mouseReleased() {
  //could be compacted with the other clear screens, maybe with a function?
  fill(0);
  noStroke();
  rect(-width, -height, width*3, height*3);  
}

void keyPressed() {
  if (key == ' ') {
    chemotaxis = !chemotaxis;
  }
}

void mouseWheel(MouseEvent event) {
  if (event.getCount() == -1) {
    addBolt(1);
  }
  if (event.getCount() == 1 && count > 0) {
    removeBolt(1);
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

color[] newColorRange() {
  int[] colors = new int[3];
  int vibrancy = 255;
  for (int i = 0; i < colors.length; i++) {
    vibrancy -= (int)(Math.random() * vibrancy);
    colors[i] = 255 - vibrancy;
  }
  return colors;
}
