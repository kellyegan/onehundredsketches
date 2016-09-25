PointSet staticPoints;
ArrayList<Particle> particles;

int [] colors;

float maxDistance = 75.0;

void setup() {
  size( 1500, 1500 );
  pixelDensity(2);
  colorMode(HSB);
  
  colors = new int[7];
  
  for(int i = 0; i< colors.length; i++) {
    colors[i] = color( random(255), random(50,255), random(100,255));
  }
  
  staticPoints = new PointSet(width, height, (int)maxDistance*2);
  particles = new ArrayList<Particle>();
  
  for(int i = 0; i < 70; i++) {
    Particle p = new Particle( random(width), random(height), 1);
    p.c = colors[ floor( random(colors.length) ) ];
    staticPoints.add(p);
  }
  
  for(int i = 0; i < 500; i++) {
    Particle p = new Particle( random(width), random(height), 1);
    p.c = color( random(255), random(0,200), random(0,200));
    particles.add( p );
  }
  background(0);
}

void draw() {
  //background(200);
  Particle point;
  Particle particle;
  

  
  for(int i = 0; i < particles.size(); i++ ) {
    particle = particles.get(i);
    ArrayList<Location> neighbors = staticPoints.getNeighbors(particle.x(),particle.y());

    int closestColor = color(0,0,0);
    float closestDistance = width;
    for(int j = 0; j < neighbors.size(); j++) {
      Particle neighbor = (Particle) neighbors.get(j);
      float distance = dist( particle.x(), particle.y(), neighbor.x(), neighbor.y() );
      
      if( distance < closestDistance ) {
        closestDistance = distance;
        closestColor = colorMix(particle.c, neighbor.c, distance / maxDistance);
        
      }
    }
    
    fill( closestColor );
    particle.draw();
    
    particle.update();
  }
  
  for( int i = 0; i < staticPoints.points.size(); i++  ) {
    point = (Particle) staticPoints.points.get(i);
    noStroke();
    //fill( point.c );
    //point.draw();
  }
  
}

void mouseClicked() {
  setup();
}

void keyPressed() {
  if ( key == ' ' ) {
    saveFrame("voronoisy-####.png");
  }
}

int colorMix( int colorA, int colorB, float mix ) {
  PVector a = new PVector( hue(colorA), saturation(colorA), brightness(colorA) );
  PVector b = new PVector( hue(colorB), saturation(colorB), brightness(colorB) );
  PVector diff = PVector.sub( b, a );
  float magnitude = diff.mag();
  diff.normalize();
  diff.mult( magnitude * mix );
  diff.add(a);
  return color( diff.x, diff.y, diff.z );
}