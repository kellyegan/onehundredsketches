class Walker {
  PVector location;
  PVector velocity;
  float speed;
  int age;
  int radius;
  boolean attached;
  ArrayList<Walker> children;

  Walker( float x, float y) {
    location = new PVector();
    speed = 2;
    velocity = PVector.random2D().mult(speed);
    location.set( x, y );
    age = 0;
    radius = 1;
    
    attached = false;
    children = new ArrayList<Walker>();
  }
  
  Walker() {
    this( random(width), random(height) );
  }

  
  void draw() { 
    //println(map( age, 0, 10, 255, 0));
    float h = 0.6 - 0.5 * age / 5000.0;
    float s = constrain(1.0 - age / 15000.0, 0.0, 0.9);
    float b = constrain(0.2 + age / 10000.0, 0.0, 0.8);
    fill( h, s, b );
    ellipse( location.x, location.y, radius * 2, radius * 2);
  }
  
  void drawFamilyTree(int depth) {
    ellipse( location.x, location.y, radius * 2, radius * 2);
    for(Walker child: this.children ) {
      line( this.location.x, this.location.y, child.location.x, child.location.y );
    }
    
    
    for(Walker child: this.children ) {
      child.drawFamilyTree(depth+1);
    }
  }
  
  void move() {
    if( !attached ) {
      velocity.rotate( random(-PI/4,PI/4) );
      location.add( velocity );
      //Create toroid space by looping values around edges.
      location.x = location.x > 0 ? location.x % width : width + location.x;
      location.y = location.y > 0 ? location.y % width : width + location.y;
    } else {
      age++;
    }
  }
  
  boolean intersects( Walker other ) {
    float dx = other.location.x - this.location.x;
    float dy = other.location.y - this.location.y;
    float sqDist = dx * dx + dy * dy;
    float sqRadius = this.radius * this.radius + other.radius * other.radius + 2 * other.radius * this.radius;

    if( sqDist <= sqRadius ) {
      return true;
    }
    return false;
  }
  
  boolean checkAttached(Tree tree) {     
    for( Walker node : tree.getNeighborhood(this.location.x, this.location.y) ) {
        if( this.intersects( node ) ) {
          node.addChild(this);
          attached = true; 
          return true;
        }
    }
    return false;
  }
  
  void addChild( Walker child ) {
    this.children.add(child);
  }
}