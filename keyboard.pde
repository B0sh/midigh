import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

// https://forum.processing.org/two/discussion/4583/how-do-i-generate-a-keypress-maybe-robot
class KeyboardController 
{
    Robot robot; 

    KeyboardController()
    {
        try { 
            robot = new Robot();
        }
        catch (AWTException e) {
            e.printStackTrace();
            exit();
        }
    }

    // sendKeyPress
    void send(int event)
    {
        robot.keyPress(event);
        robot.keyRelease(event);
    }
}


// Processing Built in
boolean[] held_keys = new boolean[256];
void keyPressed()
{
    if (held_keys[keyCode] == false) 
    {
        if (held_keys[16]) {
            switch (keyCode) {
                case 39: transposeUp(); transposeUp(); transposeUp(); transposeUp(); break;
                case 37: transposeDown(); transposeDown(); transposeDown(); transposeDown(); transposeDown(); break;
            }
        }

        switch (keyCode) {
            case 38: offsetUp(); offsetUp(); offsetUp(); offsetUp(); offsetUp(); break;
            case 40: offsetDown(); offsetDown(); offsetDown(); offsetDown(); offsetDown(); break;
            case 39: transposeUp(); break;
            case 37: transposeDown(); break;
            case 123: switchInstrument(); break;

            case 9: // Tab
                toggleOptions();
                break;

            case 49: depressGreen(); break;
            case 50: depressRed(); break;
            case 51: depressYellow(); break;
            case 52: depressBlue(); break;
            case 53: depressOrange(); break;
        }

    }

    held_keys[keyCode] = true;
    
    printKey("**** keyPressed", key, keyCode);
}

void keyReleased() {
    switch (keyCode)
    {
        case 49: releaseGreen(); break;
        case 50: releaseRed(); break;
        case 51: releaseYellow(); break;
        case 52: releaseBlue(); break;
        case 53: releaseOrange(); break;
    }

    held_keys[keyCode] = false;
    printKey("^^^^ keyReleased", key,   keyCode);
}

void printKey(String label, char myKey, int myKeyCode){
    String timestamp = "time: " + millis() + ": ";

    if (myKey == CODED) {
        println(timestamp + label + " --> CODED: " + myKeyCode);
    } else {
        println(timestamp + label + " --> CHAR: '"  + myKey + "' CODED: " + myKeyCode);
    } 
}
