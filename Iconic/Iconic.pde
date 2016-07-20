GameState world;

void setup() {
  Table map = loadTable("assets/map.csv");
  world = new GameState(new Map(map));
  size(800,600);
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
      print(map.get(r, c)); 
    }
    println("");
  }
}