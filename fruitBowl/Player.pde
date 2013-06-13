class Player {
  
   int number;
   int x;
   int y;
   int score;
   char letter;
   String name;
   boolean lit;
   PImage icon;
   
   Player(int num, int xp, int yp, char l, String n) {
     number = num;
     x = xp;
     y = yp;
     score = 0;
     letter = l;
     name = n;
     lit = false;
     icon = loadImage("/players/" + number + ".png");
   }
   
   void display() {
     fill(255);
     stroke(255);
     strokeWeight(4);
     
     // bulb
     int xp = x + (playerSpacing - 
       ((int) (cflScale * 1.0 * cflLit.width / cflLit.height))) /2;
     int yp = windowHeight - playerSpacing - scoreHeight - cflScale;
     displayBulb(xp, yp);
    
    // score + name
     yp = yp + cflScale;
     displayScore(x, yp);
     
     // icon
     yp = yp + scoreHeight;
     displayIcon(x, yp, playerSpacing); 
     
     
     
   }
   
   void displayBulb(int xp, int yp) {
     int w = (int) (cflScale * 1.0 * cflLit.width / cflLit.height);
     if(lit) {
        image(cflLit, xp, yp, w, cflScale);
     }
     else {  
       image(cfl, xp, yp, w, cflScale);
     }
   }
   
   void displayIcon(int xp, int yp, int dim) {
     noStroke();
     fill(255);
     rect(xp, yp, dim, dim);
     image(icon, xp, yp, dim, dim);
     stroke(0);
     noFill();
     rect(xp, yp, dim, dim);
   }
   
   void displayScore(int xp, int yp) {
     // background
     fill(0);
     stroke(0);
     rect(xp, yp, playerSpacing, scoreHeight);
     
     // name
     fill(255);
     textSize(20);
     text(name, xp + 5, yp + 25);
     
     // score
     textSize(20);
     text("$" + score, xp + 5, yp + 55);
   }
   
   void updateScore(int points) {
     score+=points;
   }
   
    void buzzer() {
     lit =! lit;
   }

   void restart() {
     score = 0;
     lit = false;
   }
}
