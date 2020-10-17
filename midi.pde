import themidibus.*; // http://www.music-software-development.com/midi-tutorial.html
MidiBus myBus;
MidiBus myBusIn;
import javax.sound.midi.MidiMessage; // http://www.instructables.com/id/Scripting-Processing-with-MIDI/

void initMidiInterface() 
{
    // creates a new midibus input with the output being "To Logic" 
    // set this up in step 4 with the audio midi interface IAC Driver
    // MidiBus.list();   
    myBus = new MidiBus(this, -1, "loopMIDI Port"); 
    // myBusIn = new MidiBus(this, 1, "From Logic"); 
    //println(myBusIn.attachedInputs());
    
    FULLMIDIRESET();
}

// sends a raw MIDI message for pitch bend
int LAST_PITCH_BEND = 0;
void sendPitchBend(int bendLevel) {
    if (LAST_PITCH_BEND != bendLevel)
    {
        LAST_PITCH_BEND = bendLevel;

        // 0xE0 is the pitch bend status code plus channel 0
        //  according to http://www.music-software-development.com/midi-tutorial.html
        // databye 1 is the LSB (least significant bit) a la cents
        // databyte 2 is the MSB (most significant bit) a la  semitones?
        myBus.sendMessage(0xE0, 0, 0x00, bendLevel); 
    }
}

// unset every midi note
void FULLMIDIRESET() {
    for (int i = 0; i < 100; i++) {
        myBus.sendNoteOff(0, i, 69);
    }
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) { 
    int note = (int)(message.getMessage()[1] & 0xFF) ;
    int vel = (int)(message.getMessage()[2] & 0xFF);

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
//}

//void noteOff(int channel, int pitch, int velocity) {
//  println("Note Off: "+channel + " "+ pitch + " " + velocity);
//}
