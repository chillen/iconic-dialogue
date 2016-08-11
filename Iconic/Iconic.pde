import java.awt.Point;

GameState world;
HashMap<Character, PImage> tiles;
HashMap<String, PImage> icons;
ArrayList<Person> people;
HashMap<Point, Place> places;
final int TILE_SIZE = 24; // tiles are 64x64
boolean rendered = false;
int continueX;
int continueY;
int continueHeight;
int continueWidth;
int defaultFill = 230;
Place activePlace = null;

boolean mindmapMode = false;

void setup() {
  Table map = loadTable("assets/tables/map.csv");
  fill(defaultFill);
  world = new GameState(new Map(map), Constants.PHASE_OVERWORLD);
  populateTiles();
  size(900,700);
  continueY = height-100;
  continueX = width/2;
  continueWidth = 100;
  continueHeight = 50;
  
  populateIcons();
  initNPCs();
  initPlaces();
  initPlayer();
}

// Update model data separate from the draw loop
void update() {

}

void draw() {
  update();
  background(0);
  switch (world.getPhase()) {
    case Constants.PHASE_TUTORIAL:
      drawTutorial(); break;
    case Constants.PHASE_BACKGROUND:
      drawBackstory(); break;
    case Constants.PHASE_OVERWORLD:
      drawOverworld(); break;
    case Constants.PHASE_PLACE:
      drawPlace(); break;
  }  
  
}

void initPlayer() {
  Information i;
  
  i = new Information("murder", loadImage("assets/icons/backstab.png"));
  world.getPlayer().addKnowledge(new Knowledge(i));
  
  i = new Information("trade", loadImage("assets/icons/trade.png"));
  world.getPlayer().addKnowledge(new Knowledge(i));
  
  i = new Information("stealing", loadImage("assets/icons/robber.png"));
  world.getPlayer().addKnowledge(new Knowledge(i));
}

void populateIcons() {
  Table infoTable = loadTable("assets/tables/information.csv", "header");
  icons = new HashMap<String, PImage>();
  for (TableRow info : infoTable.rows())
    icons.put(info.getString("title"), loadImage("assets/icons/"+info.getString("filename")));
}

void initNPCs() {
  people = new ArrayList<Person>();
  loadNPCs();
}

// Very manually populated here.
void initPlaces() {
  // Just create blank places on the map
  places = new HashMap<Point, Place>();
  populatePlaces();
}

// This is pretty manually handled, but might be able to be pushed into a spreadsheet at some point
void populatePlaces() {
 Table npcTable = loadTable("assets/tables/npc.csv", "header");
 
 for (int r = 0; r < world.getMap().getRowCount(); r++) {
    for (int c = 0; c < world.getMap().getColCount(); c++) {
       // manual coordinates
       Map m = world.getMap();
       
       if (m.get(r, c) == 'm') {
         Place p = new Mine("Mines", icons.get("mines"));
         
         places.put(new Point(r, c), p);
       }
       
       if (m.get(r,c) == 'a') {
        Place p = new Forest("Forest", icons.get("forest"));
        places.put(new Point(r, c), p);
       }
       
       // Buildings take a little more parsing
       if (m.get(r,c) == 'b') {
         String personName = npcTable.findRow(r+","+c, "building").getString("npc");
         for (Person p : people) {
           if (p.getName().equals(personName)) {
             places.put(new Point(r, c), new Building(p, npcTable.findRow(r+","+c, "building").getString("buildingName"), icons.get(personName.toLowerCase())));
           }
         }
       }
    }
  } 
}

void loadNPCs() {
  Table npcs = loadTable("assets/tables/npc.csv", "header");  
  Table infoTable = loadTable("assets/tables/information.csv", "header");

  Person p = null;
  
  for (TableRow r : npcs.rows()) {
    p = populateStats(r);
    
    // Look at each piece of info
    for (TableRow info : infoTable.rows()) {
      String title = info.getString("title");
      PImage icon = loadImage("assets/icons/" + info.getString("filename"));
      rollForKnowledge(p, new Information(title, icon), r.getString(title), info.getInt("DC"));
    }
    
    for (Knowledge k : p.getMemories()) {
      rollForLinkedInfo(p, k); 
    }
    people.add(p);
  }  
}

