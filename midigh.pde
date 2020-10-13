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
int inputPolls = 0;

KeyboardController keyboard;
int instrumentIndex = 0;
Instrument instrument;
Instrument[] instruments;

void settings() {
    size(400, 900);
}

void setup()
{ 
    surface.setResizable(true);

    PFont font = createFont("Arial", 48);
    textFont(font);

    keyboard = new KeyboardController();
    instruments = new Instrument[] {
        new FretInstrument(),
        new StrumInstrument()
    };
    instrument = instruments[0];
    
    initGameController();
    initMidiInterface();

    thread("pollInput");
    
    HELDKEYS = new boolean[256];
    HELD_FRETS = new boolean[5];
    FRETS_PITCH = new int[5];
    
    FRETS_PITCH = setFrets(SCALE, OFFSET, 0);
}
void draw() {
    drawFrame();
}

void pollInput() {
    while (true) {
        delay(1);
        pollControllerInput();
    }
}

void switchInstrument() {
    instrumentIndex++;
    instrument.cleanup();
    instrument = instruments[instrumentIndex % instruments.length];
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
