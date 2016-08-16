class Knowledge {
 Information info;
 Attitude attitude;
 HashMap<Knowledge, Double> links;
 
 Knowledge(Information info, Attitude attitude) {
   this.info = info;
   this.attitude = attitude;
   links = new HashMap<Knowledge, Double>();
 }
 
 // roll for attitude
 Knowledge(Information info) {
   this.info = info;
   this.attitude = randomAttitude();
   links = new HashMap<Knowledge, Double>();
 }
 
 // The sides align
 private Attitude randomAttitude() {
   double f = random(0, 0.5);
   double i = 0.5 - f;
   double r = random(0, 0.5);
   double e = 0.5 - r;
   return new Attitude(f, i, r, e);
 }
 
 Attitude getAttitude() {
  return attitude; 
 }
 
 void setAttitude(Attitude a) { attitude = a; }
 
 Information getInfo() { return info; }
 
 void increaseLink(Knowledge k) {
   
 }
 
 // XXX Perform a rebalancing of the links knowledge
 void linkTo(Knowledge k, double weight) {
   links.put(k, weight);
 }
 
 HashMap<Knowledge, Double> getLinks() {
   return links; 
 }
 
 String stringLinks() {
   String s = ":";
   for (Knowledge k : links.keySet()) {
     s += k.getInfo().getName() + ":";
   }
   return s;
 }
 
 String toString() {
   return String.format("[ Knows about %s. Attitude of %s. Linked to %s ]", info.getName(), attitude, stringLinks());
 }
 
}