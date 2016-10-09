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
    this.maxSpeed = 1.5;
    this.maxForce = 0.01;
    this.sensorRange = 60;
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
    PVector pointOfInterest = new PVector( 10 * sin(wanderAngle), 15 * cos(wanderAngle) );
    
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
    float personalSpace = size * 10;
    int count = 0;
    
    for( Vehicle other : vehicles ) { 
      float distance = PVector.dist( location, other.location );
      
      if( other != this && distance < personalSpace ) {
        PVector diff = PVector.sub( location, other.location );
        diff.normalize();
        float colorWeight = map( colorDistance( this.col, other.col ), 0, 100, 1.0, 2.0);
        colorWeight = constrain(colorWeight, 0, 2.0);
        diff.mult(colorWeight);
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
    float count = 0;
    
    for( Vehicle other : vehicles ) {
      float distance = PVector.dist(location, other.location);
      if( other != this && distance < sensorRange ) {
        PVector diff = PVector.sub(other.location, location);
        float otherAngle = diff.heading();
        float heading = velocity.heading();
        if( abs( otherAngle - heading ) < PI/2 ) {    
          float colorWeight = map( colorDistance( this.col, other.col ), 0, 100, 1.0, 0);
          colorWeight = constrain(colorWeight, 0, 1.0);
          PVector weightedLocation = PVector.mult(other.location, colorWeight);
          desired.add( weightedLocation );
          count += colorWeight;
        }
      }
    }
    if( count > 0 ) {
      desired.div(count);
      desired = seek(desired);
      
    }
    
    return desired;
  }
  
  PVector align( ArrayList<Vehicle> vehicles ) {
    PVector desired = new PVector();
    float count = 0;
    
    for( Vehicle other : vehicles ) {
      float distance = PVector.dist(location, other.location);
      if( other != this && distance < sensorRange ) {
        PVector diff = PVector.sub(other.location, location);
        float otherAngle = diff.heading();
        float heading = velocity.heading();
        if( abs( otherAngle - heading ) < PI/2 ) {
          float colorWeight = map( colorDistance( this.col, other.col ), 0, 100, 1.0, -0.4);
          colorWeight = constrain(colorWeight, 0, 1.0);
          PVector weightedVelocity = PVector.mult(other.velocity, colorWeight);
          desired.add( weightedVelocity );
          count += colorWeight;
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
    
    cohesionForce.mult(1.0);
    separateForce.mult(1.0);
    alignForce.mult(1.0);
    wanderForce.mult(1.0);
    seekForce.mult(0.0);

    addForce( cohesionForce );
    addForce( separateForce );
    addForce( alignForce );
    addForce( wanderForce );
    addForce( seekForce );
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
  }
  
  PVector colorVector( int c ) {
    return new PVector( (c >> 16) & 0xFF, (c >> 8) & 0xFF, c & 0xFF );
  }
  
  float colorDistance( int a, int b ) {
    return dist( (a >> 16) & 0xFF, (a >> 8) & 0xFF, a & 0xFF, (b >> 16) & 0xFF, (b >> 8) & 0xFF, b & 0xFF );
  }
  
  int colorMix( int colorA, int colorB, float mix ) {
    PVector a = colorVector( colorA );
    PVector b = colorVector( colorB );
    PVector diff = PVector.sub( b, a );
    float magnitude = diff.mag();
    
    diff.normalize();
    diff.mult( magnitude * mix );
    diff.add(a);
    
    return color( diff.x, diff.y, diff.z );  
  }
  
}