//Define sensor pinout
const byte nrSensors = 10;
const int sensorPins[nrSensors] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
const int sampleFrequency = 5; //Hz

bool sensorValues[nrSensors];
bool sensorDebounceValues[nrSensors];

void setup() {
  initializeSensorPins();

  Serial.begin(9600);
}

void loop() {
  delay(1000 / sampleFrequency);

  for (byte i = 0; i < nrSensors; i++) {
    if (sampleSensor(i)) {
      Serial.write(i);
    }
  }
}

void initializeSensorPins() {
  for (byte i = 0; i < nrSensors; i++) {
    pinMode(sensorPins[i], INPUT_PULLUP);
  }
}

//sampleSensor reads the value of sensor i and returns true if this value has changed
bool sampleSensor(int i) {
  bool value = digitalRead(sensorPins[i]);

  if (value == sensorValues[i]) {
    //no state change detected, or previous measure was invalid
    sensorDebounceValues[i] = value;
    return false;
  } else if (value == sensorDebounceValues[i]) {
    //state change detected and detected stable
    sensorValues[i] = value;
    return true;
  } else {
    //state change detected, debounce activated
    sensorDebounceValues[i] = value;
    return false;
  }
}

