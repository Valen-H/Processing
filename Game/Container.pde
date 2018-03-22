//M,K = C
class Container extends ContainerS {
  
  Type type = Type.EMPTY;
  Subtype subtype = Subtype.NULL;
  Kingdom.Village village;
  Kingdom kingdom;
  transient int rnd = int(random(100)); //N
  float x, y, dx, dy;
  
  Container is(Kingdom.Village village) {
    this.village = village;
    kingdom = village.owner;
    dx = dy = mp.unit;
    at(village.x * dx, village.y * dy);
    is(Type.VILLAGE);
    return this;
  } //is(village)
  Container is(Kingdom kingdom) {
    is(kingdom.capital);
    is(Subtype.CAPITAL);
    return this;
  } //is(kingdom)
  void is(Type type, Subtype subtype) {
    is(type);
    is(subtype);
  } //is(type, subtype)
  void is(Subtype subtype) {
    this.subtype = subtype;
    if (type == Type.EMPTY) {
      switch (subtype) {
        case WATER:
        case MOUNTAIN:
          is(Type.OBSTACLE);
      }
    }
  } //is(subtype)
  Container is(Type type) {
    this.type = type;
    if (type == Type.OBSTACLE && subtype == Subtype.NULL) {
      switch (int(round(random(1)))) {
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
  
  void ini() {
    Container.containers.add(this);
  } //ini
  
  Container at(float x, float y) {
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