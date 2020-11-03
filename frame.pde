color[] FRET_COLORS = {
    #209C3C,
    #D8402F,
    #F4C522,
    #0063A8,
    #E68E27
};

void drawFrame() 
{
    scale (1);
    pushMatrix();
    
    background(#0A0A30);
    fill(127,30,30);
    
    translate(0, map(WHAMMY, 64, 0, 10, 100));
    
    // generate the frets
    int fret_y = 72;
    int fret_x = 96;
    int padding = 24;
    int fret_width = 196;
    int fret_height = 1000;
    int button_spacing = 72;
    int button_height = 68;
    int magic_button_fixing_constant = -3;

    fill(15);
    strokeWeight(5);
    stroke(0);
    rect(fret_x - padding, fret_y - padding, fret_width+padding*2, fret_height+padding*2, 20);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("The Plastic Instrument", 200, 20);

    if (instrument == null)
    {
        return;
    }
    
    strokeWeight(1);

    for (int i = 0; i < 5; i++)
    {
        if (instrument.isFretHeld(i)) 
            fill (FRET_COLORS[i]);
        else 
            fill (96);
        
        rect(fret_x, fret_y + button_spacing*i, fret_width, button_height, 16);

        textAlign(LEFT, CENTER);
        textSize(40);
        fill(0);
        text(midiNumberToNote(FRETS_PITCH[i]), fret_x + padding, fret_y + button_spacing * i + button_height * 0.5 + magic_button_fixing_constant);
    }

    String[] fret_information = {
        instrument.name(),
        "Volume: " + VOLUME,
        "Whammy: " + WHAMMY,
        "Scale: (" + OFFSET + ", "+TRANSPOSE + ")",
        "",
        "",
        "",
        ""
    };
   
    int info_fret_y = button_spacing * 6;
    int info_button_spacing = floor(button_spacing * .75);
    int info_button_height = floor(button_height * .75);
    int info_padding = floor(padding * .75);
    for (int i = 0; i < fret_information.length; i++)
    {
        fill (90);
        rect(fret_x, info_fret_y + info_button_spacing*i, fret_width, info_button_height, 16);

        textAlign(LEFT, CENTER);
        fill(0);
        textSize(24);

        text(fret_information[i], fret_x + info_padding, info_fret_y + info_button_spacing * i + info_button_height * 0.5 + magic_button_fixing_constant);
    }

    drawTimer(fret_x, height - 100);

    popMatrix();
}


import g4p_controls.*;
import java.awt.Font;

GCustomSlider volume_slider;
GDropList root_dropdown;
Font dropdown_font;

int options_x = 420;
int options_y = 40;
int options_width = 400;
int options_height = 800;

void initOptions() 
{
    dropdown_font = new Font("Arial", 0, 24);

    volume_slider = new GCustomSlider(this, options_x + 40, options_y + 30, 200, 100);
    // volume_slider.setShowValue(true);
    volume_slider.setLimits(0, 0, 100);
    volume_slider.setNumberFormat(G4P.INTEGER, 0);
    volume_slider.setOpaque(false);
    volume_slider.setValue(VOLUME);
    volume_slider.addEventHandler(this, "setVolume");

    root_dropdown = new GDropList(this, options_x + 40, options_y + 130, 100, 400, 12, 30);
    root_dropdown.addItem("C");
    root_dropdown.addItem("C#");
    root_dropdown.addItem("D");
    root_dropdown.addItem("D#");
    root_dropdown.addItem("E");
    root_dropdown.addItem("F");
    root_dropdown.addItem("F#");
    root_dropdown.addItem("G");
    root_dropdown.addItem("G#");
    root_dropdown.addItem("A");
    root_dropdown.addItem("A#");
    root_dropdown.addItem("B");
    root_dropdown.setFont(dropdown_font);
    root_dropdown.setSelected(TRANSPOSE);
    root_dropdown.addEventHandler(this, "setTransposition");
}

void setVolume(GCustomSlider control, GEvent event)
{
    VOLUME = control.getValueI();
    println("set volume called");
}

void setTransposition(GDropList control, GEvent event)
{
    TRANSPOSE = control.getSelectedIndex();
    fretboard = setFretboard("Pentatonic", TRANSPOSE);
    FRETS_PITCH = setFrets(OFFSET, fretboard);
}

void drawOptions() 
{
    pushMatrix();

    fill(15);
    strokeWeight(5);
    stroke(0);
    rect(options_x, options_y, options_width, options_height);

    fill(208);
    textSize(24);
    textAlign(CENTER, TOP);
    text("MIDIGH Option Menu", options_x + options_width / 2, options_y + 6);

    fill(208);
    textSize(20);
    textAlign(LEFT, TOP);
    text("Volume:", options_x + 20, options_y + 40);

    fill(208);
    textSize(20);
    textAlign(LEFT, TOP);
    text("Root Note:", options_x + 20, options_y + 100);

    popMatrix();
}