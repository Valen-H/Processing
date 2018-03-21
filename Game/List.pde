//C2 = L
class List extends ListS {
  
  float x, y, dx, dy;
  int split = 0;
  Mode mode = Mode.NONE;
  ArrayList<ClickRegion> list = new ArrayList<ClickRegion>(0);
  
  List() {
    
  } //List()
  List(ClickRegion... regs) {
    for (ClickRegion reg : regs) {
      add(reg);
    }
  } //List(regs...)
  List(float x, float y, float dx, float dy) {
    this.dx = dx;
    this.dy = dy;
    this.x = x - (mode == Mode.CENTERED ? dx / 2 : 0);
    this.y = y - (mode == Mode.CENTERED ? dy / 2 : 0);
  } //List(x, y, dx, dy)
  
  List split(int split) {
    this.split = split;
    return this;
  } //split(split)
  
  List mode(Mode mode) {
    this.mode = mode;
    return this;
  } //mode(mode)
  
  ClickRegion add(ClickRegion region) {
    list.add(region);
    resize();
    return region;
  } //add(region)
  
  List resize() {
    float step = dy / (split > 0 ? split : list.size());
    for (ClickRegion item : list) {
      item.resize(x, y + step * (list.size() - 1), dx, step);
    }
    return this;
  } //resize
  
} //List

static abstract protected class ListS {
  
  static enum Mode {
    NONE, CENTERED
  } //Mode
  
} //ListS

//ADD GROUPS!