import controlP5.*;

GameState world;

HashMap<Character, PImage> tiles;
final int TILE_SIZE = 24; // tiles are 64x64
ControlP5 cp5;

void setup() {
  Table map = loadTable("assets/map.csv");
  populateTiles();
  world = new GameState(new Map(map));
  size(900,700);
}

// Update model data separate from the draw loop
void update() {
  
}

void draw() {
  update();
  drawMap(world.getMap());
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
  tiles.put('b', loadImage("assets/img/building.png"));
  // Grass
  tiles.put('g', loadImage("assets/img/terrainTile3.png"));
  // Dirt
  tiles.put('d', loadImage("assets/img/terrainTile4.png"));
  // Trees
  tiles.put('t', loadImage("assets/img/tree.png"));
  // Road
  tiles.put('r', loadImage("assets/img/terrainTile1.png"));
}