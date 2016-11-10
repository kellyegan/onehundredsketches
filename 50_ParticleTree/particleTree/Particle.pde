public class Particle {
  
  PVector location, velocity, acceleration;
  float radius, maxForce, maxSpeed, wanderAngle;
  int col;
  int age;
  
  Particle( float x, float y, int c, float r ) {
    location = new PVector(x, y);
    velocity = new PVector(0,0);
    acceleration = new PVector();
    col = c;
    radius = r;
    maxForce = 0.05;
    maxSpeed = 0.8;
    wanderAngle = random(-PI, PI);

  }
  
  PVector seek( PVector target ) {
    PVector desired = PVector.sub( target, this.location );
    desired.setMag(maxSpeed);
    return steer(desired);
  }
  
  PVector steer( PVector desired ) {
    PVector steerForce = PVector.sub(desired,this.velocity);
    steerForce.limit(maxForce);
    return steerForce;    
  }
  
  PVector separate( ArrayList<Particle> particles ) {
    PVector desired = new PVector();
    float personalSpace = radius * 10;
    int count = 0;
    
    for( Particle other : particles ) { 
      float distance = PVector.dist( location, other.location );
      
      if( other != this && distance < personalSpace ) {
        PVector diff = PVector.sub( location, other.location );
        diff.normalize();
        //float colorWeight = map( colorDistance( this.col, other.col ), 0, 100, 1.0, 2.0);
        //colorWeight = constrain(colorWeight, 0, 2.0);
        //diff.mult(colorWeight);
        desired.add(diff);
        count++;
      }
    }
    
    if( count > 0 ) {
      desired.div(count);
      desired.setMag(maxSpeed);
      desired = steer( desired );
    }
    
    return( desired );
  }
  
  PVector wander() {
    PVector desired = new PVector();

    desired.set( this.velocity );
    desired.setMag(10);

    wanderAngle += random( -PI / 16, PI / 16 );
    PVector pointOfInterest = new PVector( 10 * sin(wanderAngle), 10 * cos(wanderAngle) );
    
    desired.add( pointOfInterest );
    desired.add( location );    
    
    return seek( desired );
  }
  
  void addForce( PVector force ) {
    acceleration.add( force );
  }
  
  void update() {
    age++;
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