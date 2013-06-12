/*
Makey Makey Moon Man
Jenna deBoisblanc
June 2013
jdeboi.com
*/

/*
Instructions
- When the moon man moves his body, press the corresponding
pads
- The faster the player gets the correct body combination 
(relative to other players), the more points the player receives
- The player loses points if he/she hits a body part that isn't
highlighted.
- Press the 'r' key to restart the game.
*/

/////////////////////////////////////////////////////////////
//VARIABLES//////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

///////////UPDATE////////////////
int numPlayers = 6;
String[] names = {"Nyan Cat", "Pika", "Yoda", "Bill", "Peach", "Angry Bird"};
char[][] playerKeys = 
{ 
  // player 1: left hand, right hand, left foot, right foot
  {'z', 'x', 'c', 'v'},
  // player 2
  {'q', 'w', 'e', 'r'},
  // player 3 ...
  {'a', 's', 'd', 'f'},
  {'h', 'j', 'k', 'l'},
  {'1', '2', '3', '4'},
  {'5', '6', '7', '8'}
};
int winningScore = 100;
/////////////////////////////////

//////MAY NEED ADJUSTMENT////////
int penalty = numPlayers;
int reward = 4 * numPlayers;
/////////////////////////////////

Player[] players;
boolean [] bodyParts = new boolean[4];

// boolean states
boolean waiting = true;
boolean menu = true;

// time variables
int waitTime;
int playerCount = 0;

// position variables
int windowWidth = 1400;
int windowHeight = 780;
int playerSpacing = windowWidth / (numPlayers + 1);
int xPlayerOffset = playerSpacing/2;
int yPlayerOffset = 30;
int iconSize = (int) (playerSpacing/1.5);

// images
PImage moon;
PImage helmet;

// keys
char restartKey = '0';
char startKey = 'p';

// body variables
int helmetX = windowWidth/2 - 100;
int helmetY = 220;
int xOffset = windowWidth/2 + 50;
int yOffset = 350;
int bodyLength = 200;
int armHeight = 90;
int legHeight = bodyLength;
int footLen = 20;
int armLength = 100;
int legLength = 120;
int bodyStroke = 25;
int lineStroke = 4;

// body colors
color highlight = #C8FF52;
color stickColor = 230;
int lineColor = 215;


/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  size(windowWidth, windowHeight);
  
  // images
  helmet = loadImage("helmet.png");
  moon = loadImage("moon.jpg");
  
  // initialize some values
  playersInit();
  randomizeBody();
  randomizeTime();
}

/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(0);
  image(moon, 0, -140);
  if (menu) {
    drawMenu();
  }
  else {
    drawPlayers();
    if(waiting) {
      drawBody(false, false, false, false);
      if(millis() > waitTime) {
        waiting = false;
        playersReset();
      }
    }
    else {
      drawBody();
    }
  }
}

void drawMenu() {
  textSize(200);
  fill(highlight);
  text("MOON MAN", 100, 230);
  String s = "Press '" + startKey + "' to play";
  textSize(24);
  text(s, 150, 275);
  drawBody(false, false, false, false);
}

void drawPlayers() {
  for(int i = 0; i < numPlayers; i++) {
    players[i].display();   
  }
}

void drawBody() {
  drawBody(bodyParts[0], bodyParts[1], 
    bodyParts[2], bodyParts[3]);
}

void drawBody(boolean lh, boolean rh, boolean lf, boolean rf) {
  // body
  fill(255);
  stroke(stickColor);
  strokeWeight(bodyStroke);
  
  drawLeftHand(lh);
  drawRightHand(rh);
  drawLeftFoot(lf);
  drawRightFoot(rf);
  drawBodyStick();
  drawHelmet(); 
}

void drawLeftHand(boolean lh) {
  int deltaX;
  int deltaY;
  if (!lh) {
    stroke(stickColor);
    fill(stickColor);
    deltaX = 35;
    deltaY = (int) sqrt(armLength * armLength - deltaX * deltaX);
  }
  else {
    stroke(highlight);
    fill(highlight);
    deltaX = 95;
    deltaY = (int) sqrt(armLength * armLength - deltaX * deltaX);
  }
  strokeWeight(bodyStroke);  
  line(xOffset, yOffset + armHeight, xOffset - deltaX, yOffset + armHeight + deltaY);
  strokeWeight(lineStroke);
  stroke(lineColor);
  line(xOffset, yOffset + armHeight, xOffset - deltaX, yOffset + armHeight + deltaY);
}

void drawRightHand(boolean rh) {
  int deltaX;
  int deltaY;
  if (!rh) {
    stroke(stickColor);
    fill(stickColor);
    deltaX = 35;
    deltaY = (int) sqrt(armLength * armLength - deltaX * deltaX);
  }
  else {
    stroke(highlight);
    fill(highlight);
    deltaX = 95;
    deltaY = (int) sqrt(armLength * armLength - deltaX * deltaX); 
  }
  strokeWeight(bodyStroke);  
  line(xOffset, yOffset + armHeight, xOffset + deltaX, yOffset + armHeight + deltaY);
  strokeWeight(lineStroke);
  stroke(lineColor);
  line(xOffset, yOffset + armHeight, xOffset + deltaX, yOffset + armHeight + deltaY);
}

