import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;
import java.util.*;

Map<String, Integer> durations = new HashMap<String, Integer>();

OOCSI oocsi;
String keypadTarget = "";

//mutex for locking level code and waiting for completion
Object levelLock = new Object();

List<SubLevel> sublevels;

void setup() {
  durations.put("g10Blauw", 8);
  durations.put("g10Final", 11);
  durations.put("g10Hacking 2", 7);
  durations.put("g10Hacking", 7);
  durations.put("g10Intro", 17);
  durations.put("g10Lights", 19);
  durations.put("g10SomethingBlue", 10);
  durations.put("g10Tetris", 11);
  durations.put("g10Tones", 3);
  
  noLoop();
  
  oocsi = new OOCSI(this, "levelGroup10", "oocsi.id.tue.nl");
  sublevels = new ArrayList<SubLevel>();
  
  sublevels.add(new BlueLevel());
  sublevels.add(new GameLevel());
  sublevels.add(new LightsLevel());
  
  //randomize the first 3 levels
  Collections.shuffle(sublevels);
  
  sublevels.add(new HackerLevel());
  sublevels.add(new FinalLevel());
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
    println("playing: " + audiofile);
    OOCSICall call = oocsi.call("soundbox", "play", 1000).data("name", audiofile).sendAndWait();
    try {
      Thread.sleep(durations.getOrDefault(audiofile, 0) * 1000);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    
}

void playAsync(String audiofile) {  
  println("playing: " + audiofile);
    oocsi.call("soundbox", "play", 1000).data("name", audiofile).sendAndWait();
}

void printMessage(String message) {
  oocsi.channel("sPrinter").data("sPrintermessage", message).send();
}