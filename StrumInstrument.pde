class StrumInstrument extends Instrument
{
    String name() {
        return "Strum Mode";
    }

    int[] last_held_frets_pitch = new int[5];

    void up() { strum(); }
    void down() { strum(); }

    void strum() {
        // loop through whats in the last held frets varible
        //   and release those notes
        for (int i = 0; i < 5; i++) {
            if (last_held_frets_pitch[i] != 0) {
                int pitch = last_held_frets_pitch[i];
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
                last_held_frets_pitch[i] = pitch;
            } else {
                last_held_frets_pitch[i] = 0;
            }
        }
    }

    int[] specialStrumChords() 
    {
        int chord = 0;
        for (int i = 0; i < 5; i++) {
            if (HELD_FRETS[i])
                chord += pow(2, i);
        }
        
        if (chord == unbinary("11100")) {
            int x = 12*4+2;
            return new int[] { 0, x+19, x+14, x+21, x+0 };
        }
        if (chord == unbinary("01110")) {
            int x = 12*4;
            return new int[] { x+0, x+19, x+14, x+16, 0 };
        }
        if (chord == unbinary("11010")) {
            int x = 12*4;
            return new int[] { x-5, x+14, x+16, x+11, x+19 };
        }
        //if (chord == unbinary("11000")) {
        //  return new int[] { 36, 36+7, 36+12, 36+12+2, 36+12+5 };
        //} else if (chord == unbinary("10100")) {
        //  return new int[] { 36-1, 36+7-1, 36+12-1, 36+12+2-1, 36+12+5-1 };
        //} else if (chord == unbinary("10010")) {
        //  return new int[] { 36-2, 36+7-2, 36+12-2, 36+12+2-2, 36+12+5-2 };
        //} else if (chord == unbinary("10001")) {
        //  return new int[] { 36-3, 36+7-3, 36+12-3, 36+12+2-3, 36+12+5-3 };
        //} else if (chord == unbinary("11100")) {
        //  return new int[] { 36-4, 36+7-4, 36+12-4, 36+12+2-4, 36+12+5-4 };
        //}
            
            
        
        int[] temp = { 0, 0, 0, 0, 0 };
        for (int i = 0; i < 5; i++) {
            if (HELD_FRETS[i])
                temp[i] = FRETS_PITCH[i];
            else
                temp[i] = 0;
        }
        
        return temp;
    }
}