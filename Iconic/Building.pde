class Building extends Place {
  Person patron;
  byte state;
  private HashMap<String, String> welcome;
  
  Building(Person person, String name, PImage icon) {
    super(name, icon);
    this.patron = person;
    this.state = Constants.BUILDING_EMPTY;
    welcome = new HashMap<String, String>();
    setupWelcome();
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
          text(welcomeMessage, 0,super.padding, innerWidth, 200);
        }
      popMatrix();
    popMatrix();
    super.relevantInfo(info);
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
  }
}