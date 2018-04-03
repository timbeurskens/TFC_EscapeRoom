class FinalLevel extends SubLevel {
  String introFile() {
    //todo: enter the right filename
    return "";
  }
  
  String targetDisks() {
    //todo: enter the right disk indexes
    return "";
  }
  
  void setup() {
    //reset target disks
    keypadTarget = "";
  }
  
  void completed() {
    //unlock the safe
    OOCSICall call = oocsi.call("combinationLock", 1000).data("unlock", true).sendAndWait();
    println(call);
  }
}