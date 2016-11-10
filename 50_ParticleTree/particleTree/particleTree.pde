ArrayList<Particle> particles;

int alpha = 50;

void setup() {
  size( 1024, 1024 );
  pixelDensity(2);
  colorMode(HSB);
  
  
  background(0);
  
  particles = new ArrayList<Particle>();
  int c = color(random(255), random(200,255), random(0, 255), alpha );
  for(int i = 0; i < 5; i++) {
    
    Particle p = new Particle(width/2, height/2, c, 1);
    p.velocity = PVector.random2D();
    particles.add(p);
  }
}

void draw() {
  if( frameCount % 15 == 0) {
    filter(DILATE);
  }
  if( frameCount % 12 == 0 ) {
    loadPixels();

    for( int i = 0; i < pixels.length; i++) {
      int c = pixels[i];
      int r = floor( (float)((c >> 16) & 0xFF) * 0.99);
      int g = floor( (float)((c >> 8) & 0xFF) * 0.99);
      int b = floor( (float)(c & 0xFF) * 0.999);
      //if( i % 100 == 0 ) {
      //  println( r + " " + g + " " + b);
      //}
      pixels[i] = (255 << 24) | (r << 16) | (g << 8) | b;
    }
    updatePixels();
  }
  for(int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    
    PVector wander = p.wander();
    PVector separate = p.separate(particles);
    
    PVector force = new PVector();
    force.add(wander.mult(0.9));
    if(p.age > 20) {
      force.add(separate);
    }
    
    p.addForce( force );
    
    p.update();
    p.display();
    
    if( p.age > random(100, 120) ) {
      particles.remove(i);
      for(int j = 0; j < random(2); j++) {
        int c = color( (hue(p.col) + random(-20,20)) % 255, (saturation(p.col)), (brightness(p.col) + random(-10,10)), alpha );
        Particle child = new Particle(p.location.x, p.location.y, c, 1);
        child.velocity.set(p.velocity);
        //child.velocity.rotate(random(-PI/16,PI/16) );
        particles.add(child);
      }
    }

    
    if( particles.size() > 1900 ) {
      for(int k = 0; k < 150; k++) {
        particles.remove(floor(random(particles.size()) ) );
      }
    }
  }
  
  //if(frameCount <= 1440 ) {
  //  saveFrame("particleTree-####.png");
  //} else {
  //  exit();
  //}
}

void keyPressed() {
  if( key == ' ' ) {
    setup();
  } else if ( key == 'a' ) {
    saveFrame("circles-####.png");
  }
}