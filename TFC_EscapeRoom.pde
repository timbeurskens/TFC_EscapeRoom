import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;

OOCSI oocsi;

void setup() {
  oocsi = new OOCSI(this, "group10", "localhost");
  
  oocsi.subscribe("lockChannel", "channelReceive");
}

void draw() {
  
}

void channelReceive(OOCSIEvent event) {
  
}