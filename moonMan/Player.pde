class Player {
  
  int number;
  String name;
  int score;
  int xpos;
  int ypos;
  char[] playerKeys;
  boolean[] playerBody = {false, false, false, false};
  boolean out;
  boolean complete;
  PImage icon;
  int scoreYOffset = 130;
  int scoreXOffset = 10;
  
  Player(int num, String na, int xp, int yp, char lh, char rh, char lf, char rf) {
    number = num;
    name = na;
    xpos = xp;
    ypos = yp;
    //playerKeys = new Int[4];
    playerKeys = new char[4];
    playerKeys[0] = lh;
    playerKeys[1] = rh;
    playerKeys[2] = lf;
    playerKeys[3] = rf;
    score = 0;
    out = false;
    complete = false;
    icon = loadImage("/players/" + number + ".png");
  }
  
  void restart() {
    score = 0;
    reset();
  }
  
  boolean playerKeyPressed(char k) {
    for(int i = 0; i < 4; i++) {
      if(k == playerKeys[i]) {
        playerBody[i] = true;
        return true;
      }
    }
    return false;
  }
  
  boolean madeMistake() {
    for(int i = 0; i < 4; i++) {
      if(!bodyParts[i] && playerBody[i]){
        out = true;
        return true;
      }
    }
    return false;
  }
  
  boolean complete() {
    for(int i = 0; i < 4; i++) {
      if(bodyParts[i] != playerBody[i]){
        return false;
      }
    }
    complete = true;
    return complete;
  }

  void display() {
    if(out) {
      stroke(255);
      fill(255, 0, 0);
    }
    else if(complete) {
      stroke(255);
      fill(0, 255, 0);
    }
    else {
      stroke(0);
      fill(0);
    }
    noStroke();  
    rect(xpos, ypos, playerSpacing, iconSize + 1.5 * iconSize);
    int h;
    int w;
    if(icon.height > icon.width) {
      h = iconSize;
      w = (int) (iconSize * 1.0 /icon.height * icon.width);
    }
    else {
      h = (int) (iconSize * 1.0 /icon.width * icon.height);
      w = iconSize;
    }
    int x = xpos + (playerSpacing - w)/2;
    image(icon, x, ypos + 10, w, h);
 
    // draw score
    fill(255);   
    textSize(24);
    text(score, xpos + scoreXOffset, ypos + scoreYOffset);
  }
  
  void reset() {
    for(int i = 0; i < 4; i++) {
      playerBody[i] = false;
    }
    out = false;
    complete = false; 
  }
  
  void losePoints() {
    score = score - penalty;
  }
  
  void gainPoints() {
    score = score + reward;
  }
}
