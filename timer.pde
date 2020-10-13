int timer_start = -1;
boolean setup_buttons = false;
Button start_button;
Button stop_button;

void drawTimer(int x, int y) {
    if (!setup_buttons) {
        start_button = new Button("Start", x, y-20, 80, 40);
        stop_button = new Button("Stop", x, y-20, 80, 40);
    }
    
    if (timer_start != -1) {
        textSize(52);
        textAlign(LEFT, CENTER);
        fill(200);
        int seconds = (int) ( (millis() - timer_start)/1000 ) % 60;
        int minutes = (int) (millis() - timer_start)/1000 / 60;
        if (seconds >= 10)
            text(minutes+":"+seconds, x+100, y-5);
        else
            text(minutes+":0"+seconds, x+150, y-5);
        
        textSize(16);
        stop_button.draw();
    }
    else
    {
        textSize(16);
        start_button.draw();
      
    }
    
}

void mousePressed() {
    if (start_button.mouseIsOver() && timer_start == -1) {
        timer_start = millis();
    } else if (stop_button.mouseIsOver() && timer_start != -1) {
        timer_start = -1; 
        
    }
}

void stopTimer() {
  
}

void resetTimer() {
  
}