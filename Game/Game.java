package processing.test.game;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.lang.*; 
import android.app.*; 
import android.content.*; 
import android.os.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Game extends PApplet {

//P = C3
class Canvas extends CanvasS {
  
  float[] trns = {0.0f, 0.0f, 0.0f},
  itrns = {1.0f, 1.0f, 1.0f},
  zoom = {1.0f, 1.0f, 1.0f},
  izoom = {1.0f, 1.0f, 1.0f},
  strns = {0.0f, 0.0f, 0.0f},
  szoom = {0.0f, 0.0f, 0.0f};
  Mode mode = Mode.NORMAL;
  float wdt = width, hgt = height;
  volatile ArrayList<Submode> submode = new ArrayList<Submode>(2);
  volatile boolean auto = true;
  volatile String pmode = "2D";
  volatile float ZOOM = 2.0f;
  
  Canvas(Mode mode, float width, float height, float zoom) {
    float[] zooms = {zoom, zoom, zoom};
    ini(width, height, zooms, mode);
  } //Canvas(mode, width, height, zoom)++
  Canvas(float zoom, float width, float height, Mode mode) {
    this(mode, width, height, zoom);
  } //Canvas(zoom, width, height, mode)
  Canvas() {
    this(width, height);
  } //Canvas()**
  Canvas(float size) {
    this(size, size);
  } //Canvas(size)**
  Canvas(float width, float height) {
    this(Mode.NORMAL, width, height);
  } //Canvas(width, height)**
  Canvas(Mode mode, float width, float height) {
    this(mode, width, height, 1.0f);
  } //Canvas(mode, width, height)**
  Canvas(float width, float height, Mode mode) {
    this(mode, width, height);
  } //Canvas(width, height, mode)
  Canvas(float[] zoom, float width, float y) {
    this(zoom, width, height, Mode.NORMAL);
  } //Canvas(zoom[], width, height)**
  Canvas(float width, float height, float[] zoom) {
    this(zoom, width, height);
  } //Canvas(width, height, zoom[])
  Canvas(float zoom, float width, float y) {
    this(zoom, width, height, Mode.NORMAL);
  } //Canvas(zoom, width, height)**
  Canvas(float zoom, Mode mode, float width, float y) {
    this(mode, width, height, zoom);
  } //Canvas(zoom, mode, width, height)
  Canvas(float width, float height, Mode mode, float zoom) {
    this(mode, width, height, zoom);
  } //Canvas(width, height, mode, zoom)
  Canvas(Mode mode, float[] zoom, float width, float y) {
    this(mode, width, height, zoom);
  } //Canvas(mode, zoom[], width, height)
  Canvas(float[] zoom, Mode mode, float width, float y) {
    this(mode, width, height, zoom);
  } //Canvas(zoom[], mode, width, height)
  Canvas(float width, float height, Mode mode, float[] zoom) {
    this(mode, width, height, zoom);
  } //Canvas(width, height, mode, zoom[])
  Canvas(float width, float height, float[] zoom, Mode mode) {
    this(mode, width, height, zoom);
  } //Canvas(width, height, zoom[], mode)
  Canvas(Mode mode, float width, float height, float[] zoom) {
    ini(width, height, zoom, mode);
  } //Canvas(mode, width, height, zoom[])++
  Canvas(float[] zoom, float width, float height, Mode mode) {
    this(mode, width, height, zoom);
  } //Canvas(zoom[], width, height, mode)
  Canvas(float zoom, Mode mode) {
    this(zoom, mode, width, height);
  } //Canvas(zoom, mode)
  Canvas(float[] zoom, Mode mode) {
    this(zoom, mode, width, height);
  } //Canvas(zoom[], mode)
  Canvas(Mode mode) {
    this(1.0f, mode, width, height);
  } //Canvas(mode)
  
  public void ini(float width, float height, float[] zoom, Mode mode) {
    wdt = width;
    hgt = height;
    switch (mode) {
      case CENTERED:
        trns[0] = wdt / 2;
        trns[1] = hgt / 2;
        break;
      default:
        trns[0] = 0.0f;
        trns[1] = 0.0f;
    }
    itrns = trns;
    izoom = zoom;
    for (int stp = 0; stp < zoom.length; stp++) {
      this.zoom[stp] = zoom[stp];
    }
    render();
    submode.add(Canvas.Submode.ZOOM);
    submode.add(Canvas.Submode.SCROLL);
  } //ini
  
  public void trans() {
    if (auto) {
      if (pmode.equalsIgnoreCase("3D")) {
        translate(trns[0], trns[1], trns[2]);
      } else {
        translate(trns[0], trns[1]);
      }
    }
  } //trans
  
  public float[] scroll() {
    float[] diff = {mouseX - pmouseX, mouseY - pmouseY};
    trns[0] += round(strns[0] = diff[0] / zoom[0]);
    trns[1] += round(strns[1] = diff[1] / zoom[1]);
    render();
    return trns;
  } //scroll
  public float[] scroll(float z) {
    trns[2] += strns[2] = z;
    render();
    return trns;
  } //scroll(z)
  public float[] scroll(float[] by) {
    if (by.length == 2) {
      return scroll(by[0], by[1]);
    } else if (by.length == 1) {
      return scroll(by[0]);
    } else if (by.length == 0) {
      return scroll();
    } else {
      return scroll(by[0], by[1], by[2]);
    }
  } //scroll(by[])
  public float[] scroll(float x, float y) {
    trns[0] += strns[0] = x;
    trns[1] += strns[1] = y;
    render();
    return trns;
  } //scroll(x, y)
  public float[] scroll(float x, float y, float z) {
    trns[0] += x;
    trns[1] += y;
    trns[2] += z;
    render();
    return trns;
  } //scroll(x, y, z)
  public float[] scrollTo(float[] to) {
    if (to.length == 2) {
      return scrollTo(to[0], to[1]);
    } else if (to.length == 1) {
      return scrollTo(to[0]);
    } else {
      return scrollTo(to[0], to[1], to[2]);
    }
  } //scrollTo(to[])
  public float[] scrollTo(float z) {
    trns[2] = z;
    render();
    return trns;
  } //scrollTo(z)
  public float[] scrollTo(float x, float y) {
    trns[0] = x;
    trns[1] = y;
    render();
    return trns;
  } //scrollTo(x, y)
  public float[] scrollTo(float x, float y, float z) {
    trns[0] = x;
    trns[1] = y;
    trns[2] = z;
    render();
    return trns;
  } //scrollTo(x, y, z)
  
  public float[] zoom() {
    if (auto) {
      if (pmode.equalsIgnoreCase("3D")) {
          scale(zoom[0], zoom[1], zoom[2]);
        } else {
          scale(zoom[0], zoom[1]);
        }
    }
    return zoom;
  } //zoom
  public float[] zoom(float to) {
    zoom[0] = to;
    zoom[1] = to;
    zoom[2] = to;
    render();
    return zoom;
  } //zoom(to)
  public float[] zoom(float[] to) {
    if (to.length >= 1) {
      zoom[0] = to[0];
    }
    if (to.length >= 2) {
      zoom[1] = to[1];
    }
    if (to.length >= 3) {
      zoom[2] = to[2];
    }
    render();
    return zoom;
  } //zoom(to[])
  public float[] zoom(float x, float y) {
    zoom[0] = x;
    zoom[1] = y;
    render();
    return zoom;
  } //zoom(x, y)
  public float[] zoom(float x, float y, float z) {
    zoom[0] = x;
    zoom[1] = y;
    zoom[2] = z;
    render();
    return zoom;
  } //zoom(x, y, z)
  public float[] zoomBy(float by) {
    zoom[0] *= by;
    zoom[1] *= by;
    zoom[2] *= by;
    render();
    return zoom;
  } //zoom(by)
  public float[] zoomBy(float[] by) {
    if (by.length >= 1) {
      zoom[0] *= by[0];
    }
    if (by.length >= 2) {
      zoom[1] *= by[1];
    }
    if (by.length >= 3) {
      zoom[2] *= by[2];
    }
    render();
    return zoom;
  } //zoom(by[])
  public float[] zoomBy(float x, float y) {
    zoom[0] *= x;
    zoom[1] *= y;
    render();
    return zoom;
  } //zoom(x, y)
  public float[] zoomBy(float x, float y, float z) {
    zoom[0] *= x;
    zoom[1] *= y;
    zoom[2] *= z;
    render();
    return zoom;
  } //zoom(x, y, z)
  
  public void render() {
    resetMatrix();
    if (submode.contains(Canvas.Submode.ZOOM)) {
      zoom();
    }
    if (submode.contains(Canvas.Submode.SCROLL)) {
      trans();
    }
  } //render
  
  public Canvas reset() {
    trns = itrns;
    zoom = izoom;
    resetMatrix();
    return this;
  } //reset
  
} //Canvas

static abstract protected class CanvasS {
  
  static enum Submode {
    ZOOM, SCROLL
  } //Submode
  
  static enum Mode {
    NORMAL, CENTERED
  } //Mode
  
} //CanvasS
//C,C3,K,K2,M = P
volatile float zoom = 2.0f, milli = 0.0f, counter = 0.0f;
float[] coord = {0.0f, 0.0f};
float X = width, Y = height;
final int SIZE = 50;
final float UNIT = 50 / zoom, OFFSET = 10.0f;
final int CLICK_SENSITIVITY = 400;
volatile String screen = "Ini";
int inistep = 0;
final String packet = "processing.test.game"; //N

Canvas can;
Map mp;
Kingdom player;
Keyboard keyb;
ClickRegion menu, load, start;
XML xml;

public void settings() {
  fullScreen(P2D);
}

public void setup() {
  X = width;
  Y = height;
  frameRate(120);
  Dialog.milli = frameRate * 2;
  background(200);
  textSize(32);
  smooth();
  can = new Canvas(zoom, Canvas.Mode.CENTERED);
  can.submode.remove(Canvas.Submode.ZOOM);
  mp = new Map(SIZE, SIZE, UNIT * zoom);
  keyb = new Keyboard(X / 2, Y / 2, X - OFFSET, Y / 3 + OFFSET, Keyboard.Alph.BASIC, 8, Keyboard.Mode.CENTERED);
  keyb.capital = true;
  menu = new ClickRegion(0.0f, 0.0f, PApplet.parseFloat(SIZE), PApplet.parseFloat(SIZE));
  load = new ClickRegion(X / 2, Y / 2 - 100, X - 100, 100, ClickRegion.Subtype.CENTERED);
  start = new ClickRegion(X / 2, Y / 2 + 100, X - 100, 100, ClickRegion.Subtype.CENTERED);
  stroke(180);
  fill(160);
  pushMatrix();
  resetMatrix();
  textAlign(CENTER, CENTER);
  translate(X / 2, Y / 2);
  text("Loading...", 0, 0);
  popMatrix();
  noFill();
}

public void draw() {
  tick();
} //draw

public void tick() {
  clear();
  clip(0, 0, X, Y);
  textAlign(CENTER, CENTER);
  background(200);
  float[] coords = can.trns;
  coord[0] = mouseX - coords[0];
  coord[1] = mouseY - coords[1];
  if (screen.equalsIgnoreCase("Map")) {
    can.scroll();
    mp.draw();
  } else if (screen.equalsIgnoreCase("Ini")) {
    try {
      ini();
    } catch(Exception e) {
      e.printStackTrace();
    }
  } else {
    menu();
  }
  resetMatrix();
  shape(menu.rect, 0, 0);
  stroke(0, 0, 180);
  fill(0, 0, 180);
  text("M", menu.x + menu.dx / 2, menu.y + menu.dy / 2);
  if (millis() - counter >= 5000) {
    Kingdom.tickAll();
    counter = millis();
  }
  try {
    Dialog.renderRAll();
  } catch (Exception e) {
    e.printStackTrace();
  }
} //tick

public void mouseDragged() {
  if (screen.equalsIgnoreCase("Map")) {
    can.scroll();
  } else if ((int) pmouseX != (int) mouseX || (int) pmouseY != (int) mouseY) {
    mousePressed = false;
  }
  float[] coords = can.trns;
  coord[0] = mouseX - coords[0];
  coord[1] = mouseY - coords[1];
} //mouseDragged

public void mousePressed() {
  milli = millis();
  mousePressed = true;
} //mousePressed

public void mouseReleased() {
  if (menu.clickedR(true) && millis() - milli < CLICK_SENSITIVITY) {
    screen = screen.equalsIgnoreCase("Map") ? "Menu" : "Map";
  }
  if (screen.equalsIgnoreCase("Ini")) {
    keyb.locked = false;
  }
  mousePressed = false;
} //mouseReleased

public void save() {
  xml = parseXML("<?xml version='1.0'?>\n<data>\n\t\n</data>");
  int counter = 0;
  for (Kingdom kingdom : Kingdom.kingdoms) {
    if (kingdom.capital == null || kingdom.name == "") continue;
    XML child = xml.addChild("kingdom");
    //child.setContent(kingdom.name + "\n\t");
    //child.setString("color", kingdom.color);
    child.setString("name", kingdom.name);
    child.setInt("id", counter++);
    child.setInt("x", kingdom.capital.x);
    child.setInt("y", kingdom.capital.y);
    int count = 0;
    for (Kingdom.Village village : kingdom.cities) {
      XML cchild = child.addChild("village");
      cchild.setContent(village.name);
      cchild.setString("name", village.name);
      cchild.setInt("wealth", village.wealth);
      cchild.setInt("population", village.population);
      cchild.setInt("x", village.x);
      cchild.setInt("y", village.y);
      cchild.setInt("id", count++);
      //cchild.setString("color", village.color);
    }
  }
  saveXML(xml, "data.xml");
  println("Game saved...");
} //save

public void onBackPressed() {
  save();
  exit();
} //onBackPressed

public void load() {
  try {
    xml = loadXML("data.xml");
  } catch(Exception e) {
    save();
    inistep = 1;
    return;
  }
  for (XML kingdom : xml.getChildren()) {
    if (kingdom.getString("name") != null) {
      Kingdom curr;
      if (kingdom.getInt("id") == 0) {
        curr = player = new Kingdom(kingdom.getString("name"));
      } else {
        curr = new Kingdom(kingdom.getString("name"));
      }
      for (XML village : kingdom.getChildren()) {
        Kingdom.Village vill = (curr.new Village(village.getString("name"))).on(village.getInt("x"), village.getInt("y"));
        vill.population = village.getInt("population");
        vill.wealth = village.getInt("wealth");
      }
    }
  }
  println("Game loaded...");
} //load

public void ini() {
  screen = "Ini";
  if (inistep == 1) {
    keyb.runR("Empire Name:");
    if (keyb.submit && keyb.typed.length() >= 1) {
      player = new Kingdom(keyb.submit()).on().go();
      inistep = 2;
    }
  } else if (inistep == 0) {
    startup();
  } else {
    screen = "Map";
    new Dialog(frameRate / 2, 0.0f, 0.0f, X, Y, 0.0f, Y / (frameRate / 2)).text = "Welcome!";
    save();
  }
} //ini

public void menu() {
  text("Coming soon...", 0, 0, X, Y);
} //menu

public void startup() {
  shape(load.rect, 0, 0);
  shape(start.rect, 0, 0);
  text("Load", load.x, load.y, load.dx, load.dy);
  text("Start", start.x, start.y, start.dx, start.dy);
  if (load.clickedR()) {
    load();
    if (player != null) {
      player.go();
    } else {
      inistep = 1;
    }
    inistep = 2;
  } else if (start.clickedR()) {
    inistep = 1;
  }
} //startup
/** = N //N
 * Clicking an owned city opens its city menu,
 * there you can plan expansions on neighbouring tiles
 * 
 * Menu contains goto startup
 * 
 * DONE : add filesystem and popup.
 * add multiple enemies
 * store obstacles and chain menuitems
 * FIX CRASHES!!!
 * 
*/
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
  
  public void draw() {
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
        if (!PApplet.parseBoolean(PApplet.parseInt(random(10))) && mode == Mode.AUTO) {
          curr.is(Container.Type.OBSTACLE);
        }
        map.add(curr);
      }
    }
  } //ini
  
  public Container get(int x, int y) {
    return map.get(PApplet.parseInt(y * width + x));
  } //get(x, y)
  
  public Container get(int x) {
    return map.get(x);
  } //get(position)
  
  public Container at(float x, float y) {
    return get(PApplet.parseInt(x / unit), PApplet.parseInt(y / unit));
  } //at(x, y)
  
  public Container at(float[] xy) {
    return at(xy[0], xy[1]);
  } //at(coordinates)
  
  public void finalise() {
    save();
  } //finalise
  
} //Map

