
ArrayList<Vehicle> vehicles;

PVector target;

void setup() {
  size(768, 768);
  pixelDensity(2);
  
  vehicles = new ArrayList<Vehicle>();

  int pink = color(255, 200, 200);
  
  for(int i = 0; i < 50; i++) {
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
  //background(255);
  fill(255);
  
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