
float maxColorDistance, maxDistance;

float maxVelocity = 0;

int [] colors;

PointSet fixedPoints;
ArrayList<Particle> particles;

void setup() {
  size( 768, 768 );
  pixelDensity(2);
  
  colors = new int[10];
  
  for(int i = 0; i< colors.length; i++) {
    colors[i] = color( random(255), random(255), random(255), 4);
  }

  maxColorDistance = 60; //colorDistance( color(0,0,0), color(255,255,255) );
  maxDistance = 100;
  
  fixedPoints = new PointSet( width, height, (int)maxDistance * 2);
  particles = new ArrayList<Particle>();
  
  //Create fixed points
  for( int i = 0; i < 15; i++) {
    Particle p = new Particle( random(width), random(height), 1);
    p.c = colors[ floor( random(colors.length) ) ];
    p.size = 5;
    fixedPoints.add(p);
  }
  
  //Create particles
  for( int i = 0; i < 700; i++) {
    Particle p = new Particle( random(width), random(height), 1);
    p.c = color( random(255), random(255), random(255), 4);
    particles.add( p );
  }  
  
  noStroke();
  background(255);
}


void draw() {
  Particle particle, point;
  
  for( int i = 0; i < fixedPoints.points.size(); i++  ) {
    point = (Particle) fixedPoints.points.get(i);
    noStroke();
    fill( point.c );
    //point.draw();
  }
  
  
  for(int i = 0; i < particles.size(); i++ ) {
    particle = particles.get(i);
    ArrayList<Location> neighbors = fixedPoints.getNeighbors(particle.x(), particle.y());
    
    for( int j = 0; j < neighbors.size(); j++) {
      Particle neighbor = (Particle) neighbors.get(j);
      particle.gravity( neighbor );   
    }
    
    for( int j = 0; j < particles.size(); j++) {
      if( i != j ) {
        Particle other = (Particle) particles.get(j);
        particle.gravity( other );
      }
    }
    
    fill( particle.c );   
    particle.draw();
    particle.update();
  }
  
  saveFrame("colorsmove-#####.png");
  println(frameCount);
}

void mouseClicked() {
  setup();
}

void keyPressed() {
  if ( key == ' ' ) {
    //saveFrame("circles-####.png");
  }
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