static abstract protected class MapS {
  
  static enum Mode {
    AUTO, NOAUTO
  } //MODE
  
} //MapS
//C,M,P = K
class Kingdom extends KingdomS {
  
  Village capital;
  private Kingdom king;
  final Set<Village> cities = new HashSet<Village>(0);
  volatile String name = "Kingdom-" + (Kingdom.kingdoms.size() + 1);
  int clr = rndRGB();
  int x = mp.width, y = mp.height;
  boolean established = false;
  Container area;
  
  Kingdom() {
    ini();
  } //Kingdom()
  Kingdom(String name) {
    this.name = name;
    ini();
  } //Kingdom(name)
  Kingdom(String name, int clr) {
    this.name = name;
    this.clr = clr;
    ini();
  } //Kingdom(name, clr)
  
  private void ini() {
    kingdoms.add(this);
    king = this;
  } //ini
  
  public Village city() {
    Village village = new Village(this);
    cities.add(village);
    return village;
  } //city
  public Village city(int x, int y) {
    Village village = new Village(this);
    village.x = x;
    village.y = y;
    cities.add(village);
    return village;
  } //city(x, y)
  
  public void tick() {
    for (Village village : cities) {
      village.tick();
    }
    refresh();
  } //tick
  
  public Kingdom on() {
    if (capital == null) {
      capital = city();
    }
    capital.on();
    return this;
  } //on
  public Kingdom on(int x, int y) {
    if (capital == null) {
      capital = city(x, y);
    }
    capital.on(x, y);
    return this;
  } //on(x, y)
  
