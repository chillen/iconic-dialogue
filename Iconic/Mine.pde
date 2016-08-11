class Mine extends Place {
  Mine(String name, PImage icon) {
    super(name, icon); 
    setupFlags();
  }
  
  private void setupFlags() {
    world.setFlag(Constants.FLAG_MINE_HAS_TORCH, false);
  }
  
  void specificRender() {
    ArrayList<String> info = new ArrayList<String>();
    info.add("mines");
    
    if (!world.getPlayer().knowsAbout("mines"))
        world.getPlayer().addKnowledge(new Knowledge(new Information("mines", icons.get("mines"))));
      relevantInfo(info);
    }
}