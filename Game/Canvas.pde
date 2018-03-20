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
    this(mode, width, height, 1.0);
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
  
  void ini(float width, float height, float[] zoom, Mode mode) {
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
  
  void trans() {
    if (auto) {
      if (pmode.equalsIgnoreCase("3D")) {
        translate(trns[0], trns[1], trns[2]);
      } else {
        translate(trns[0], trns[1]);
      }
    }
  } //trans
  
  float[] scroll() {
    float[] diff = {mouseX - pmouseX, mouseY - pmouseY};
    trns[0] += round(strns[0] = diff[0] / zoom[0]);
    trns[1] += round(strns[1] = diff[1] / zoom[1]);
    render();
    return trns;
  } //scroll
  float[] scroll(float z) {
    trns[2] += strns[2] = z;
    render();
    return trns;
  } //scroll(z)
  float[] scroll(float[] by) {
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
  float[] scroll(float x, float y) {
    trns[0] += strns[0] = x;
    trns[1] += strns[1] = y;
    render();
    return trns;
  } //scroll(x, y)
  float[] scroll(float x, float y, float z) {
    trns[0] += x;
    trns[1] += y;
    trns[2] += z;
    render();
    return trns;
  } //scroll(x, y, z)
  float[] scrollTo(float[] to) {
    if (to.length == 2) {
      return scrollTo(to[0], to[1]);
    } else if (to.length == 1) {
      return scrollTo(to[0]);
    } else {
      return scrollTo(to[0], to[1], to[2]);
    }
  } //scrollTo(to[])
  float[] scrollTo(float z) {
    trns[2] = z;
    render();
    return trns;
  } //scrollTo(z)
  float[] scrollTo(float x, float y) {
    trns[0] = x;
    trns[1] = y;
    render();
    return trns;
  } //scrollTo(x, y)
  float[] scrollTo(float x, float y, float z) {
    trns[0] = x;
    trns[1] = y;
    trns[2] = z;
    render();
    return trns;
  } //scrollTo(x, y, z)
  
  float[] zoom() {
    if (auto) {
      if (pmode.equalsIgnoreCase("3D")) {
          scale(zoom[0], zoom[1], zoom[2]);
        } else {
          scale(zoom[0], zoom[1]);
        }
    }
    return zoom;
  } //zoom
  float[] zoom(float to) {
    zoom[0] = to;
    zoom[1] = to;
    zoom[2] = to;
    render();
    return zoom;
  } //zoom(to)
  float[] zoom(float[] to) {
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
  float[] zoom(float x, float y) {
    zoom[0] = x;
    zoom[1] = y;
    render();
    return zoom;
  } //zoom(x, y)
  float[] zoom(float x, float y, float z) {
    zoom[0] = x;
    zoom[1] = y;
    zoom[2] = z;
    render();
    return zoom;
  } //zoom(x, y, z)
  float[] zoomBy(float by) {
    zoom[0] *= by;
    zoom[1] *= by;
    zoom[2] *= by;
    render();
    return zoom;
  } //zoom(by)
  float[] zoomBy(float[] by) {
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
  float[] zoomBy(float x, float y) {
    zoom[0] *= x;
    zoom[1] *= y;
    render();
    return zoom;
  } //zoom(x, y)
  float[] zoomBy(float x, float y, float z) {
    zoom[0] *= x;
    zoom[1] *= y;
    zoom[2] *= z;
    render();
    return zoom;
  } //zoom(x, y, z)
  
  void render() {
    resetMatrix();
    if (submode.contains(Canvas.Submode.ZOOM)) {
      zoom();
    }
    if (submode.contains(Canvas.Submode.SCROLL)) {
      trans();
    }
  } //render
  
  Canvas reset() {
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