//   Operation Guitar Hero as instruments
// B0sh 10/9/17 - Updating 10/3/20
//
// Libaries Required:
// The MIDIBus  - sending midi signals
// Game Control Plus - Getting joystick input cross platform
// G4P - Creating inputs for options menu
//

// ON THE TODO:
// - Polling controller input faster than 60hz
// - Instrument switcher
// - Notes class
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;
import java.util.HashMap;

Ini config;

String SCALE = "Pentatonic";
int[] FRETS_PITCH;
int WHAMMY;
int STARPOWER;
int VOLUME = 69;

int OFFSET = 15;
int TRANSPOSE = 5;

boolean show_options = false;

KeyboardController keyboard;
int instrument_index = 0;
Instrument instrument;
Instrument[] instruments;
List<Integer> fretboard;

void settings()
{
    size(400, 900);
}

void setup()
{ 
    surface.setResizable(true);
    surface.setLocation(350, 60);

    show_options = true;

    config = new Ini("config.ini");

    PFont font = createFont("Arial", 48);
    textFont(font);

    keyboard = new KeyboardController();
    instruments = new Instrument[] {
        new FretInstrument(),
        new MonophonicInstrument(),
        new StrumInstrument(),
    };

    for (int i = 0; i < instruments.length; i++)
    {
        if (config.getString("instrument").equals(instruments[i].name()))
        {
            instrument_index = i;
        }
    }

    instrument = instruments[instrument_index];    

    fretboard = setFretboard("Pentatonic", TRANSPOSE);

    FRETS_PITCH = new int[5];
    
    FRETS_PITCH = setFrets(OFFSET, fretboard);
    
    initOptions();
    initMidiInterface();
    initGameController();

    thread("pollInputThread");
}

void draw()
{
    drawFrame();

    if (show_options)
    {
        drawOptions();
    }
}

void stop()
{
    // saving ini file
}

void toggleOptions()
{
    if (show_options) 
    {
        show_options = false;
        frame.setSize(400, 900);
    }
    else 
    {
        show_options = true;
        frame.setSize(900, 900);
    }
}

void pollInputThread() {
    while (true) {
        delay(1);
        pollControllerInput();
    }
}

void switchInstrument()
{
    instrument_index++;
    instrument.cleanup();
    instrument = instruments[instrument_index % instruments.length];
    config.setString("instrument", instrument.name());
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
