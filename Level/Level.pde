import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;
import java.util.*;

OOCSI oocsi;
String keypadTarget = "";

//mutex for locking level code and waiting for completion
Object levelLock = new Object();

List<SubLevel> sublevels;

void setup() {
  noLoop();
  oocsi = new OOCSI(this, "levelGroup10", "localhost");
  sublevels = new ArrayList<SubLevel>();
  
  sublevels.add(new BlueLevel());
  sublevels.add(new GameLevel());
  sublevels.add(new LightsLevel());
  
  //randomize the first 3 levels
  Collections.shuffle(sublevels);
  
  sublevels.add(new HackerLevel());
}

void draw() {
  //intro
  playSync("group10Intro");
  
  for(SubLevel sublevel : sublevels) {
      println("setting up sublevel: " + sublevel.getClass().getName());
    
      sublevel.setup();
    
      keypadTarget += sublevel.targetDisks();
      oocsi.call("keypadSet", 1000).data("code", keypadTarget);
      playAsync(sublevel.introFile());
      
      synchronized(levelLock) {
        try {
          //wait until keypad disks entered
          levelLock.wait();
        } catch(InterruptedException e) {
          e.printStackTrace();
        }
      }
      
      sublevel.completed();
      println("sublevel completed: " + sublevel.getClass().getName());
  }
  
  //panic
  playAsync("group10Panic");
  
  //final
  playSync("group10Final");
}

void handleOOCSIEvent(OOCSIEvent ev) {
    if(ev.has("type") && ev.getString("type").equals("success")) {
      synchronized(levelLock) {
        levelLock.notifyAll();
      }
    }
}

void playSync(String audiofile) {
    OOCSICall call = oocsi.call("soundbox", "play", 1000).data("name", audiofile).sendAndWait();
}

void playAsync(String audiofile) {  
    oocsi.call("soundbox", "play", 1000).data("name", audiofile).send();
}