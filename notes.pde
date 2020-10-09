

int[] setFrets(String scale, int offset, int transposition) {
    int[] notes = new int[5];
    transposition = 5;
    
    // bounds protection
    if (offset <= 0) 
        offset = 0;
  //   transposition = transposition % 12;
    
    if (scale.equals("Pentatonic")) 
    {
        int[] temp = {0, 2, 4, 7, 9}; notes = temp;
    }
    else if (scale.equals("Drumset")) 
    {
        // you can't change the drumset
        offset = 0;
        transposition = 0;
        int[] temp = {36,38,42,48,57}; notes = temp;
    }
    else
    {
        int[] temp = {0, 1, 2, 3, 4}; notes = temp;
    }
    int[] temp2 = {0,0,0,0,0};
    for (int i = 0; i < 5; i++) {
        notes[i] += transposition + 12*floor(offset/5);
        temp2[i] = notes[i];
    }
    offset = offset % 5;
    
        // offset the notes, which allows the starting note to not be the first one of the scale

    for (int i = 0; i < 5; i++) {
        notes[i] = temp2[(i + offset) % 5];
        if ((i + offset) >= 5) 
            notes[i] += 12;
        
    }
    
    return notes;
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
        case 0: out = out + "-2"; break; 
        case 1: out = out + "-1"; break; 
        case 2: out = out + "0"; break; 
        case 3: out = out + "1"; break; 
        case 4: out = out + "2"; break; 
        case 5: out = out + "3"; break; 
        case 6: out = out + "4"; break; 
        case 7: out = out + "5"; break; 
        case 8: out = out + "6"; break; 
        case 9: out = out + "7"; break; 
        case 10: out = out + "8"; break; 
        case 11: out = out + "9"; break; 
    }
    
    return out;
}