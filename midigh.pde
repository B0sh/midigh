//   Operation Guitar Hero as instruments
// B0sh 10/9/17 - Updating 10/3/20
//
// Libaries Required:
// The MIDIBus  - sending midi signals
// Game Control Plus - Getting joystick input cross platform
//

// ON THE TODO:
// - Polling controller input faster than 60hz
// - Instrument switcher
// - Notes class

String SCALE = "Pentatonic";
boolean[] HELDKEYS;
boolean[] HELD_FRETS;
int[] FRETS_PITCH;
int WHAMMY;
int STARPOWER;
int VOLUME = 69;

int OFFSET = 20;
int TRANSPOSE = 0;

KeyboardController keyboard;
Instrument instrument;

void settings() {
    size(400, 900);
}

void setup()
{ 
    surface.setResizable(true);

    PFont font = createFont("Arial", 48);
    textFont(font);

    keyboard = new KeyboardController();
    instrument = new FretInstrument();
    
    initGameController();
    initMidiInterface();
    
    HELDKEYS = new boolean[256];
    HELD_FRETS = new boolean[5];
    FRETS_PITCH = new int[5];
    
    FRETS_PITCH = setFrets(SCALE, OFFSET, 0);
}

int idd = 0;
void switchInstrument() {
    println(idd);
    if (idd == 0) {
        instrument = new FretInstrument();
        idd = 1;
    }
    else {
        instrument = new StrumInstrument();
        idd = 0;
    }
}

void draw() {
    pollControllerInput();
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

void FULLSYSTEMRESET() {
    FULLMIDIRESET();
    WHAMMY = 64;
    OFFSET = 20;
    TRANSPOSE = 0;
    FRETS_PITCH = setFrets(SCALE, OFFSET, TRANSPOSE);
}
