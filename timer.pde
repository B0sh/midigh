int timer_start = -1;
boolean setupButtons = false;
Button startButton;
Button stopButton;

void drawTimer(int x, int y) {
  if (!setupButtons) {
    startButton = new Button("Start", x, y-20, 80, 40);
    stopButton = new Button("Stop", x, y-20, 80, 40);
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
    stopButton.Draw();
  }
  else
  {
    textSize(16);
    startButton.Draw();
    
  }
  
}

void mousePressed() {
  if (startButton.MouseIsOver() && timer_start == -1) {
    timer_start = millis();
  } else if (stopButton.MouseIsOver() && timer_start != -1) {
    timer_start = -1; 
    
  }
}

void stopTimer() {
  
}

void resetTimer() {
  
}