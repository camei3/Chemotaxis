class Bolt {
  float myX, myY, myT = 0;
  float centerX, centerY, myR;
  color light;
  Bolt() {
    centerX = 400;
    centerY = 400;
    light = color((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
    myR = (float)(Math.random()*50+10);
    
  }
  void flash() {
    myX = centerX + myR * cos(myT);
    myY = centerY + myR * sin(myT);
    
    myT++;
  
  }
  void show() {
    strokeWeight(4);
    stroke(light);
    point(myX,myY);
  }

}
Bolt [] bolts = new Bolt[10];
void setup() {
  size(800,800);
  background(0);
  for (int i = 0; i < bolts.length; i++) {
    bolts[i] = new Bolt();
  }
}

void draw() {
  background(0);
  for (int i = 0; i < bolts.length; i++) {
    bolts[i].flash();
    bolts[i].show();
  }
}
