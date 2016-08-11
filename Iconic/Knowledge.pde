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
   this(info, new Attitude(random(0,1), random(0,1), random(0,1), random(0,1)));
 }
 
 Information getInfo() { return info; }
 
 void linkTo(Knowledge k, double weight) {
   links.put(k, weight);
 }
}