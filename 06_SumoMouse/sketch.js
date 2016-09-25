
var canvas, body;
var pullPoint, position, force, velocity, center;

var ringRadius, wrestlerRadius;

var count;

var countDown, countdownStart, roundStart, roundTime;

var playerOneScore, playerTwoScore;
var currentPlayer, currentPoints;
var roundCount;
var newRound;

var NEWGAME = 0;
var COUNTINGDOWN = 1;
var PLAYING = 2;
var ROUNDOVER = 3;

var bgColor;


function setup() {
  canvas = createCanvas(600, 600);
  canvas.class("sketch");
  canvas.parent("main");
  
  body = select("#body");
  
  center = new createVector( width/2, height/2 );
  pullPoint = new createVector( center.x, center.y );
  force = new createVector();
  velocity = new createVector();
  position = createVector( width/2, height/2 );
  
  ringRadius = width / 2 * 0.9;
  wrestlerRadius = 50;
  
  countDown = 3000;
  
  roundOver = false;
  delayStarted = false;
  roundStarted = false;
  
  playerOneScore = 0;
  playerTwoScore = 0;
  roundCount = 1; 
  roundTime = 0;
  currentPlayer = 1;
  
  status = NEWGAME;
  newRound = true;
  
}

function draw() {
  bgColor = 100;
  drawRing( roundOver );
  
  if( status == COUNTINGDOWN) {
    var timeLeft = round( (countDown - (millis() - countdownStart)) / 1000);
    if( timeLeft <= 0 ) {
      status = PLAYING;
      roundStart = millis();
    } else {
      push();
      fill(0);
      textAlign(CENTER);
      textSize(128);
      text(timeLeft, center.x, center.y + 48);
      pop();
    }
  } else if( status == PLAYING ) {
    updateRound();
    drawWrestler(position.x, position.y, wrestlerRadius);    
  } else if( status == ROUNDOVER ){
    bgColor = color(200, 0, 0);
  }
  
  drawBoard();
}

function updateRound() {
  roundTime = floor((millis() - roundStart) / 1000);
  
  //Set the pullPoint to stay within canvas
  var x = min( mouseX, width );
  var x = max( x, 0 );
  var y = min( mouseY, width );
  var y = max( y, 0 );
  pullPoint.set( x, y );
  
  //Apply force to wrestler position
  force = p5.Vector.sub( pullPoint, position );
  force.mult( 0.05 );
  velocity.add( force );
  position.add( velocity );
  velocity.mult( 0.01 );
  
  //Check if wrestler has left ring
  var distance = p5.Vector.dist( center, position);
  if( distance + wrestlerRadius > ringRadius ) {
    resetRound();
    status = ROUNDOVER;
  }
}

function drawBoard() {
  push();
  fill(255);
  noStroke();
  textSize(24);
  
  //Scores
  textAlign(LEFT);
  text( "One: " + playerOneScore, 20, height - 20 );
  textAlign(RIGHT);
  text( "Two: " + playerTwoScore, width - 20, height - 20 );
  
  //Round
  textAlign(LEFT);
  text( "Round: " + roundCount, 20, 30 );
  
  //Round
  textAlign(RIGHT);
  text( "Time: " + roundTime, width - 20, 30 );
  
  pop();
}

function drawRing() {
  push();
  if( status == ROUNDOVER ) {
    background( "#c80000");
    body.style("background-color", "#c80000");
  } else {
    background( "#c8c8c8" );
    body.style("background-color", "#c8c8c8");
  }
  
  //Draw ring border
  var ringDiameter = ringRadius * 2;
  noStroke();
  fill(255);  
  ellipse( width / 2, height /2, ringDiameter + 20, ringDiameter + 20 );

  //Draw ring
  fill(200);
  ellipse( width / 2, height /2, ringDiameter, ringDiameter ); 
  
  if( status == NEWGAME || status == ROUNDOVER  ) {
    drawX(center.x, center.y);
  }
  pop();
}

function drawWrestler(x, y, radius) {
  push();
  fill(0);
  translate( x, y );
  ellipse( 0, 0, radius * 2, radius * 2 );
  textAlign(CENTER);
  textStyle(BOLD);
  textSize(60);
  fill(255);
  text(currentPlayer, 0, 24);
  pop();
}

function drawX(x, y) {
  push();
  noFill();
  stroke(0);
  strokeWeight(10);
  line( x - 20, y - 20, x + 20, y + 20);
  line( x - 20, y + 20, x + 20, y - 20);
  
  fill(0);
  noStroke();
  textAlign(CENTER);
  
  if( newRound ){
    textStyle(BOLD);
    textSize(48);
    text("Round " + roundCount + "!",  center.x, center.y - 108);
  }

  
  var playerText = currentPlayer == 1 ? "one" : "two";
  textStyle(BOLD);
  textSize(36);
  text("Player " + playerText + ", stay in the ring!",  center.x, center.y - 60);
     
  textSize(20);
  textStyle(ITALIC);
  text("Click X to start", center.x, center.y + 60);
  pop();
}

function resetRound() {
  if( currentPlayer == "1") {
    playerOneScore += roundTime;
    currentPlayer = 2;
  } else {
    playerTwoScore += roundTime;
    currentPlayer = 1; 
    roundCount++;
    newRound = true;
  }
  
  pullPoint.set( center );
  position.set( center );
  roundTime = 0;  
}

function mouseClicked() { 
  if( status == NEWGAME || status == ROUNDOVER ){
    status = COUNTINGDOWN;
    newRound = false;
    countdownStart = millis();
  }
}

