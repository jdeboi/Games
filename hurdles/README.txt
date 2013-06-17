Makey Makey Hurdles

Jenna deBoisblanc
June 2013
jdeboi.com

**Materials**
Makey Makey
computer
aluminum foil + tape (or conductive pads - get creative)
Processing

**Instructions**
1. Setup your Makey Makey
Connect aluminum foil to Makey Makey key inputs using alligator clips. Make sure each player is connected to a ground pin (check the interwebs for examples). 
Depending on the number of players, you may need to edit the Makey Makey Settings.h file to make use of additional inputs. Check out this Sparkfun tutorial for information about reprogramming the Arduino: https://www.sparkfun.com/tutorials/388 

2. Setup the Processing Fruit Bowl sketch
If you haven't already downloaded Processing, get it here:
https://processing.org/download/
Download all of the files in the Hurdles folder on github. Open hurdles.pde. Edit the variables in the "UPDATE" section - most importantly the "playerKeys." These keys need to correspond to the keys associated with your Makey Makey inputs as specified in the Settings.h file.

3. Gameplay
Run in place to make the character move faster. Jump in the air to clear the hurdle. If you jump too soon or too late, Lakitu (cloud man) will slow you down. You may need to adjust the sensitivity of the jump threshold, which you can do by changing the variable, "jumpThreshold."

**Characters**
To add your own characters, replace the images in the "player" folders with your own sprites (make sure the background is transparent). Here's the breakdown of the images in the player directory:
0.png - when the character hits a hurdle
1.png - image of the character while jumping
2.png - run cycle #1 (standing still)
3.png - run cycle #2
4.png - run cycle #3
...

Add as many pics as you need. Edit the array, "numCharacterImages" so that the element in the array that corresponds to that particular player matches the number of images you've added to playerX's folder.