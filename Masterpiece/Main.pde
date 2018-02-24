void settings() {
  fullScreen(P2D);
}//settings

void setup() {
  background(200);
  noStroke();
  frameRate(10);
  ellipseMode(RADIUS);
}//setup

void draw() {
  fill(random(255), random(255), random(255));
  float off = random(120);
  for (int rep = 0; rep < random(5); rep++) {
    rect(random(width - off), random(height - off), random(1, off), random(1, off));
   }
  for (Circle circle : Circle.circles) {
    fill(circle.c);
    ellipse(circle.x, circle.y, circle.s, circle.s);
  }
}//draw

void mouseDragged() {
  if (pmouseX != mouseX && pmouseY != mouseY) {
    new Circle(mouseX, mouseY);
  }
}//mouseDragged

void mousePressed() {
  new Circle(mouseX, mouseY);
}//mousePressed

class Circle extends Circles {
  float x, y;
  color c = color(random(255), random(255), random(255));
  float s = random(5, 20);
  boolean un = false;
  Circle(float x, float y) {
    this.x = x;
    this.y = y;
    circles.add(this);
  }//Circle
}//Circle

static class Circles {
  static ArrayList<Circle> circles = new ArrayList<Circle>();
}//Circles