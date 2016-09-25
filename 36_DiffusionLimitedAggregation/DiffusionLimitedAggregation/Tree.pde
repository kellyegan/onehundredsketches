class Tree {
  ArrayList<Walker> nodeList;
  Grid nodeGrid;
  PVector center;
  float radius, lastNodeDistance;
  
  Tree(float x, float y, float w, float h) {
    nodeList = new ArrayList<Walker>();
    nodeGrid = new Grid(w, h, 25);
    this.center = new PVector(x, y);
    
    add(new Walker(center.x, center.y) );   
  }
  
  void add( Walker w ) {
    nodeList.add(w);
    nodeGrid.add(w.location.x, w.location.y, w);
    lastNodeDistance = dist(this.center.x, this.center.y, w.location.x, w.location.y) + w.radius;
    radius = max(radius, lastNodeDistance);

  }
  
  ArrayList<Walker> getNodes() {
    return nodeList;
  }
  
  PVector getNewPointInRing( float inside, float outside) {
    PVector p = PVector.random2D();
    
    //Using lastNodeDistance instead of the trees radius creates a more round tree
    p.mult( this.lastNodeDistance + inside + random(outside) );
    //p.mult( this.radius + inside + random(outside) );
    p.add( this.center );
    return p;
  }
  
  ArrayList<Walker> getNeighborhood( float x, float y ) {
    return nodeGrid.getNeighborhood( x, y );
  }
}