import nl.tue.id.oocsi.*;

OOCSI oocsi;
color bgColor = color(0);

void setup() {
  size(400, 400);
  background(120);
  frameRate(10);
  
  oocsi = new OOCSI(this, "group102", "localhost");

  oocsi    
    .channel("lockChannel")    
    .data("type", "set")    
    .data("code", "1258")    
    .send();
  println();
}

void draw() {
  background(bgColor);
}

void handleOOCSIEvent(OOCSIEvent event) {
  println(event.getString("type"));
  bgColor = color(0, 255, 0);  
}