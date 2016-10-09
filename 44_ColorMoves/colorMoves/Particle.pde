class Particle implements Location {
  PVector location, velocity;
  float size;
  int c;
  int id;
  
  Particle( float x, float y, int id) {
    this.location = new PVector(x, y);
    this.velocity = PVector.random2D();
    this.size = 25;
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
    velocity.mult(0.95);
    //size = map(velocity.mag(), 0, 40, 1, 6);
    //velocity.rotate( random(-PI/4,PI/4) );
    location.x = location.x < 0 ? width + location.x : location.x % width;
    location.y = location.y < 0 ? height + location.y : location.y % height;
  }
  
  void gravity( Particle other ) {
      float distance = dist( this.x(), this.y(), other.x(), other.y() );
      if( distance < maxDistance ) {
        float colorDist = colorDistance( this.c, other.c );
        if( colorDist < maxColorDistance ) {
          float magnitude = map( colorDist, 0, maxColorDistance, 3.0, 0 ) / ( distance + 0.1 );
          PVector force = new PVector( other.x() - this.x(), other.y() - this.y() );
          force.normalize();
          force.mult(magnitude);
          this.addForce(force);
        }
      }    
  }
  
  void addForce( PVector force ) {
    velocity.add(force); 
  }
  
  void draw() {
    ellipse( location.x, location.y, size, size);
  }
}