class Map {
 ArrayList<ArrayList<Character>> map;
 
 public Map(Table map) {
   this.map = processMap(map);
 }
 
 public Map(ArrayList<ArrayList<Character>> map) {
   this.map = map;
 }
 
 public char get(int row, int col) {
   return map.get(row).get(col);
 }
 
 public int getRowCount() { return map.size(); }
 public int getColCount() { return map.get(0).size(); }
 
 private ArrayList<ArrayList<Character>> processMap(Table t) {
  ArrayList<ArrayList<Character>> map = new ArrayList<ArrayList<Character>>();
  
  for (TableRow row : t.rows()) {
    ArrayList<Character> workingRow = new ArrayList<Character>();
    for (int col = 0; col < t.getColumnCount(); col++) {
      workingRow.add(row.getString(col).charAt(0)); 
    }
    map.add(workingRow);
  }
  
  return map;
 }
}