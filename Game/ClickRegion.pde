//P = C2
class ClickRegion extends ClickRegionS {
  
  float x, y, dx, dy, counter = 0.0f;
  PShape rect;
  transient final int id = clicks.size();
  volatile int zindex = 0;
  Type type = ClickRegion.Type.RECT;
  volatile Mode mode = Mode.ACTIVE;
  volatile String discriminator = "c" + (id + 1);
  volatile ArrayList<ClickRegion> group = new ArrayList<ClickRegion>(0);
  String groupname = "Main";
  boolean clicked = false,
  statuschanged = false; //N
  
  ClickRegion(float x, float y, float dx, float dy) {
    this(x, y, dx, dy, Mode.ACTIVE, "Main");
  } //ClickRegion(x, y, dx, dy)
  ClickRegion(float x, float y, float dx, float dy, Mode mode) {
    this(x, y, dx, dy, mode, "Main");
  } //ClickRegion(x, y, dx, dy, mode)
  ClickRegion(float x, float y, float dx, float dy, String group) {
    this(x, y, dx, dy, Mode.ACTIVE, group);
  } //ClickRegion(x, y, dx, dy, group)
  ClickRegion(float x, float y, float dx, float dy, Mode mode, String group) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.mode = mode;
    rect = createShape(type == Type.RECT ? RECT : ELLIPSE, x, y, dx, dy);
    ClickRegion.clicks.add(this);
    if (ClickRegion.groups.isEmpty()) {
      ClickRegion.group("Main");
    }
    if (!ClickRegion.groups.containsKey(group)) {
      ClickRegion.group(group);
    }
    groupname = group;
    this.group = (ArrayList<ClickRegion>) ClickRegion.groups.get(group).clone();
    ClickRegion.groups.get(group).add(this);
  } //ClickRegion(x, y, dx, dy, mode, group)
  
  boolean clicked() {
    return clicked(false);
  } //clicked
  boolean clicked(boolean stat) {
    if ((mousePressed || stat) && type == Type.RECT && coord[0] >= x && coord[0] <= x + dx && coord[1] >= y && coord[1] <= y + dy) {
      return clicked = true;
    }
    return clicked = false;
  } //clicked(stat)
  boolean clickedR(boolean stat) {
    if ((mousePressed || stat) && type == Type.RECT && mouseX >= x && mouseX <= x + dx && mouseY >= y && mouseY <= y + dy) {
      return clicked = true;
    }
    return clicked = false;
  } //clickedR(stat)
  boolean clickedR() {
    return clickedR(false);
  } //clickedR
  boolean clickedL(boolean stat) {
    if ((mousePressed || stat) && type == Type.RECT && coord[0] >= x && coord[0] <= x + dx && coord[1] >= y && coord[1] <= y + dy) {
      return clicked = true;
    }
    return clicked = false;
  } //clickedL(stat)
  boolean clickedL() {
    return clickedL(false);
  } //clickedL
  boolean clickedRL(boolean stat) {
    if ((mousePressed || stat) && type == Type.RECT && mouseX >= x && mouseX <= x + dx && mouseY >= y && mouseY <= y + dy) {
      return clicked = true;
    }
    return clicked = false;
  } //clickedRL(stat)
  boolean clickedRL() {
    return clickedRL(false);
  } //clickedRL
  boolean clickover() {
    boolean clicked = clicked();
    ArrayList<ClickRegion> clk = ClickRegion.clicks(group);
    if (clk.size() == 1 && clicked) {
      return this.clicked = true;
    } else if (clicked) {
      for (ClickRegion click : clk) {
        if (click.zindex > zindex) {
          return this.clicked = false;
        }
      }
      return this.clicked = true;
    }
    return this.clicked = false;
  } //clickover
  boolean clickoverR() {
    boolean clicked = clickedR();
    ArrayList<ClickRegion> clk = ClickRegion.clicksR(group);
    if (clk.size() == 1 && clicked) {
      return this.clicked = true;
    } else if (clicked) {
      for (ClickRegion click : clk) {
        if (click.zindex > zindex) {
          return this.clicked = false;
        }
      }
      return this.clicked = true;
    }
    return this.clicked = false;
  } //clickoverR
  boolean clickoverL() {
    boolean clicked = clickedL();
    ArrayList<ClickRegion> clk = ClickRegion.clicks(group);
    if (clk.size() == 1 && clicked) {
      return this.clicked = true;
    } else if (clicked) {
      for (ClickRegion click : clk) {
        if (click.zindex > zindex) {
          return this.clicked = false;
        }
      }
      return this.clicked = true;
    }
    return this.clicked = false;
  } //clickoverL
  boolean clickoverRL() {
    boolean clicked = clickedRL();
    ArrayList<ClickRegion> clk = ClickRegion.clicksR(group);
    if (clk.size() == 1 && clicked) {
      return this.clicked = true;
    } else if (clicked) {
      for (ClickRegion click : clk) {
        if (click.zindex > zindex) {
          return this.clicked = false;
        }
      }
      return this.clicked = true;
    }
    return this.clicked = false;
  } //clickoverRL
  
} //ClickRegion

