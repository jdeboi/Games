class Player {
  
   int x;
   int y;
   int score;
   char letter;
   String name;
   boolean lit;
   
   Player(int xp, int yp, char l, String n) {
     x = xp;
     y = yp;
     score = 0;
     letter = l;
     name = n;
     lit = false;
   }
   
   void displayBuzzed() {
      int w = (int) (cflScale * 1.0 * cflLit.width / cflLit.height);
      image(cflLit, x, y, w, cflScale);
   }
   
   void display() {
     textSize(20);
     fill(255);
     stroke(255);
     strokeWeight(4);
     
     int lineLen = 80;
     int lineTopY = y + 200;
     int lineBottomY = lineTopY + 130;
     line(x, lineTopY, x + lineLen, lineTopY);
     text(name, x, lineTopY + 20);
     
     textSize(40);
     text("$" + score, x, lineTopY + 100);
     line(x, lineBottomY, x + lineLen, lineBottomY);
     
     int w = (int) (cflScale * 1.0 * cflLit.width / cflLit.height);
     if(lit) {
        image(cflLit, x, y, w, cflScale);
     }
     else {  
       image(cfl, x, y, w, cflScale);
     }
   }
   
   void updateScore(int points) {
     score+=points;
   }

   void restart() {
     score = 0;
     lit = false;
   }
   
   void buzzer() {
     lit =! lit;
   }
}
