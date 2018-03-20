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
  blocked = false; //N
  float cooldown = CLICK_SENSITIVITY,
  last = millis();
  String reason = "Keyboard"; //N
  
  Keyboard(float x, float y, float dx, float dy, Alph alph) {
    this(x, y, dx, dy, alph, 8, Mode.FREE, "Keyboard");
  } //Keyboard(x, y, dx, dy)
  Keyboard(float x, float y, float dx, float dy, Alph alph, int split, Mode mode, String reason) {
    this.alph = alph;
    this.split = split;
    this.reason = reason;
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
      inp = createShape(RECT, this.x + dx * 0.1f, this.y - dy / 3 - OFFSET, dx * 0.8, dy / 3);
    } else if (submode == Submode.BOTTOM) {
      inp = createShape(RECT, this.x + dx * 0.1f, this.y + dy / 3 + OFFSET, dx * 0.8, dy / 3);
    }
    int length = 0,
    block = 0;
    for (int stp = 0; stp < alph.alph.length(); stp++) {
      if (alph.alph.charAt(stp) == '[') {
        block++;
      } else if (alph.alph.charAt(stp) == ']') {
        block--;
      }
      if (!boolean(block)) {
        length++;
      }
    }
    float Dy = dy / (int(length / split) + 1), Dx = dx / split;
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
      Piece piece = new Piece(comp, this.x + (count % split) * Dx, this.y + int(count / split) * Dy, Dx, Dy, this);
      if (comp.equalsIgnoreCase("Del") || comp.equalsIgnoreCase("Cap") || comp.equalsIgnoreCase("End")) {
        piece.special = true;
      }
      pieces.add(piece);
      count++;
    }
  } //Keyboard(x, y, dx, dy, split, mode)
  
  boolean clicked() {
    if (region.clicked()) {
      return true;
    }
    return false;
  } //clicked
  
  boolean clickedR() {
    if (region.clickedR()) {
      return true;
    }
    return false;
  } //clickedR
  
  ArrayList<Piece> clickedRP() {
    ArrayList<Piece> clicks = new ArrayList<Piece>();
    for (Piece piece : pieces) {
      if (piece.clickedR()) {
        clicks.add(piece);
      }
    }
    return clicks;
  } //clickedRP
  
  ArrayList<Piece> clickedP() {
    ArrayList<Piece> clicks = new ArrayList<Piece>();
    for (Piece piece : pieces) {
      if (piece.clicked()) {
        clicks.add(piece);
      }
    }
    return clicks;
  } //clickedP
  
  String type() {
    for (Piece piece : clickedP()) {
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
    return typed;
  } //type
  
  String typeR() {
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
    return typed;
  } //typeR
  
  Keyboard draw() {
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
  
  Keyboard drawR() {
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
  
  Keyboard show() {
    for (Piece piece : pieces) {
      piece.region.mode = ClickRegion.Mode.ACTIVE;
    }
    return draw();
  } //show
  Keyboard showR() {
    for (Piece piece : pieces) {
      piece.region.mode = ClickRegion.Mode.ACTIVE;
    }
    return drawR();
  } //showR
  Keyboard show(String reason) {
    pushStyle();
    float tmp;
    fill(255);
    stroke(0);
    shape(createShape(RECT, x, tmp = y - (submode == Keyboard.Submode.TOP ? inp.getParams()[3] : 0) - dy / 5 - 2 * OFFSET, dx, dy / 5), 0, 0);
    popStyle();
    text(reason, x, tmp, dx, dy / 5);
    return show();
  } //show
  Keyboard showR(String reason) {
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
  
  void hide() {
    for (Piece piece : pieces) {
      piece.region.mode = ClickRegion.Mode.PASSIVE;
    }
  } //hide
  
  Keyboard run() {
    type();
    show();
    return this;
  } //run
  Keyboard runR() {
    typeR();
    showR();
    return this;
  } //runR
  Keyboard run(String text) {
    type();
    show(text);
    return this;
  } //run(text)
  Keyboard runR(String text) {
    typeR();
    showR(text);
    return this;
  } //runR(text)
  
  String submit() {
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
    
    void draw() {
      textAlign(CENTER, CENTER);
      text(chr(), x, y, dx, dy);
    } //draw
    
    void drawR() {
      pushMatrix();
      resetMatrix();
      textAlign(CENTER, CENTER);
      text(chr(), x, y, dx, dy);
      popMatrix();
    } //drawR
    
    boolean clicked() {
      if (region.clickover()) {
        return true;
      }
      return false;
    } //clicked
    
    boolean clickedR() {
      if (region.clickoverR()) {
        return true;
      }
      return false;
    } //clickedR
    
    String chr() {
      if (keyboard.capital && !special) {
        return chr.toUpperCase();
      }
      return chr;
    } //chr
    
  } //Piece
  
} //Keyboard

static abstract protected class KeyboardS extends Module {
  
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