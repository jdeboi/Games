/*
Makey Makey Quiz Bowl
Jenna deBoisblanc
5/23/13
jdeboi.com

Instructions:
1. update the variables in the 'update' section
2. press 'n' to restart the game
3. press 'r' if the player gets the right answer
4. press 'w' if the player get the wrong answer
5. press 'q' to advance to the next question
*/

///////////UPDATE////////////////
int numPlayers = 6;
int correctPoints = 5;
int incorrectPoints = -3;
char[] playerKeys = {'a', 's', 'd', 'f', 'g', 'h'};
String[] playerNames = 
{
  "Obama", "Palin", "Oprah", 
  "Einstein", "Santa", "Beyonce"
};
String[] questions = {
  "What is the capital of Louisiana?",
  "Name the 7 continents.",
  "What color is the sky?",
  "Who is the US president?"
};
/////////////////////////////////

Player[] players;
boolean buzzed = false;
boolean finished = false;
int playerBuzzed;
int currentQuestion;
int xOffset = 100;
int yOffset = 200;
int windowWidth = 1200;
int windowHeight = 600;
PImage chalkboard;
PImage cfl;
PImage cflLit;
int questionTextSize = 40;
int lineWidth = (windowWidth - 200) / (questionTextSize / 2);
int playerSpacing = windowWidth / (numPlayers + 1);
int cflScale = playerSpacing;
int xPlayerOffset = playerSpacing/2;
int yPlayerOffset = 250;

void setup() {
  size(windowWidth, windowHeight);
  
  // load images
  chalkboard = loadImage("blackboard.jpeg");
  cfl = loadImage("cfl0.png");
  cflLit = loadImage("cfl1.png");
  
  // initialize players
  players = new Player[numPlayers];
  for(int i = 0; i < numPlayers; i++) {
    /*
    int xpos = (width - xOffset) / 4 * (i % 4) + xOffset/2;
    int rows = ((int) (numPlayers / 4)) + 1;
    int rowHeight = (height - yOffset) / rows;
    int ypos = ((int) i / 4) * rowHeight + yOffset;
    */
    int xpos = xPlayerOffset + i * playerSpacing;
    int ypos = yPlayerOffset;
    players[i] = new Player(xpos, ypos, playerKeys[i], playerNames[i]);
  }
}

void draw() {
  background(120);
  image(chalkboard, 0, 0);
  for(int i = 0; i < numPlayers; i++) {
    players[i].display();
  }
  if (!finished) {
    if(questions.length != 0){
      drawQuestion(questions[currentQuestion], 100, 100);
    }
  }
  else {
    text(playerNames[playerBuzzed] + " wins!", 100, 100);
    textSize(20);
    text("Press 'n' to restart.", 100, 130);
  }
}

void drawQuestion(String q, int x, int y) {
  textSize(questionTextSize);
  if(q.length() > lineWidth) {
    int i = lineWidth;
    while(i > 0) {
      if(q.charAt(i) == ' ') {
        break;
      }
      i--;
    }
    if(i == 0) {
      text(q, x, y);
    }
    else {
      String one = q.substring(0, i);
      String two = q.substring(i + 1);
      text(one, x, y);
      drawQuestion(two, x, y + questionTextSize + 5);
    }
  }
  else {
    text(q, x, y);
  }
}

void keyPressed() {
  if (key == 'n') {
      restart();
  }
  else if(!finished) {
    if (buzzed) {
      // if the player answered correctly
      if (key == 'r') {
        players[playerBuzzed].updateScore(correctPoints);
        players[playerBuzzed].buzzer();
        buzzed = false;
        currentQuestion++;
        if(currentQuestion == questions.length) {
          finished = true;
        }
      }
      // if the player answered incorrectly
      else if (key == 'w') {
        players[playerBuzzed].updateScore(incorrectPoints);
        players[playerBuzzed].buzzer();
        buzzed = false;
      }
    }
    else if (key == 'q') {
      currentQuestion++;
      if(currentQuestion == questions.length){
        currentQuestion = 0;
      }
    }
    // to restart the game and reset keys
    else {
      for(int i = 0; i < numPlayers; i++) {
        if(key == playerKeys[i]) {
          playerBuzzed = i;
          players[playerBuzzed].buzzer();
          buzzed = true;    
        }
      }
    }
  }
}

void restart() {
  for(int i = 0; i < numPlayers; i++) {
    players[i].restart();
  }
  buzzed = false;
  currentQuestion = 0;
  finished = false;
}

  
