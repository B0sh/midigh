color[] FRET_COLORS = {
    #2E9F21,
    #BD4B45,
    #BEBE2C,
    #1D4DB2,
    #AA7F48
};

void drawFrame() 
{
    scale (1);
    background(#0A0A30);
    fill(127,30,30);
        // rect(0, -20, width, height, 10);
    
    translate(0, map(WHAMMY, 64, 0, 10, 100));
    
    
    // generate the frets
    int fret_y = 72;
    int fret_x = 72;
    int padding = 20;
    int fret_width = 250;
    int fret_height = 1000;
    int button_height = 72;
    
    
    fill(33);
    strokeWeight(5);
    stroke(0);
    rect(fret_x - padding, fret_y - padding, fret_width+padding*2, fret_height+padding*2, 20);
    
    fill(255);
    
    textAlign(CENTER, CENTER);
    textSize(32);
    text("The Plastic Instrument", width/2, 20);
    
    

    strokeWeight(1);

    // legacy buttons
    fill(#2A2A50);
    if (HELD_FRETS[0]) rect(10, -10, 10, 10);
    if (HELD_FRETS[1]) rect(20, -10, 10, 10);
    if (HELD_FRETS[2]) rect(30, -10, 10, 10);
    if (HELD_FRETS[3]) rect(40, -10, 10, 10);
    if (HELD_FRETS[4]) rect(50, -10, 10, 10);

    fill(255);
    for (int i = 0; i < 5; i++) {
        if (CONTROL_MODE == 1 && HELD_FRETS[i]) 
        fill (FRET_COLORS[i]);
        else if (CONTROL_MODE == 2 && LAST_STRUM_HELD_FRETS_PITCH[i] != 0) 
        fill(FRET_COLORS[i]);
        else 
        fill (140);
        
        rect(fret_x, fret_y + button_height*i, fret_width, button_height-3, 16);
    }

    textAlign(LEFT, CENTER);
    textSize(40);
    fill(0);
    // if Logic Mode is active no notes are played
    if (CONTROL_MODE != 3) {
        for (int i = 0; i < 5; i++) {
            text(midiNumberToNote(FRETS_PITCH[i]), fret_x + padding, fret_y + 30 +  button_height * i);
        }
    }
    textAlign(LEFT, BOTTOM);


    fill (#DDA300);
    textSize(32);
    
    // set the display text for the mode
    String mode = "";
    switch (CONTROL_MODE) {
        case 1: mode = "Tap Mode"; break;
        case 2: mode = "Strum Mode"; break;
        case 3: mode = "Logic Mode"; break;
    }
    
    text(mode, fret_x, fret_y + button_height * 5 + 48);
    text("Volume: " + VOLUME, fret_x, fret_y + button_height * 5 + 48 + 32);
    text("Whammy: " + WHAMMY, fret_x, fret_y + button_height * 5 + 48 + 64);
    text("Scale: (" + OFFSET + ", "+TRANSPOSE + ")", fret_x, fret_y + button_height * 5 + 48 + 96);
    
    // Metronome
        
    drawTimer(fret_x, height - 100);
}