/*
Makey Makey Hurdles
Jenna deBoisblanc
5/23/13
jdeboi.com
*/

/////////////////////////////////////////////////////////////
//VARIABLES//////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

///////////UPDATE////////////////
int numSprinters = 6;
int numHurdles = 5;
int trackLength = 5000;
String[] playerNames = {"Sonic", "Chewy", "Luigi", "Walker", "Mario", "Nyan"};
char[][] playerKeys = 
{
  // player 1: left, right
  {'z', 'x'},
  // player 2: left, right
  {'j', 'k'},
  //...
  {'n', 'm'},
  {'o', 'p'},
  {'g', 'h'},
  {'c', 'v'}
};
int[] numCharacterImages = {12, 8, 5, 8, 3, 3};
int windowWidth = 1400;
int windowHeight = 900;
/////////////////////////////////

float ratio = trackLength / windowWidth;

//////MAY NEED ADJUSTMENT////////
int fallDownStall = 80;
int jumpThreshold = 300;
/////////////////////////////////

Sprinter[] sprinters;
int[] hurdles;
boolean raceStarted = false;
boolean countStarted = false;
int startClock = 0;
boolean hit = false;
PFont f;
float raceTime = 0;
static int playerIndex;
int[] finished;
int finishedIndex;
int sprinterHeight = 100;
PImage cloud;

// Track variables
int angle = 25;
int yTopOffset = 300;
int yBottomOffset = 100;
int numLanes = 6;
int trackHeight = 700;
int laneHeight = trackHeight / numLanes;
int xStartOffset = 70;
int xNumberOffset = xStartOffset + 30;
int startLine = 0;
int hurdleWidth = 10;
int hurdleHeight = 60; 

// scoreboard variables
int countX = 150;
int countY = 100;
int scoreX = 70;
int scoreY = 30;
int scoreW = windowWidth /2;
int scoreH = yTopOffset - scoreY - 70;

// position change variables
int stepSize = 15;
int jumpSize = 3;
int cycleSize = 1;
int fallSize = 1;
int hurdlePadding = 20;
int jumpPadding = 20;
int sprinterWidth = sprinterHeight;
int jumpLength = (int) (ratio * 
  (hurdlePadding + hurdleWidth + jumpPadding + sprinterWidth) / jumpSize);

/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  size(windowWidth, windowHeight, P3D);
  hurdles = new int[numHurdles];
  sprinters = new Sprinter[numSprinters];
  finished = new int[numSprinters];
  for(int i = 0; i < numSprinters; i++) {
    int yp = yTopOffset + laneHeight * i - 30;
    sprinters[i] = new Sprinter(0, yp, playerNames[i], playerKeys[i][0], 
      playerKeys[i][1], numCharacterImages[i]);
  }
  f = createFont("Arial", 80, true);
  setHurdles();
  cloud = loadImage("cloud.png");
}

/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(120);
  translate(0, -100, -500);
  
  //TRACK//////////////////////
  pushMatrix();
    rotateX(angle * PI / 180);
    lights();
    //ambientLight(200, 200, 200);
    drawTrack();
    drawLines();
    drawStart();
    drawNumbers();
    drawHurdles();
    drawScoreBoard();
    drawFinishLine();
  popMatrix();
  ////////////////////////////
  
  //PLAYERS///////////////////
  for (int i = 0; i < numSprinters; i++) {
    pushMatrix();
    int y = (int) ((yTopOffset + (i + 1.0 - .1) * laneHeight - 100) * cos(angle * PI / 180));
    int z = (int) ((yTopOffset + (i + 1.0) * laneHeight) * sin(angle * PI / 180));
    translate(0, y, z);
    sprinters[i].display();
    popMatrix();
  }
  ////////////////////////////
  
  if (countStarted) {
    if (millis() - startClock > 3000){
      raceStarted = true;
      countStarted = false;
      raceTime = millis();
    }
  }
  if (raceStarted) {
    for (int i = 0; i < numSprinters; i++) {
      sprinters[i].move();
      if (sprinters[i].isFinished()) {
        finished[finishedIndex] = i;
        finishedIndex++;
        if(finishedIndex == numSprinters) {
          finish();
        }
      }  
    }
  }  
}

