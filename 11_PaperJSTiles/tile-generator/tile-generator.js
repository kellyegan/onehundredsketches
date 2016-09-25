

var tilesStarted = false;

var files = ["shapes/a.svg",
             "shapes/b.svg",
             "shapes/c.svg",
             "shapes/d.svg",
             "shapes/e.svg",
             "shapes/f.svg",
             "shapes/g.svg",
             "shapes/h.svg",
             "shapes/i.svg",
             "shapes/j.svg",
             "shapes/k.svg",
             "shapes/l.svg",
             "shapes/m.svg",
             "shapes/n.svg",
             "shapes/o.svg",
             "shapes/p.svg",
             "shapes/q.svg",
             "shapes/r.svg",
             "shapes/s.svg",
            ];

var colors = ["#E6E8E8", "#213457", "#55B5AC", "#E0761A", "#BA0A09" ];

var shapes = [];
var tiles, currentTile;

var scale = 1.0;
var position;

var interval;

var tileLayer = project.getActiveLayer();
var enlargedLayer = new Layer();
tileLayer.activate();



function reset() {
  tileLayer.removeChildren();
  enlargedLayer.removeChildren();
  position = new Point(0,0);
  tiles = [];
  tileLayer.activate();
  interval = setInterval( makeTile, 100 );
  makeTile();
}


files.forEach( function (filePath){
  project.importSVG(filePath, function (item){

    item.pivot = item.bounds.topLeft;
    scale = 70 / item.bounds.width;

    item.visible = false;
    shapes.push(item);

    //Make sure a minimum number of shapes have been loaded
    if( !tilesStarted && shapes.length > 5) {
      tilesStarted = true;
      reset();
    }
  });
});


//Generate the tiles
function makeTile() {
  var tile = new Group();

  //Shuffle shapes and colors
  shapes = shuffle(shapes);
  colors = shuffle(colors);

  var background = new Path.Rectangle(new Point(0, 0), new Size(640, 640));
  background.fillColor = colors[ 0 ];
  tile.addChild(background);

  var numberOfShapes = Math.floor( Math.random() * 3 + 4 );

  for( i = 0; i < numberOfShapes; i++) {
    var currentShape = shapes[i].clone();

    currentShape.fillColor = colors[(i + 1) % colors.length];
    currentShape.bringToFront();
    currentShape.visible = true;

    tile.addChild(currentShape);
  }
  tile.pivot = tile.bounds.topLeft;
  tile.scale( scale, tile.bounds.topLeft);
  tile.position = position;

  if( tile.bounds.topLeft.x > project.view.size.width ) {
    position.x = 0;
    position.y += tile.bounds.height;
    tile.position = position;
  }

  if( tile.bounds.topLeft.y > project.view.size.height ) {
    clearInterval(interval);
  }

  position.x += tile.bounds.width;

  tile.on("mouseup", function () {
    enlargedLayer.removeChildren();

    var enlarged = this.clone();

    enlarged.scale(5);
    enlarged.bringToFront();
    enlarged.pivot = null;
    enlarged.position = project.view.center;

    enlarged.on("mouseup", function () {
      enlargedLayer.removeChildren();
      this.remove();
    });

    enlargedLayer.addChild(enlarged);

    createExportLink("tile.svg", enlargedLayer)
  });

  tile.sendToBack();
  tiles.push(tile);
}

//Fisher-Yates Shuffle
function shuffle(array) {
  var counter = array.length;

  // While there are elements in the array
  while (counter > 0) {
      // Pick a random index
      var index = Math.floor(Math.random() * counter);

      // Decrease counter by 1
      counter--;

      // And swap the last element with it
      var temp = array[counter];
      array[counter] = array[index];
      array[index] = temp;
  }
  return array;
}

document.getElementById("reset").onclick = function () {
  reset();
}
