//C,M,P = K
class Kingdom extends KingdomS {
  
  Village capital;
  private Kingdom king;
  final Set<Village> cities = new HashSet<Village>(0);
  volatile String name = "Kingdom-" + (Kingdom.kingdoms.size() + 1);
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
    kingdoms.add(this);
    king = this;
  } //ini
  
  Village city() {
    Village village = new Village(this);
    cities.add(village);
    return village;
  } //city
  Village city(int x, int y) {
    Village village = new Village(this);
    village.x = x;
    village.y = y;
    cities.add(village);
    return village;
  } //city(x, y)
  
  void tick() {
    for (Village village : cities) {
      village.tick();
    }
    refresh();
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
      capital = city(x, y);
    }
    capital.on(x, y);
    return this;
  } //on(x, y)
  
  Kingdom go() {
    if (capital != null) {
      capital.go();
    }
    return this;
  } //go
    
  void destroy() {
    kingdoms.remove(this);
    for (Village village : cities) {
      if (!village.capital) {
        village.destroy();
      }
    }
  } //destroy
  void finalise() {
    destroy();
  } //finalise
  
  void refresh() {
    if (cities.size() <= 0 && established) {
      destroy();
    }
  } //refresh
  
  Kingdom conquer(Village village) {
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
    color clr = rndRGB();
    volatile Set<Village> siblings;
    volatile String name = "City-" + (villages.size() + 1);
    volatile int wealth = int(random(10, 100));
    volatile int population = int(random(wealth * 10, wealth * 100)),
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
    Village(String name) {
      ini(king);
      this.name = name;
    } //Village(name)
    Village() {
      ini(king);
    } //Village()
    
    Village ini(Kingdom owner) {
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
      villages.remove(this);
      siblings.remove(this);
    } //destroy
    void finalise() {
      destroy();
    } //finalise
    
    void tick() {
      population += wealth;
      wealth += int(population / 100);
      wealth -= population / wealth / 10;
      refresh();
    } //tick
    
    void refresh() {
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
  
  final static void tickAll() {
    for (Kingdom kingdom : new HashSet<Kingdom>(Kingdom.kingdoms)) {
      kingdom.tick();
    }
  } //tickAll
  
  static protected class VillageS extends ContainerS {
    
    final static Set<Kingdom.Village> villages = new HashSet<Kingdom.Village>(0);
    final static Type TYPE = Type.VILLAGE;
    
    final static void tickAll() {
      for (Kingdom.Village village : new HashSet<Kingdom.Village>(Kingdom.Village.villages)) {
        village.tick();
      }
    } //tickAll
    
  } //VillageS

} //KingdomS