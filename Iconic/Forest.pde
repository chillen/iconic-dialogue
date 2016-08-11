class Forest extends Place {
  Forest(String name, PImage icon) {
    super(name, icon); 
    setupFlags();
  }
  
  private void setupFlags() {
    world.setFlag(Constants.FLAG_FOREST_ANIMALS, false);
  }
  
  void specificRender() {
    String text;
    ArrayList<String> info = new ArrayList<String>();
    info.add("animals");
    info.add("forest");
    
    if (!world.flagged(Constants.FLAG_FOREST_ANIMALS)) {
      text = "The forest is dark, but you can see clearly. Echoes of beasts surround you.";
    }
    else {
      text = "Coming into the forest, the animals make their way from the trees with vicious looks in their eyes!";
    }
    
    pushMatrix();
      translate(super.padding, super.padding*2);
      text(text, 0,0);
    popMatrix();
    relevantInfo(info);
  }
}