void drawLeftFoot(boolean lf) {
  int deltaX;
  int deltaY;
  if (!lf) {
    stroke(stickColor);
    fill(stickColor);
    // leg
    deltaX = 25;
    deltaY = (int) sqrt(legLength * legLength - deltaX * deltaX);
  }
  else {
    stroke(highlight);
    fill(highlight);
    // leg
    deltaX = 100;
    deltaY = (int) sqrt(legLength * legLength - deltaX * deltaX);
  }
  strokeWeight(bodyStroke);  
  line(xOffset, yOffset + legHeight, xOffset - deltaX, yOffset + legHeight + deltaY);
  strokeWeight(lineStroke);
  stroke(lineColor);
  line(xOffset, yOffset + legHeight, xOffset - deltaX, yOffset + legHeight + deltaY); 
}

void drawRightFoot(boolean rf) {
  int deltaX;
  int deltaY;
  if (!rf) {
    stroke(stickColor);
    fill(stickColor);
    deltaX = 25;
    deltaY = (int) sqrt(legLength * legLength - deltaX * deltaX);
  }
  else {
    stroke(highlight);
    fill(highlight);
    deltaX = 100;
    deltaY = (int) sqrt(legLength * legLength - deltaX * deltaX);
  } 
  strokeWeight(bodyStroke);  
  line(xOffset, yOffset + legHeight, xOffset + deltaX, yOffset + legHeight + deltaY);
  strokeWeight(lineStroke);
  stroke(lineColor);
  line(xOffset, yOffset + legHeight, xOffset + deltaX, yOffset + legHeight + deltaY);
}

void drawBodyStick() {
  strokeWeight(bodyStroke);
  stroke(stickColor);
  line(xOffset, yOffset, xOffset, yOffset + bodyLength);
  strokeWeight(lineStroke);
  stroke(lineColor);
  line(xOffset, yOffset, xOffset, yOffset + bodyLength);
}

void drawHelmet() {
  int h = 250;
  int w = (int) (h * 1.0/helmet.height * helmet.width);
  image(helmet, helmetX, helmetY, w, h);
}


/////////////////////////////////////////////////////////////
//KEYBOARD INPUT/////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void keyPressed() {
  if (key == restartKey) {
    restart();
  }
  else if (key == startKey) {
    playGame();
  }
  else if (key == 't') {
    saveFrame("line-######.png");
  }
  else if(!waiting) {
    for(int i = 0; i < numPlayers; i++) {
      if(!players[i].out && !players[i].complete) {
        if(players[i].playerKeyPressed(key)) {
          if(players[i].madeMistake()) {
            players[i].losePoints();
            playerCount++;
          }
          else if(players[i].complete()) {
            players[i].gainPoints();
            if(players[i].score >= winningScore) {
              finish(i + 1);
            }
            reward = reward - 4;
            playerCount++;
          }
        }
      }
      if(playerCount == numPlayers) {
        nextBody();
      }
    }
  }
}


/////////////////////////////////////////////////////////////
//OTHER FUNCTIONS////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void playersInit() {
  players = new Player[numPlayers];
  for(int i = 0; i < numPlayers; i++) {
    int x = xPlayerOffset + i * playerSpacing;
    players[i] = new Player(i + 1, names[i], x, yPlayerOffset, 
      playerKeys[i][0], playerKeys[i][1],playerKeys[i][2], playerKeys[i][3]);
  }
}

void playersReset() {
  for(int i = 0; i < numPlayers; i++) {
    players[i].reset();
  }
}


// game state change functions ///////////////
void playGame() {
  menu = false;
  waiting = true;
  randomizeBody();
  randomizeTime();
}

void nextBody() {
  waiting = true;
  reward = numPlayers * 4;
  playerCount = 0;
  randomizeTime();
  randomizeBody();
}

void restart() {
  loop();
  for(int i = 0; i < numPlayers; i++){
    players[i].restart();
  }
  menu = true;
}

void finish(int num) {
  background(0);
  image(moon, 0, 0);
  fill(255);
  textSize(50);
  text("Player " + num + " wins!", 80, 190);
  textSize(25);
  text("Press 'r' to restart", 80, 230);
  for(int i = 0; i < numPlayers; i++) {
    players[i].display();
  }
  noLoop();
}

// randomize functions ///////////////////////
void randomizeBody() {
  // bodyPart[0] - left hand
  // bodyPart[1] - right hand
  // bodyPart[2] - left foot
  // bodyPart[3] - right foot
  int check = 0;
  for(int i = 0; i < 4; i++) {
    int b = (int) random(2);
    if(b == 1) {
      bodyParts[i] = true;
    }
    else{
      bodyParts[i] = false;
      check++;
    }
  }
  // make sure at least one body part is highlighted
  if(check == 4) {
    randomizeBody();
  }
}

void randomizeTime() {
  waitTime = millis() + 10 * (int) random(100, 400);
}

 
 
  
