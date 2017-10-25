//   Operation Guitar Hero as instruments
// B0sh 10/9/17
// MIDIBus library sending midi signals
// http://www.music-software-development.com/midi-tutorial.html
//    is god^^^
import themidibus.*;
MidiBus myBus; // The MidiBus
MidiBus myBusIn; // The MidiBus

// http://www.instructables.com/id/Scripting-Processing-with-MIDI/
import javax.sound.midi.MidiMessage; 

// game control plus library allows managing joystick input
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
ControlIO controlIO;
ControlDevice controller;

// the robot java class allows for sending and reciving keyboard/mouse input
// https://forum.processing.org/two/discussion/4583/how-do-i-generate-a-keypress-maybe-robot
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
 
Robot robot;



// setting global instrument varibles

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
int LAST_PITCH_BEND = 0;

int OFFSET = 20;
int TRANSPOSE = 0;


int SDFSDFSDFSDFSDFSDF = -1;



void setup() 
{ 
  size(400, 900);

  PFont font = createFont("Vernanda", 48);
  textFont(font);
  
  // creates a new midibus input with the output being "To Logic" 
  // set this up in step 4 with the audio midi interface IAC Driver
   //MidiBus.list();   
  myBus = new MidiBus(this, -1, "To Logic"); 
  myBusIn = new MidiBus(this, 1, "From Logic"); 
  //println(myBusIn.attachedInputs());
  
  FULLMIDIRESET();
  
  // load the gamecontrolplus shit
  controlIO = ControlIO.getInstance(this);
  // load the GameControlPlus configuration file "xplorer" from /data/
  controller = controlIO.getMatchedDevice("xplorer");
  
  
  if (controller == null) {
    println("No suitable device configured");
    System.exit(-1);
  }
  
  // Setup press and depress events (don't know how to pass the input in -.-)
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
  
  controller.getButton("UPSTRUM").plug(this, "upStrum", ControlIO.ON_PRESS);
  controller.getButton("DOWNSTRUM").plug(this, "downStrum", ControlIO.ON_PRESS);
  
  controller.getButton("XBOX").plug(this, "switchControlMode", ControlIO.ON_PRESS);
  controller.getButton("SELECT").plug(this, "selectButton", ControlIO.ON_PRESS);
  controller.getButton("START").plug(this, "startButton", ControlIO.ON_PRESS);
  
  
  controller.getButton("UPPAD").plug(this, "offsetDown", ControlIO.ON_PRESS);
  controller.getButton("DOWNPAD").plug(this, "offsetUp", ControlIO.ON_PRESS);
  
  
  // creating a robot
  try { 
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
  
  
  // initalize global varibles
  HELDKEYS = new boolean[256];
  HELD_FRETS = new boolean[5];
  LAST_STRUM_HELD_FRETS_PITCH = new int[5];
  LAST_HELD_FRETS_PITCH = new int[5];
  FRETS_PITCH = new int[5];
  
  
  FRETS_PITCH = setFrets(SCALE, OFFSET, 0);
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) { 
  int note = (int)(message.getMessage()[1] & 0xFF) ;
  int vel = (int)(message.getMessage()[2] & 0xFF);

  if (note == 10) {
    if (vel > 64)  SDFSDFSDFSDFSDFSDF = 1;
    else SDFSDFSDFSDFSDFSDF = 0;
  }

  //println("Bus " + bus_name + ": Note "+ note + ", vel " + vel);
}

//void rawMidi(byte[] data) { // You can also use rawMidi(byte[] data, String bus_name)
//  // Receive some raw data
//  // data[0] will be the status byte
//  // data[1] and data[2] will contain the parameter of the message (e.g. pitch and volume for noteOn noteOff)
//  println();
//  println("Raw Midi Data: Status Byte/MIDI Command:"+(int)(data[0] & 0xFF));
//  // N.B. In some cases (noteOn, noteOff, controllerChange, etc) the first half of the status byte is the command and the second half if the channel
//  // In these cases (data[0] & 0xF0) gives you the command and (data[0] & 0x0F) gives you the channel
//  for (int i = 1;i < data.length;i++) {
//    println("Param "+(i+1)+": "+(int)(data[i] & 0xFF));
//  }
//}

//void noteOn(int channel, int pitch, int velocity) {
//  println("Note On: "+channel + " "+ pitch + " " + velocity);
//  SDFSDFSDFSDFSDFSDF = 0;
//}

//void noteOff(int channel, int pitch, int velocity) {
//  println("Note Off: "+channel + " "+ pitch + " " + velocity);
//  SDFSDFSDFSDFSDFSDF = 1; 
//}

void draw() {
  // poll input
  getControllerInput();
  
  drawFrame();
}


// get analog controller input
void getControllerInput() {
  HELD_FRETS[0] = controller.getButton("GREEN").pressed();
  HELD_FRETS[1] = controller.getButton("RED").pressed();
  HELD_FRETS[2] = controller.getButton("YELLOW").pressed();
  HELD_FRETS[3] = controller.getButton("BLUE").pressed();
  HELD_FRETS[4] = controller.getButton("ORANGE").pressed();
  
  WHAMMY = int(map(controller.getSlider("WHAMMY").getValue(), -1, 1, 64, 32));
  if (WHAMMY < 60) {
    sendPitchBend(WHAMMY);
  } else if (LAST_PITCH_BEND != 0) { // ensure that whammy is reset
    sendPitchBend(64); 
  }
  
  VOLUME = int(map(controller.getSlider("STARPOWER").getValue(), -0.75, 1, 100, 4));
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

void depressFret(int fretID) {
  // Control mode one is tap mode, so just toggle the note.
  if (CONTROL_MODE == 1) 
  {
    int pitch = FRETS_PITCH[fretID];
    LAST_HELD_FRETS_PITCH[fretID] = pitch;
    myBus.sendNoteOn(0, pitch, VOLUME); // Send a Midi noteOn
  }
}

void releaseFret(int fretID) {
  // Control mode one is tap mode, so just toggle the note.
  if (CONTROL_MODE == 1) 
  {
    int pitch = LAST_HELD_FRETS_PITCH[fretID];
    myBus.sendNoteOff(0, pitch, VOLUME); // Send a Midi noteOf
  }
}

void downStrum() { strum(1); }
void upStrum() { strum(-1); } 
void strum(int direction) {
  if (CONTROL_MODE == 3) {
    switch (direction) {
      case -1: sendKeyPress(KeyEvent.VK_UP);   break;
      case 1:  sendKeyPress(KeyEvent.VK_DOWN); break;
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

// sends a raw MIDI message for pitch bend
void sendPitchBend(int bendLevel) {
  LAST_PITCH_BEND = bendLevel;

  // 0xE0 is the pitch bend status code plus channel 0
  //  according to http://www.music-software-development.com/midi-tutorial.html
  // databye 1 is the LSB (least significant bit) a la cents
  // databyte 2 is the MSB (most significant bit) a la  semitones?
  myBus.sendMessage(0xE0, 0, 0x00, bendLevel); 
}

// switch to a different control mode and destroy midi data from previous mode
void switchControlMode() {
  FULLMIDIRESET();
  CONTROL_MODE = 1 + (CONTROL_MODE) % 3;
}

void selectButton() {
  //FULLMIDIRESET();
  sendKeyPress(KeyEvent.VK_BACK_SLASH); // maybe? 
}
void startButton() {
  //FULLSYSTEMRESET();
  sendKeyPress(KeyEvent.VK_R);
  
}


// unset every midi note
void FULLMIDIRESET() {
  for (int i = 0; i < 100; i++) {
    myBus.sendNoteOff(0, i, 69);
  }
}

void FULLSYSTEMRESET() {
  FULLMIDIRESET();
  WHAMMY = 64;
  OFFSET = 20;
  TRANSPOSE = 0;
  CONTROL_MODE = 1;
  FRETS_PITCH = setFrets(SCALE, OFFSET, TRANSPOSE);
  
}

//////// SEND INPUT METHODS
void sendKeyPress(int event) {
  robot.keyPress(event);
  robot.keyRelease(event);
}

//////// GET INPUT METHODS
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


//// debug shit
void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}


void printKey(String label, char myKey, int myKeyCode){
//  if (debug ==false)
//    return;
  
  String timeStamp = "time: " + millis() + ": "; // current time in milliseconds since sketch launch
  if ( myKey == CODED) {
    println(timeStamp + label + " --> CODED: " + myKeyCode);
  } else {
    println(timeStamp + label + " --> CHAR: '"  + myKey + "' CODED: " + myKeyCode);
  } 
}