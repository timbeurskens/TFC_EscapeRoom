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
//int tries = 0;
int [] code = new int [4]; //to store a 4 digit value

void setup() {
  oocsi = new OOCSI(this, "group10", "localhost"); //our channel is group10
  oocsi.subscribe("lockChannel", "channelReceive", ); //??
  
  if (type.equals("set"){
  //input from arduino and compare it to code
}
else if (type.equals("reset"){
 for (int i=0; i<code.length; i++){
    code[i]= (int)random(0,9);
  }
  println(code);
  }
}
else 


    


  


  


void channelReceive(OOCSIEvent event) {
 type = event.getString("string", 0);//receive a 'set' or 'reset' from other modules. Type determines the actions taken within setup()
}
void draw(){ //send a message back to the original module(s) indicating if the code guessing went good or bad/ send a value that they can use. 
  oosci.channel("group10").data("type", 
}