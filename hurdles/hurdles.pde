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
String[] playerNames = {"Jenna", "Ian", "Cecilia", "Ben", "Katie", "Marc"};
char[] leftKey = {'z', 'j', 'n', 'c', 'g', 'o'};
char[] rightKey = {'x', 'k', 'm', 'v', 'h', 'p'};
int[] numCharacterImages = {12, 8, 5, 8, 3, 3};
int windowWidth = 1200;
int windowHeight = 800;
/////////////////////////////////

//////MAY NEED ADJUSTMENT////////
int fallDownStall = 80;
int jumpThreshold = 300;
int jumpLength = 100;
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

// Track variables
int yTopOffset = 200;
int yBottomOffset = 100;
int numLanes = 6;
int trackHeight = windowHeight - yTopOffset - yBottomOffset;
int laneHeight = trackHeight / numLanes;
int xStartOffset = 70;
int xNumberOffset = xStartOffset + 30;

// scoreboard variables
int countX = 150;
int countY = 100;
int scoreX = 70;
int scoreY = 30;
int scoreW = windowWidth /2;
int scoreH = yTopOffset - scoreY - 70;

/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  size(windowWidth, windowHeight);
  hurdles = new int[numHurdles];
  sprinters = new Sprinter[numSprinters];
  finished = new int[numSprinters];
  for(int i = 0; i < numSprinters; i++) {
    int yp = yTopOffset + laneHeight * i - 30;
    sprinters[i] = new Sprinter(0, yp, playerNames[i], leftKey[i], rightKey[i], numCharacterImages[i]);
  }
  f = createFont("Arial", 80, true);
  setHurdles();
}

/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(120);
  drawTrack();
  drawHurdles();
  drawScoreBoard();
  drawFinishLine();
  for (int i = 0; i < numSprinters; i++) {
    sprinters[i].display();
  }
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
  fill(#D35226);
  noStroke();
  rect(0, yTopOffset, width, trackHeight);
  // lane lines
  strokeWeight(5);
  stroke(255);
  fill(255);
  for(int i = 0; i <= numLanes; i++) {
    line(0, yTopOffset + i * laneHeight, width, yTopOffset + i * laneHeight);
  }
  // starting line
  stroke(255);
  strokeWeight(10);
  line(xStartOffset, yTopOffset, xStartOffset, trackHeight + yTopOffset - 1);
  // lane numbers
  textFont(f);
  for(int i = 1; i <= numLanes; i++) {
    text(i, xNumberOffset, yTopOffset + i * laneHeight);
  }
}

void drawHurdles() {
  for(int i = 0; i < numLanes; i++) {
    for(int j = 0; j < numHurdles; j++) {
      int legLength = 20;
      int stubLength = 15;
      int xback = (int) (hurdles[j] * 1.0 /trackLength * width);
      int xfront = xback + 30;
      int yback = yTopOffset + laneHeight * i - legLength;
      int yfront = yback + laneHeight;
      fill(0, 0, 255);
      stroke(0);
      strokeWeight(5);
      
      line(xback, yback, xback, yback + legLength);
      line(xback, yback + legLength, xback + stubLength, yback + legLength - 3);
      
      line(xback, yback, xfront, yfront);
      stroke(#FFF276);
      line(xback, yback - 5, xfront, yfront - 5);
      stroke(0);
      line(xback, yback - 10, xfront, yfront - 10);
      
      line(xfront, yfront, xfront, yfront + legLength);
      line(xfront, yfront + legLength, xfront + stubLength, yfront + legLength - 3);
    }
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
  int hurdleSpacing = trackLength / (numHurdles + 1);
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

