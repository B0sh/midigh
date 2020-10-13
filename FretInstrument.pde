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
        myBus.sendNoteOn(0, pitch, VOLUME); // Send a Midi noteOn
    }

    void releaseFret(int fret_index)
    {
        int pitch = fret_last_pitch[fret_index];
        myBus.sendNoteOff(0, pitch, VOLUME); // Send a Midi noteOf
    }
}