void drawTrack() {
  // track 
  fill(#7C3418);
  noStroke();
  pushMatrix();
  translate(0, 0, -1);
  rect(-500, yTopOffset, windowWidth + 1000, trackHeight);
  popMatrix();
}

void drawLines() {
  // lane lines
  strokeWeight(5);
  noStroke();
  fill(255);
  int lineWidth = 10;
  for(int i = 0; i <= numLanes; i++) {
    int y = yTopOffset + laneHeight * i;
    rect(-500, y - lineWidth/2, windowWidth + 1000, lineWidth);
    //line(-500, y, windowWidth + 1000, y);
  }
}

void drawStart() {
  strokeWeight(10);
  fill(255);
  noStroke();
  int lineWidth = 10;
  rect(startLine, yTopOffset, lineWidth, trackHeight);
  //line(startLine, yTopOffset, startLine, yTopOffset + trackHeight - 1);
}

void drawNumbers() {
  fill(255);
  stroke(255);
  int textSize = 80;
  int x = startLine + 20;
  for (int i = 0; i < numLanes; i++) {
    int y = yTopOffset + laneHeight * i + textSize;
    textSize(textSize);
    text((i + 1) + " " + playerNames[i], x, y);
  }
}

void drawHurdles() {
  for(int i = 0; i < numHurdles; i++) {
    int x = (int) (hurdles[i] * 1.0 / trackLength * windowWidth);
    pushMatrix();
      translate(x, yTopOffset + trackHeight/2, 0);
      noStroke();
      fill(#E0A639);
      strokeWeight(2);
      box(hurdleWidth, trackHeight, hurdleHeight);
    popMatrix();  
  }
}

void drawScoreBoard() {
  drawCount(countX, countY);
  drawRaceTime(scoreX + 400, scoreY + 50);
}

void drawCount(int x, int y) {
  fill(255);
  textSize(130);
  if(countStarted) {
     int time = 3 - (millis() - startClock)/1000;
     text(time, x, y);
  }
  else if (raceStarted) {
    text("GO", x, y);
  }
  else {
    text("--", x, y);
  }
}

void drawRank(int x, int y) {
  for(int i = 0; i < numSprinters; i++) {
    String rank = sprinters[i].name + ": " 
      + sprinters[i].percentComplete() + "%";
    textSize(18);
    text(rank, x, i*30 + y);
  }
}

void drawRaceTime(int x, int y) {
  textSize(50);
  text(getRaceTime() + "s", x, y);
}
  
void drawFinishLine() {
  int xline = width - 60;
  int boxW = 25;
  int boxH = laneHeight/2;
  pushMatrix();
  translate(0, 0, 1);
  for(int i = 0; i < numLanes; i++) {
    noStroke();
    // top left box
    fill(0);
    rect(xline, yTopOffset + i * laneHeight, boxW, boxH);
    // top right box
    fill(255);
    rect(xline + boxW, yTopOffset + i * laneHeight, boxW,boxH);
    // bottom left box
    fill(255);
    rect(xline, yTopOffset + i * laneHeight + boxH, boxW, boxH);
    // bottom right box
    fill(0);
    rect(xline + boxW, yTopOffset + i * laneHeight + boxH, boxW, boxH);
  }
  popMatrix();
}  

/////////////////////////////////////////////////////////////
//KEYBOARD INPUT/////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void keyPressed() {
  if (raceStarted) {
    for(int i = 0; i < numSprinters; i++) {
      sprinters[i].checkPressed(key); 
    }
  }
  else if (key == 's') {
    loop();
    countStarted = true;
    startClock = millis();
  }
}

void keyReleased() {
  if (raceStarted) {
    for(int i = 0; i < numSprinters; i++) {
      sprinters[i].checkReleased(key);  
    }
  }
}

/////////////////////////////////////////////////////////////
//OTHER FUNCTIONS////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void finish(){
  background(120);
  String message = "Player " + (finished[0] + 1) + " wins!";
  String message2 = "Player " + (finished[1] + 1) + " second!";
  text(message, 100, 100);
  text(message2, 100, 130);
  for(int i = 0; i < numSprinters; i++){
    sprinters[i].restart();
  }
  raceStarted = false;
  finishedIndex = 0;
  noLoop();
}

void setHurdles() {
  int hurdleSpacing = trackLength / (numHurdles + 2);
  for(int i = 0; i < numHurdles; i++) {
    hurdles[i] = (i + 1) * hurdleSpacing;
  }
}

void setRandomHurdles() {
  for(int i = 0; i < numHurdles; i++) {
    int lower = (int) (trackLength / numHurdles * i);
    int upper = (int) (trackLength / numHurdles * (i + 1));
    hurdles[i] = (int) random(lower, upper);
  }
}
   
float getRaceTime() {
  if(raceStarted) {
    /*
    // trick to round number to 2 decimal places
    int t = (int) (millis() - raceTime) / 10;
    float tf = t/100.0;
    */
    return (millis() - raceTime) / 1000;
  }
  else {
    return 0.00;
  }
}

void mouseDragged(){
  // camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  // default: camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), 
  //                 width/2.0, height/2.0, 0, 
  //                 0, 1, 0)
  camera(mouseX, mouseY, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
}


