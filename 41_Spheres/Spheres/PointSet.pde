/**
 *  PointSet manages a grid of points of a specific width and height
 *  the set wraps edge points neighbors so that it can be tileable.
 *
 */

interface Location {
  float x();
  float y();
  int getID();
}

class PointSet {
  int w, h, cellSize;
  int numRows, numCols;
  
  ArrayList<Location> [] grid;
  ArrayList<Location> points;
  
  /**
   *  Constructor to create grid
   */
  PointSet( float w, float h, int cellSize ) {
    this.w = (int)w;
    this.h = (int)h;
    this.cellSize = cellSize;
    this.numRows = ceil(w / this.cellSize) + 4;
    this.numCols = ceil(h / this.cellSize) + 4;
    
    grid = new ArrayList[this.numCols * this.numRows];
    points = new ArrayList<Location>();
  }
  
  /**
   * Add new point to set
   */
  void add( Location p ) {
    int index = getIndex( p.x(), p.y() );
    
    Location horizontalGhost, verticalGhost, cornerGhost;
    boolean horizontalEdge = false;
    boolean verticalEdge = false;
    
    
    if( grid[index] == null ) {
      grid[index] = new ArrayList<Location>(); 
    }
    
    grid[index].add( p );
    points.add(p);
  }
  
  /**
   *  Get the grid index of a coordinate
   */
  int getIndex( float x, float y ) {
    int col = floor(x / this.cellSize) + 2;
    int row = floor(y / this.cellSize) + 2;
    return col + row * this.numCols;
  }
  
  /**
   *  Return points in neighboring cells (3 x 3)
   */
  ArrayList<Location> getNeighbors( float x, float y ) {
    ArrayList<Location> neighborhood = new ArrayList<Location>();
    
    int col = floor(x / this.cellSize) + 2;
    int row = floor(y / this.cellSize) + 2;
    
    int startColumn = col >  0 ? col - 1 : 0;
    int endColumn = col < this.numCols - 1 ? col + 2 : col;
    int startRow = row >  0 ? row - 1 : 0; 
    int endRow = row < this.numCols - 1 ? row + 2 : row;
    
    for( int r = startRow; r < endRow; r++ ) {
      for( int c = startColumn; c < endColumn; c++ ) {
        int index = c + r * this.numCols;
        if( grid[index] != null ) {
          neighborhood.addAll(grid[index]);
        }
      }
    }
    
    return neighborhood;
  }
    
  
  
}