  public Kingdom go() {
    if (capital != null) {
      capital.go();
    }
    return this;
  } //go
    
  public void destroy() {
    kingdoms.remove(this);
    for (Village village : cities) {
      if (!village.capital) {
        village.destroy();
      }
    }
  } //destroy
  public void finalise() {
    destroy();
  } //finalise
  
  public void refresh() {
    if (cities.size() <= 0 && established) {
      destroy();
    }
  } //refresh
  
  public Kingdom conquer(Village village) {
    if (!cities.contains(village)) {
      cities.add(village);
      village.owner.cities.remove(village);
      if (village.owner.cities.size() <= 0) {
        village.owner.destroy();
      }
      village.ini(this);
    }
    return this;
  } //conquer(village)
  
  class Village extends KingdomS.VillageS {
    
    Kingdom owner;
    int clr = rndRGB();
    volatile Set<Village> siblings;
    volatile String name = "City-" + (villages.size() + 1);
    volatile int wealth = PApplet.parseInt(random(10, 100));
    volatile int population = PApplet.parseInt(random(wealth * 10, wealth * 100)),
    x = PApplet.parseInt(round(random(mp.width))),
    y = PApplet.parseInt(round(random(mp.height)));
    boolean established = false,
    capital;
    Container area;
    
    Village(Kingdom owner, String name) {
      ini(owner);
      this.name = name;
    } //Village(owner, name)
    Village(Kingdom owner) {
      ini(owner);
    } //Village(owner)
    Village(String name) {
      ini(king);
      this.name = name;
    } //Village(name)
    Village() {
      ini(king);
    } //Village()
    
