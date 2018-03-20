//C,C3,K,K2,M = P

import java.io.File;

volatile float zoom = 2.0f, milli = 0.0f, counter = 0.0f;
float[] coord = {0.0f, 0.0f};
float X = width, Y = height;
final int SIZE = 50;
final float UNIT = 50 / zoom, OFFSET = 10.0f;
final int CLICK_SENSITIVITY = 400;
volatile String screen = "Map";

Canvas can;
Map mp;
Kingdom player;
Keyboard keyb;
ClickRegion menu;
XML xml;

void settings() {
  fullScreen(P2D);
}

void setup() {
  X = width;
  Y = height;
  frameRate(120);
  background(200);
  textSize(30);
  smooth();
  can = new Canvas(zoom, Canvas.Mode.CENTERED);
  can.submode.remove(Canvas.Submode.ZOOM);
  mp = new Map(SIZE, SIZE, UNIT * zoom);
  keyb = new Keyboard(X / 2, Y / 2, X - OFFSET, Y / 3 + OFFSET, Keyboard.Alph.BASIC, 8, Keyboard.Mode.CENTERED, "");
  menu = new ClickRegion(0.0f, 0.0f, float(SIZE), float(SIZE));
  if (!new File("data.xml").exists()) {
    //^fix
    ini();
    save();
  } else {
    load();
  }
  stroke(180);
  fill(160);
  pushMatrix();
  resetMatrix();
  textAlign(CENTER, CENTER);
  translate(X / 2, Y / 2);
  text("Loading...", 0, 0);
  popMatrix();
  player.go();
  noFill();
}

void draw() {
  tick();
} //draw

void tick() {
  clear();
  clip(0, 0, X, Y);
  textAlign(CENTER, CENTER);
  background(200);
  if (!screen.equalsIgnoreCase("Keyboard")) {
    can.scroll();
  }
  float[] coords = can.trns;
  coord[0] = mouseX - coords[0];
  coord[1] = mouseY - coords[1];
  if (screen.equalsIgnoreCase("Map")) {
    mp.draw();
  } else if (screen.equalsIgnoreCase("Keyboard")) {
    keyb.runR("Input Text:");
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
} //tick

void mouseDragged() {
  if (!screen.equalsIgnoreCase("Keyboard")) {
    can.scroll();
  } else if ((int) pmouseX != (int) mouseX || (int) pmouseY != (int) mouseY) {
    mousePressed = false;
  }
  float[] coords = can.trns;
  coord[0] = mouseX - coords[0];
  coord[1] = mouseY - coords[1];
} //mouseDragged

/*void touchMoved() {
  if (!screen.equalsIgnoreCase("Keyboard")) {
    can.scroll();
  } else if ((int) pmouseX != (int) mouseX || (int) pmouseY != (int) mouseY) {
    mousePressed = false;
  }
  float[] coords = can.trns;
  coord[0] = mouseX - coords[0];
  coord[1] = mouseY - coords[1];
} //touchMoved*/

void mousePressed() {
  milli = millis();
  mousePressed = true;
} //mousePressed

void mouseReleased() {
  if (menu.clickedR(true) && millis() - milli < CLICK_SENSITIVITY) {
    screen = screen.equalsIgnoreCase("Map") ? "Keyboard" : "Map";
  }
  if (screen.equalsIgnoreCase("Keyboard")) {
    keyb.locked = false;
  }
  /*if (coord[0] >= 0 && coord[0] <= mp.width * mp.unit && coord[1] >= 0 && coord[1] <= mp.height * mp.unit && abs(milli - millis()) <= CLICK_SENSITIVITY && pmouseX == mouseX && pmouseY == mouseY) {
    Container cont = mp.at(coord);
    if (cont.type == Container.Type.EMPTY) {
      cont.is(player.city());
    }
  }*/
  mousePressed = false;
} //mouseReleased

void save() {
  xml = parseXML("<?xml version='1.0'?>\n<data>\n\t\n</data>");
  int counter = 0;
  for (Kingdom kingdom : Kingdom.kingdoms) {
    XML child = xml.addChild("kingdom");
    //child.setContent(kingdom.name + "\n\t");
    //child.setString("color", kingdom.color);
    child.setString("name", kingdom.name);
    child.setInt("id", counter++);
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

void onBackPressed() {
  save();
  exit();
} //onBackPressed

void load() {
  xml = loadXML("data.xml");
  for (XML kingdom : xml.getChildren()) {
    if (kingdom.getInt("id") == 0) {
      player = new Kingdom(kingdom.getString("name")).on();
    } else {
      new Kingdom(kingdom.getString("name"));
    }
  }
  println("Game loaded...");
} //load

void ini() {
  player = new Kingdom("Ellestris").on();
  //add setuping screen
} //ini

void menu() {
  //menu screen
} //menu