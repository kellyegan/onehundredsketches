
ArrayList<Vehicle> vehicles;

PVector target;

void setup() {
  size(768, 768);
  pixelDensity(2);
  
  vehicles = new ArrayList<Vehicle>();

  int pink = color(255, 200, 200);
  
  int [] colors = new int[7];
  
  for(int j = 0; j < colors.length; j++) {
    colors[j] = color(random(255), random(255), random(255), 40);
  }
  
  for(int i = 0; i < 50; i++) {
    int c = colors[floor(random(colors.length))];
    float angle = random(-PI,PI);
    float len = random(270);
    Vehicle v = new Vehicle( width/2 + cos(angle) * len, height/2 + sin(angle) * len, 5, c);
    v.velocity = PVector.random2D();
    vehicles.add( v );
  }
  
  target = new PVector(random(width),random(height));
  noStroke();
  background(255);
}

void draw() {
  if( frameCount % 40 == 0 ) {
    loadPixels();

    for( int i = 0; i < pixels.length; i++) {
      int c = pixels[i];
      //int r = floor( (float)((c >> 16) & 0xFF) * 0.9995);
      //int g = floor( (float)((c >> 8) & 0xFF) * 0.9995);
      //int b = floor( (float)(c & 0xFF) * 0.9995);
      
      int r = (c >> 16) & 0xFF;
      int g = (c >> 8) & 0xFF;
      int b = c & 0xFF;
      
      r = ceil((255 - r) * 0.001 + r);
      g = ceil((255 - g) * 0.001 + g);
      b = ceil((255 - b) * 0.001 + b);
      
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