    public Village ini(Kingdom owner) {
      this.owner = owner;
      clr = owner.clr;
      siblings = owner.cities;
      name = owner.name + "-City-" + (siblings.size() + 1);
      if (!villages.contains(this)) {
        villages.add(this);
      }
      if (siblings.size() == 0) {
        capital = true;
      } else {
        capital = false;
      }
      return this;
    } //ini
    
    public Village on() {
      on(PApplet.parseInt(floor(random(mp.width))), PApplet.parseInt(floor(random(mp.height))));
      return this;
    } //on
    public Village on(int x, int y) {
      if (established) {
        mp.get(this.x, this.y).is(Type.EMPTY);
      }
      this.x = x;
      this.y = y;
      area = mp.get(x, y).is(this);
      established = true;
      if (capital) {
        owner.x = x;
        owner.y = y;
        owner.established = true;
      }
      return this;
    } //on(x, y)
    
    public void go() {
      can.scrollTo(- area.x + X / 2 - mp.unit / 2, - area.y + Y / 2 - mp.unit / 2);
    } //go
    
    public void destroy() {
      mp.get(x, y).is(Type.EMPTY);
      villages.remove(this);
      siblings.remove(this);
    } //destroy
    public void finalise() {
      destroy();
    } //finalise
    
    public void tick() {
      population += wealth;
      wealth += PApplet.parseInt(population / 100);
      wealth -= population / wealth / 10;
      refresh();
    } //tick
    
    public void refresh() {
      if (population <= 0 && established) {
        population = 0;
        destroy();
      }
    } //refresh
    
    /*Village[] adjacents() {
      Village[] villages = new Village[4];
      int count = 0;
      if (y > 0) {
        villages[count++] = mp.get(x, y - 1).village;
      }
      if (x + 1 < mp.width) {
        villages[count++] = mp.get(x + 1, y).village;
      }
      if (y + 1 < mp.height) {
        villages[count++] = mp.get(x, y + 1).village;
      }
      if (x - 1 > 0) {
        villages[count++] = mp.get(x - 1, y).village;
      }
      return villages;
    } //adjacents*/
    
  } //Village
  
} //Kingdom

static abstract protected class KingdomS extends ContainerS {
  
  final static Set<Kingdom> kingdoms = new HashSet<Kingdom>(0);
  final static Type TYPE = Type.VILLAGE;
  
  public final static void tickAll() {
    for (Kingdom kingdom : new HashSet<Kingdom>(Kingdom.kingdoms)) {
      kingdom.tick();
    }
  } //tickAll
  
  static protected class VillageS extends ContainerS {
    
    final static Set<Kingdom.Village> villages = new HashSet<Kingdom.Village>(0);
    final static Type TYPE = Type.VILLAGE;
    
    public final static void tickAll() {
      for (Kingdom.Village village : new HashSet<Kingdom.Village>(Kingdom.Village.villages)) {
        village.tick();
      }
    } //tickAll
    
  } //VillageS

} //KingdomS
//M,K = C
class Container extends ContainerS {
  
  Type type = Type.EMPTY;
  Subtype subtype = Subtype.NULL;
  Kingdom.Village village;
  Kingdom kingdom;
  transient int rnd = PApplet.parseInt(random(100)); //N
  float x, y, dx, dy;
  
  public Container is(Kingdom.Village village) {
    this.village = village;
    kingdom = village.owner;
    dx = dy = mp.unit;
    at(village.x * dx, village.y * dy);
    is(Type.VILLAGE);
    return this;
  } //is(village)
  public Container is(Kingdom kingdom) {
    is(kingdom.capital);
    is(Subtype.CAPITAL);
    return this;
  } //is(kingdom)
  public void is(Type type, Subtype subtype) {
    is(type);
    is(subtype);
  } //is(type, subtype)
  public void is(Subtype subtype) {
    this.subtype = subtype;
    if (type == Type.EMPTY) {
      switch (subtype) {
        case WATER:
        case MOUNTAIN:
          is(Type.OBSTACLE);
      }
    }
  } //is(subtype)
  public Container is(Type type) {
    this.type = type;
    if (type == Type.OBSTACLE && subtype == Subtype.NULL) {
      switch (PApplet.parseInt(round(random(1)))) {
        case 0:
          is(Subtype.WATER);
          break;
        default:
          is(Subtype.MOUNTAIN);
      }
    } else if (type == Type.EMPTY) {
      is(Subtype.NULL);
    }
    return this;
  } //is(type)
  
