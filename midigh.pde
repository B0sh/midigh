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
import java.util.List;
import java.util.ArrayList;

String SCALE = "Pentatonic";
boolean[] HELDKEYS;
boolean[] HELD_FRETS;
int[] FRETS_PITCH;
int WHAMMY;
int STARPOWER;
int VOLUME = 69;

int OFFSET = 20;
int TRANSPOSE = 5;

KeyboardController keyboard;
int instrument_index = 0;
Instrument instrument;
Instrument[] instruments;
List<Integer> fretboard;

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
        new MonophonicInstrument(),
        new StrumInstrument(),
    };
    instrument = instruments[0];    

    fretboard = setFretboard("Pentatonic", TRANSPOSE);

    HELDKEYS = new boolean[256];
    HELD_FRETS = new boolean[5];
    FRETS_PITCH = new int[5];
    
    FRETS_PITCH = setFrets(OFFSET, fretboard);
    
    initMidiInterface();
    initGameController();

    thread("pollInputThread");
}

void draw() {
    drawFrame();
}

void pollInputThread() {
    while (true) {
        delay(1);
        pollControllerInput();
    }
}

void switchInstrument() {
    instrument_index++;
    instrument.cleanup();
    instrument = instruments[instrument_index % instruments.length];
}

void offsetUp() {
    OFFSET += 1;
    FRETS_PITCH = setFrets(OFFSET, fretboard);
}
void offsetDown() {
    OFFSET -= 1;
    FRETS_PITCH = setFrets(OFFSET, fretboard);
} 
void transposeUp() {
    TRANSPOSE += 1;
    FRETS_PITCH = setFrets(OFFSET, fretboard);
}
void transposeDown() {
    TRANSPOSE -= 1;
    FRETS_PITCH = setFrets(OFFSET, fretboard);
}

void FULLSYSTEMRESET() {
    FULLMIDIRESET();
    WHAMMY = 64;
    OFFSET = 20;
    TRANSPOSE = 0;
    FRETS_PITCH = setFrets(OFFSET, fretboard);
}
