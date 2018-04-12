class HackerLevel extends SubLevel {
  String introFile() {
    //todo: enter the right filename
    return "g10Hacking";
  }
  
  String targetDisks() {
    //todo: enter the right disk indexes
    
    return "";
  }
  
  void setup() {
    printMessage("Try to find the code for the last 3 disks");
  }
  
  void completed() {
    playSync("g10Hacking 2");
  }
}