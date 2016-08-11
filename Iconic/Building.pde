class Building extends Place {
  Person patron;
  
  Building(Person person, String name, PImage icon) {
    super(name, icon);
    this.patron = person;
  }
  
  void specificRender() {
    ArrayList<String> info = new ArrayList<String>();
    info.add(patron.getName().toLowerCase());
    if (!world.getPlayer().knowsAbout(patron.getName().toLowerCase())) {
      world.getPlayer().addKnowledge( new Knowledge( new Information( patron.getName().toLowerCase(), icons.get(patron.getName().toLowerCase()) ) ) );
    }
    
    // XXX: Delete after
    // shows all memories of the patron in a building
    for (int i = 0; i < patron.getMemories().size(); i++) {
        Knowledge k = patron.getMemories().get(i);
        image(k.getInfo().getIcon(), (i%10)*48+115,15+(i/10)*48);
      }
    
    pushMatrix();
      translate(super.padding, super.padding-3);
      fill(icon.get(0,0));
      rect(0, 0, 96,96);
      image(patron.getAvatar(), 0, 0, 96, 96);
      fill(0,0,0,160);
      rect(0, 96-24, 96, 24);
      textSize(16);
      fill(icon.get(0,0));
      textAlign(CENTER);
      text(patron.getName(), 96/2, 90);
      textAlign(LEFT);
      
      
    popMatrix();
    super.relevantInfo(info);
  }
}