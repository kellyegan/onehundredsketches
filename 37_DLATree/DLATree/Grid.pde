class Grid {
  ArrayList<Walker> [] grid;
  int w, h, cellSize;
  int numRows, numColumns;
  
  Grid(float w, float h, int cellSize) {
    this.w = (int)w;
    this.h = (int)h;
    this.cellSize = cellSize;
    this.numColumns = ceil(w / this.cellSize);
    this.numRows = ceil(h / this.cellSize);
    
    grid = new ArrayList[this.numColumns * this.numRows];
  }
  
  void add( float x, float y, Walker w ) {
    int index = getIndex( x, y );
    
    if( grid[index] == null ) {
      grid[index] = new ArrayList<Walker>(); 
    }
    
    grid[index].add( w );    
  }
  
  /**
   *  Get walkers within the neighborhood of a give point.
   */
  ArrayList<Walker> getNeighborhood( float x, float y ) {
    x = constrain(x, 0, this.w);
    y = constrain(y, 0, this.h);
    
    int column = floor(x / this.cellSize);
    int row = floor(y / this.cellSize);

    ArrayList<Walker> results = new ArrayList<Walker>();
    
    int startColumn = column >  0 ? column - 1 : 0;
    int endColumn = column < this.numColumns - 1 ? column + 2 : column;
    int startRow = row >  0 ? row - 1 : 0; 
    int endRow = row < this.numColumns - 1 ? row + 2 : row;
    
    for( int r = startRow; r < endRow; r++ ) {
      for( int c = startColumn; c < endColumn; c++ ) {
        int index = c + r * this.numColumns;
        if( grid[index] != null ) {
          results.addAll(grid[index]);
        }
      }
    }
    
       
    return results;
  }
  
  int getIndex( float x, float y ) {
    x = constrain(x, 0, this.w);
    y = constrain(y, 0, this.h);
    return floor(x / this.cellSize) + floor(y / this.cellSize) * this.numColumns;
  }
}