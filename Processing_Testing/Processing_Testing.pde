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

  //call the keypadSet function and tell the module to send a signal when disks 0, 1 and 9 are turned
  String resp = oocsi.call("keypadSet", 200).data("code", "019").sendAndWait().getFirstResponse().getString("result");
  
  println();
  println(resp);
}

void draw() {
  background(bgColor);
}

//here you will receive messages from our module
void handleOOCSIEvent(OOCSIEvent event) {
  println(event.getString("type"));
  bgColor = color(0, 255, 0);  
}

void mousePressed() {
  //send a reset signal to the module
  String resp = oocsi.call("keypadReset", 200).sendAndWait().getFirstResponse().getString("result");
  
  println(resp);
}