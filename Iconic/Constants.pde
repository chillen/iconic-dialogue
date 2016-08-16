class Constants {
  public static final byte PHASE_TUTORIAL = 0;  
  public static final byte PHASE_BACKGROUND = 1;  
  public static final byte PHASE_OVERWORLD = 2;  
  public static final byte PHASE_PLACE = 3; 
  
  public static final byte FLAG_FOREST_ANIMALS = 4; 
  public static final byte FLAG_MINE_HAS_TORCH = 5; 
  
  public static final byte BUILDING_EMPTY = 6;
  public static final byte BUILDING_ENTERED = 7;
  public static final byte BUILDING_ACTION = 8;
  public static final byte BUILDING_CONVERSATION = 9;
  
  public static final byte ACTION_STEAL = 10;
  public static final byte ACTION_ATTACK = 11;
  public static final byte ACTION_TAKE = 12;
  public static final byte ACTION_GIVE = 13;
  public static final byte ACTION_TALK = 14;
  public static final byte ACTION_RETURN = 15;
  
  // XXX These likely shouldn't be used; the legend data should handle this ideally
  // Possibly have these set when loaded in the map? Map.Constants.TILE_...
  public static final char TILE_BUILDING = 'b';
  public static final char TILE_TREE = 't';
  public static final char TILE_ROAD = 'r';
  public static final char TILE_GRASS = 'g';
  public static final char TILE_DIRT = 'd';
  public static final char TILE_INVALID = 'X';
  
  public static final byte TALK_CHOOSE = 16;
  public static final byte TALK_BIAS = 17;
  public static final byte TALK_NPC = 18;
}