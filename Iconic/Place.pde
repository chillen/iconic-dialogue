abstract class Place {
  String name;
  PImage icon; // relavent info iceon
  private int padding = 10;
  private int topLeftX = 0;
  private int topLeftY = TILE_SIZE * world.getMap().getRowCount();
  private int bgWidth = TILE_SIZE * world.getMap().getColCount();
  private int bgHeight = height - topLeftY;
  
  Place(String name, PImage icon) {
    this.name = name;
    this.icon = icon;
  }
  
  String getName() { return name; }
  
  void enterPlace() {
    
  }
  
  private void renderRelevantPush() {
    pushMatrix();
      translate(0, 107);
      fill(0,0,0,80);
      rect(0,0,bgWidth,200);
      fill(255);
      translate(padding, 26);
      textSize(18);
      text("Relavent Information: ", 0, 0);
      translate(textWidth("Relavent Information: ")+10, 0);
  }
  
  private void renderTemplate() {
    int topLeftX = 0;
    int topLeftY = TILE_SIZE * world.getMap().getRowCount();
    int bgWidth = TILE_SIZE * world.getMap().getColCount();
    int bgHeight = height - topLeftY;
    int padding = 10;
    
    String header = name;
    
    fill(180,180,130);
    rect(0, 0, bgWidth, bgHeight);
    image(icon, padding, padding);
    fill(0);
    textSize(24);
    text(header, padding+36, padding+3, bgWidth-2*padding, bgHeight-2*padding);
    textSize(12);
    fill(defaultFill);
  }
  
  public final void render() {
    pushMatrix();
      translate(this.topLeftX, this.topLeftY);
      renderTemplate();
      translate(0, 40);
      specificRender();
    popMatrix();
  }
  
  // Things you need to be rendered on top of everything
  abstract void specificRender();
  
  // register knowledge icons and render them 
  public void relevantInfo(ArrayList<String> info) {
    renderRelevantPush();
    for (int i = 0; i < info.size(); i++) {
      String s = info.get(i);
      if (!world.getPlayer().knowsAbout(s))
          world.getPlayer().addKnowledge(new Knowledge(new Information(s, icons.get(s))));
      image(icons.get(s), i*48, -20);
    }
    popMatrix();
  }

}