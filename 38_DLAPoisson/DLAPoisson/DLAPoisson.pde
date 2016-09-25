PointDistribution distribution;
ArrayList<Walker> walkers;
Walker w;
Tree tree;

void setup() {
  size( 1024, 1024 );
  pixelDensity(2);
  colorMode(HSB, 1.0);
  
  distribution = new PointDistribution(width, height, 100, 40 );
  distribution.createPoints();
  PVector p = distribution.points.get(0);
  tree = new Tree(p.x, p.y, width, height);
  
  for(int i = 1; i < distribution.points.size(); i++) {
    p = distribution.points.get(i);
    tree.add( new Walker(p.x, p.y) );
  }
  
  walkers = new ArrayList<Walker>();
  
  for(int i = 0; i < 20; i++) {
    walkers.add( new Walker( random(width), random(height)) );
  }
  
}

void draw() {
  background(0);
  noStroke();
  fill(0,1.0,1.0);
  for( Walker node : tree.getNodes() ) {
    node.age++;
  }
  tree.draw();
  
  for( int i = 0; i < walkers.size(); i++ ) {
    w = walkers.get(i);
    if(w.checkAttached( tree )) {
      tree.add( w );
      walkers.remove(i);
    }
    //w.draw();
    w.move();
    //w.age++;
  }
  
  if( walkers.size() < 5000 ) {
    for(int i = 0; i < 10; i++) {
      walkers.add( new Walker( random(width), random(height)) );
    }
  }
  
}


void mouseClicked() {
  setup();
}

void keyPressed() {
  if ( key == ' ' ) {
    saveFrame("PoissonDLA-####.png");
  }
}