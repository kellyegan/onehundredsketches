//Java Processing Implementation of 
int w, h, k, gridW, gridH, tries;
float minimumRadius, minimumRadiusSquared, cellSize;
int [] grid;
int [] colors, sizes;

ArrayList<PVector> active, points;

PVector selection;

PointDistribution g;

void setup() {
  size( 1024, 1024 );
  pixelDensity(2);
  colorMode(HSB);

  tries = 0;
  minimumRadius = 18;
  int k = 40;

  g = new PointDistribution( 1024, 1024, minimumRadius, k );
  g.createPoints();
  
  colors = new int[g.uniquePoints];
  sizes = new int[g.uniquePoints];
  for(int i = 0; i < g.uniquePoints; i++) {
     colors[i] = color( random(255), random(150,255), 200);
     sizes[i] = (int) random( 8, 15);
  }

  smooth();
}

void draw() {
  background(0);
  noStroke();
  fill(255);
  PVector p;
  for( int i = 0; i < g.points.size(); i++) {
    p = g.points.get(i);
    fill(colors[g.id.get(i)]);
    ellipse( p.x, p.y, sizes[g.id.get(i)], sizes[g.id.get(i)] );
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