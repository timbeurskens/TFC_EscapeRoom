class FinalLevel extends SubLevel {
  String introFile() {
    //todo: enter the right filename
    return "g10Tones";
  }
  
  String targetDisks() {
    //todo: enter the right disk indexes
    //xor 0110100101
    return "";
  }
  
  void setup() {
    //reset target disks
    keypadTarget = "12479";
    
    printMessage("A high pitched tone = 1, a low pitched tone = 0");
  }
  
  void completed() {
    //unlock the safe
    OOCSICall call = oocsi.call("combinationLock", 1000).data("unlock", true).sendAndWait();
    println(call);
  }
}