  Container(Kingdom.Village village) {
    is(village);
    ini();
  } //Container(village)
  Container(Kingdom kingdom) {
    this(kingdom.capital);
  } //Container(kingdom)
  Container(Type type) {
    is(type);
    ini();
  } //Container(type)
  Container(Type type, Subtype subtype) {
    is(type, subtype);
    ini();
  } //Container(type, subtype)
  Container(Subtype subtype) {
    is(subtype);
    ini();
  } //Container(subtype)
  Container() {
    ini();
  } //Container()
  
  public void ini() {
    Container.containers.add(this);
  } //ini
  
  public Container at(float x, float y) {
    this.x = x;
    this.y = y;
    return this;
  } //at(x, y)
  
} //Container

static abstract protected class ContainerS extends Module.Container<Container> {
  
  final static int TYPES = 3, SUBTYPES = 5;
  final static ArrayList<Container> containers = new ArrayList<Container>();
  
  static enum Type {
    EMPTY, VILLAGE, OBSTACLE
  } //Type
  
  static enum Subtype {
    NULL, CITY, CAPITAL, WATER, MOUNTAIN
  } //Subtype
  
} //ContainerS
//P = M







final int RED = color(255, 0, 0), GREEN = color(0, 255, 0), BLUE = color(0, 0, 255);

public int rndRGB() {
  return color(PApplet.parseInt(round(random(255))), PApplet.parseInt(round(random(255))), PApplet.parseInt(round(random(255))));
} //rndRGB

public char[] splitAll(String string) {
  return string.toCharArray();
} //splitAll(string)

public String[] splitAllS(String string) {
  String[] comp = new String[string.length()];
  for (int stp = 0; stp < string.length(); stp++) {
    comp[stp] = "" + string.charAt(stp);
  }
  return comp;
} //splitAllS(string)

<T extends Collection<E>, E> E rnd(T item) {
  ArrayList<E> list = new ArrayList<E>(item);
  return list.get(PApplet.parseInt(random(list.size())));
} //rnd(item)

static abstract class Module {
  
  public static char[] splitAll(String string) {
    return string.toCharArray();
  } //splitAll(string)
  
  public static String[] splitAllS(String string) {
    String[] comp = new String[string.length()];
    for (int stp = 0; stp < string.length(); stp++) {
      comp[stp] = "" + string.charAt(stp);
    }
    return comp;
  } //splitAllS(string)
  
  static class Container<T> extends ContainerS {
    
    volatile T item;
    
    Container() {
      Container.items.add(this);
    } //Container
    Container(T item) {
      this.item = item;
      Container.items.add(this);
    } //Container(item)
    
  } //Container
  
  static abstract protected class ContainerS {
    final static ArrayList<Object> items = new ArrayList<Object>(0);
  } //ContainerS
  
  final static PApplet app = new PApplet();
  volatile static int rnd = PApplet.parseInt(Module.app.random(100));
  
  static interface Animatable {
    
    public void tick();
    
  } //Animatable
  
} //Module
//P,M = K2
class Keyboard extends KeyboardS {
  
  Alph alph = Alph.LATIN;
  ArrayList<Piece> pieces = new ArrayList<Piece>();
  float x, y, dx, dy;
  int split;
  Mode mode = Mode.FREE;
  Submode submode = Submode.TOP;
  PShape inp;
  ClickRegion region;
  volatile String typed = "";
  boolean capital = false,
  submit = false,
  locked = false,
  capOnce = KeyboardS.capOnce,
  blocked = false;
  float cooldown = CLICK_SENSITIVITY,
  last = millis();
  
  Keyboard(float x, float y, float dx, float dy, Alph alph) {
    this(x, y, dx, dy, alph, 8, Mode.FREE);
  } //Keyboard(x, y, dx, dy)
  Keyboard(float x, float y, float dx, float dy, Alph alph, int split, Mode mode) {
    this.alph = alph;
    this.split = split;
    this.dx = dx;
    this.dy = dy;
    this.mode = mode;
    if (mode == Mode.CENTERED) {
      this.x = x - dx / 2;
      this.y = y - dy / 2;
    } else {
      this.x = x;
      this.y = y;
    }
    region = new ClickRegion(this.x, this.y, dx, dy);
    if (submode == Submode.TOP) {
      inp = createShape(RECT, this.x + dx * 0.1f, this.y - dy / 3 - OFFSET, dx * 0.8f, dy / 3);
    } else if (submode == Submode.BOTTOM) {
      inp = createShape(RECT, this.x + dx * 0.1f, this.y + dy / 3 + OFFSET, dx * 0.8f, dy / 3);
    }
    int length = 0,
    block = 0;
    for (int stp = 0; stp < alph.alph.length(); stp++) {
      if (alph.alph.charAt(stp) == '[') {
        block++;
      } else if (alph.alph.charAt(stp) == ']') {
        block--;
      }
      if (!PApplet.parseBoolean(block)) {
        length++;
      }
    }
    float Dy = dy / (PApplet.parseInt(length / split) + 1), Dx = dx / split;
    int count = 0;
    for (int stp = 0; stp < alph.alph.length(); stp++) {
      char curr = alph.alph.charAt(stp);
      String comp = "";
      if (curr == '[') {
        do {
          comp += alph.alph.charAt(++stp);
        } while (alph.alph.charAt(stp + 1) != ']');
        stp++;
      } else {
        comp += curr;
      }
      Piece piece = new Piece(comp, this.x + (count % split) * Dx, this.y + PApplet.parseInt(count / split) * Dy, Dx, Dy, this);
      if (comp.equalsIgnoreCase("Del") || comp.equalsIgnoreCase("Cap") || comp.equalsIgnoreCase("End")) {
        piece.special = true;
      }
      pieces.add(piece);
      count++;
    }
  } //Keyboard(x, y, dx, dy, split, mode)
  
