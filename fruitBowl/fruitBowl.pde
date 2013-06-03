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
  "Who is the US President?",
  "What is JZ's favorite color?", 
  "What is the highest number to which a human has counted?"
};
/////////////////////////////////

Player[] players;
boolean buzzed = false;
boolean finished = false;
boolean tie = false;
boolean answered = false;
int playerBuzzed;
int currentQuestion;
int xOffset = 100;
int yOffset = 200;
int windowWidth = 1200;
int windowHeight = 600;
PImage fruitBowl;
PImage cfl;
PImage cflLit;
int questionTextSize = 40;
int lineWidth = (windowWidth - 200) / (questionTextSize / 2);
int playerSpacing = 160;
int cflScale;
int xPlayerOffset;
int yPlayerOffset;
int scoreHeight = 60;
int winner;

/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  size(windowWidth, windowHeight);
  
  // setup constants
  if(numPlayers > 4) {
    playerSpacing = windowWidth / (numPlayers + 1);
  }
  cflScale = playerSpacing * 2 / 3;
  xPlayerOffset = (windowWidth - playerSpacing * numPlayers)/2;
  yPlayerOffset = 250;
  
  // load images
  fruitBowl = loadImage("fruitbowl.jpg");
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
    players[i] = new Player(i + 1, xpos, ypos, playerKeys[i], playerNames[i]);
  }
}


/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(255);
  image(fruitBowl, 0, 30);
  for(int i = 0; i < numPlayers; i++) {
    players[i].display();
  }
  
  if (!finished) {
    if(questions.length != 0){
      fill(0);
      stroke(0);
      drawQuestion(questions[currentQuestion], 300, 150);
    }
  }
  else {
    textSize(30);
    fill(0);
    stroke(0);
    if(!tie) {
      text(playerNames[winner] + " wins!", 300, 100);
    }
    else {
      text("Tie game!", 300, 100);  
    }
    textSize(20);
    text("Press 'n' to restart.", 300, 150);
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

/////////////////////////////////////////////////////////////
//KEYBOARD INPUT/////////////////////////////////////////////
/////////////////////////////////////////////////////////////
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
        answered = true;
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
      answered = false;
      if(currentQuestion == questions.length){
        currentQuestion = 0;
        finished = true;
        setWinner();
      }
    }
    // to restart the game and reset keys
    else if (!answered) {
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


/////////////////////////////////////////////////////////////
//OTHER FUNCTIONS////////////////////////////////////////////
/////////////////////////////////////////////////////////////
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
  

  