// Look through the linked info and roll int + wisdom to add connected information
void rollForLinkedInfo(Person p, Knowledge k) {
   Table linkedTable = loadTable("assets/tables/links.csv", "header");
   Table infoTable = loadTable("assets/tables/information.csv", "header");
   String title = k.getInfo().getName();
   
   for (TableRow link : linkedTable.rows()) {
     String a = link.getString("A");
     String b = link.getString("B");
     double weight = link.getDouble("Weight");
     int dc, roll;
     
     // Populate with new info
     if (a.equals(title) || b.equals(title)) {
       // avoid duplicate info
       if (!p.knowsAbout(a)) {
         dc = infoTable.findRow(a, "title").getInt("DC");
         roll = (int) random(1,21) + p.getInt();
         if (roll >= dc) {
           PImage icon = loadImage("assets/icons/" + infoTable.findRow(a, "title").getString("filename"));
           Information info = new Information(a, icon);
           p.addKnowledge(new Knowledge(info));
         }
       }
       if (!p.knowsAbout(b)) {
         dc = infoTable.findRow(b, "title").getInt("DC");
         roll = (int) random(1,21) + p.getInt();
         if (roll >= dc) {
           PImage icon = loadImage("assets/icons/" + infoTable.findRow(b, "title").getString("filename"));
           Information info = new Information(b, icon);
           p.addKnowledge(new Knowledge(info));
         }
       }
     }
   }
   
   // Now that all of the connection info has been added, check for actual connections
   for (TableRow link : linkedTable.rows()) {
     String a = link.getString("A");
     String b = link.getString("B");
     double weight = link.getDouble("Weight");
     int dc, roll;
     
     // If they know about both things, they roll wisdom to see if they are connected
     if (p.knowsAbout(a) && p.knowsAbout(b)) {
       roll = (int) random(1, 21) + p.getWis();
       dc = link.getInt("DC");
       if (roll >= dc) {
         p.linkKnowledge(a, b, weight); 
       }
     }
   }
}

void rollForKnowledge(Person p, Information info, String seed, int baseDC) {
  String[] splitSeed = seed.split(",");
  double f = random(0,1);
  double i = random(0,1);
  double r = random(0,1);
  double e = random(0,1);
  
  // Flag symbol; x or ?
  if (splitSeed.length == 1) {
    
    // Skip rolling
    if (splitSeed[0].equals("x"))
      return;
      
    // pure random
    if (splitSeed[0].equals("?")) {
      int roll = (int) random(1, 21); // [1,20)
      
      // check for d20 roll
      if (roll + p.getInt() >= baseDC) {
        p.addKnowledge( new Knowledge(info) );
        return;
      }
    }
  }
  
  for (String str : splitSeed) {
   // Overwrite default DC if they have a new DC
   if (str.contains("DC")) {
     // Strip all non-numbers
     str = str.replaceAll("\\D+","");
     baseDC = Integer.parseInt(str);
   }   
   if (str.contains("F")) {
     // Strip all non-numbers
     str = str.replaceAll("\\D+","");
     f = Double.parseDouble(str);
   }
   
   if (str.contains("I")) {
     // Strip all non-numbers
     str = str.replaceAll("\\D+","");
     i = Double.parseDouble(str);
   }
   
   if (str.contains("R")) {
     // Strip all non-numbers
     str = str.replaceAll("\\D+","");
     r = Double.parseDouble(str);
   }
   
   if (str.contains("E")) {
     // Strip all non-numbers
     str = str.replaceAll("\\D+","");
     e = Double.parseDouble(str);
   }
  }
  
  int roll = (int) random(1,21);
  if (roll + p.getInt() >= baseDC) 
    p.addKnowledge( new Knowledge(info, new Attitude(f,i,r,e)) );
}

Person populateStats(TableRow r) {
  Person p;
  String name = r.getString("npc");
  PImage icon = loadImage("assets/icons/" + r.getString("icon"));
  PImage avatar = loadImage("assets/avatars/" + r.getString("avatar"));
  String role = r.getString("role");
  int i = r.getInt("int");
  int w = r.getInt("wis");
  int c = r.getInt("cha");
    
  p = new Person(name, role, icon, avatar, i, w, c);
  return p;
}

boolean overContinue() {
  if (mouseX >= continueX-continueWidth/2 && mouseX <= continueX+continueWidth/2 && 
      mouseY >= continueY-continueHeight/2 && mouseY <= continueY+continueHeight/2) {
    return true;
  } else {
    return false;
  }
}

void drawTutorial() {
  int paddingY = 100;
  int paddingX = 50;
  int marginX = 50;
  int marginY = 100;
 
  String displayText = "This is the tutorial.";
  
  text(displayText, marginX, marginY, width-marginX*2, height-marginY*2);
  
  rectMode(CENTER);
  if (overContinue())
    fill(100);
  else
    fill(200);
  rect(continueX, continueY, continueWidth, continueHeight);
  fill(0);
  text("Continue", continueX-25, continueY+2);
  fill(defaultFill);
  rectMode(CORNER);
}

