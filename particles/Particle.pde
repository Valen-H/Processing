class Particle extends Particles {
  float x, y, z, dx, dy, dz, s, ds, X, Y, Z, S, C;
  color c, dc;
  int l, L;
  boolean d = false;
  Particle(float x, float y, float z, float dx, float dy, float dz, float s, float ds, color c, color dc) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.dx = dx;
    this.dy = dy;
    this.dz = dz;
    this.X = x;
    this.Y = y;
    this.Z = z;
    this.s = s;
    this.ds = ds;
    this.S = s;
    this.c = c;
    this.dc = dc;
    this.C = c;
    l = int(random(5, 80));
    L = l;
    addParticle(this);
  }//x y z dx dy dz s ds c dc  10
  Particle() {
    this(random(width), random(height), random(depth), random(- scale, scale), random(- scale, scale), random(- scale, scale), random(scale), random(- scale / 2, scale / 2), randomColor(), color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//0
  Particle(float x, float y) {
    this(x, y, random(depth), random(scale), random(scale), random(scale), random(scale), random(scale / 2), randomColor(), color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//2
  Particle(float x, float y, float z) {
    this(x, y, z, random(- scale, scale), random(- scale, scale), random(- scale, scale), random(scale), random(- scale / 2, scale / 2), randomColor(), color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//3
  Particle(float x, float y, float dx, float dy) {
    this(x, y, random(depth), dx, dy, random(- scale, scale), random(scale), random(- scale / 2, scale / 2), randomColor(), color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//4
  Particle(float x, float y, float z, float s, color c) {
    this(x, y, z, random(- scale, scale), random(- scale, scale), random(-scale, scale), s, random(- scale / 2, scale / 2), c, color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//5
  Particle(float x, float y, float z, float dx, float dy, float dz) {
    this(x, y, z, dx, dy, dz, random(scale), random(- scale / 2, scale / 2), randomColor(), color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//6
  Particle(float x, float y, float z, float dx, float dy, float dz, float s) {
    this(x, y, z, dx, dy, dz, s, random(- scale / 2, scale / 2), randomColor(), color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//7
  Particle(float x, float y, float z, float dx, float dy, float dz, float s, float ds) {
    this(x, y, z, dx, dy, dz, s, ds, randomColor(), color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//8
  Particle(float x, float y, float z, float dx, float dy, float dz, float s, float ds, color c) {
    this(x, y, z, dx, dy, dz, s, ds, c, color(random(255 / 2), random(255 / 2), random(255 / 2)));
  }//9
  Particle tick(int times) {
    for (; times > 0; times--) {
      X += dx;
      Y += dy;
      Z += dz;
      S += ds;
      C += dc;
      L--;
    }
    if (L <= 0 || X > width + S || X < - S || Y > height + S || Y < - S || S > scale * 5 || S <= 0) {
      d = true;
      return removeParticle(this);
    }
    return this;
  }
  Particle tick() {
    return tick(1);
  }
}

static private class Particles {
  static final ArrayList<Particle> particles = new ArrayList<Particle>();
  static int size = 0;
  static int addParticle(Particle particle) {
    particles.add(particle);
    size = particles.size();
    return size;
  }
  static Particle removeParticle(Particle particle) {
    particles.remove(particle);
    size = particles.size();
    return particle;
  }
}