import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO controlIO;
ControlDevice controller;

void initGameController() 
{
    // load the gamecontrolplus shit
    controlIO = ControlIO.getInstance(this);
    // load the GameControlPlus configuration file "xplorer" from /data/
    controller = controlIO.getMatchedDevice("gh");
    
    if (controller == null)
    {
        println("[MIDIGH] No suitable device configured");
        System.exit(-1);
    }
    
    controller.getButton("GREEN").plug(this, "depressGreen", ControlIO.ON_PRESS);
    controller.getButton("RED").plug(this, "depressRed", ControlIO.ON_PRESS);
    controller.getButton("YELLOW").plug(this, "depressYellow", ControlIO.ON_PRESS);
    controller.getButton("BLUE").plug(this, "depressBlue", ControlIO.ON_PRESS);
    controller.getButton("ORANGE").plug(this, "depressOrange", ControlIO.ON_PRESS);
    
    controller.getButton("GREEN").plug(this, "releaseGreen", ControlIO.ON_RELEASE);
    controller.getButton("RED").plug(this, "releaseRed", ControlIO.ON_RELEASE);
    controller.getButton("YELLOW").plug(this, "releaseYellow", ControlIO.ON_RELEASE);
    controller.getButton("BLUE").plug(this, "releaseBlue", ControlIO.ON_RELEASE);
    controller.getButton("ORANGE").plug(this, "releaseOrange", ControlIO.ON_RELEASE);
    
    controller.getButton("SELECT").plug(this, "selectButton", ControlIO.ON_PRESS);
    controller.getButton("START").plug(this, "startButton", ControlIO.ON_PRESS);
}

void selectButton() {
    instrument.select();
}

void startButton() {
    instrument.start();
}

// get analog controller input
void pollControllerInput()
{
    HELD_FRETS[0] = controller.getButton("GREEN").pressed();
    HELD_FRETS[1] = controller.getButton("RED").pressed();
    HELD_FRETS[2] = controller.getButton("YELLOW").pressed();
    HELD_FRETS[3] = controller.getButton("BLUE").pressed();
    HELD_FRETS[4] = controller.getButton("ORANGE").pressed();
    
    WHAMMY = int(map(controller.getSlider("WHAMMY").getValue(), -1, 1, 64, 32));

    STARPOWER = int(map(controller.getSlider("STARPOWER").getValue(), -0.75, 1, 100, 4));

    instrument.whammy(WHAMMY);
    instrument.starpower(STARPOWER);

    processDpadInput();
}

int last_dpad_position_id = -1;
void processDpadInput()
{
    int position_id = controller.getHat("DPAD").getPos();

    if (position_id == 3 || position_id == 5)
    {
        position_id = 4;
    }
    else if (position_id == 1 || position_id == 7)
    {
        position_id = 8;
    }
    
    if (position_id != last_dpad_position_id && instrument != null)
    {
        last_dpad_position_id = position_id;

        switch (position_id) {
            case 2: // Up
                // println("[", millis() , "] DPAD Up");
                instrument.up();
                break;
            case 4: // Right
                // println("[", millis() , "] DPAD Right");
                instrument.right();
                break;
            case 6: // Down
                // println("[", millis() , "] DPAD Down");
                instrument.down();
                break;
            case 8: // Left
                // println("[", millis() , "] DPAD Left");
                instrument.left();
                break;
        }
    }
}

void depressGreen()
{
    if (instrument != null) 
    {
        instrument.depressFret(0);
    }
}
void depressRed()
{
    if (instrument != null)
    {
        instrument.depressFret(1);
    }
}
void depressYellow()
{
    if (instrument != null)
    {
        instrument.depressFret(2);
    }
}
void depressBlue()
{
    if (instrument != null)
    {
        instrument.depressFret(3);
    }
}
void depressOrange()
{
    if (instrument != null)
    {
        instrument.depressFret(4);
    }
}

void releaseGreen()
{
    if (instrument != null)
    {
        instrument.releaseFret(0);
    }
}
void releaseRed()
{
    if (instrument != null)
    {
        instrument.releaseFret(1);
    }
}
void releaseYellow()
{
    if (instrument != null)
    {
        instrument.releaseFret(2);
    }
}
void releaseBlue()
{
    if (instrument != null)
    {
        instrument.releaseFret(3);
    }
}
void releaseOrange()
{
    if (instrument != null)
    {
        instrument.releaseFret(4);
    }
}