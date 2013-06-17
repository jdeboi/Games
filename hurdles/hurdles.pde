/*
Makey Makey Hurdles
Jenna deBoisblanc
5/23/13
jdeboi.com
*/

/////////////////////////////////////////////////////////////
//VARIABLES//////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

///////////UPDATE//////////////////////////////
///////////////////////////////////////////////
int numSprinters = 6;
int numHurdles = 4;
int trackLength = 2000;
String[] playerNames = {"Nyan", "Chewy", "Luigi", "Walker", "Mario", "Sonic"};
char[][] playerKeys = 
{
  // player 1: left, right
  {'q', 'w'},
  // player 2: left, right
  {'e', 'r'},
  //...
  {'t', 'y'},
  {'u', 'i'},
  {'o', 'p'},
  {'g', 'h'}
};
int[] numCharacterImages = {3, 8, 5, 8, 3, 12};
int windowWidth = 1400;
int windowHeight = 900;
char startKey = 's';
///////////////////////////////////////////////
///////////////////////////////////////////////

//////MAY NEED ADJUSTMENT////////
int fallDownStall = 80;
int jumpThreshold = 200;
/////////////////////////////////

Sprinter[] sprinters;
int[] hurdles;
boolean raceStarted = false;
boolean countStarted = false;
boolean finishedRace = false;
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
float ratio = trackLength / windowWidth;

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
  f = createFont("Arial", 80, true);
  cloud = loadImage("lakitu.png");
  initSprinters();
  initHurdles();
  frameRate(60);
}

/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(#000855);
  if(finishedRace) {
    drawFinish();
  } 
  else {
    translate(0, -100, -500);
    pushMatrix();
      rotateX(angle * PI / 180);
      lights();
      directionalLight(200, 200, 200, 1, -1, -1);
      drawTitle();
      drawTrack();
    popMatrix();
    checkCount();
    drawSprinters();
    updateSprinters();
  }
  saveFrame("frames/####.tif");
}

void drawSprinters() {
  for (int i = 0; i < numSprinters; i++) {
    pushMatrix();
    int y = (int) ((yTopOffset + (i + 1.0 - .1) * laneHeight - 100) * cos(angle * PI / 180));
    int z = (int) ((yTopOffset + (i + 1.0) * laneHeight) * sin(angle * PI / 180));
    translate(0, y, z);
    sprinters[i].display();
    popMatrix();
  }
}

void drawTitle() {
  if(!raceStarted && !countStarted) {
    stroke(255);
    fill(255);
    textSize(350);
    text("Hurdles", 0, 80);
    textSize(60);
    text("Press '" + startKey + "' to play", 80, 200);
  }
}

void drawTrack() {
  drawConcrete();
  drawLines();
  drawStartLine();
  drawNumbers();
  drawNames();
  drawHurdles();
  drawScoreBoard();
  drawFinishLine();
}

void drawConcrete() {
  // track 
  fill(#FF7543);
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
  }
}

void drawStartLine() {
  strokeWeight(10);
  fill(255);
  noStroke();
  int lineWidth = 10;
  rect(startLine, yTopOffset, lineWidth, trackHeight);
}

void drawNumbers() {
  fill(255);
  stroke(255);
  int textSize = 80;
  int x = startLine + 20;
  for (int i = 0; i < numLanes; i++) {
    int y = yTopOffset + laneHeight * i + textSize;
    textSize(textSize);
    text((i + 1), x, y);
  }
}

void drawNames() {
  fill(255);
  stroke(255);
  int textSize = 80;
  int x = startLine + 90;
  for (int i = 0; i < numSprinters; i++) {
    int y = yTopOffset + laneHeight * i + textSize;
    textSize(textSize);
    text(playerNames[i], x, y);
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
  //drawRaceTime(scoreX + 440, scoreY + 50);
}

void drawCount(int x, int y) {
  fill(255);
  textSize(220);
  if(countStarted) {
     int time = 3 - (millis() - startClock)/1000;
     text(time, x, y);
  }
  else if (raceStarted) {
    text("GO", x, y);
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
  if(raceStarted) {  
    textSize(50);
    text(getRaceTime() + "s", x, y);
  }
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

void drawFinish() {
  int i = 0;
  while(i < numSprinters) {
    textSize(100);
    if (i%2 == 0) {
      fill(255);
    }
    else {
      fill(#FF860D);
    }
    int ypos = 150 + i * 100;
    
    // sprinters
    sprinters[finished[i]].display(160, ypos + 20);
    
    // numbers
    text((i+1), 250, ypos);
    
    // sprinter names
    textSize(50);
    text(playerNames[finished[i]], 320, ypos);  
    i++;
  }
  textSize(30);
  fill(255);
  text("Press '" + startKey + "' to play again", 200, 150 + i * 100);
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
  else if (key == startKey) {
    finishedRace = false;
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
//INITIALIZE FUNCTIONS///////////////////////////////////////
/////////////////////////////////////////////////////////////
void initSprinters() {
  finished = new int[numSprinters];
  sprinters = new Sprinter[numSprinters];
  for(int i = 0; i < numSprinters; i++) {
    int yp = yTopOffset + laneHeight * i - 30;
    sprinters[i] = new Sprinter(0, yp, playerNames[i], playerKeys[i][0], 
      playerKeys[i][1], numCharacterImages[i]);
  }
}

void initHurdles() {
  hurdles = new int[numHurdles];
  int hurdleSpacing = trackLength / (numHurdles + 2);
  for(int i = 0; i < numHurdles; i++) {
    hurdles[i] = (i + 2) * hurdleSpacing;
  }
}

/////////////////////////////////////////////////////////////
//OTHER FUNCTIONS////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void updateSprinters() {
  if(raceStarted) {
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

void checkCount() {
  if (countStarted) {
    if (millis() - startClock > 3000){
      startRace();
    }
  }
}

void startRace() {
  raceStarted = true;
  countStarted = false;
  raceTime = millis();
}

void finish(){
  finishedRace = true;
  resetRace();
}

void resetRace() {
  for(int i = 0; i < numSprinters; i++){
    sprinters[i].restart();
  }
  raceStarted = false;
  finishedIndex = 0;
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

/*
// in case I decide to create random hurdles
void setRandomHurdles() {
  for(int i = 0; i < numHurdles; i++) {
    int lower = (int) (trackLength / numHurdles * i);
    int upper = (int) (trackLength / numHurdles * (i + 1));
    hurdles[i] = (int) random(lower, upper);
  }
}
*/

/*
// debugging 3D perspective
void mouseDragged(){
  camera(mouseX, mouseY, (height/2.0) / tan(PI*30.0 / 180.0), 
    width/2.0, height/2.0, 0, 0, 1, 0);
}
*/


