
ArrayList<Vehicle> vehicles;

PVector target;

void setup() {
  size(768, 768);
  pixelDensity(2);
  
  vehicles = new ArrayList<Vehicle>();

  int pink = color(255, 200, 200);
  
  for(int i = 0; i < 1000; i++) {
    int c = color(random(255), random(255), random(255), 40);
    Vehicle v = new Vehicle( random(width), random(height), 2, c);
    v.addForce( PVector.random2D().mult(2) );
    vehicles.add( v );
  }
  
  target = new PVector(random(width),random(height));
  noStroke();
  background(0);
}

void draw() {
  if( frameCount % 30 == 0 ) {
    loadPixels();

    for( int i = 0; i < pixels.length; i++) {
      int c = pixels[i];
      int r = floor( (float)((c >> 16) & 0xFF) * 0.999);
      int g = floor( (float)((c >> 8) & 0xFF) * 0.999);
      int b = floor( (float)(c & 0xFF) * 0.96);
      //if( i % 100 == 0 ) {
      //  println( r + " " + g + " " + b);
      //}
      pixels[i] = (255 << 24) | (r << 16) | (g << 8) | b;
    }
    updatePixels();
  }
  
  if( frameCount % 2000 == 1 ) {
    saveFrame("colorFlock-####.png");
  }
  
  for( Vehicle vehicle: vehicles ) {
    vehicle.draw();
    
    vehicle.applyBehaviors( new PVector( mouseX, mouseY), vehicles);
    vehicle.update();
  }
    
  //fill(200,0,0);
  //ellipse(target.x, target.y, 5, 5);
}
void keyPressed() {
  if( key == ' ' ) {
    setup();
  } else if ( key == 'a' ) {
    saveFrame("circles-####.png");
  }
}