  public boolean clicked() {
    if (region.clicked()) {
      return true;
    }
    return false;
  } //clicked
  
  public boolean clickedR() {
    if (region.clickedR()) {
      return true;
    }
    return false;
  } //clickedR
  
  public ArrayList<Piece> clickedRP() {
    ArrayList<Piece> clicks = new ArrayList<Piece>();
    for (Piece piece : pieces) {
      if (piece.clickedR()) {
        clicks.add(piece);
      }
    }
    return clicks;
  } //clickedRP
  
  public ArrayList<Piece> clickedP() {
    ArrayList<Piece> clicks = new ArrayList<Piece>();
    for (Piece piece : pieces) {
      if (piece.clicked()) {
        clicks.add(piece);
      }
    }
    return clicks;
  } //clickedP
  
  public String type() {
    if (!blocked) {
      for (Piece piece : clickedP()) {
        if ((millis() - last > cooldown || !locked) && mousePressed) {
          if ((alph == Alph.BASIC && !piece.special) || alph != Alph.BASIC) {
            typed += piece.chr();
            if (capital && capOnce) {
              capital = false;
            }
          } else if (piece.chr().equalsIgnoreCase("Del")) {
            typed = join(shorten(splitAllS(typed)), "");
          } else if (piece.chr().equalsIgnoreCase("Cap") && !locked) {
            capital = !capital;
          } else if (piece.chr().equalsIgnoreCase("End") && !locked) {
            submit = true;
          }
          last = millis();
          locked = true;
        } else if (locked && !mousePressed) {
          locked = false;
        }
      }
    }
    return typed;
  } //type
  
  public String typeR() {
    if (!blocked) {
      for (Piece piece : clickedRP()) {
        if ((millis() - last > cooldown || !locked) && mousePressed) {
          if ((alph == Alph.BASIC && !piece.special) || alph != Alph.BASIC) {
            typed += piece.chr();
          } else if (piece.chr().equalsIgnoreCase("Del")) {
            typed = join(shorten(splitAllS(typed)), "");
          } else if (piece.chr().equalsIgnoreCase("Cap") && !locked) {
            capital = !capital;
          } else if (piece.chr().equalsIgnoreCase("End") && !locked) {
            submit = true;
          }
          last = millis();
          locked = true;
        } else if (locked && !mousePressed) {
          locked = false;
        }
      }
    }
    return typed;
  } //typeR
  
  public Keyboard draw() {
    if (submode != Submode.NONE) {
      shape(inp, 0, 0);
      float[] p = inp.getParams();
      text(typed, p[0], p[1], p[2], p[3]);
    }
    shape(region.rect, 0, 0);
    for (Piece piece : pieces) {
      shape(piece.region.rect, 0, 0);
      piece.draw();
    }
    return this;
  } //draw
  
  public Keyboard drawR() {
    pushMatrix();
    resetMatrix();
    if (submode != Submode.NONE) {
      shape(inp, 0, 0);
      float[] p = inp.getParams();
      text(typed, p[0], p[1], p[2], p[3]);
    }
    shape(region.rect, 0, 0);
    for (Piece piece : pieces) {
      shape(piece.region.rect, 0, 0);
      piece.drawR();
    }
    popMatrix();
    return this;
  } //drawR
  
  public Keyboard show() {
    for (Piece piece : pieces) {
      piece.region.mode = ClickRegion.Mode.ACTIVE;
    }
    return draw();
  } //show
  public Keyboard showR() {
    for (Piece piece : pieces) {
      piece.region.mode = ClickRegion.Mode.ACTIVE;
    }
    return drawR();
  } //showR
  public Keyboard show(String reason) {
    pushStyle();
    float tmp;
    fill(255);
    stroke(0);
    shape(createShape(RECT, x, tmp = y - (submode == Keyboard.Submode.TOP ? inp.getParams()[3] : 0) - dy / 5 - 2 * OFFSET, dx, dy / 5), 0, 0);
    popStyle();
    text(reason, x, tmp, dx, dy / 5);
    return show();
  } //show
  public Keyboard showR(String reason) {
    pushMatrix();
    pushStyle();
    resetMatrix();
    float tmp;
    fill(255);
    stroke(0);
    shape(createShape(RECT, x, tmp = y - (submode == Keyboard.Submode.TOP ? inp.getParams()[3] : 0) - dy / 5 - 2 * OFFSET, dx, dy / 5), 0, 0);
    popStyle();
    text(reason, x, tmp, dx, dy / 5);
    popMatrix();
    return showR();
  } //showR
  
  public void hide() {
    for (Piece piece : pieces) {
      piece.region.mode = ClickRegion.Mode.PASSIVE;
    }
  } //hide
  
  public Keyboard run() {
    type();
    show();
    return this;
  } //run
  public Keyboard runR() {
    typeR();
    showR();
    return this;
  } //runR
  public Keyboard run(String text) {
    type();
    show(text);
    return this;
  } //run(text)
  public Keyboard runR(String text) {
    typeR();
    showR(text);
    return this;
  } //runR(text)
  
  public String submit() {
    if (submit) {
      final String typ = typed;
      typed = "";
      submit = false;
      return typ;
    }
    return "";
  } //submit
  
  protected class Piece {
    
    float x, y, dx, dy;
    String chr;
    Keyboard keyboard;
    ClickRegion region;
    volatile boolean special = false;
    
    Piece(String chr, float x, float y, float dx, float dy, Keyboard keyboard) {
      this.x = x;
      this.y = y;
      this.dx = dx;
      this.dy = dy;
      this.chr = chr;
      this.keyboard = keyboard;
      region = new ClickRegion(x + OFFSET / 2, y + OFFSET / 2, dx - OFFSET, dy - OFFSET, "Keyboard");
    } //Piece(chr, x, y, dx, dy, keyboard)
    