void drawBackstory() {
  int marginX = 50;
  int marginY = 100;
 
  String displayText = "BACKGROUND TEXT!";
  
  text(displayText, marginX, marginY, width-marginX*2, height-marginY*2);
  
  rectMode(CENTER);
  if (overContinue())
    fill(100);
  else
    fill(200);
  rect(continueX, continueY, continueWidth, continueHeight);
  fill(0);
  text("Continue", continueX-25, continueY+2);
  fill(defaultFill);
  rectMode(CORNER);
}

void drawOverworld() {
  drawMap(world.getMap());
  if (mindmapMode)
    drawMindmap();
  else
    drawInstructions();
  drawInventory();
}

void drawPlace() {
  drawMap(world.getMap());
  drawInventory();
  if (activePlace == null)
    return;
  activePlace.render();
}

void drawMindmap() {
  
}

void drawInstructions() {
  int topLeftX = 0;
  int topLeftY = TILE_SIZE * world.getMap().getRowCount();
  int bgWidth = TILE_SIZE * world.getMap().getColCount();
  int bgHeight = height - topLeftY;
  int padding = 10;
  
  String text = "Click on an icon to enter the location. Your known information is displayed on the right. "
               +"Click on a piece of known information to explore its connections. ";
  
  fill(180);
  rect(topLeftX, topLeftY, bgWidth, bgHeight);
  fill(0);
  text(text, topLeftX+padding, topLeftY+padding, bgWidth-2*padding, bgHeight-2*padding);
  fill(defaultFill);
}

void drawInventory() {
  int topLeftX = TILE_SIZE * world.getMap().getColCount();
  int topLeftY = 0;
  int bgWidth = width - topLeftX;
  int bgHeight = height;
  int padding = 10;
  
  pushMatrix();
    translate(topLeftX, topLeftY);
    fill(180,180,140);
    rect(0, 0, bgWidth, bgHeight);
    fill(0);
    textSize(24);
    text("Information", padding, padding, bgWidth-2*padding, bgHeight-2*padding);
    drawInfo();
    textSize(12);
    fill(defaultFill);
  popMatrix();
}

void drawInfo() {
  for (int i = 0; i < world.getPlayer().getMemories().size(); i++) {
    Knowledge k = world.getPlayer().getMemories().get(i);
    image(k.getInfo().getIcon(), (i%5)*48+16, 48+(i/5)*48);
  }
}

void nextPhase() {
  if (world.getPhase() == Constants.PHASE_TUTORIAL)
    world.setPhase(Constants.PHASE_BACKGROUND);
  else if (world.getPhase() == Constants.PHASE_BACKGROUND)
    world.setPhase(Constants.PHASE_OVERWORLD);
}

// Handle non-controlP5 buttons
void mouseClicked() {
  if (world.getPhase() == Constants.PHASE_TUTORIAL || world.getPhase() == Constants.PHASE_BACKGROUND) {
    if (overContinue())
      nextPhase();
  }
  else {
    // translate into grid
    int gridCol = mouseX / TILE_SIZE;
    int gridRow = mouseY / TILE_SIZE;
    
    // if out of the grid, flag with -1
    if (gridCol > world.getMap().getColCount())
      gridCol = -1;
    if (gridRow > world.getMap().getRowCount())
      gridRow = -1;
      
    handleEntityClick(world, gridRow, gridCol);
  }
}

void handleEntityClick(GameState world, int row, int col) {
  if (places.containsKey(new Point(row, col))) {
    Place p = places.get(new Point(row, col));
    p.enterPlace();
    activePlace = p;
    world.setPhase(Constants.PHASE_PLACE);
  }
}

private void drawMap(Map map) {
  for (int r = 0; r < map.getRowCount(); r++) {
    for (int c = 0; c < map.getColCount(); c++) {
      image(tiles.get(map.get(r, c)), c*TILE_SIZE, r*TILE_SIZE, TILE_SIZE, TILE_SIZE); 
    }
  }
}

// Populate the tile images
private void populateTiles() {
  tiles = new HashMap<Character, PImage>();
  Table legend = loadTable("assets/tables/legend.csv", "header");
  for (TableRow row : legend.rows()) { 
    tiles.put(row.getString("Symbol").charAt(0), loadImage("assets/tiles/" + row.getString("File")));
  }
}