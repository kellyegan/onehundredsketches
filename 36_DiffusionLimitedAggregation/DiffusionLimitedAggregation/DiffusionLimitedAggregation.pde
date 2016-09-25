Walker w;
ArrayList<Walker> walkers;
ArrayList<Walker> tree;
Tree t;

int totalWalkers = 2000;

void setup() {
  size(728, 728);
  pixelDensity(2);
  frameRate(30);
  colorMode(HSB, 1.0);
  t = new Tree( width/2, height/2, width, height );

  walkers = new ArrayList<Walker>();

  PVector p;
  for(int i = 0; i< 10; i++) {
      p = t.getNewPointInRing(40, 60);
      walkers.add( new Walker(p.x, p.y) );
  }
  
  noStroke();
}

void draw() {
  if( frameCount % 1000 == 0) {
    println(frameCount + ": " + t.radius); 
  }
  
  background(0, 0, 1.0);
  
  for( Walker node : t.getNodes() ) {
    node.draw();
    node.age++;
  }
  
  if( walkers.size() < totalWalkers ) {
     int rate = totalWalkers * (int)(t.radius / (width/2)) + 10;
     for(int i = 0; i < rate; i++) {

       PVector p = t.getNewPointInRing(3, 8);
       walkers.add( new Walker(p.x, p.y) );
     }
  }
  
  for( int i = 0; i < walkers.size(); i++ ) {
    w = walkers.get(i);
    if(w.checkAttached( t )) {
      t.add( w );
      walkers.remove(i);
    } else if(w.age > 500) {
      walkers.remove(i);
    }
    w.draw();
    w.move();
    w.age++;
  }
  
}

void mouseClicked() {
  setup();
}

void keyPressed() {
  if ( key == ' ' ) {
    saveFrame("dots.png");
  }
}