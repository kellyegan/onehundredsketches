float noiseScale = 0.005;

PVector [] rFlowField, gFlowField, bFlowField;

int cellsize = 12;
int rows, cols;

FlowField flow;
ArrayList<Particle> particles;

void setup() {
  size( 960, 540);
  pixelDensity(2);
  
  flow = new FlowField( width, height, cellsize, 0.02 );
  
  particles = new ArrayList<Particle>();
  Particle p;
  int c;
  for( int i = 0; i < 500; i++) {
     c = color( random(255), random(255), random(255), 20);
     p = new Particle( random(width), random(height), c, 10 );
     particles.add(p);
  }
  
  background(0);
}

void draw() {
  filter(DILATE);
  filter(BLUR);
  if( frameCount % 3 == 0 ) {
    loadPixels();

    for( int i = 0; i < pixels.length; i++) {
      int c = pixels[i];
      int r = floor( (float)((c >> 16) & 0xFF) * 0.98);
      int g = floor( (float)((c >> 8) & 0xFF) * 0.98);
      int b = floor( (float)(c & 0xFF) * 0.995);
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
  
  //if(frameCount <= 1440 ) {
  //  saveFrame("triangleFlow-####.png");
  //} else {
  //  exit();
  //}
}

void keyPressed() {
  if( key == ' ' ) {
    setup();
  } else if ( key == 'a' ) {
    saveFrame("flowfield-####.png");
  }
}