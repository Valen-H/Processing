final float depth = (width + height) / 2;
final float scale = (width + height + depth) / 35;
ArrayList<ParticleSource> production = new ArrayList<ParticleSource>();

void settings() {
  fullScreen(P2D);
}

void setup() {
  noStroke();
  frameRate(25);
  ellipseMode(RADIUS);
  colorMode(RGB);
  lights();
}

void draw() {
  clear();
  background(150);
  if (!boolean(int(random(4)))) {
    production.add(new ParticleSource(random(width), random(height)));
  }
  ArrayList<ParticleSource> temp = new ArrayList<ParticleSource>();
  for (ParticleSource source : production) {
    source.produce();
    if (boolean(int(random(5)))) {
      temp.add(source);
    }
  }
  production = temp;
  for (Particle particle : (ArrayList<Particle>) Particle.particles.clone()) {
    fill(particle.c);
    ellipse(particle.X, particle.Y, particle.S, particle.S);
    particle.tick();
  }
}

void mouseReleased() {
  production.add(new ParticleSource(mouseX, mouseY));
}

void mousePressed() {
  production.add(new ParticleSource(mouseX, mouseY));
}

void mouseDragged() {
  new ParticleSource(mouseX, mouseY);
}

color randomColor() {
  return color(random(255), random(255), random(255));
}