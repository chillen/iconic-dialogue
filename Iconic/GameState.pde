class GameState {
  Map map;
  byte phase;
  
  public GameState(Map map, byte phase) {
    this.map = map;
    this.phase = phase;
  }
  
  public GameState(Map map) {
    this(map, Constants.PHASE_TUTORIAL);
  }
  
  public Map getMap() { return this.map; }
  
  public byte getPhase() { return this.phase; }
  public byte setPhase(byte phase) { return this.phase = phase; }
}