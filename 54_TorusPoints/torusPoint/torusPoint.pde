int c;
int count;

float minorRotation, majorRotation;
float hueCycle, satCycle;

void setup() {
  size( 768, 768, P3D );
  pixelDensity(2);
  colorMode(HSB);
  
  minorRotation = 361;
  majorRotation = minorRotation * 361;
  hueCycle = 36;
  satCycle = hueCycle / 2; 
  
  noStroke();
  fill(0, 100);
  count = 0;
  background(0);
}

void draw() {
  //translate(0, 0, -400);
  //rotateX(0.15 * PI);
  
  //background(0);
  if( count < majorRotation -1 ) {
    for(int i = 0; i < minorRotation; i++) {
      
      float a1 = TAU * count / majorRotation;
      float a2 = TAU * count / minorRotation; 
      PVector p = torus( a1, a2, 225, 150 );
      
      float h = map( count % hueCycle, 0, hueCycle, 0, 192);
      float s = map( count % satCycle, 0, satCycle, 64, 255);//map( count % 12, 0, 11, 0, 255);
      float b = 255;//sin( a2 ) * 128.0 + 255;
      fill( h, s, b, 128);
      
      pushMatrix();
      translate(width/2, height/2, 0);
      rotateX(PI/2);
      translate(p.x, p.y, p.z);
      sphere( 2 );
      popMatrix();
      
      count++;
    }
  }
}

/**
 *  Returns a point on a torus given a rotation on major and minor radius.
 *
 *  @param theta     Major axis angle in radians
 *  @param gamma     Minor axis angle in radius
 *  @param majorRad  Radius of major axis
 *  @param minorRad  Radius of minor axis
 */
PVector torus( float theta, float gamma, float majorRad, float minorRad ) {
  PVector p = new PVector(majorRad, 0, 0);
  p.add( new PVector(minorRad * cos(gamma), minorRad * sin(gamma), 0) );
  
  float z = p.z*cos(theta) - p.x*sin(theta);
  float x = p.z*sin(theta) + p.x*cos(theta);
  float y = p.y;
  
  return new PVector(x, y, z);
}

void keyPressed() {
  if( key == ' ' ) {
    setup();
  } else if ( key == 'a' ) {
    saveFrame("torusPoint-####.png");
  }
}