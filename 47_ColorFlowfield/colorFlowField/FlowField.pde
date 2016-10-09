public class FlowField {
  float w, h;
  int cellSize;
  int rows, cols;
  
  float noiseScale;
    
  FlowField(float w, float h, int c, float n ) {
    this.w = w;
    this.h = h;
    noiseScale = 0.1;
    cellSize = c;
    cols = ceil (w / cellSize);
    rows = ceil (h / cellSize);
    
  }
  
  PVector lookup( PVector location ) {
    return lookup( location, 0.0, 0.0 );
  }
  
  PVector lookup( PVector location, float offset ) {    
    return lookup( location, offset, 0.0 );
  }
  
  PVector lookup( PVector location, float offset, float time ) {    
    float x = (location.x / cellSize + offset * cols);
    float y = (location.y / cellSize  + offset * rows);
    
    float angle = noise( x * noiseScale, y * noiseScale, time * noiseScale );  
    angle = map( angle, 0, 0.5, 0, TAU);
    PVector result = PVector.fromAngle( angle );
    //
    
    return result;
  }
  
  void display(float time) {
    stroke(200, 50);
    noFill();
    for( int y = 0; y < rows; y++ ) {
      for( int x = 0; x < cols; x++ ) {
        pushMatrix();
        translate( x * cellSize + cellSize * 0.5, y * cellSize + cellSize * 0.5);
        float angle = noise( x * noiseScale, y * noiseScale, time * noiseScale );  
        angle = map( angle, 0, 0.85, 0, TAU);
        rotate( angle );
        ellipse( -(cellSize * 0.4), 0, 3, 3 );
        line( -(cellSize * 0.4), 0, cellSize * 0.4, 0 );
        popMatrix();
      }
    }
  }
}