List<Integer> setFretboard(String scale, int transposition)
{
    List<Integer> fretboard = new ArrayList<Integer>();

    if (scale.equals("Pentatonic")) 
    {
        int[] notes = new int[] {0, 2, 4, 7, 9};
        // notes = new int[] {0, 3, 5, 7, 8};
        // notes = new int[] { 0, 1, 3, 5, 8 };

        int last_pitch = transposition;
        int notes_index = 0;
        while (last_pitch < 110)
        {
            for (int note : notes)
            {
                int pitch = note + last_pitch;
                if (pitch >= 12 && pitch <= 108)
                {
                    fretboard.add(pitch);
                }
            }

            last_pitch += 12;
        }
    }
    else if (scale.equals("Drumset")) 
    {
        fretboard.add(36);
        fretboard.add(38);
        fretboard.add(42);
        fretboard.add(48);
        fretboard.add(57);
    }

    return fretboard;
}

int[] setFrets(int offset, List<Integer> fretboard)
{
    if (offset < 0)
    {
        offset = 0;
    } 
    else if (offset > fretboard.size() - 5)
    {
        offset = fretboard.size() - 5;
    }

    return new int[] {
        fretboard.get(offset + 0),
        fretboard.get(offset + 1),
        fretboard.get(offset + 2),
        fretboard.get(offset + 3),
        fretboard.get(offset + 4),
    };
}

String midiNumberToNote(int note) {
    String out = "";
    switch (note % 12) {
        case 0: out = "C"; break;
        case 1: out = "Db"; break;
        case 2: out = "D"; break;
        case 3: out = "Eb"; break;
        case 4: out = "E"; break;
        case 5: out = "F"; break;
        case 6: out = "Gb"; break;
        case 7: out = "G"; break;
        case 8: out = "Ab"; break;
        case 9: out = "A"; break;
        case 10: out = "Bb"; break;
        case 11: out = "B"; break;
    }
    
    switch (floor(note / 12)) {
        case 0: out = out + "-1"; break; 
        case 1: out = out + "0"; break; 
        case 2: out = out + "1"; break; 
        case 3: out = out + "2"; break; 
        case 4: out = out + "3"; break; 
        case 5: out = out + "4"; break; 
        case 6: out = out + "5"; break; 
        case 7: out = out + "6"; break; 
        case 8: out = out + "7"; break; 
        case 9: out = out + "8"; break; 
        case 10: out = out + "9"; break; 
        case 11: out = out + "10"; break; 
    }
    
    return out;
}