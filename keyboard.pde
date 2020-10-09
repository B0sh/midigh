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
        println ("INIT");
    }

    // sendKeyPress
    void send(int event)
    {
        robot.keyPress(event);
        robot.keyRelease(event);
    }
}



// Processing Built in
void keyPressed() {
    HELDKEYS[keyCode] = true;
    if (HELDKEYS[16]) {
            
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
        
    }
    
    printKey("**** keyPressed", key, keyCode);
}

void keyReleased() {
    HELDKEYS[keyCode] = false;
    printKey("^^^^ keyReleased", key,   keyCode);
}

void printKey(String label, char myKey, int myKeyCode){
    String timeStamp = "time: " + millis() + ": "; // current time in milliseconds since sketch launch
    if ( myKey == CODED) {
        println(timeStamp + label + " --> CODED: " + myKeyCode);
    } else {
        println(timeStamp + label + " --> CHAR: '"  + myKey + "' CODED: " + myKeyCode);
    } 
}
