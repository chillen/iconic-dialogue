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
  
  void setFear(double f) { fear = f; }
  void setInterest(double i) { interest = i; }
  void setRage(double r) { rage = r; }
  void setEnjoyment(double e) { enjoyment = e; }
  
  void adjustFear(double f) { fear += f; }
  void adjustInterest(double i) { interest += i; }
  void adjustRage(double r) { rage += r; }
  void adjustEnjoyment(double e) { enjoyment += e; }
  
}