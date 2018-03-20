//P = M
import java.util.*;
import java.lang.*;
import android.app.*;
import android.content.*;
import android.os.*;

final color RED = color(255, 0, 0), GREEN = color(0, 255, 0), BLUE = color(0, 0, 255);

color rndRGB() {
  return color(int(round(random(255))), int(round(random(255))), int(round(random(255))));
} //rndRGB

char[] splitAll(String string) {
  return string.toCharArray();
} //splitAll(string)

String[] splitAllS(String string) {
  String[] comp = new String[string.length()];
  for (int stp = 0; stp < string.length(); stp++) {
    comp[stp] = "" + string.charAt(stp);
  }
  return comp;
} //splitAllS(string)

<T extends Collection<E>, E> E rnd(T item) {
  ArrayList<E> list = new ArrayList<E>(item);
  return list.get(int(random(list.size())));
} //rnd(item)

static abstract class Module {
  
  static char[] splitAll(String string) {
    return string.toCharArray();
  } //splitAll(string)
  
  static String[] splitAllS(String string) {
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
  volatile static int rnd = int(Module.app.random(100));
  
  static interface Animatable {
    
    float x = 0.0f,
    y = 0.0f,
    z = 0.0f,
    dx = 0.0f,
    dy = 0.0f,
    dz = 0.0f;
    
    void tick();
    
  } //Animatable
  
} //Module