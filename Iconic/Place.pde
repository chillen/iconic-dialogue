abstract class Place {
  String name;
  PImage icon; // relavent info icon
  ArrayList<Byte> actions;
  private final int padding = 10;
  private final int topLeftX = 0;
  private final int topLeftY = TILE_SIZE * world.getMap().getRowCount();
  private final int bgWidth = TILE_SIZE * world.getMap().getColCount();
  private final int ACTION_HEIGHT = 30;
  private final int ACTION_WIDTH = 120;
  
  Place(String name, PImage icon) {
    this.name = name;
    this.icon = icon;
    actions = new ArrayList<Byte>();
    actions.add(Constants.ACTION_RETURN);
  }
  
  String getName() { return name; }
  
  // go through everywhere and exit
  private void enter() {
    exitEverywhere();
    initPlace();
  }
  
   // go through everywhere and exit
  private void exitEverywhere() {
    if (places != null) {
      for (Place p : places.values()) {
        p.leave();
      }
    }
  }
  
  // Run some code when exiting
  // likely clear conversations, get attacked, etc. 
  // some places may not need this behaviour if they are purely state flags
  void leave() {}
  void initPlace() {}
  
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
  
  void handleAction(byte action) {
    switch(action) {
      case Constants.ACTION_RETURN:
        exitEverywhere();
        world.setPhase(Constants.PHASE_OVERWORLD);
        break;      
    }
  }
  
  void handleClick() {
    for (int i = 0; i < actions.size(); i++)
      if (overAction(i))
        handleAction(actions.get(i));
  }
    
  void renderActions() {
    int boxWidth = ACTION_WIDTH;
    int boxHeight = ACTION_HEIGHT;
    pushMatrix();
      translate(TILE_SIZE * world.getMap().getColCount() - boxWidth, 0);
      textSize(16);
      fill(255,255,255,100);
      rect(0,0, boxWidth, 147);
      textAlign(CENTER, CENTER);
      fill(0);
      text("Actions", boxWidth/2, boxHeight/2);
      for (int i = 0; i < actions.size(); i++) {
        byte action = actions.get(i);
        if (overAction(i))
          fill(140,150,80);
        else
          fill(180, 190, 120);
        rect(0,(i+1)*boxHeight, boxWidth, boxHeight);
        fill(0,0,0);
        text(getActionName(action), boxWidth/2, boxHeight/2+(i+1)*boxHeight);
      }
      textAlign(LEFT, BASELINE);
    popMatrix();
  }
  
  // bad design, oh well. Quick solution
  private String getActionName(byte action) {
    switch(action) {
      case Constants.ACTION_RETURN: return "Go Back";
      case Constants.ACTION_STEAL: return "Steal";
      case Constants.ACTION_TAKE: return "Take";
      case Constants.ACTION_GIVE: return "Give";
      case Constants.ACTION_ATTACK: return "Attack";
      case Constants.ACTION_TALK: return "Talk";
      default: return "Undefined";
    }
  }
  
  // check if over the action listed in the i'th position of our list
  private boolean overAction(int i) {
    return mouseX > TILE_SIZE * world.getMap().getColCount() - ACTION_WIDTH &&
           mouseX < TILE_SIZE * world.getMap().getColCount() && 
           mouseY > TILE_SIZE * world.getMap().getRowCount() + ACTION_HEIGHT * (i+1) && // there's some padding for the title equal to one box
           mouseY < TILE_SIZE * world.getMap().getRowCount() + ACTION_HEIGHT * (i + 2); // +1 for padding
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
      renderActions();
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
          world.getPlayer().addKnowledge(new Knowledge(new Information(s, categories.get(s), icons.get(s))));
      image(icons.get(s), i*48, -20);
    }
    popMatrix();
  }

}