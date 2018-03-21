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
  
  void tick() {
    x += dx;
    y += dy;
    if (--millis <= 0) {
      closed = true;
      Dialog.dialogs.remove(this);
    }
    rect = createShape(RECT, x, y, X, Y);
    rect.disableStyle();
  } //tick
  void tick (int times) {
    for (int time = 0; time < times; time++) {
      tick();
    }
  } //tick(times)
  
  Dialog render(String text) {
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
  Dialog renderR(String text) {
    pushMatrix();
    resetMatrix();
    render(text);
    popMatrix();
    return this;
  } //renderR(text)
  Dialog render() {
    return render(text);
  } //render
  Dialog renderR() {
    return renderR(text);
  } //renderR
  
} //Dialog

static abstract protected class DialogS extends Module {
  
  static volatile float milli = app.frameRate * 2;
  static ArrayList<Dialog> dialogs = new ArrayList<Dialog>(0);
  
  static void renderRAll() {
    for (Dialog dialog : Dialog.dialogs) {
      dialog.renderR();
    }
  } //renderRAll
  static void renderAll() {
    for (Dialog dialog : Dialog.dialogs) {
      dialog.render();
    }
  } //renderAll
  
} //DialogS

//ADD GROUPS!