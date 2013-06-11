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
  {'u', 'i', 'o', 'p'},
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
int playerSpacing;
int xPlayerOffset;
int yPlayerOffset;
int iconSize;

// images
PImage moon;
PImage helmet;

// keys
char restartKey = 'r';
char startKey = '0';

// body variables
color highlight = #C8FF52;
color stickColor = 220;
int xOffset;
int yOffset = 100;
int bodyLength = 200;
int armHeight = 80;
int legHeight = bodyLength;
int footLen = 20;


/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  // images
  helmet = loadImage("helmet.png");
  moon = loadImage("moon2.jpg");
  
  // position variables
  //windowWidth = moon.width;
  //windowHeight = moon.height + 150;
  playerSpacing = windowWidth / (numPlayers + 1);
  iconSize = (int) (playerSpacing/1.5);
  xPlayerOffset = playerSpacing/2;
  yPlayerOffset = moon.height;
  xOffset = windowWidth/2;
  
  size(windowWidth, windowHeight);
  
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
  image(moon, 0, 0);
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
  text("MOON MAN", 100, 220);
  String s = "Press '" + startKey + "' to play";
  textSize(24);
  text(s, 140, 200);
  drawBody(false, false, false, false);
  drawPlayers();
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
  strokeWeight(10);
  line(xOffset, yOffset, xOffset, yOffset + bodyLength);
  
  strokeWeight(10);
  // left hand
  if (!lh) {
    stroke(stickColor);
    fill(stickColor);
    line(xOffset, yOffset + armHeight, xOffset - 25, yOffset + armHeight + 60);
  }
  else {
    stroke(highlight);
    fill(highlight);
    line(xOffset, yOffset + armHeight, xOffset - 90, yOffset + armHeight);
  }
  
  // right hand
  if (!rh) {
    stroke(stickColor);
    fill(stickColor);
    line(xOffset, yOffset + armHeight, xOffset + 25, yOffset + armHeight + 60);
  }
  else {
    stroke(highlight);
    fill(highlight);
    line(xOffset, yOffset + armHeight, xOffset + 90, yOffset + armHeight);
  }
  
  // left leg/foot
  if (!lf) {
    stroke(stickColor);
    fill(stickColor);
    // leg
    line(xOffset, yOffset + legHeight, xOffset - 25, yOffset + legHeight + 60);
    // foot
    line(xOffset - 25, yOffset + legHeight + 60, xOffset - 25 - footLen, 
      yOffset + legHeight + 60);  
}
  else {
    stroke(highlight);
    fill(highlight);
    // leg
    line(xOffset, yOffset + legHeight, xOffset - 90, yOffset + legHeight+ 30);
  }
  
  // right leg/foot
  if (!rf) {
    stroke(stickColor);
    fill(stickColor);
    line(xOffset, yOffset + legHeight, xOffset + 25, yOffset + legHeight + 60);
  }
  else {
    stroke(highlight);
    fill(highlight);
    line(xOffset, yOffset + legHeight, xOffset + 90, yOffset + legHeight + 30);
  } 
  drawHelmet(); 
}

void drawHelmet() {
  int h = 170;
  int w = (int) (h * 1.0/helmet.height * helmet.width);
  image(helmet, width/2 - h/2 -20, 50, w, h);
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

void playGame() {
  menu = false;
  waiting = true;
  randomizeBody();
  randomizeTime();
}

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
 
 
  
