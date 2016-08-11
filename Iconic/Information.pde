class Information {
  String name;
  String category;
  PImage icon;
  
  Information(String name, String category, PImage icon) {
    this.name = name;
    this.icon = icon;
    this.category = category;
  }
  
  Information(String name, PImage icon) {
    this(name, "Unspecified", icon);
  }
  
  PImage getIcon() {
    return icon;
  }
  
  String getName() {
    return name;
  }
}