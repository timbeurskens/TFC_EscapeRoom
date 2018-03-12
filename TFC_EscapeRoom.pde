import processing.serial.*;
import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;

final int numDisks = 10;

OOCSI oocsi;
String code = null;
Serial arduino;
String sender = null;

void setup() {
  println(convertBinary(1019));
  
  oocsi = new OOCSI(this, "group10", "localhost");
  
  oocsi.register("keypadSet");
  oocsi.register("keypadReset");
  oocsi.register("keypadStatus");
  
  println();
  
  String portName = Serial.list()[0];
  arduino = new Serial(this, portName, 9600);
}

void keypadStatus(OOCSIEvent event, OOCSIData response) {
  response.data("result", "ok");
}

void keypadSet(OOCSIEvent event, OOCSIData response) {
  response.data("result", "ok");
  
  if ((sender != null && !sender.equals(event.getSender())) || !event.has("code")) {
    response.data("result", "error");
    return;
  }
  
  //received a valid set message:
  boolean isBinary = event.getBoolean("binary",false);
  
  if (isBinary) {
    code = convertBinary(event.getInt("code", 0));
  } else {
    code = sortInput(event.getString("code", ""));
  }
    
  if (code == null) {
    response.data("result", "error");  
  }
  
  sender = event.getSender();
  
  println("set: " + code + " by: " + sender);
}

String convertBinary(int input) {
  if (input < 0 || input >= pow(2, numDisks)) {
    return null;
  }
  
  StringBuilder resultBuilder = new StringBuilder();
  int factor = (int)pow(2, numDisks - 1);
  int index = 0;
  
  while(input > 0) {
    int div = input / factor; 
    input = input % factor;
    
    if (div > 0) {
      resultBuilder.append(String.valueOf(index));  
    }
    
    factor /= 2;
    index++;
  }
  
  return resultBuilder.toString();
}

String sortInput(String input) {
  char[] inputChars = input.toCharArray();
  java.util.Arrays.sort(inputChars);
  
  for (int i = 1; i < inputChars.length; i++) {
    if (inputChars[i] == inputChars[i - 1]) return null;
  }
  
  return String.valueOf(inputChars);
}

void keypadReset(OOCSIEvent event, OOCSIData response) {
  response.data("result", "ok");
  
  if (event.getSender() != sender) {
    response.data("result", "error");
    return;
  }
  
  //received a valid reset message:
  code = null;
  sender = null;
  
  println("reset");
}

void draw() {
  if (code == null) return;
  if (arduino.available() == 0) return;
  
  String inputValue = arduino.readStringUntil('\n').trim();
  println(inputValue);
  
  if (inputValue.equals(code)) {
    oocsi.channel(sender).data("type", "success").send();
    
    code = null;
    sender = null;
  } else {
    oocsi.channel(sender).data("type", "input").send();  
  }
}