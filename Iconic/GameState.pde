class GameState {
  Map map;
  byte phase;
  HashMap<Byte, Boolean> flags;
  Player player;
  
  public GameState(Map map, byte phase) {
    this.map = map;
    this.phase = phase;
    player = new Player();
    initFlags();
  }
  
  public GameState(Map map) {
    this(map, Constants.PHASE_TUTORIAL);
  }
  
  private void initFlags() {
    flags = new HashMap<Byte, Boolean>();
  }
  
  public boolean flagged(byte f) { return flags.get(f); }
  public void setFlag(byte f, boolean b) { flags.put(f, b); }
  public boolean flag(byte f) { return flags.put(f, true); }
  
  public void setMap(Map m) { map = m; }
  public Map getMap() { return this.map; }
  
  public byte getPhase() { return this.phase; }
  public byte setPhase(byte phase) { return this.phase = phase; }
  public Player getPlayer() { return this.player; }
}