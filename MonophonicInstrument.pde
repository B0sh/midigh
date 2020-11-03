class MonophonicInstrument extends Instrument
{
    String name() {
        return "Tapping Mode";
    }

    int[] fret_last_pitch = new int[5];
    boolean[] held_frets = new boolean[5];

    void up() {
        offsetDown();
    }
    void down() {
        offsetUp();
    }

    void depressFret(int fret_index)
    {
        cleanup();

        int pitch = FRETS_PITCH[fret_index];
        fret_last_pitch[fret_index] = pitch;
        myBus.sendNoteOn(0, pitch, VOLUME);

        held_frets[fret_index] = true;
    }

    void releaseFret(int fret_index)
    {
        int pitch = fret_last_pitch[fret_index];
        myBus.sendNoteOff(0, pitch, VOLUME);
        fret_last_pitch[fret_index] = 0;

        held_frets[fret_index] = false;

        int activate_fret = -1;
        for (int i = 0; i < held_frets.length; i++)
        {
            if (held_frets[i])
            {
                activate_fret = i;
            }
        }

        if (activate_fret != -1)
        {
            depressFret(activate_fret);
        }
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

