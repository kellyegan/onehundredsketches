public class FlowField {
  float w, h;
  int cellSize;
  int rows, cols;
  
  float noiseScale;
    
  FlowField(float w, float h, int c, float n ) {
    this.w = w;
    this.h = h;
    noiseScale = 0.02;
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
    float x = (location.x / cellSize + 0 * cols);
    float y = (location.y / cellSize  + 0 * rows);
    
    PVector result = gradient( x, y, offset, time );
    
    //float angle = map( value, 0, 1.0, 0, TAU);
    //PVector result = PVector.fromAngle( angle );
    
    return result;
  }
  
  float noiseWave(float x, float y,  float offset, float time) {
    float turb = noise( x * noiseScale + offset * width, y * noiseScale, time * noiseScale ) * 12 - 6;
    //float turb = 0;
    float value = (sin( dist(32, 32, x, y) + turb + time * 0.2 + offset * 20) + 1) / 2;
    //float value = (sin( y * 0.1 + turb - time * 0.2 + offset * 20) + 1) / 2;
    
    return value;
  }
  
  PVector gradient(float x, float y, float offset, float time) {
    float xGradient = noiseWave(x + 1, y, offset, time) - noiseWave(x - 1, y, offset, time); 
    float yGradient = noiseWave(x, y + 1, offset, time) - noiseWave(x, y - 1, offset, time);
    PVector grad =  new PVector(xGradient, yGradient);
    grad.normalize().mult(0.005);
    return grad;
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