import java.util.*;

class Person extends Information {
  HashMap<String, Knowledge> memory;
  PImage avatar;
  int intelligence, wisdom, charisma;
  String role;
  ArrayList<String> inventory;
  double trust;
  
  Person(String name, String role, PImage icon, PImage avatar, int intelligence, int wisdom, int charisma) {
    super(name, icon);
    this.avatar = avatar;
    this.intelligence = intelligence;
    this.wisdom = wisdom;
    this.charisma = charisma;
    this.role = role;
    this.trust = min((random(1,21) + charisma) / 20, 0.99);
    memory = new HashMap<String,Knowledge>();
    inventory = new ArrayList<String>();
  }
  
  int getInt() { return intelligence; }
  int getWis() { return wisdom; }
  int getCha() { return charisma; }
  PImage getAvatar() { return avatar; }
  String getRole() { return role; }
  double getTrust() { return trust; }
  void setTrust(double t) { trust = max(max(0, (float)t), min(1, (float)t)); }
  
  void addItem(String i) {
   inventory.add(i); 
  }
  
  boolean has(String s) {
    return inventory.contains(s); 
  }
  
  void removeItem(String i) {
   inventory.remove(i); 
  }
  
  void addKnowledge(Knowledge k) {
    memory.put(k.getInfo().getName(), k);
  }
  
  Attitude getAttitude(Information i) {
    if (memory.containsKey(i.getName()))
      return memory.get(i.getName()).getAttitude();
    else return new Attitude();
  }
  
  void setAttitude(Information i, Attitude a) {
    if (memory.containsKey(i.getName()))
      memory.get(i.getName()).setAttitude(a);
  }
  
  boolean knowsAbout(String info) {
    return memory.containsKey(info); 
  }
  
  boolean knowsAbout(Information info) {
    return memory.containsKey(info.getName()); 
  }
  
  Knowledge getKnowledge(Information info) {
    return memory.get(info.getName());
  }
  
  void linkKnowledge(String a, String b, double weight) {
     memory.get(a).linkTo(memory.get(b), weight);
     memory.get(b).linkTo(memory.get(a), weight);
  }
  
  ArrayList<Knowledge> getMemories() { return new ArrayList<Knowledge>(memory.values()); }
}