void setup() {
  size(600, 200, P2D);
  frameRate(60);
  smooth();
}

float[] createPoints() {
  float[] points = new float[width];
  
  for (int i = 0; i < width; i++) {
    int start = i + frameCount;
    points[i] = noise(start * .01) * height;
  }
  
  return points;
}

void renderPoints(float[] points) {
  for (int i = 1; i < points.length; i++) {
    int x = frameCount + i;
    float prev = points[i - 1];
    float current = points[i];
    
    line(x - 1, prev, x, current);
  }
}

void draw() {
  background(255, 255, 255);
  translate(-frameCount, 0);
  
  float[] points = createPoints();
  renderPoints(points);
}