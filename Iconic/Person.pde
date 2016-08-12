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
    this.trust = min((random(1,21) + charisma) / 20, 20);
    memory = new HashMap<String,Knowledge>();
    inventory = new ArrayList<String>();
  }
  
  int getInt() { return intelligence; }
  int getWis() { return wisdom; }
  int getCha() { return charisma; }
  PImage getAvatar() { return avatar; }
  String getRole() { return role; }
  double getTrust() { return trust; }
  
  void addItem(String i) {
   inventory.add(i); 
  }
  
  boolean has(String s) {
    return inventory.contains(s); 
  }
  
  void addKnowledge(Knowledge k) {
    memory.put(k.getInfo().getName(), k);
  }
  
  boolean knowsAbout(String info) {
    return memory.containsKey(info); 
  }
  
  boolean knowsAbout(Information info) {
    return memory.containsKey(info.getName()); 
  }
  
  void linkKnowledge(String a, String b, double weight) {
     memory.get(a).linkTo(memory.get(b), weight);
     memory.get(b).linkTo(memory.get(a), weight);
  }
  
  ArrayList<Knowledge> getMemories() { return new ArrayList<Knowledge>(memory.values()); }
}