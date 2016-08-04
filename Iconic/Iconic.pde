GameState world;

HashMap<Character, PImage> tiles;
final int TILE_SIZE = 24; // tiles are 64x64
boolean rendered = false;
int continueX;
int continueY;
int continueHeight;
int continueWidth;
int defaultFill = 230;

void setup() {
  Table map = loadTable("assets/map.csv");
  fill(defaultFill);
  populateTiles();
  world = new GameState(new Map(map), Constants.PHASE_TUTORIAL);
  size(900,700);
  continueY = height-100;
  continueX = width/2;
  continueWidth = 100;
  continueHeight = 50;
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
  int paddingY = 100;
  int paddingX = 50;
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
}

void drawPlace() {
  
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
  char entityAtClick = world.getMap().get(row, col);
  
  switch(entityAtClick) {
   case 'b': handleHouseClick(world, row, col); break; 
  }
  
}

void handleHouseClick(GameState world, int row, int col) {
  char entityAtClick = world.getMap().get(row, col);
}

// Helper methods

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
  // Building
  tiles.put(Constants.TILE_BUILDING, loadImage("assets/img/building.png"));
  // Grass
  tiles.put(Constants.TILE_GRASS, loadImage("assets/img/terrainTile3.png"));
  // Dirt
  tiles.put(Constants.TILE_DIRT, loadImage("assets/img/terrainTile4.png"));
  // Trees
  tiles.put(Constants.TILE_TREE, loadImage("assets/img/tree.png"));
  // Road
  tiles.put(Constants.TILE_ROAD, loadImage("assets/img/terrainTile1.png"));
}