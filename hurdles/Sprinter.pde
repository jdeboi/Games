
class Sprinter {
  
  int x;
  int y;
  String name;
  char leftKey;
  char rightKey;
  
  // step variables
  int steps;
  float position;
  boolean leftDown;
  boolean rightDown;
  boolean recorded;
  
  // jumping variables
  boolean airborne;
  int airTime;
  boolean jumping;
  int jumpCount;
  int jumpHeight;
  
  // hurdle variables
  int currentHurdle;
  boolean fallDown;
  int fallDownCount;
  
  // images
  PImage[] images;
  int numImages;
  int imgw;
  int frame;
  int frameMultiplier;
  
  Sprinter(int xp, int yp, String n, char l, char r, int ni) {
    x = xp;
    y = 0;
    name = n;
    leftKey = l;
    rightKey = r;
    
    steps = 0;
    position = 0;
    airTime = 0;
    currentHurdle = 0;
    
    leftDown = true;
    rightDown = true;
    airborne = false;
    
    frameMultiplier = 1;
    jumpHeight = 60;
  
    numImages = ni;
    loadImages();
  }
  
  /////////////////////////////////////////////////////////////
  //DISPLAY SPRINTER///////////////////////////////////////////
  /////////////////////////////////////////////////////////////  
  void display() {
    // image 0 - fall down
    // image 1 - jump
    // image 2 - standing still (first image of run cycle)
    float xpos = width * 1.0 / trackLength * position - imgw;
    if(!raceStarted) {
      image(images[2], xpos, y, imgw, sprinterHeight);
    }
    else if (fallDown){
      int wc = cloud.width * sprinterHeight / cloud.height;
      int wp = images[0].width * sprinterHeight / images[0].height;
      image(cloud, xpos, y - 2 * jumpHeight, wc, sprinterHeight);
      image(images[0], xpos, y - jumpHeight, wp, sprinterHeight); 
    }
    else if(jumping) {
      int wp = images[1].width * sprinterHeight / images[1].height;
      image(images[1], xpos, y - jumpHeight, wp, sprinterHeight);
    }
    else {
      image(images[frame/frameMultiplier], xpos, y, imgw, sprinterHeight);
    }
    frame++;
    if(frame == numImages * frameMultiplier) {
      frame = 2 * frameMultiplier;
    }
  }
  
  void display(int xpos, int ypos) {
    image(images[2], xpos, ypos - sprinterHeight, imgw, sprinterHeight);
  }
  
  /*
  // in case I decide to use speed
  void displaySpeedometer() {
    fill(200);
    strokeWeight(1);
    stroke(0);
    rect(x, y + 180, 100, 30);
    float s = speed * 100.0;
    fill(255, 249, 45);
    rect(x, y + 180, s, 30);
  }
  */
  
  /////////////////////////////////////////////////////////////
  //CHECK INPUTS///////////////////////////////////////////////
  /////////////////////////////////////////////////////////////
  void checkPressed(char k) {
    if(k == leftKey){
      airborne = false;
      if(steps % 2 == 0) {
        leftDown = true;
        step();
      } 
    }
    else if(k == rightKey){
      airborne = false;
      if(steps % 2 == 1) {
        rightDown = true;
        step();
      }
    }
  }
  
  void checkReleased(char k) {
    if(k == leftKey) {
      leftDown = false;
      if(!rightDown) {
        airTime = millis();
        airborne = true;
      }
    }
    else if (k == rightKey) {
      rightDown = false;
      if(!leftDown) {
        airTime = millis();
        airborne = true;
      }
    }
  }
  
  /////////////////////////////////////////////////////////////
  //UPDATE POSITION////////////////////////////////////////////
  /////////////////////////////////////////////////////////////
  void move() {
    updatePosition();
    updateHurdle();
    updateJumping();
  }
  
  void updatePosition() {
    if (fallDown) {
      if(position <= hurdles[currentHurdle] + ratio * (hurdleWidth/2 + sprinterWidth)){
        position+= fallSize;
      }
      else {
        fallDown = false;
      }
    }
    else if (jumping) {
      position+=jumpSize;
    }
    else {
      position+=cycleSize;
    }
  }
  
  void updateJumping() {
    if (!jumping && airborne) {
      if (getAirTime() < jumpThreshold) {
        jumping = false;
        jumpCount = 0;
      }
      else if (getAirTime() > jumpThreshold && jumpCount < jumpLength) {
        jumping = true;
      }
      else {
        jumping = false;
      }
    }
    else if(jumping) {
      jumpCount++;
      if(jumpCount > jumpLength) {
        jumping = false;
      }
    }
  }
 
  void updateHurdle() {
    if(position < trackLength) {
      if(hitHurdle()) {
        fallDown();
      }
    }
  }
  
  /////////////////////////////////////////////////////////////
  //OTHER FUNCTIONS////////////////////////////////////////////
  /////////////////////////////////////////////////////////////
  void step() {
    airborne = false;
    if(!jumping && !fallDown) {
      steps++;
      position+=stepSize;
    }
  }
  
  void fallDown() {
    fallDown = true;
    fallDownCount = 0;
  }
  
   void restart() {
    leftDown = true;
    rightDown = true;
    airborne = false;
    airTime = 0;
    //hurdleNum = 0;
    position = 0;
    //speed = 0;
    recorded = false;
  }
  
  int getAirTime() {
    if(airborne) {
      return millis() - airTime;
    }
    else {
      return 0;
    }
  }
  
  boolean atHurdle() {
    for(int i = 0; i < numHurdles; i++) {
      if(position > hurdles[i] - ratio * (hurdlePadding + hurdleWidth/2)
        && position < hurdles[i] + ratio * (hurdleWidth/2 + sprinterWidth)) {
          currentHurdle = i;
          return true;
      }
    }
    return false;
  }
  
  boolean hitHurdle() {
    return (!jumping && atHurdle());
  }
  
  boolean isFinished() {
    if(!recorded) { 
      if(position > trackLength){
        recorded = true;
        return true;
      }
      else {
        return false;
      }
    }
    else {
      return false;
    }
  }
  
  int percentComplete() {
    if (position <= trackLength) {
      return (int) (position / trackLength * 100.0);
    }
    else {
      return 100;
    }
  }

  void loadImages() {
    playerIndex++;
    images = new PImage[numImages];
    for(int i = 0; i < numImages; i++) {
      String imageName = "/player" + playerIndex + "/" + i + ".png";
      images[i] = loadImage(imageName);
    }
    imgw = (int) (images[2].width * 1.0 * sprinterHeight / images[2].height);
  }
}
    
