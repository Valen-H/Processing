//C,M,P = K
class Kingdom extends KingdomS {
  
  Village capital;
  private Kingdom king;
  final ArrayList<Kingdom> kingdomsS = Kingdom.kingdoms;
  final ArrayList<Village> cities = new ArrayList<Village>(0);
  String name = "Kingdom-" + (Kingdom.kingdoms.size() + 1);
  color clr = rndRGB();
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
  Kingdom(String name, color clr) {
    this.name = name;
    this.clr = clr;
    ini();
  } //Kingdom(name, clr)
  
  private void ini() {
    Kingdom.kingdoms.add(this);
    king = this;
  } //ini
  
  Village city() {
    Village village = new Village(this);
    cities.add(village);
    return village;
  } //city
  
  void tick() {
    for (Village village : cities) {
      village.tick();
    }
  } //tick
  
  Kingdom on() {
    if (capital == null) {
      capital = city();
    }
    capital.on();
    return this;
  } //on
  Kingdom on(int x, int y) {
    if (capital == null) {
      capital = city();
    }
    capital.on(x, y);
    return this;
  } //on(x, y)
  
  Kingdom go() {
    capital.go();
    return this;
  } //go
    
  void destroy() {
    Kingdom.kingdoms.remove(this);
    for (Village village : cities) {
      if (!village.capital) {
        village.destroy();
      }
    }
  } //destroy
  
  class Village extends KingdomS.VillageS {
    
    Kingdom owner;
    color clr = rndRGB();
    final ArrayList<Village> villagesS = Village.villages;
    ArrayList<Village> siblings;
    String name = "City-" + (Village.villages.size() + 1);
    int wealth = int(random(10, 100));
    int population = int(random(wealth * 10, wealth * 100)),
    x = int(round(random(mp.width))),
    y = int(round(random(mp.height)));
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
    Village() {
      ini(king);
    } //Village()
    
    private void ini(Kingdom owner) {
      this.owner = owner;
      clr = owner.clr;
      siblings = owner.cities;
      name = owner.name + "-City-" + (siblings.size() + 1);
      if (!Village.villages.contains(this)) {
        Village.villages.add(this);
      }
      if (siblings.size() == 0) {
        capital = true;
      } else {
        capital = false;
      }
    } //ini
    
    Village on() {
      on(int(floor(random(mp.width))), int(floor(random(mp.height))));
      return this;
    } //on
    Village on(int x, int y) {
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
    
    void go() {
      can.scrollTo(- area.x + X / 2 - mp.unit / 2, - area.y + Y / 2 - mp.unit / 2);
    } //go
    
    void destroy() {
      mp.get(x, y).is(Type.EMPTY);
      Village.villages.remove(this);
      siblings.remove(this);
    } //destroy
    
    void tick() {
      population += wealth;
      wealth += int(population / 100);
      wealth -= population / wealth / 10;
    } //tick
    
    Village[] adjacents() {
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
    } //adjacents
    
  } //Village
  
} //Kingdom

static abstract protected class KingdomS extends ContainerS {
  
  final static ArrayList<Kingdom> kingdoms = new ArrayList<Kingdom>(0);
  final static Type TYPE = Type.VILLAGE;
  
  final static void tickAll() {
    for (Kingdom kingdom : kingdoms) {
      kingdom.tick();
    }
  } //tickAll
  
  static protected class VillageS extends ContainerS {
    
    final static ArrayList<Kingdom.Village> villages = new ArrayList<Kingdom.Village>();
    final static Type TYPE = Type.VILLAGE;
    
    final static void tickAll() {
      for (Kingdom.Village village : villages) {
        village.tick();
      }
    } //tickAll
    
  } //VillageS

} //KingdomS