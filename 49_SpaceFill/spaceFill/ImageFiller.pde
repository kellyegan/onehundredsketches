public class ImageFiller {
  int wid, hei, k, minimumRadius, shapeIndex;
  float scale, angle;

  ArrayList<PShape> sourceImages;
  ArrayList<PVector> points;

  PGraphics buffer, current, results;


  ImageFiller(int w, int h) {
    this.wid = w;
    this.hei = h;
    minimumRadius = 100;
    shapeIndex = 0;
    k = 150;

    sourceImages = new ArrayList<PShape>();
    points = new ArrayList<PVector>();

    buffer = createGraphics(wid, hei);
    buffer.beginDraw();
    buffer.background(255);
    buffer.endDraw();
    
    results = createGraphics(wid, hei);

    scale = 0.5;
  }

  void loadSourceImages( String [] files ) {
    for ( String file : files ) {
      sourceImages.add( loadShape( file ) );
    }
  }

  void tileImages() {
    PShape currentShape;
    for (int i= 1; i < 1200; i++) {
      scale = sqrt( pow(i, -1.0) );
      shapeIndex = (int)random( sourceImages.size() );
      currentShape = sourceImages.get( shapeIndex );
      setCurrent( currentShape );

      int x, y;
      int tries = 0;
      while( tries < k ) {
        x = (int)random(buffer.width) - current.width / 2;
        y = (int)random(buffer.height) - current.height / 2;
        
        
        if( !intersect( current, buffer, x, y ) ) {
          buffer.beginDraw();
          buffer.blend(current, 0, 0, current.width, current.height, x, y, current.width, current.height, MULTIPLY);
          buffer.endDraw();
          pushMatrix();
          translate(x + (currentShape.width * scale)/2, y +(currentShape.height * scale)/2);
          rotate(angle);
          shape( currentShape, -(currentShape.width * scale)/2, -(currentShape.height * scale)/2, (int)(currentShape.width * scale), (int)(currentShape.height * scale));
          popMatrix();
          //scale = pow( i, -1.0 );
          println(scale);
          break;
        }
        
        tries++;
      }

    }
  }

  void setCurrent( PShape s ) {
    int scaledWidth = (int)(s.width * scale);
    int scaledHeight = (int)(s.height * scale);
    current = createGraphics( scaledWidth + 10, scaledHeight + 10 );
    int x = (int) (current.width - scaledWidth ) / 2;
    int y = (int) (current.height - scaledHeight ) / 2;
    
    angle = random(-PI/3, PI/3);
    
    current.beginDraw();
    current.background(255);
    current.pushMatrix();
    current.translate(x + scaledWidth/2, y + scaledWidth/2);
    current.rotate(angle);
    current.shape( s, -scaledWidth/2, -scaledHeight/2, scaledWidth, scaledHeight );
    current.popMatrix();
    for (int i = 0; i < 3; i++) {
      current.filter(ERODE);
    }
    current.endDraw();
  }

  boolean intersect( PImage a, PImage b, int xOffset, int yOffset ) {

    if ( xOffset < b.width && yOffset < b.height) {
      int startX = xOffset < 0 ? -xOffset : 0;
      int startY = yOffset < 0 ? -yOffset : 0;
      int endX = min( xOffset + a.width, b.width ) - xOffset;
      int endY = min( yOffset + a.height, b.height ) - yOffset;

      int white = color(255, 255, 255);

      for ( int y = startY; y < endY; y++) {
        for (int x = startX; x < endX; x++) {
          int aIndex = x + y * a.width;
          int bIndex = x + xOffset + (y + yOffset) * b.width;
          
          if ( aIndex < 0 || aIndex >= a.pixels.length || bIndex < 0 || bIndex >= b.pixels.length) {
            println("Out of bounds");
          } else {
            if ( a.pixels[aIndex] != white && b.pixels[bIndex] != white) {
              return true;
            }
          }
        }
      }
    } else {
      //Offset is beyond boundary of image b ignore.
      return true;
    }
    return false;
  }
}