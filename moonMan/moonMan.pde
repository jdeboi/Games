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

/*
Thoughts
- get points by being the first to follow instructions
and lose points if you mess up. win when player gets to 
certain score

- pass level by responding in a certain time frame, 
which gets shorter and shorter over time

- first player presses an input. next player repeats input
and adds an additional input. if player messes up, removed 
from the contest. continues until there is one player 
remaining

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

boolean [] bodyParts = new boolean[4];
Player[] players;
boolean waiting;
int waitTime;
int playerCount = 0;
int windowWidth;
int windowHeight;
int playerSpacing;
int xPlayerOffset;
int yPlayerOffset;
int iconSize;
PImage moon;
PImage helmet;


/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  // load helmet image
  helmet = loadImage("helmet.png");
  // load background image
  moon = loadImage("moon.jpg");
  windowWidth = moon.width;
  windowHeight = moon.height + 150;
  
  // variables to align character images
  playerSpacing = windowWidth / (numPlayers + 1);
  iconSize = (int) (playerSpacing/1.5);
  xPlayerOffset = playerSpacing/2;
  yPlayerOffset = moon.height;
  
  size(windowWidth, windowHeight);
  
  // initialize the players
  players = new Player[numPlayers];
  for(int i = 0; i < numPlayers; i++) {
    int x = xPlayerOffset + i * playerSpacing;
    players[i] = new Player(i + 1, names[i], x, yPlayerOffset, 
      playerKeys[i][0], playerKeys[i][1],playerKeys[i][2], playerKeys[i][3]);
  }
  
  // randomize the moon man's body position
  randomizeBody();
  // randomize the time until the new position is drawn
  randomizeTime();
  // wait for a period of time before drawing the moon man
  waiting = true;
}

/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(0);
  image(moon, 0, 0);
  for(int i = 0; i < numPlayers; i++) {
    players[i].display();
  }
  if(waiting) {
    drawBody(false, false, false, false);
    if(millis() > waitTime) {
      waiting = false;
      for(int i = 0; i < numPlayers; i++) {
        players[i].reset();
      }
    }
  }
  else {
    drawBody();
  }
  int h = 170;
  int w = (int) (h * 1.0/helmet.height * helmet.width);
  image(helmet, width/2 - h/2 -20, 50, w, h);
}

void drawBody() {
  drawBody(bodyParts[0], bodyParts[1], 
    bodyParts[2], bodyParts[3]);
}

void drawBody(boolean lh, boolean rh, boolean lf, boolean rf) {
  int xOffset = width/2;
  int yOffset = 100;
  int bodyLength = 200;
  int highlight = 255;
  int stickColor = 0;
  // body
  fill(255);
  stroke(stickColor);
  strokeWeight(10);
  line(xOffset, yOffset, xOffset, yOffset + bodyLength);
  
  /*
  // head
  ellipseMode(CENTER);
  ellipse(xOffset, yOffset, 100, 100);
  // face
  strokeWeight(6);
  ellipse(xOffset - 10, yOffset, 10, 10);
  ellipse(xOffset + 10, yOffset, 13, 13);
  line(xOffset - 14, yOffset + 20, xOffset + 7, yOffset + 20);
  */
  
  strokeWeight(10);
  // left hand
  int armHeight = 80;
  int legHeight = bodyLength;
  int footLen = 20;
 
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
}


/////////////////////////////////////////////////////////////
//KEYBOARD INPUT/////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void keyPressed() {
  if (key == 'r') {
    restart();
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
  
  
