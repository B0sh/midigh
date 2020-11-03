class FretInstrument extends Instrument
{
    String name() {
        return "Fret Mode";
    }

    int[] fret_last_pitch = new int[5];

    void depressFret(int fret_index)
    {        
        int pitch = FRETS_PITCH[fret_index];
        fret_last_pitch[fret_index] = pitch;
        myBus.sendNoteOn(0, pitch, VOLUME);
    }

    void releaseFret(int fret_index)
    {
        int pitch = fret_last_pitch[fret_index];
        myBus.sendNoteOff(0, pitch, VOLUME);
        fret_last_pitch[fret_index] = 0;
    }

    boolean isFretHeld(int fret_index)
    {
        return fret_last_pitch[fret_index] != 0;
    }
    
    void cleanup()
    {
        for (int i = 0; i < fret_last_pitch.length; i++)
        {
            if (fret_last_pitch[i] != 0) {
                myBus.sendNoteOff(0, fret_last_pitch[i], VOLUME);
            }
            fret_last_pitch[i] = 0;
        }
    }
}

