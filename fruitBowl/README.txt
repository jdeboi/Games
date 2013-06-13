Fruit Bowl - quiz bowl with fruit!

Jenna deBoisblanc
June 2013

**Materials**
Makey Makey
computer
fruit (or conductive pads - get creative)
Processing

**Instructions**
1. Setup your Makey Makey
Connect fruit/conductive pads to Makey Makey key inputs using alligator clips. Make sure each player is connected to a ground pin (check the interwebs for examples). 
Depending on the number of players, you may need to edit the Makey Makey Settings.h file to make use of additional inputs. Check out this Sparkfun tutorial for information about reprogramming the Arduino: https://www.sparkfun.com/tutorials/388 

2. Setup the Processing Fruit Bowl sketch
If you haven't already downloaded Processing, get it here:
https://processing.org/download/
Download all of the files in the Fruit Bowl folder on github. Open fruitBowl.pde. Edit the variables in the "UPDATE" section - most importantly the "playerKeys." These keys need to correspond to the keys associated with your Makey Makey inputs as specified in the Settings.h file. You should also update the "questions" array. Make sure each question is enclosed in quotation marks and each line ends with a comma.
When you're ready to play, click the Processing arrow to compile and run the sketch.

3. Gameplay
Players can buzz in by tapping their banana (while holding/connected to ground). The "host" determines whether or not the player answered correctly. If the player answered incorrectly, another contestant may buzz in. The host can also decide to move on to the next question. Check the sketch to figure out which keys are which.
