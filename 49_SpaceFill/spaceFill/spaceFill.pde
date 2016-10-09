
PGraphics buffer;
PGraphics currentImage;

ArrayList<PShape> shapes;

ImageFiller filler;

void setup() {
  size( 1536, 1536);
  
  filler = new ImageFiller( width, height );
    
  //File f = new File(sketchPath("svg"));
  //if( f.isDirectory() ) {
  //  String [] filenames = f.list();
  //  shapes = new ArrayList<PShape>();
    
  //  for( int i = 0; i < filenames.length; i++ ) {      
  //    if( match(filenames[i], ".+[.]svg") != null ) {
  //      filenames[i] = "svg/" + filenames[i];
  //    }
  //  }
    
  //  filler.loadSourceImages(filenames);
  //  filler.tileImages();
  //}
  background(255);
  String [] shapeArray = {"svg/20160706_KellyStipple.svg"};
  filler.loadSourceImages(shapeArray);
  filler.tileImages();
  saveFrame( "spaceFiller.png");
  //image(filler.buffer, 0,0);
}

void draw() {
  
}

void mousePressed() {
  setup(); 
}