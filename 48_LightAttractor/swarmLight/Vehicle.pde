/**
 *  Vehicle class
 *  Based on Daniel Shiffman's Nature of Code
 */

public class Vehicle {
  PVector location, velocity, acceleration;
  float size, maxSpeed, maxForce, sensorRange, wanderAngle;
  int col;
  
  Vehicle( float x, float y, float size, int col ) {
    this.location = new PVector( x, y );
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.size = size;
    this.maxSpeed = 1.0;
    this.maxForce = 0.01;
    this.sensorRange = 100;
    this.wanderAngle = 0;
    this.col = col;
    
  }
  
  PVector seek( PVector target ) {
    PVector desired = PVector.sub( target, this.location );
    desired.normalize();
    desired.mult(maxSpeed);
    return steer(desired);
  }
  
  PVector wander() {
    PVector desired = new PVector();
    
    pushMatrix();
    
    if( velocity.mag() > 0 ) {
      desired.set( velocity );
    } else {
      desired = PVector.random2D();
    }
    
    desired.setMag(30);
    
    translate( location.x, location.y );
    //fill(0, 0, 200, 30);
    //fill( this.col );
    //ellipse( desired.x, desired.y, 2, 2 );
    
    wanderAngle += random( -TAU / 16, TAU / 16 );
    PVector pointOfInterest = new PVector( 10 * sin(wanderAngle), 10 * cos(wanderAngle) );
    
    desired.add( pointOfInterest );
    
    //fill( this.col );
    //ellipse( desired.x, desired.y, 2, 2 );
    
    desired.add( PVector.random2D().mult(10) );
    desired.add( location );
    
    popMatrix();
    
    return seek( desired );
  }
  
  PVector separate( ArrayList<Vehicle> vehicles ) {
    PVector desired = new PVector();
    float personalSpace = size * 20;
    int count = 0;
    
    for( Vehicle other : vehicles ) { 
      float distance = PVector.dist( location, other.location );
      
      if( other != this && distance < personalSpace ) {
        PVector diff = PVector.sub( location, other.location );
        diff.normalize();
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
  
  PVector cohesion( ArrayList<Vehicle> vehicles ) {
    PVector desired = new PVector();
    int count = 0;
    
    for( Vehicle other : vehicles ) {
      float distance = PVector.dist(location, other.location);
      if( other != this && distance < sensorRange ) {
        PVector diff = PVector.sub(other.location, location);
        float otherAngle = diff.heading();
        float heading = velocity.heading();
        if( abs( otherAngle - heading ) < PI/3 ) {
          desired.add(other.location);
          count++;
        }
      }
    }
    if( count > 0 ) {
      desired.div(count);
      desired = seek(desired);
    }
    
    return desired;
  }
  
    
  PVector towardTheLight(int w, int h) {
    PVector direction = new PVector();
    float minBrightness = 255;
    float maxBrightness = 0;
    int outerRad = 128;
    int innerRad = 64;
    
    for(int yOffset = -outerRad; yOffset <= outerRad; yOffset++) {
      for(int xOffset = -outerRad; xOffset <= outerRad; xOffset++) {
        if( abs(xOffset) > innerRad && abs(yOffset) > innerRad ) {
          int x = xOffset > 0 ? (xOffset + (int)location.x) % w : w + xOffset;
          int y = yOffset > 0 ? (yOffset + (int)location.y) % h : h + yOffset;
  
          float b = brightness( pixels[x + y * w] );
          if( b > maxBrightness ) {
            maxBrightness = b;
            direction.set(-xOffset, -yOffset);
           
          }
        }
      }
    }
    if( maxBrightness > 0 ){
      direction.setMag(maxSpeed); 
      return steer(direction);
    } else {
      return new PVector();
    }
  }
  
  
  PVector align( ArrayList<Vehicle> vehicles ) {
    PVector desired = new PVector();
    int count = 0;
    
    for( Vehicle other : vehicles ) {
      float distance = PVector.dist(location, other.location);
      if( other != this && distance < sensorRange ) {
        PVector diff = PVector.sub(other.location, location);
        float otherAngle = diff.heading();
        float heading = velocity.heading();
        if( abs( otherAngle - heading ) < PI/3 ) {
          desired.add(other.velocity);
          count++;
        }
      }
    }
    
    if( count > 0 ) {
      desired.div(count);
      desired.setMag(maxSpeed);
      desired = steer(desired);
      
    }
    
    return desired;
  }

  void applyBehaviors( PVector target, ArrayList<Vehicle> vehicles ) {
    PVector cohesionForce = cohesion( vehicles );
    PVector separateForce = separate( vehicles );
    PVector alignForce = align( vehicles );
    PVector wanderForce = wander();
    PVector seekForce = seek( target );
    PVector lightForce = towardTheLight( width, height);
    
    cohesionForce.mult(0.0);
    separateForce.mult(0.0);
    alignForce.mult(0.0);
    wanderForce.mult(0.0);
    lightForce.mult(2.0);
    

    addForce( cohesionForce );
    addForce( separateForce );
    addForce( alignForce );
    addForce( wanderForce );
    addForce( lightForce );
  }
  
  PVector steer( PVector desired ) {
    PVector steerForce = PVector.sub(desired,this.velocity);
    steerForce.limit(maxForce);
    return steerForce;    
  }
  
  void update() {
    this.velocity.add(acceleration);
    this.velocity.limit(maxSpeed);
    this.location.add(velocity);
    //Wrap around edges Torus universe
    location.x = location.x < 0 ? width + location.x : location.x % width;
    location.y = location.y < 0 ? height + location.y : location.y % height;
    
    //Friction
   this.velocity.mult(0.99);
    //Reset forces
    this.acceleration.set(0, 0);
  }
  
  void addForce( PVector force ) {
    this.acceleration.add( force );
  }
  
  void draw() {
    fill(this.col);
    ellipse( location.x, location.y, size, size ); 
    
    float angle = velocity.heading() + PI/2;
    
    //pushMatrix();
    //translate(location.x,location.y);
    //rotate(angle);
    //beginShape();
    //vertex(0, -size*2);
    //vertex(-size, size*2);
    //vertex(size, size*2);
    //endShape(CLOSE);
    //popMatrix();
  }
  

  
}