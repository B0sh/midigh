# Setup for Windows

1. Loop MIDI


# Setup for Mac

1: do not use a hackintosh (my hackintosh didn't work)

2: Install the 360Controller mac drivers 

* https://github.com/360Controller/360Controller/releases

3: Go to Audio midi setup

* Double click IAC driver for prefs
* Click to enable it and also add a new midi input method “To Logic”, which is referenced in processing script
* http://www.johanlooijenga.com/tools/12-virtual-ports.html

4: Configure Keyboard Maestro for Logic Pro usage. This for starting and stopping recording using the guitar

5: Get libaries required: GameControlPlus, Midibus
    
6: Run MIDIGH




## Chart for hat codes

Pos 	X 	Y 	Direction hat is pushed
1 	-0.707 	-0.707 	Up-left
2 	0 	-1 	Up
3 	0.707 	-0.707 	Up-right
4 	1 	0 	Right
5 	0.707 	0.707 	Down-right
6 	0 	1 	Down
7 	-0.707 	0.707 	Down-left
8 	-1 	0 	Left