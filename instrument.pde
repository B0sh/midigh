class Instrument 
{
    Instrument() {

    }

    String name() {
        return "Default";
    }

    void depressFret(int fret_index) { }
    void releaseFret(int fret_index) { }
    boolean isFretHeld(int fret_index) {
        return false;
    }

    void up() { }
    void down() { }
    
    void left() {
        offsetDown();
    }
    void right() {
        offsetUp();
    }

    void start() { }
    void select() {
        println("Select");
        switchInstrument();
    }

    void whammy(int whammy) {
        if (whammy < 60) {
            sendPitchBend(whammy);
        } else if (LAST_PITCH_BEND != 0) { // ensure that whammy is reset
            sendPitchBend(64); 
        }
    }

    void starpower (int starpower) { }

    void cleanup() {}

}