    public void draw() {
      pushStyle();
      textAlign(CENTER, CENTER);
      if (chr().equalsIgnoreCase("Cap") && keyboard.capital) {
        fill(255, 0, 0);
      }
      text(chr(), x, y, dx, dy);
      popStyle();
    } //draw
    
    public void drawR() {
      pushMatrix();
      resetMatrix();
      draw();
      popMatrix();
    } //drawR
    
    public boolean clicked() {
      if (region.clickover()) {
        return true;
      }
      return false;
    } //clicked
    
    public boolean clickedR() {
      if (region.clickoverR()) {
        return true;
      }
      return false;
    } //clickedR
    
    public String chr() {
      if (keyboard.capital && !special) {
        return chr.toUpperCase();
      }
      return chr;
    } //chr
    
  } //Piece
  
} //Keyboard

static abstract protected class KeyboardS extends Module {
  
  static volatile boolean capOnce = false;
  
  static enum Alph {
    
    LATIN("abcdefghijklmnopqrstuvwxyz"),
    NUMS("1234567890"),
    BASIC("abcdefghijklmnopqrstuvwxyz0123456789[Del][Cap][End]");
    
    String alph, cap;
    char[] alpha, capa;
    
    Alph(String alph) {
      this.alph = alph;
      cap = alph.toUpperCase();
      alpha = splitAll(alph);
      capa = splitAll(cap);
    } //Alph(alph)
    
  } //Alph
  
  static enum Mode {
    FREE, CENTERED
  } //Mode
  
  static enum Submode {
    TOP, BOTTOM, NONE
  } //Submode
  
} //KeyboardS
//P = C2
class ClickRegion extends ClickRegionS {
  
