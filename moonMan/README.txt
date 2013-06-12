Makey Makey Moon Man

Jenna deBoisblanc
June 2013

**Materials**
Makey Makey
computer
fruit (or conductive pads - get creative)
Processing

**Instructions**
1. Setup your Makey Makey
Connect fruit/conductive pads to Makey Makey key inputs using alligator clips. Make sure each player is connected to a ground pin (check the interwebs for examples) 
Depending on the number of players, you may need to edit the Makey Makey Settings.h file to make use of additional inputs. Check out this Sparkfun tutorial for information about reprogramming the Arduino: https://www.sparkfun.com/tutorials/388 

2. Setup the Processing Moon Man sketch
If you haven't already downloaded Processing, get it here:
https://processing.org/download/
Download all of the files in the Moon Man folder on github. Open moonMan.pde. Edit the variables in the "UPDATE" section - most importantly the "playerKeys." These keys need to correspond to the keys associated with your Makey Makey inputs as specified in the Settings.h file.
When you're ready to play, click the Processing arrow to compile and run the sketch.

3. Game play
When the moon man moves his body, press the corresponding pads. The faster the player gets the correct body combination (relative to other players), the more points the player receives. The player loses points if he/she hits a body part that isn't highlighted.
Press the 'r' key to restart the game.