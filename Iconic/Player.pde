class Player {
  HashMap<String, Knowledge> memory;
  ArrayList<String> inventory;
  
  Player() {
    memory = new HashMap<String,Knowledge>();
    inventory = new ArrayList<String>(); 
  }
  
  void addItem(String s) {
    inventory.add(s); 
  }
  
  void addKnowledge(Knowledge k) {
    memory.put(k.getInfo().getName(), k);
  }
  
  boolean has(String s) {
    return inventory.contains(s); 
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