#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "VTR-6216549";
const char* password = "n4rdVvqptnkf";

// HTTP settings for LOCAL HOSTED Flask server
const int portnum = 5000;
IPAddress server_ip(192, 168, 0, 10);  // <-- IP de tu servidor Flask
const char * server_url = "http://192.168.0.10:5000/sensor-data";  // <-- Dirección del servidor

// Humedad pins
#define Humidity 34
#define LED 4
uint8_t gotHumidity;

void setEspPins();
void startWifi();
void sendSensorData();

void setup() {
  setEspPins();
  Serial.begin(115200); 
  startWifi();
  Serial.println();
}

void loop() {
  if(digitalRead(Humidity) == 1) {
    Serial.println("It's dark!");
    gotHumidity = 0;
  }
  else {
    Serial.println("Se detecta humedad");
    gotHumidity = 1;
  }

  sendSensorData();
  delay(7000);
}

void startWifi() { 
  WiFi.mode(WIFI_STA);               
  WiFi.begin(ssid, password);        
  Serial.print("Connecting to ");
  Serial.print(ssid); Serial.println(" ...");
  
  int i = 0;
  while (WiFi.status() != WL_CONNECTED) {   
    delay(1000);
    Serial.print(++i); Serial.print(' ');
    Serial.println(WiFi.status());
  }

  Serial.println('\n');
  Serial.println("Connection established!");  
  Serial.print("Connected to ");
  Serial.println(WiFi.SSID());              
  Serial.print("IP address:\t");
  Serial.println(WiFi.localIP());           
}

void setEspPins() {  
  pinMode(Humidity, INPUT);
  pinMode(LED, OUTPUT);
  digitalWrite(LED, HIGH);
}

void sendSensorData(){
  HTTPClient http;
  http.begin(server_url);
  http.addHeader("Content-Type", "application/json");

  String requestData = "{\"humedad\": " + String(gotHumidity) + ", \"count\": true}";
  int httpCode = http.POST(requestData);
  String payload = http.getString(); //Guarda la respuesta del servidor (sirve para depurar el servidor o verificar)

  Serial.println(httpCode);
  http.end();
  Serial.println("Sent POST URLencoded request to server.");
  Serial.println();
}