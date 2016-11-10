public class Particle {
  
  PVector location, velocity, acceleration;
  float radius, maxForce, maxSpeed;
  int col;
  
  Particle( float x, float y, int c, float r ) {
    location = new PVector(x, y);
    velocity = new PVector(0,0);
    acceleration = new PVector();
    col = c;
    radius = r;
    maxForce = 0.05;
    maxSpeed = 1.5;

  }
  
  void seek( PVector target ) {
    PVector desired = PVector.sub( target, this.location );
    desired.setMag(maxSpeed);
    steer(desired);
  }
  
  void flow( FlowField flow ) {
    float r = (float)((col >> 16) & 0xFF) / 255.0;
    float g = (float)((col >> 8) & 0xFF) / 255.0;
    float b = (float)((col) & 0xFF) / 255.0;
    
    PVector rFlow = flow.lookup(location, 0.0, frameCount / 360.0);
    PVector gFlow = flow.lookup(location, 2.0, frameCount / 360.0);
    PVector bFlow = flow.lookup(location, 3.0, frameCount/ 90.0);
    
    rFlow.mult( r );
    gFlow.mult( g );
    bFlow.mult( b );
    
    PVector desired = new PVector();
    desired.add(rFlow);
    desired.add(gFlow);
    desired.add(bFlow);
    
    desired.setMag(maxSpeed);
    steer(desired);    
  }
  
  void steer( PVector desired ) {
    PVector steerForce = PVector.sub(desired,this.velocity);
    steerForce.limit(maxForce);
    addForce(steerForce);    
  }
  
  void addForce( PVector force ) {
    acceleration.add( force );
  }
  
  void update() {

    velocity.add(acceleration);
    location.add(velocity);
    //velocity.mult(0.99);
    acceleration.set(0,0);
    location.x = location.x < 0 ? width + location.x : location.x % width;
    location.y = location.y < 0 ? height + location.y : location.y % height;
  }
  
  void display() {
    noStroke();
    fill(col);
    //ellipse( location.x, location.y, radius * 2, radius * 2);
    
    float angle = velocity.heading() + PI/2;
    
    pushMatrix();
    translate(location.x,location.y);
    rotate(angle);
    beginShape();
    vertex(0, -radius*2);
    vertex(-radius, radius*2);
    vertex(radius, radius*2);
    endShape(CLOSE);
    popMatrix();
  }
}