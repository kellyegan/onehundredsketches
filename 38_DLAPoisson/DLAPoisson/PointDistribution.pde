
class PointDistribution {
 
  float cellSize, minimumRadius, minimumRadiusSquared;
  int w, h, gridW, gridH, k;
     
  int [] grid;
  ArrayList<PVector> points;
  ArrayList<PVector> active;
  ArrayList<Integer> id;
  int uniquePoints;
  
  PVector selection;
  int tries;

  
  PointDistribution( int w, int h, float minimumRadius, int k ) {
    this.w = w;
    this.h = h;
    this.minimumRadius = minimumRadius;
    this.minimumRadiusSquared = minimumRadius * minimumRadius;
    this.cellSize = minimumRadius * sqrt(0.5);
    
    this.k = k;
     
    this.gridW = ceil( w / this.cellSize ) + 4;
    this.gridH = ceil( h / this.cellSize ) + 4;
    
    grid = new int[gridW * gridH];
    for(int i = 0; i < grid.length; i++) {
      grid[i] = -1;
    }
    
    uniquePoints = 0;
     
    points = new ArrayList<PVector>();
    active = new ArrayList<PVector>();
    id = new ArrayList<Integer>();
  }
  
  
  /**
   * Return the grid index for a given point
   */
  int getGridIndex( PVector p ) {
    int gridX = floor(p.x / this.cellSize) + 2;
    int gridY = floor(p.y / this.cellSize) + 2;
    
    return gridY * gridW + gridX;
  }
 
  /**
   * Check that a point is the minimum distance away from nearby points
   *
   * @param  p   Point to check
   * @return     Returns true if point is not too close to any nearby points.
   */
  boolean checkDistance( PVector p ) {
    int gridX = floor(p.x / this.cellSize) + 2;
    int gridY = floor(p.y / this.cellSize) + 2;
    
    int firstCol = gridX - 2;
    int firstRow = gridY - 2;
    
    int lastCol = gridX + 3;
    int lastRow = gridY + 3;
    
    PVector current; 
  
    for( int y = firstRow; y < lastRow; y++ ) {
      for( int x = firstCol; x < lastCol; x++ ) {
        int currentIndex = grid[x + y * gridW];
        if( currentIndex != -1 ) {
          current = points.get(currentIndex);
          float dx = p.x - current.x;
          float dy = p.y - current.y;
          if(  dx * dx + dy * dy < minimumRadiusSquared ) {
            return false;
          }
        }
      }
    }
 
    return true;
  }
  
  /**
   * Pick random point within annulus (donut) of a given point
   *
   * @param  p   Starting point at center of annulus
   * @return     Returns new point within annulus.
   */
  PVector pickNewPoint(PVector p) {
    float angle = TAU * random(1.0);
    float radius = minimumRadius + random(1.0) * minimumRadius;
    float x = p.x + radius * cos(angle);
    float y = p.y + radius * sin(angle);
    
    if( x > 0 && x < this.w && y > 0 && y < this.h ) {
      return new PVector(x, y);
    } else {
      return pickNewPoint( p );
    }
  }
 
  /**
   *  Add point to grid and points ArrayList. If it is near edge
   *  add 'ghosts' to account for repeating the pattern.
   */
  void addPoint( PVector p ) {
    int gridX = floor(p.x / this.cellSize) + 2;
    int gridY = floor(p.y / this.cellSize) + 2;
    
    boolean horizontal = false;
    boolean vertical = false;
    
    PVector hGhost = new PVector();
    PVector vGhost = new PVector();
    PVector cornerGhost = new PVector();
    
    active.add(p);
    points.add(p);
    
    int index = points.size() - 1;
    
    id.add(uniquePoints);
    
    grid[getGridIndex(p)] = index;
    
    //Check for edge cases in horizontal direction
    if( p.x < cellSize * 2) {
      hGhost = new PVector(p.x + w, p.y);
      points.add(hGhost);
      id.add(uniquePoints);
      grid[getGridIndex(hGhost)] = points.size() - 1;
      horizontal = true;
    } else if( p.x > w - cellSize * 2) {
      hGhost = new PVector(p.x - w , p.y);
      points.add(hGhost);
      id.add(uniquePoints);
      grid[getGridIndex(hGhost)] = points.size() - 1;
      horizontal = true;
    }
    
    //Check for edge cases in vertical direction
    if( p.y < cellSize * 2) {
      vGhost = new PVector(p.x, p.y + h);
      points.add(vGhost);
      id.add(uniquePoints);
      grid[getGridIndex(vGhost)] = points.size() - 1;
      vertical = true;
    } else if( p.y > h - cellSize * 2) {
      vGhost = new PVector(p.x, p.y - h);
      points.add(vGhost);
      id.add(uniquePoints);
      grid[getGridIndex(vGhost)] = points.size() - 1;
      vertical = true;
    }
    
    if( horizontal && vertical ) {
      cornerGhost = new PVector( hGhost.x, vGhost.y );
      points.add(cornerGhost);
      id.add(uniquePoints);
      grid[getGridIndex(cornerGhost)] = points.size() - 1;
    }
       
    uniquePoints++;
  }
  
  /**
   *  Iterate over field creating new points.
   */
  void createPoints() {
    this.addPoint( new PVector( random(w), random(h)) );  
    
    while( this.active.size() > 0 ) {
      selection = this.pickNewPoint( this.active.get(0) );
      
      if( this.checkDistance(selection) ) {
        this.addPoint( selection );
      } else {
        tries++; 
      }
      
      if( tries > k ) {
        tries = 0;
        this.active.remove(0);
      }
    } 
  }
}