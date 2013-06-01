int numPlayers = 2;
int[] steps;
int trackLength = 100;
PImage left;
PImage right;
boolean raceStarted = false;
boolean countStarted = false;
int startClock = 0;

void setup() {
  size(600, 600);
  steps = new int[numPlayers];
  left = loadImage("left.png");
  right = loadImage("right.png");
}

void draw() {
  background(120);
  if (countStarted) {
    if (millis() - startClock < 3001){
      int time = 3 - (millis() - startClock)/1000;
      text(time, 200, 200);
    }
    else {
      raceStarted = true;
      countStarted = false;
    }
  }
  if (raceStarted) {
    // player1
    if(steps[0] % 2 == 0){
      image(left, 0, 0);
    }
    else {
      image(right, 0, 0);
    }
    
    // player2
    if(steps[1] % 2 == 0){
      image(left, 0, height/numPlayers);
    }
    else {
      image(right, 0, height/numPlayers);
    }
    status();
    text(steps[0], 400, 100);
    text(steps[1], 400, 300);
  }  
}

void keyPressed() {
  if (raceStarted) {
    if (key == 'd'){
      if(steps[0] % 2 == 1){
        steps[0]++;
        if(steps[0] == trackLength){
          finish(1);
        }
      }
    }
    else if (key == 'f'){
      if(steps[0] % 2 == 0){
        steps[0]++;
        if(steps[0] == trackLength){
          finish(1);
        }
      }
    }
    else if (key == 'j'){
      if(steps[1] % 2 == 1){
        steps[1]++;
        if(steps[1] == trackLength){
          finish(2);
        }
      }
    }
    else if (key == 'k'){
      if(steps[1] % 2 == 0){
        steps[1]++;
        if(steps[1] == trackLength){
          finish(2);
        }
      }
    }
  }
  else if (key == 's') {
    loop();
    countStarted = true;
    startClock = millis();
  }
}



void finish(int player){
  background(120);
  String message = "Player " + player + " wins!";
  text(message, 100, 100);
  for(int i = 0; i < steps.length; i++){
    steps[i] = 0;
  }
  raceStarted = false;
  noLoop();
}


void status() {
  fill(255, 0, 0);
  rect(0, 100, width, 50);
  fill(0, 255, 0);
  rect(0, 100, width*steps[0]/trackLength, 50);
  
  fill(255, 0, 0);
  rect(0, 400, width, 50);
  fill(0, 255, 0);
  rect(0, 400, width*steps[1]/trackLength, 50);
}


