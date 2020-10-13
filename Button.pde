class Button {
    String label;
    float x;    // top left corner x position
    float y;    // top left corner y position
    float w;    // width of button
    float h;    // height of button
    
    Button(String label_, float xpos_, float ypos_, float width_, float height_) {
        label = label_;
        x = xpos_;
        y = ypos_;
        w = width_;
        h = height_;
    }
    
    void draw() {
        fill(218);
        stroke(141);
        rect(x, y, w, h, 10);
        textAlign(CENTER, CENTER);
        fill(0);
        text(label, x + (w / 2), y + (h / 2));
    }
    
    boolean mouseIsOver() {
        if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
            return true;
        }
        return false;
    }
}