#include <Ed25519.h>
#include "secrets.h"
#include <WaspFrame.h>

char moteID[] = "node_01";

uint8_t signature[64];
uint8_t* privateKey = signing_key;
uint8_t* publicKey = verifying_key;

void setup() {
  USB.ON();
  frame.setID(moteID);
}

void loop() {
  frame.createFrame(ASCII);
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

  USB.print("Frame buffer: "); USB.println((char*) frame.buffer);

  USB.println("Signing frame buffer...");
  Ed25519::sign(signature, privateKey, publicKey, frame.buffer, sizeof(frame.buffer));

  USB.print("Signature length: "); USB.println(sizeof(signature));
  USB.print("Signature: "); USB.println((char*) signature);

  frame.addSensor(SENSOR_STR, (char*) signature);
  USB.print("Frame buffer: "); USB.println((char*) frame.buffer);

  frame.showFrame();
  delay(10000);
}
