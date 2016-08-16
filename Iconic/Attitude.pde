class Attitude {
  double fear;
  double interest;
  double rage;
  double enjoyment;
  
  Attitude() {
    this(0,0,0,0);
  }
  
  Attitude(double f, double i, double r, double e) {
    fear = f;
    interest = i;
    rage = r;
    enjoyment = e;
  }
  
  double getFear() { return fear; }
  double getInterest() { return interest; }
  double getRage() { return rage; }
  double getEnjoyment() { return enjoyment; }
  
  void setFear(double f) { fear = f; }
  void setInterest(double i) { interest = i; }
  void setRage(double r) { rage = r; }
  void setEnjoyment(double e) { enjoyment = e; }
  
  void adjustFear(double f) { fear += f; }
  void adjustInterest(double i) { interest += i; }
  void adjustRage(double r) { rage += r; }
  void adjustEnjoyment(double e) { enjoyment += e; }
  
  String toString() {
    return String.format("{F: %.2f, I: %.2f, R: %.2f, E: %.2f}", fear, interest, rage, enjoyment); 
  }
  
}