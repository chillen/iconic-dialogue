class Knowledge {
 Information info;
 Attitude attitude;
 HashMap<Knowledge, Double> links;
 private final double LINK_INCREASE = 0.05;
 
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
   if (links.containsKey(k))
     links.put( k, Math.min(links.get(k) + LINK_INCREASE, 0.99) );
 }
 
 void linkTo(Knowledge k) {
   double d = 0;
   if (k == this)
     return;
   if (linkedTo(k))
     increaseLink(k);
   else {
     links.put(k, d);
     increaseLink(k);
   }
 }
 
 double getLink(Knowledge k) {
   return links.get(k);
 }
 
 void linkTo(Knowledge k, double weight) {
   if (k != this)
     links.put(k, weight);
 }
 
 boolean linkedTo(Knowledge k) {
   for (Knowledge link : links.keySet()) {
     if (k == link)
       return true;
   }
   return false;
 }
 
 HashMap<Knowledge, Double> getLinks() {
   return links; 
 }
 
 String stringLinks() {
   String s = ":";
   for (Knowledge k : links.keySet()) {
     s += String.format("%s (%.2f):",k.getInfo().getName(), getLink(k));
   }
   return s;
 }
 
 String toString() {
   return String.format("[ Knows about %s. Attitude of %s. Linked to %s ]", info.getName(), attitude, stringLinks());
 }
 
}