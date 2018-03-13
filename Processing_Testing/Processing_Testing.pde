import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;

import nl.tue.id.oocsi.*;

OOCSI oocsi;
color bgColor = color(0);

void setup() {
  size(400, 400);
  background(120);
  frameRate(10);
  
  oocsi = new OOCSI(this, "group102", "localhost");

  String resp = oocsi.call("keypadSet", 200).data("code", "1019").sendAndWait().getFirstResponse().getString("result");
  
  println();
  println(resp);
}

void draw() {
  background(bgColor);
}

void handleOOCSIEvent(OOCSIEvent event) {
  println(event.getString("type"));
  bgColor = color(0, 255, 0);  
}

void mousePressed() {
  String resp = oocsi.call("keypadReset", 200).sendAndWait().getFirstResponse().getString("result");
  
  println(resp);
}