static abstract protected class ClickRegionS extends Object {
  
  final static ArrayList<ClickRegion> clicks = new ArrayList<ClickRegion>(0);
  final static HashMap<String, ArrayList<ClickRegion>> groups = new HashMap<String, ArrayList<ClickRegion>>();
  
  static ArrayList<ClickRegion> clicks() {
    return ClickRegion.clicks(ClickRegion.clicks);
  } //clicks
  
  static ArrayList<ClickRegion> clicksR() {
    return ClickRegion.clicksR(ClickRegion.clicks);
  } //clicksR
  
  static ArrayList<ClickRegion> clicks(String group) {
    return ClickRegion.clicks(ClickRegion.groups.get(group));
  } //clicks(group)
  
  static ArrayList<ClickRegion> clicks(ArrayList<ClickRegion> group) {
    ArrayList<ClickRegion> click = new ArrayList<ClickRegion>();
    for (ClickRegion clk : group) {
      if (clk.clicked() && clk.mode == ClickRegion.Mode.ACTIVE) {
        click.add(clk);
      }
    }
    return click;
  } //clicks(group[])
  
  static ArrayList<ClickRegion> clicksR(String group) {
    return ClickRegion.clicksR(ClickRegion.groups.get(group));
  } //clicksR(group)
  
  static ArrayList<ClickRegion> clicksR(ArrayList<ClickRegion> group) {
    ArrayList<ClickRegion> click = new ArrayList<ClickRegion>();
    for (ClickRegion clk : group) {
      if (clk.clickedR() && clk.mode == ClickRegion.Mode.ACTIVE) {
        click.add(clk);
      }
    }
    return click;
  } //clicksR(group[])
  
  static void all(ClickRegion.Mode mode) {
    for (ClickRegion region : ClickRegion.clicks) {
      region.mode = mode;
    }
  } //all(mode)
  
  static void all(String group) {
    for (ClickRegion region : ClickRegion.groups.get(group)) {
      region.mode = ClickRegion.Mode.PASSIVE;
    }
  } //all(group)
  
  static void all(String group, ClickRegion.Mode mode) {
    for (ClickRegion region : ClickRegion.groups.get(group)) {
      region.mode = mode;
    }
  } //all(group, mode)
  
  static void all() {
    ClickRegion.all(ClickRegion.Mode.PASSIVE);
  } //all
  
  static void group(String group) {
    if (!ClickRegion.groups.containsKey(group)) {
      ClickRegion.groups.put(group, new ArrayList<ClickRegion>(0));
    }
  } //new(group)
  
  static enum Mode {
    ACTIVE, PASSIVE
  } //Mode
  
  static enum Type {
    RECT, CIRCULAR
  } //Type
  
} //ClickRegionS

//ADD CIRCULAR!