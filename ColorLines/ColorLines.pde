PVector focus;
PVector cameraPos;

void setup() { 
  size(400, 400, P3D);
  frameRate(24);
  
  noStroke();
  smooth();
  
  focus = new PVector(width / 2, height / 2, 0);
  cameraPos = focus.copy();
  
  rectMode(CENTER);
  fill(51);
}

void draw() {
  moveCamera();
  
  translate(50, 50, 0);
  //translate(focus.x, focus.y, focus.z);
  //rect(0, 0, 100, 100);
  box(45);
}

int up = 0;

void moveCamera() {
  findNextPoint();
  
  camera(70.0, 35.0, 120.0, 50.0, 50.0, 0.0, 0.0, 1.0, 0.0);
  //camera(cameraPos.x, cameraPos.y, cameraPos.z, focus.x, focus.y, focus.z, up, up, up);
}

int maxMove = 100;

void findNextPoint() {
  /*int min = -maxMove / 2;
  int max = maxMove / 2;
  
  float x = random(min, max);
  float y = random(min, max);
  float z = random(min, max);*/
 
  cameraPos.add(10, 0, 0);
}