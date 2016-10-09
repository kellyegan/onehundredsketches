float noiseScale = 0.005;

PVector [] rFlowField, gFlowField, bFlowField;

int cellsize = 12;
int rows, cols;

FlowField flow;
ArrayList<Particle> particles;

void setup() {
  size( 768, 768);
  pixelDensity(2);
  
  flow = new FlowField( width, height, cellsize, 0.02 );
  
  particles = new ArrayList<Particle>();
  Particle p;
  int c;
  for( int i = 0; i < 1000; i++) {
     c = color( random(255), random(255), random(255), 40);
     p = new Particle( random(width), random(height), c, 1 );
     particles.add(p);
  }
  
  background(0);
}

void draw() {
  if( frameCount % 30 == 0 ) {
    loadPixels();

    for( int i = 0; i < pixels.length; i++) {
      int c = pixels[i];
      int r = floor( (float)((c >> 16) & 0xFF) * 0.95);
      int g = floor( (float)((c >> 8) & 0xFF) * 0.95);
      int b = floor( (float)(c & 0xFF) * 0.99);
      //if( i % 100 == 0 ) {
      //  println( r + " " + g + " " + b);
      //}
      pixels[i] = (255 << 24) | (r << 16) | (g << 8) | b;
    }
    updatePixels();
  }
  
  for( Particle p : particles ) {
    
    p.flow(flow);
    
    p.update();
    p.display();
  }
}

void keyPressed() {
  if( key == ' ' ) {
    setup();
  } else if ( key == 'a' ) {
    saveFrame("circles-####.png");
  }
}