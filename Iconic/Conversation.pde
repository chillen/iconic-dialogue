class Conversation {
  Person patron; // the NPC involved in the conversation
  Information topic;
  ArrayList<Information> currentInfo;
  Attitude bias;
  byte phase = Constants.TALK_CHOOSE;
  String tooltip;
  private Table reactions;
  String reaction = "";
  
  Conversation(Person patron) {
    this.patron = patron;
    reactions = loadTable("assets/tables/reactions.csv", "header");
    // Initialize a main topic
    int index = (int) (random(0, patron.getMemories().size()));
    setTopic( patron.getMemories().get(index).getInfo() );
    world.getPlayer().setTalking(true); // player initiates conversation
    currentInfo = new ArrayList<Information>();
    bias = new Attitude(.25,.25,.25,.25);
    tooltip = "Click info to talk about it. Click the main topic to change it.";
  }
  
  String getReaction() { return reaction; }
  
  Information getTopic() { return topic; }
  
  void clearInfo() { currentInfo.clear(); }
  
  byte getPhase() {
    return phase;
  }
  
  String getTooltip() {
    return tooltip;
  }
  
  void nextPhase() {
    if (phase == Constants.TALK_CHOOSE) {
      // Avoid empty conversation
      if (currentInfo.isEmpty())
        return;
      phase = Constants.TALK_BIAS;
      tooltip = "Click to add bias to your info.";
    }
    else if (phase == Constants.TALK_BIAS) {
      speakAtNPC();
      respond();
      phase = Constants.TALK_NPC;
      tooltip = patron.getName() + " sounds " + ambiguousAttitude() + " when mentioning this." ;
    }
    else if (phase == Constants.TALK_NPC) {
      bias = new Attitude(.25, .25, .25, .25);
      phase = Constants.TALK_CHOOSE;
      currentInfo.clear();
      tooltip = "Click info to talk about it. Click the main topic to change it.";
    }
  }
  
  // Guaranteed only one attitude, since it's the npc
  String ambiguousAttitude() {
    String s = "";
    Attitude a = patron.getKnowledge(topic).getAttitude();
    double little = 0.32;
    double very = 0.43;
    if (a.getFear() > very)
      s += "very afraid, ";
    else if (a.getFear() > little)
      s += "a bit fearful, ";
    if (a.getInterest() > very)
      s += "very intruiged, ";
    else if (a.getInterest() > little)
      s += "a little interested, ";
    if (a.getRage() > very)
      s += "very angry, ";
    else if (a.getRage() > little)
      s += "a bit annoyed, ";
    if (a.getEnjoyment() > very)
      s += "very pleased, ";
    else if (a.getEnjoyment() > little)
      s += "content, ";
    
    if (s.equals(""))
      s += "of little emotion, ";
 
    return s;
  }
  
  ArrayList<Information> getInfo() {
    return currentInfo;
  }
  
  void addInfo(Information i) {
    if (currentInfo.contains(i))
      return;
    if (currentInfo.size() < 3)
      currentInfo.add(i);
    else {
      currentInfo.remove(0);
      currentInfo.add(i);
    }
  }
  
  void setTopic(Information i) {
    if (!patron.knowsAbout(i)) {
      tooltip = patron.getName() + " does not know about that topic. They must know the main topic to discuss.";
      return;
    }
    topic = i; 
    if (!world.getPlayer().knowsAbout(i))
      world.getPlayer().addKnowledge(new Knowledge(i));
  }
  
  // Perform a proportionate selection on knowledge to respond; higher weights are more likely to show up
  // They will discuss things they know which are linked to the main topic
  void respond() {
    float sum = 0;
    HashMap<Knowledge, Double> links = patron.getKnowledge(topic).getLinks();
    if (links.size() == 0) {
       currentInfo.clear();
       currentInfo.add(patron.getKnowledge(topic).getInfo());
       System.out.println("------------------------------------");
       System.out.printf("%s's Response to You\n", patron.getName());
       System.out.println("------------------------------------");
       System.out.printf("%s's knowledge of %s\n", patron.getName(), topic.getName());
       System.out.println(patron.getKnowledge(topic));
       System.out.println("------------------------------------");

       return;
    }
    Knowledge response = null;
    for (Knowledge k : links.keySet()) {
      // Sum the weights of every link
      sum += links.get(k); 
    }
    int value = (int) random(0, sum);
    
    // Make a sorted TreeMap, based on the HashMap, with <VK, K>(descending) 
    // This gives us a nice sorted list of pairings to roulette from. 
    // The VK just needs to be the value first and a random, unique string. 
    TreeMap<String, Knowledge> sorted = new TreeMap<String, Knowledge>();
    for (Knowledge link: links.keySet()) {
      sorted.put(""+links.get(link) + link, link);
    }
    
    // KV pairs are now in a nice sorted order to be rouletted
    for (String s : sorted.descendingKeySet()) {
      value -= links.get( sorted.get(s) );
      if (value <= 0)
        response = sorted.get(s);
    }
    
    // Rounding error
    if (response == null) 
      if (sorted.size() > 0)
        response = sorted.get( sorted.lastKey() );
      else
      // Zero links
       response = patron.getKnowledge(topic);
      
    // First, set the displayed information to this new knowledge
    currentInfo.clear();
    currentInfo.add(response.getInfo());
    
   System.out.println("------------------------------------");
   System.out.printf("%s's Response to You\n", patron.getName());
   System.out.println("------------------------------------");
   System.out.printf("%s's knowledge of %s\n", patron.getName(), response.getInfo().getName());
   System.out.println(response);
   System.out.println("------------------------------------");
    
    // if the player hasn't heard of it, they have now
    if (!world.getPlayer().knowsAbout(response.getInfo().getName()))
          world.getPlayer().addKnowledge( new Knowledge(response.getInfo()) );
  }
  
  void speakAtNPC() {
    // Add the information with bias, or change their attitude
    for (Information i : currentInfo) {
      impart(new Knowledge(i, bias));
    }  
    
    // link all information to one another
    for (int i = 0; i < currentInfo.size(); i++) {
      for (int j = 0; j < currentInfo.size(); j++) {
        if (i == j)
          continue;
        patron.getKnowledge(currentInfo.get(i)).linkTo(patron.getKnowledge(currentInfo.get(j)));
      }
    }
    
    // link main topic to everything
    for (Information i : currentInfo) {
      patron.getKnowledge(i).linkTo(patron.getKnowledge(topic));
      patron.getKnowledge(topic).linkTo(patron.getKnowledge(i));
    }
  }
  
  // Only deals with the first thing mentioned
  
  void setReactionNewInfo() {
    Knowledge info = patron.getKnowledge(currentInfo.get(0));
    reaction = reactions.findRow(info.getInfo().getCategory(), "Category").getString("Neutral");
  }
  
  void setReactionOldInfo() {
    double[] fire = new double[4];
    Knowledge info = patron.getKnowledge(currentInfo.get(0));
    Attitude a = info.getAttitude();
    fire[0] = a.getFear();
    fire[1] = a.getInterest();
    fire[2] = a.getRage();
    fire[3] = a.getEnjoyment();
    
    int biggest = 0;
    int secondBiggest = 1;
    // find biggest and second biggest values
    for (int i = 0; i < 4; i++) {
      if (fire[i] > fire[secondBiggest]) {
        if (fire[i] > fire[biggest]) {
          secondBiggest = biggest;
          biggest = i;
        }
        else if (fire[i] > secondBiggest){
          secondBiggest = i;
        }
      }
    }
    
    String[] headers = {"Fear", "Interest", "Rage", "Enjoyment", "Neutral", "New"};
    // If the most passionate of these is greater than a threshold, it wins. Otherwise, neutral
    double threshold = 0.15;
    if (fire[biggest] > fire[secondBiggest] + threshold) {
      reaction = reactions.findRow(info.getInfo().getCategory(), "Category").getString(headers[biggest]);
    }
    else {
      reaction = reactions.findRow(info.getInfo().getCategory(), "Category").getString("Neutral");
    }
  }
    
  void impart(Knowledge k) {
    // Check if they have the knowledge. If they do not, simply impart it. If they do, adjust their knowledge
    if (patron.knowsAbout(k.getInfo())) {
      System.out.println("------------------------------------");
      System.out.printf("You spoke to %s\n", patron.getName());
      System.out.println("------------------------------------");      
      System.out.printf("This patron currently trusts you %.2f\n", patron.getTrust()); 
      patron.setTrust(adjustTrust(k));
      System.out.printf("You are discussing %s\n", k.getInfo().getName());
      System.out.printf("Their attitude towards %s is currently %s\n", k.getInfo().getName(), patron.getAttitude(k.getInfo()));
      System.out.printf("You described it with an attitude: %s\n", bias);
      System.out.printf("Your opinions differ  %.2f\n", totalDifferedOpinion(bias, patron.getAttitude(k.getInfo())));
      patron.setAttitude(k.getInfo(), adjustAttitude(k));
      System.out.printf("This patron now trusts you %.2f\n", patron.getTrust()); 
      System.out.printf("Their attitude towards %s is now %s\n", k.getInfo().getName(), patron.getAttitude(k.getInfo()));
      System.out.println("------------------------------------");
      setReactionOldInfo();
    }
    else {
      patron.addKnowledge(k);
      System.out.println("------------------------------------");
      System.out.printf("You spoke to %s\n", patron.getName());
      System.out.println("---------------------------------");
      System.out.printf("This patron currently trusts you %.2f\n", patron.getTrust()); 
      System.out.printf("Their attitude towards %s is currently %s\n", k.getInfo().getName(), patron.getAttitude(k.getInfo()));
      System.out.println("------------------------------------");
      setReactionNewInfo();
    }
  }
  
  Attitude adjustAttitude(Knowledge k) {
    double t = patron.getTrust();
    Attitude p = bias;
    Attitude n = patron.getAttitude(k.getInfo());
    Attitude adjust = new Attitude();
    double diff = 0;
    
    diff = p.getFear() - n.getFear();
    diff *= (t - 0.5);
    adjust.setFear(bound(n.getFear() + diff, 0.0,1.0));
    
    diff = p.getInterest() - n.getInterest();
    diff *= (t - 0.5);
    adjust.setInterest(bound(n.getInterest() + diff, 0.0, 1.0));
    
    diff = p.getRage() - n.getRage();
    diff *= (t - 0.5);
    adjust.setRage(bound(n.getRage() + diff, 0.0, 1.0));
    
    diff = p.getEnjoyment() - n.getEnjoyment();
    diff *= (t - 0.5);
    
    adjust.setEnjoyment(bound(n.getEnjoyment() + diff, 0.0, 1.0));
    
    return adjust;
  }
  
  private double bound(double val, double min, double max) {
    if (val <= min)
      return min;
    if (val >= max)
      return max;
    return val;
  }
  
  double totalDifferedOpinion(Attitude p, Attitude n) {
    return Math.abs(p.getFear() - n.getFear()) + 
                        Math.abs(p.getInterest() - n.getInterest()) + 
                        Math.abs(p.getRage() - n.getRage()) + 
                        Math.abs(p.getEnjoyment() - n.getEnjoyment());
  }
  
  double adjustTrust(Knowledge k) {
    double t = patron.getTrust();
    double ta = Math.pow((Math.abs(2 * t - 1) / 2), 2);
    Attitude p = bias;
    Attitude n = patron.getAttitude(k.getInfo());    
    double d = totalDifferedOpinion(p, n);
    double da = 1 - 2 * d;
    
    return bound(t - ta*da, 0.01, 0.99);
  }
  
  Attitude getBias() { return bias; }
  void setBias(Attitude b) { bias = b; }

}