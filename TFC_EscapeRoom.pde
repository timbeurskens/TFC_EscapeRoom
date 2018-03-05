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
String type = "";
String code = "";
Serial myPort;
String codeValue;
String output;

void setup() {
  oocsi = new OOCSI(this, "group10", "localhost"); //our channel is group10
  oocsi.subscribe("lockChannel", "channelReceive"); 
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
}
  
void channelReceive(OOCSIEvent event) {
 type = event.getString("string");//receive a 'set' or 'reset' from other modules. Type determines the actions taken within setup()
 code = event.getString("string");
}
void draw(){

 if ( myPort.available() > 0) {  // If data is available,
  codeValue = myPort.readStringUntil('\n');         // read it and store it in val
println(codeValue); //print it out in the console
 }

 if (type.equals("set")){
    if (code == codeValue){
      println(code);
      oocsi.channel("group10").data("good job", (String) output);
}
else if (code != codeValue){
  println(code);
  oocsi.channel("group10").data("error"), (String) output);
 }
 else {
   oocsi.channel("group10").data("timeout").(String) output);
 }
 

 if (type.equals("reset")){
  code = "";
  }
}