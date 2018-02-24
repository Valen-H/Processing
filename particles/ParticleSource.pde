class ParticleSource extends Source {
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float x, y, z;
  int particleSize = 0;
  ParticleSource(float x, float y) {
    this(x, y, 0.0);
  }
  ParticleSource(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    addSource(this);
    for (int rnd = int(random(10)); rnd > 0; rnd--) {
      addParticle(x, y, z);
    }
  }
  Particle addParticle(float x, float y, float z) {
    Particle part = new Particle(x, y, z);
    particles.add(part);
    particles();
    return part;
  }
  ArrayList<Particle> particles() {
    ArrayList<Particle> filt = new ArrayList<Particle>();
    for (Particle particle : particles) {
      if (!particle.d) {
        filt.add(particle);
      }
    }
    particles = filt;
    particleSize = particles.size();
    return particles;
  }
  void produce(int times) {
    for (; times > 0; times--) {
      new ParticleSource(x, y);
    }
  }
  void produce() {
    produce(1);
  }
}
static private class Source {
  static final ArrayList<ParticleSource> sources = new ArrayList<ParticleSource>();
  static int size = 0;
  static int addSource(ParticleSource source) {
    sources.add(source);
    size = sources.size();
    return size;
  }
}