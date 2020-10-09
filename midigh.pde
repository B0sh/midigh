//   Operation Guitar Hero as instruments
// B0sh 10/9/17 - Updating 10/3/20
//
// Libaries Required:
// The MIDIBus  - sending midi signals
// Game Control Plus - Getting joystick input cross platform
//
// CONTROL MODES:
// 1 = TAP MODE. where notes are played for button presses and not strumes
// 2 = STRUM MODE. where notes are played on strum
// 3 = LOGIC MODE. where notes affect logic pro
int CONTROL_MODE = 1;
String SCALE = "Pentatonic";
boolean[] HELDKEYS;
boolean[] HELD_FRETS;
int[] FRETS_PITCH;
int[] LAST_HELD_FRETS_PITCH;
int[] LAST_STRUM_HELD_FRETS_PITCH;
int WHAMMY;
int VOLUME = 69;

int OFFSET = 20;
int TRANSPOSE = 0;

KeyboardController keyboard;

void setup() 
{ 
    size(400, 900);
    surface.setResizable(true);

    PFont font = createFont("Arial", 48);
    textFont(font);

    keyboard = new KeyboardController();
    initGameController();
    initMidiInterface();
    
    HELDKEYS = new boolean[256];
    HELD_FRETS = new boolean[5];
    LAST_STRUM_HELD_FRETS_PITCH = new int[5];
    LAST_HELD_FRETS_PITCH = new int[5];
    FRETS_PITCH = new int[5];
    
    FRETS_PITCH = setFrets(SCALE, OFFSET, 0);
}

void draw() {
    getControllerInput();
    drawFrame();
}


void offsetUp() {
    OFFSET += 1;
    FRETS_PITCH = setFrets(SCALE, OFFSET, TRANSPOSE);
}
void offsetDown() {
    OFFSET -= 1;
    FRETS_PITCH = setFrets(SCALE, OFFSET, TRANSPOSE);
} 
void transposeUp() {
    TRANSPOSE += 1;
    FRETS_PITCH = setFrets(SCALE, OFFSET, TRANSPOSE);
}
void transposeDown() {
    TRANSPOSE -= 1;
    FRETS_PITCH = setFrets(SCALE, OFFSET, TRANSPOSE);
}

void depressGreen() { depressFret(0); }
void depressRed() { depressFret(1); }
void depressYellow() { depressFret(2); }
void depressBlue() { depressFret(3); }
void depressOrange() { depressFret(4); }
void releaseGreen() { releaseFret(0); }
void releaseRed() { releaseFret(1); }
void releaseYellow() { releaseFret(2); }
void releaseBlue() { releaseFret(3); }
void releaseOrange() { releaseFret(4); }

void depressFret(int fretID)
{
    // Control mode one is tap mode, so just toggle the note.
    if (CONTROL_MODE == 1) 
    {
        int pitch = FRETS_PITCH[fretID];
        LAST_HELD_FRETS_PITCH[fretID] = pitch;
        myBus.sendNoteOn(0, pitch, VOLUME); // Send a Midi noteOn
    }
}

void releaseFret(int fretID)
{
    // Control mode one is tap mode, so just toggle the note.
    if (CONTROL_MODE == 1) 
    {
        int pitch = LAST_HELD_FRETS_PITCH[fretID];
        myBus.sendNoteOff(0, pitch, VOLUME); // Send a Midi noteOf
    }
}

void downStrum() { strum(1); }
void upStrum() { strum(-1); } 

void strum(int direction)
{
    if (CONTROL_MODE == 3) {
        switch (direction) {
            case -1: keyboard.send(KeyEvent.VK_UP);   break;
            case 1:  keyboard.send(KeyEvent.VK_DOWN); break;
        }
    }
    else if (CONTROL_MODE == 2) 
    {
        
        // loop through whats in the last held frets varible
        //   and release those notes
        for (int i = 0; i < 5; i++) {
            if (LAST_STRUM_HELD_FRETS_PITCH[i] != 0) {
                int pitch = LAST_STRUM_HELD_FRETS_PITCH[i];
                myBus.sendNoteOff(0, pitch, VOLUME); // Send a Midi noteOf321
            }
        }
        
        int[] pitches = specialStrumChords();
        
        // loop through whats in the held frets varible
        //   and play those notes
        for (int i = 0; i < 5; i++) {
            if (pitches[i] != 0) {
                int pitch = pitches[i];
                myBus.sendNoteOn(0, pitch, VOLUME); // Send a Midi noteOf
                // do a deep copy of the held frets array
                LAST_STRUM_HELD_FRETS_PITCH[i] = pitch;
            } else {
                LAST_STRUM_HELD_FRETS_PITCH[i] = 0;
            }
        }
        
    }
}

// switch to a different control mode and destroy midi data from previous mode
void switchControlMode() {
    FULLMIDIRESET();
    CONTROL_MODE = 1 + (CONTROL_MODE) % 3;
}

void selectButton() {
    //FULLMIDIRESET();
    keyboard.send(KeyEvent.VK_BACK_SLASH); // maybe? 
}
void startButton() {
    //FULLSYSTEMRESET();
    keyboard.send(KeyEvent.VK_R);
}


void FULLSYSTEMRESET() {
    FULLMIDIRESET();
    WHAMMY = 64;
    OFFSET = 20;
    TRANSPOSE = 0;
    CONTROL_MODE = 1;
    FRETS_PITCH = setFrets(SCALE, OFFSET, TRANSPOSE);
}