  float x, y, dx, dy, counter = 0.0f;
  PShape rect;
  transient final int id = clicks.size();
  volatile int zindex = 0;
  Type type = Type.RECT;
  Subtype subtype = Subtype.NONE;
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
    this(x, y, dx, dy, Mode.ACTIVE, group, Subtype.NONE);
  } //ClickRegion(x, y, dx, dy, group)
  ClickRegion(float x, float y, float dx, float dy, String group, Subtype subtype) {
    this(x, y, dx, dy, Mode.ACTIVE, group, subtype);
  } //ClickRegion(x, y, dx, dy, group, subtype)
  ClickRegion(float x, float y, float dx, float dy, Subtype subtype) {
    this(x, y, dx, dy, Mode.ACTIVE, "Main", subtype);
  } //ClickRegion(x, y, dx, dy, subtype)
  ClickRegion(float x, float y, float dx, float dy, Mode mode, String group) {
    this(x, y, dx, dy, mode, group, Subtype.NONE);
  } //ClickRegion(x, y, dx, dy, mode, group)
  ClickRegion(float x, float y, float dx, float dy, Mode mode, String group, Subtype subtype) {
    this.dx = dx;
    this.dy = dy;
    this.subtype = subtype;
    this.mode = mode;
    rect = createShape(type == Type.RECT ? RECT : ELLIPSE, this.x = x - (subtype == Subtype.CENTERED ? dx / 2 : 0), this.y = y - (subtype == Subtype.CENTERED ? dy / 2 : 0), dx, dy);
    ClickRegion.clicks.add(this);
    if (ClickRegion.groups.isEmpty()) {
      ClickRegion.group("Main");
    }
    if (!ClickRegion.groups.containsKey(group)) {
      ClickRegion.group(group);
    }
    groupname = group;
    this.group = groups.get(group);
    zindex = this.group.size();
    this.group.add(this);
  } //ClickRegion(x, y, dx, dy, mode, group, subtype)
  
  public ClickRegion resize(float x, float y, float dx, float dy) {
    this.dx = dx;
    this.dy = dy;
    rect = createShape(type == Type.RECT ? RECT : ELLIPSE, this.x = x - (subtype == Subtype.CENTERED ? dx / 2 : 0), this.y = y - (subtype == Subtype.CENTERED ? dy / 2 : 0), dx, dy);
    return this;
  } //resize(x, y, dx, dy)
  
  public boolean clicked() {
    return clicked(false);
  } //clicked
  public boolean clicked(boolean stat) {
    if ((mousePressed || stat) && ((type == Type.RECT && coord[0] >= x && coord[0] <= x + dx && coord[1] >= y && coord[1] <= y + dy) || (type == Type.CIRCULAR && dist(coord[0], coord[1], x, y) <= x))) {
      return clicked = true;
    }
    return clicked = false;
  } //clicked(stat)
  public boolean clickedR(boolean stat) {
    if ((mousePressed || stat) && ((type == Type.RECT && mouseX >= x && mouseX <= x + dx && mouseY >= y && mouseY <= y + dy) || (type == Type.CIRCULAR && dist(mouseX, mouseY, x, y) <= x))) {
      return clicked = true;
    }
    return clicked = false;
  } //clickedR(stat)
  public boolean clickedR() {
    return clickedR(false);
  } //clickedR
  public boolean clickedL(boolean stat) {
    if ((mousePressed || stat) && mode == ClickRegion.Mode.ACTIVE && type == Type.RECT && coord[0] >= x && coord[0] <= x + dx && coord[1] >= y && coord[1] <= y + dy) {
      return clicked = true;
    }
    return clicked = false;
  } //clickedL(stat)
  public boolean clickedL() {
    return clickedL(false);
  } //clickedL
  public boolean clickedRL(boolean stat) {
    if ((mousePressed || stat) && mode == ClickRegion.Mode.ACTIVE && type == Type.RECT && mouseX >= x && mouseX <= x + dx && mouseY >= y && mouseY <= y + dy) {
      return clicked = true;
    }
    return clicked = false;
  } //clickedRL(stat)
  public boolean clickedRL() {
    return clickedRL(false);
  } //clickedRL
  public boolean clickover() {
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
  public boolean clickoverR() {
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
  public boolean clickoverL() {
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
  public boolean clickoverRL() {
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
  
  public static ArrayList<ClickRegion> clicks() {
    return ClickRegion.clicks(ClickRegion.clicks);
  } //clicks
  
  public static ArrayList<ClickRegion> clicksR() {
    return ClickRegion.clicksR(ClickRegion.clicks);
  } //clicksR
  
  public static ArrayList<ClickRegion> clicks(String group) {
    return ClickRegion.clicks(ClickRegion.groups.get(group));
  } //clicks(group)
  
  public static ArrayList<ClickRegion> clicks(ArrayList<ClickRegion> group) {
    ArrayList<ClickRegion> click = new ArrayList<ClickRegion>();
    for (ClickRegion clk : group) {
      if (clk.clicked() && clk.mode == ClickRegion.Mode.ACTIVE) {
        click.add(clk);
      }
    }
    return click;
  } //clicks(group[])
  
  public static ArrayList<ClickRegion> clicksR(String group) {
    return ClickRegion.clicksR(ClickRegion.groups.get(group));
  } //clicksR(group)
  
  public static ArrayList<ClickRegion> clicksR(ArrayList<ClickRegion> group) {
    ArrayList<ClickRegion> click = new ArrayList<ClickRegion>();
    for (ClickRegion clk : group) {
      if (clk.clickedR() && clk.mode == ClickRegion.Mode.ACTIVE) {
        click.add(clk);
      }
    }
    return click;
  } //clicksR(group[])
  
  public static void all(ClickRegion.Mode mode) {
    for (ClickRegion region : ClickRegion.clicks) {
      region.mode = mode;
    }
  } //all(mode)
  
  public static void all(String group) {
    for (ClickRegion region : ClickRegion.groups.get(group)) {
      region.mode = ClickRegion.Mode.PASSIVE;
    }
  } //all(group)
  
  public static void all(String group, ClickRegion.Mode mode) {
    for (ClickRegion region : ClickRegion.groups.get(group)) {
      region.mode = mode;
    }
  } //all(group, mode)
  
  public static void all() {
    ClickRegion.all(ClickRegion.Mode.PASSIVE);
  } //all
  
  public static void group(String group) {
    if (!ClickRegion.groups.containsKey(group)) {
      ClickRegion.groups.put(group, new ArrayList<ClickRegion>(0));
    }
  } //group(group)
  
  static enum Mode {
    ACTIVE, PASSIVE
  } //Mode
  
  static enum Subtype {
    NONE, CENTERED
  } //Subtype
  
  static enum Type {
    RECT, CIRCULAR
  } //Type
  
} //ClickRegionS
//P,M = D
class Dialog extends DialogS implements Module.Animatable {
  
  float millis = Dialog.milli, x = 0.0f, y = 0.0f, dx = 0.0f, dy = 0.0f, X = width, Y = height;
  PShape rect;
  boolean closed = false;
  volatile String text;
  
  Dialog(float millis, float x, float y, float X, float Y, float dx, float dy) {
    this.millis = millis;
    this.x = x;
    this.y = y;
    this.X = X;
    this.Y = Y;
    this.dx = dx;
    this.dy = dy;
    rect = createShape(RECT, x, y, X, Y);
    rect.disableStyle();
    Dialog.dialogs.add(this);
  } //Dialog(millis, x, y, X, Y, dx, dy)
  Dialog(float millis, float x, float y, float X, float Y) {
    this(millis, x, y, X, Y, 0.0f, 0.0f);
  } //Dialog(millis, x, y, X, Y)
  Dialog(float millis, float x, float y) {
    this(millis, x, y, width, height, 0.0f, 0.0f);
  } //Dialog(millis, x, y)
  Dialog(float millis) {
    this(millis, 0.0f, 0.0f, width, height, 0.0f, 0.0f);
  } //Dialog(millis)
  Dialog() {
    this(Dialog.milli, 0.0f, 0.0f, width, height, 0.0f, 0.0f);
  } //Dialog()
  
  public void tick() {
    x += dx;
    y += dy;
    if (--millis <= 0) {
      closed = true;
      Dialog.dialogs.remove(this);
    }
    rect = createShape(RECT, x, y, X, Y);
    rect.disableStyle();
  } //tick
  public void tick (int times) {
    for (int time = 0; time < times; time++) {
      tick();
    }
  } //tick(times)
  
  public Dialog render(String text) {
    pushStyle();
    fill(150, 150, 150);
    shape(rect, 0, 0);
    float[] p = rect.getParams();
    fill(200, 200, 200);
    text(this.text = text, p[0], p[1], p[2], p[3]);
    tick();
    popStyle();
    return this;
  } //render(text)
  public Dialog renderR(String text) {
    pushMatrix();
    resetMatrix();
    render(text);
    popMatrix();
    return this;
  } //renderR(text)
  public Dialog render() {
    return render(text);
  } //render
  public Dialog renderR() {
    return renderR(text);
  } //renderR
  
} //Dialog

static abstract protected class DialogS extends Module {
  
  static volatile float milli = app.frameRate * 2;
  static ArrayList<Dialog> dialogs = new ArrayList<Dialog>(0);
  
  public static void renderRAll() {
    for (Dialog dialog : Dialog.dialogs) {
      dialog.renderR();
    }
  } //renderRAll
  public static void renderAll() {
    for (Dialog dialog : Dialog.dialogs) {
      dialog.render();
    }
  } //renderAll
  
} //DialogS

//ADD GROUPS!
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
  
  public List split(int split) {
    this.split = split;
    return this;
  } //split(split)
  
  public List mode(Mode mode) {
    this.mode = mode;
    return this;
  } //mode(mode)
  
  public ClickRegion add(ClickRegion region) {
    list.add(region);
    resize();
    return region;
  } //add(region)
  
  public List resize() {
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
{
	System.setOut(new java.io.PrintStream(new APDEInternalLogBroadcasterUtil.APDEInternalConsoleStream('o', this)));
	System.setErr(new java.io.PrintStream(new APDEInternalLogBroadcasterUtil.APDEInternalConsoleStream('e', this)));

	Thread.setDefaultUncaughtExceptionHandler(new APDEInternalLogBroadcasterUtil.APDEInternalExceptionHandler(this));
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
