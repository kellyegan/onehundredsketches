class Particle implements Location {
  PVector location, velocity;
  float size;
  int c;
  int id;
  
  Particle( float x, float y, int id) {
    this.location = new PVector(x, y);
    this.velocity = PVector.random2D();
    this.size = 2;
    this.c = 
    this.id = id;
  }
  
  float x() {
    return location.x;
  }
  
  float y() { 
    return location.y;
  }
  
  int getID() {
    return id;
  }
  
  void update() {
    location.add(velocity);
    velocity.mult(0.99);
    //size = map(velocity.mag(), 0, 40, 1, 6);
    //velocity.rotate( random(-PI/4,PI/4) );
    location.x = location.x < 0 ? width + location.x : location.x % width;
    location.y = location.y < 0 ? height + location.y : location.y % height;
  }
  
  void addForce( PVector force ) {
    velocity.add(force); 
  }
  
  void draw() {
    ellipse( location.x, location.y, size, size);
  }
}