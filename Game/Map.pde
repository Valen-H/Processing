//P,C = M
class Map extends MapS {
  
  int width, height, 
  part = 1; //N
  float unit;
  Mode mode = Mode.AUTO;
  final ArrayList<Container> map = new ArrayList<Container>();
  
  Map(int wdt, int hgt, float unit, Mode mode) {
    width = wdt;
    height = hgt;
    this.unit = unit;
    this.mode = mode;
    ini();
  } //Map(width, height, unit, mode)
  
  Map(Mode mode, int wdt, int hgt, float unit) {
    this(wdt, hgt, unit, mode);
  } //Map(mode, width, height, unit)
  
  Map(int wdt, int hgt, float unit) {
    this(wdt, hgt, unit, Mode.AUTO);
  } //Map(width, height, unit)
  
  Map() {
    ini();
  } //Map()
  
  void draw() {
    stroke(0);
    noFill();
    for (int hg = 0; hg < height; hg++) {
      for (int wd = 0; wd < width; wd++) {
        Container curr = get(wd, hg);
        switch(curr.type) {
          case VILLAGE:
            noStroke();
            fill(curr.village.clr);
            rect(wd * unit, hg * unit, unit, unit);
            if (curr.village.capital) {
              fill(200, 200, 5);
            } else {
              fill(250);
            }
            stroke(0);
            text(curr.village.name.charAt(0), wd * unit + unit / 2, hg * unit + unit / 2);
            break;
          case OBSTACLE:
            noStroke();
            switch(curr.subtype) {
              case WATER:
                fill(0, 0, 200);
                break;
              default:
                fill(100, 100, 0);
            }
            rect(wd * unit, hg * unit, unit, unit);
            break;
          default:
            rect(wd * unit, hg * unit, unit, unit);
        }
        stroke(0);
        noFill();
      }
    }
  } //draw
  
  private void ini() {
    for (int hg = 0; hg < height; hg++) {
      for (int wd = 0; wd < width; wd++) {
        Container curr = new Container().at(wd * unit, hg * unit);
        if (!boolean(int(random(10))) && mode == Mode.AUTO) {
          curr.is(Container.Type.OBSTACLE);
        }
        map.add(curr);
      }
    }
  } //ini
  
  Container get(int x, int y) {
    return map.get(int(y * width + x));
  } //get(x, y)
  
  Container get(int x) {
    return map.get(x);
  } //get(position)
  
  Container at(float x, float y) {
    return get(int(x / unit), int(y / unit));
  } //at(x, y)
  
  Container at(float[] xy) {
    return at(xy[0], xy[1]);
  } //at(coordinates)
  
  void finalise() {
    save();
  } //finalise
  
} //Map

static abstract protected class MapS {
  
  static enum Mode {
    AUTO, NOAUTO
  } //MODE
  
} //MapS