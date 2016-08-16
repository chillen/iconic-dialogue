class Building extends Place {
  Person patron;
  byte state;
  Conversation dialogue;
  private HashMap<String, String> welcome;
  boolean clickingMainTopic = false;
  String currentReaction;
  
  Building(Person person, String name, PImage icon) {
    super(name, icon);
    this.patron = person;
    this.state = Constants.BUILDING_EMPTY;
    welcome = new HashMap<String, String>();
    actions.add(Constants.ACTION_TALK);
    setupWelcome();
    currentReaction = "Sure, let's talk.";
  }
  
  void specificRender() {
    ArrayList<String> info = new ArrayList<String>();
    info.add(patron.getName().toLowerCase());    
    String welcomeMessage = "Hello!";
    double trustThreshold = 0.3;
    int innerWidth = TILE_SIZE * world.getMap().getColCount() - 96 - super.padding*2 - super.ACTION_WIDTH;
    
    // unfriendly
    if (patron.getTrust() < 0.5 - trustThreshold) 
      welcomeMessage = welcome.get("unfriendly");
    else if (patron.getTrust() < 0.5 + trustThreshold) 
      welcomeMessage = welcome.get("neutral");
    else
      welcomeMessage = welcome.get("friendly");
              
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
      
      // inner content
      pushMatrix();
        fill(0);
        translate(104, 0);
        if (state == Constants.BUILDING_ENTERED) {
          text(welcomeMessage, 0, 0, innerWidth, 200);
        }
        else if (state == Constants.BUILDING_CONVERSATION) {
          text(dialogue.getReaction(), 0, 0, innerWidth, 200);
          renderDialogue();
        }
      popMatrix();
    popMatrix();
    super.relevantInfo(info);
  }
  
  void setupDialogue() {
    dialogue = new Conversation(this.patron);
  }
  
  void renderDialogue() {
    int innerWidth = TILE_SIZE * world.getMap().getColCount() - 104 - super.padding*2 - super.ACTION_WIDTH;
    if (dialogue.getPhase() == Constants.TALK_NPC)
      fill(icon.get(0,0), 150);
    else
      fill (150,150,150,120);
    rect (0, 30, innerWidth, 60);
    
    fill(0,0,0,150);
    rectMode(CENTER);
    rect(innerWidth/2, -60, 500, 20);
    rectMode(CORNER);
    fill (255);
    textSize(10);
    textAlign(CENTER);
    text(dialogue.getTooltip(), innerWidth/2, -60);
    textAlign(LEFT);
    
    if (overMainTopic() || clickingMainTopic)
      fill (30,30,30,200);
    else
      fill (100,100,100,100);
    rect(0,30,60,60);
    imageMode(CENTER);
    image(dialogue.getTopic().getIcon(), 30,50);
    imageMode(CORNER);
    textSize(10);
    fill(255);
    textAlign(CENTER);
    text("Main Topic", 0,70, 60, 60);  
    textAlign(LEFT);
    textSize(16);
      
    if (dialogue.getPhase() == Constants.TALK_CHOOSE || dialogue.getPhase() == Constants.TALK_NPC) {
      drawInfo();
    }
    
    if (dialogue.getPhase() == Constants.TALK_BIAS) {
      drawBias();
    }
    
    if (overContinue())
      fill (30,30,30,200);
    else
      fill (100,100,100,100);
    rect(innerWidth-60,30,60,60);
    textSize(10);
    fill(255);
    textAlign(CENTER);
    text("Continue", innerWidth-60,50, 60, 60);  
    textAlign(LEFT);
    textSize(16);
  }
  
  void drawBias() {
    int innerWidth = TILE_SIZE * world.getMap().getColCount() - 104 - super.padding*2 - super.ACTION_WIDTH;
    if (overBias())
      fill(150,150,150,120);
    else
      fill(200,200,200,200);
    rectMode(CENTER);
    rect(innerWidth/2, 60, innerWidth/4, 60);  
    rectMode(CORNER);
    
    // Draw FIRE words
    fill(255);
    textSize(12);
    textAlign(CENTER);
    text("FEAR", innerWidth/2, 30);
    text("ENJOYMENT", innerWidth/4+10, 66);
    text("RAGE", innerWidth - innerWidth/4-10, 66);
    text("INTEREST", innerWidth/2, 100);
    textAlign(LEFT);
    
    // Draw grid lines
    stroke(0,0,0,100);
    line(innerWidth/2, 30, innerWidth/2, 90);
    line(innerWidth/2-47, 60, innerWidth/2+47, 60);
    stroke(0);
    
    Point bias = attitudeToXY(dialogue.getBias());
    bias.x += innerWidth/2;
    bias.y += 60;
    
    fill(0,0,0,80);
    ellipse(bias.x, bias.y, 5, 5);
  }
  
  private Point attitudeToXY(Attitude a) {
    Point p = new Point(0,0);
    p.x = (int) (96 * (a.getRage())) * 2 - 48;
    p.y = (int) (60 * (a.getInterest())) * 2 - 30;
    return p;
  }
  
  boolean overContinue() { 
    int x2 = TILE_SIZE * world.getMap().getColCount() - super.ACTION_WIDTH - 7;
    int x1 = TILE_SIZE * world.getMap().getColCount() - super.ACTION_WIDTH - 60 - 7;
    int y1 = super.padding-3 + 30 + TILE_SIZE * world.getMap().getRowCount() + 40;
    int y2 = super.padding-3 + 30 + 60 + TILE_SIZE * world.getMap().getRowCount() + 40;

    return mouseX < x2 && mouseX > x1 && mouseY < y2 && mouseY > y1;
  }
  
  boolean overMainTopic() { 
    int x2 = 177;
    int x1 = 117;
    int y1 = super.padding-3 + 30 + TILE_SIZE * world.getMap().getRowCount() + 40;
    int y2 = super.padding-3 + 30 + 60 + TILE_SIZE * world.getMap().getRowCount() + 40;

    return mouseX < x2 && mouseX > x1 && mouseY < y2 && mouseY > y1;
  }
  
  void handleClick() {
    super.handleClick(); 
    if (overMainTopic() && dialogue.getPhase() == Constants.TALK_CHOOSE) {
      clickingMainTopic = !clickingMainTopic;
    }
    if (overContinue()) {
      dialogue.nextPhase(); 
    }
    if (overBias() && dialogue.getPhase() == Constants.TALK_BIAS) {
      // values were manually found. Poor, yes, but prototype      
      Point modPoint = new Point(mouseX - 257,mouseY - 353-232);
      dialogue.setBias(pointToBias(modPoint));
    }
  }
  
  Attitude pointToBias(Point p) {
    // just in case anything is off by a pixel

    p.x = max(p.x, 0);
    p.y = max(p.y, 0);
    p.x = min(p.x, 96);
    p.y = min(p.y, 60);
    
    
    // x range is 96, y range is 60
    // mid point is 48, 30
    // Attitude is in a cross, NESW, FRIE
    Attitude a = new Attitude();
    // Set each as a percentage of their way to the maximum/minimum
    // This is done by subtracting the respective midpoint and taking the absolute
    // ex. Fear is top, so (Math.abs(y - 30) / 60) gives us a percentage have how Fear it is - assuming Fear is negative
    
    // E Side
    if (p.x < 48) {
      a.setEnjoyment(((96-p.x) / 96.0) / 2);
      a.setRage(.5 - a.getEnjoyment());
    }
    else if (p.x >= 48) {
      a.setRage((p.x / 96.0) / 2);
      a.setEnjoyment(.5 - a.getRage());
    }
    
    if (p.y < 30) {
      a.setFear(((60 - p.y) / 60.0)/2);
      a.setInterest(.5 - a.getFear());
    }
    else if (p.y >= 30) {
      a.setInterest((p.y / 60.0)/2);
      a.setFear(.5 - a.getInterest());
    }
    return a;
  }
  
  boolean overBias() {
    int innerWidth = TILE_SIZE * world.getMap().getColCount() - 104 - super.padding*2 - super.ACTION_WIDTH;
    int x1 = 258;
    int x2 = 352;
    int y1 = 584;
    int y2 = 643;
  
    return mouseX < x2 && mouseX > x1 && mouseY < y2 && mouseY > y1;
  }
  
  void drawInfo() {
    int totalWidth = TILE_SIZE * world.getMap().getColCount() - 104 - super.padding*2 - super.ACTION_WIDTH - 120;
    int infoPerRow = 3;
    int mod = totalWidth / infoPerRow;
    
    imageMode(CENTER);
    for (int i = 0; i < dialogue.getInfo().size(); i++) {
      image(dialogue.getInfo().get(i).getIcon(), 60+mod/2+(i%3)*mod, 55);
    }
    imageMode(CORNER);
  }
  
  void handleAction(byte action) {
    super.handleAction(action);
    
    switch(action) {
      case Constants.ACTION_TALK:
        state = Constants.BUILDING_CONVERSATION;
        setupDialogue();
        break;
    }
  }
  
  void handleInfoClick(Information i) {
    if (!(dialogue.getPhase() == Constants.TALK_CHOOSE))
      return;
    if (clickingMainTopic) {
      dialogue.setTopic(i);
      clickingMainTopic = false;
    }
    else
      dialogue.addInfo(i);
  }
  
  // populates the welcome map with the relavent messages from the spreadsheet
  void setupWelcome() {
    Table welcomeTable = loadTable("assets/tables/text.csv", "header");
    Iterable<TableRow> welcomeTextNPC = welcomeTable.findRows(patron.getName(), "NPC");
    for (TableRow row : welcomeTextNPC) {
      welcome.put(row.getString("Attitude"), row.getString("Content"));
    }
  }
  
  void initPlace() {
    state = Constants.BUILDING_ENTERED;
  }
  
  void leave() {
    this.state = Constants.BUILDING_EMPTY;
    world.getPlayer().setTalking(false);
  }
}