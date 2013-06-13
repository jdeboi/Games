/*
Makey Makey Fruit Bowl
Jenna deBoisblanc
5/23/13
jdeboi.com

Instructions:
1. update the variables in the 'update' section
2. press 'n' to restart the game
3. press 'r' if the player gets the right answer
4. press 'w' if the player get the wrong answer
5. press 'q' to advance to the next question
Game ends when there are no more questions. 
*/

///////////UPDATE////////////////
int numPlayers = 7;
int correctPoints = 500;
int incorrectPoints = -300;
char[] playerKeys = {'a', 's', 'd', 'f', 'g', 'h', 'j'};
String[] playerNames = 
{
  "Obama", "Palin", "Oprah", 
  "Einstein", "Tina", "Beyonce", 
  "Chuck"
};
String[] questions = {
  "Where is Russia?",
  "Kamala Harris is ________.",
  "What's the biggest number to which a human has counted?"
};
// keys
char startKey = 'p';
char nextKey = startKey;
char wrongKey = 'w';
char correctKey = 'r';
char restartKey = 'n';
/////////////////////////////////

Player[] players;

// images
PImage fruitBowl;
PImage cfl;
PImage cflLit;
int cflScale;

// boolean state variables
boolean buzzed = false;
boolean finished = false;
boolean tie = false;
boolean answered = false;
boolean menu = true;

// index variables
int playerBuzzed;
int currentQuestion;
int winner;

// text size
int questionTextSize = 80;
int smallText = 30;
int medText = 80;
int largeText = 160;

// display variables
int xOffset = 100;
int yOffset = 200;
int windowWidth = 1400;
int windowHeight = 780;
int lineWidth = (windowWidth - 500) / (questionTextSize / 2);
int playerSpacing = 180;
int xPlayerOffset;
int yPlayerOffset;
int questionHeight = 180;
int scoreHeight = 60;


/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  
  size(windowWidth, windowHeight);
  
  // setup position variables
  if(numPlayers > 4) {
    playerSpacing = windowWidth / (numPlayers + 1);
  }
  cflScale = playerSpacing * 2 / 3;
  xPlayerOffset = (windowWidth - playerSpacing * numPlayers)/2;
  yPlayerOffset = 250;
  
  // load images
  fruitBowl = loadImage("/images/fruitbowl.jpg");
  cfl = loadImage("/images/cfl0.png");
  cflLit = loadImage("/images/cfl1.png");
  
  // initialize players
  players = new Player[numPlayers];
  for(int i = 0; i < numPlayers; i++) {
    int xpos = xPlayerOffset + i * playerSpacing;
    int ypos = yPlayerOffset;
    players[i] = new Player(i + 1, xpos, ypos, playerKeys[i], playerNames[i]);
  }
}


/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(255);
  // start screen with logo
  if(menu) {
    drawMenu();
  }
  else {
    drawPlayers();
    if (!finished) {
      if(questions.length != 0){
        drawQuestion(questions[currentQuestion], 300, questionHeight);
      }
    }
    else {
      drawFinish();
    }
  }
}

void drawMenu() {
  image(fruitBowl, 50, 230);
  fill(0);
  stroke(0);
  textSize(largeText);
  text("fruit bowl", 370, 400);
  textSize(smallText);
  String s = "Press '" + startKey + "' to play";
  text(s, 470, 480);
}

void drawPlayers() {
  image(fruitBowl, 0, 100);
  for(int i = 0; i < numPlayers; i++) {
    players[i].display();
  }
}

void drawQuestion(String q, int x, int y) {
  fill(0);
  stroke(0);
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

void drawFinish() {
  textSize(medText);
  fill(0);
  stroke(0);
  if(!tie) {
    text(playerNames[winner] + " wins!", 300, questionHeight);
  }
  else {
    text("Tie game!", 300, questionHeight);  
  }
  textSize(smallText);
  String s = "Press '" + restartKey + "' to restart";
  text(s, 340, questionHeight + 50);
}

/////////////////////////////////////////////////////////////
//KEYBOARD INPUT/////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void keyPressed() {
  if (menu) {
    if (key == startKey) {
      menu = false;
    }
  }
  else if (key == restartKey) {
      restart();
  }
  
  else if(!finished) {
    // if a player has already buzzed, host decides
    // if he/she is right or wrong
    if (buzzed) {
      if (key == correctKey) {
        correctAnswer();
      }
      else if (key == wrongKey) {
        wrongAnswer();
      }
    }
    
    // perhaps the host would like to move to the next question
    else if (key == nextKey) {
      nextQuestion();
      println("works?");
    }
    
    // if not previously buzzed and if the correct answer hasn't
    // been provided, check to see if a player buzzed in
    else if (!answered) {
      checkPlayerKeys();
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
  menu = true;
}


/////////////////////////////////////////////////////////////
//OTHER FUNCTIONS////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void correctAnswer() {
  players[playerBuzzed].updateScore(correctPoints);
  players[playerBuzzed].buzzer();
  buzzed = false;
  answered = true;
}

void wrongAnswer() {
  players[playerBuzzed].updateScore(incorrectPoints);
  players[playerBuzzed].buzzer();
  buzzed = false;
}

void nextQuestion() {
  currentQuestion++;
  answered = false;
  if(currentQuestion == questions.length){
    currentQuestion = 0;
    finished = true;
    setWinner();
  }
}

void checkPlayerKeys() {
  for(int i = 0; i < numPlayers; i++) {
    if(key == playerKeys[i]) {
      playerBuzzed = i;
      players[playerBuzzed].buzzer();
      buzzed = true;    
    }
  }
}

void setWinner() {
  winner = 0;
  tie = false;
  for(int i = 1; i < numPlayers; i++) {
    if (players[i].score > players[winner].score) {
      winner = i;
      tie = false;
    }
    else if (players[i].score == players[winner].score) {
      tie = true;
    }
  }
}
  

  
