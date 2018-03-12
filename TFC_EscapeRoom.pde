import processing.serial.*;

import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;

OOCSI oocsi;
String type = null;
String code = null;
Serial arduino;
String sender = null;
int tries = 3;

void setup() {
  oocsi = new OOCSI(this, "group10", "localhost"); //our channel is group10
  oocsi.subscribe("lockChannel"); 
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  arduino = new Serial(this, portName, 9600);
}

void lockChannel(OOCSIEvent event) {
  handleOOCSIEvent(event);
}

void handleOOCSIEvent(OOCSIEvent event) {
  type = event.getString("type");//receive a 'set' or 'reset' from other modules. Type determines the actions taken within setup()
  code = event.getString("code");
  sender = event.getSender();

  println();
  println(type);
  println(code);
  println(sender);
}

void draw() {
  String codeValue = null;
  
  if ( arduino.available() > 0) {  // If data is available
    codeValue = arduino.readStringUntil('\n').trim(); // read it and store it in val

    println(codeValue); //print it out in the console
  }
  
  if (type == null || codeValue == null) return;

  println(code);

  if (type.equals("set")) {
    if (code.equals(codeValue)) {
      println("SUCCESS");        
      oocsi.channel(sender).data("type", "success").send();
    }
  } else if (type.equals("reset")) {
    code = null;
    sender = null;
  }
}