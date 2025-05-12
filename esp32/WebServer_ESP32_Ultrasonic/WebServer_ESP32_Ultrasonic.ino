#include <WiFi.h>
#include <HTTPClient.h>

//const char* ssid = "VTR-6216549";
//const char* password = "n4rdVvqptnkf";

//nat
const char* ssid = "HUAWEI Y8s";
const char* password = "jubiloso123";

// HTTP settings for LOCAL HOSTED Flask server
const int portnum = 5000;
IPAddress server_ip(192, 168, 43, 147);  // <-- IP de tu servidor Flask
const char * server_url = "http://192.168.43.147:5000/sensor-data";  // <-- Dirección del servidor


//Nivel de luz: variables
#define LightLevel 32
uint8_t gotLightLevel;


// Nivel de agua pins (sensor ultrasónico)
#define WaterLevel_echo 34
#define WaterLevel_trigger 19
uint8_t gotWaterLevel;

//Variables de calculo del nivel de agua
float tiempo_espera;
float distancia;

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

  

  digitalWrite(WaterLevel_trigger, LOW);
  delayMicroseconds(2);
  digitalWrite(WaterLevel_trigger, HIGH);
  delayMicroseconds(10);  // El sensor necesita al menos 10 µs de tranmisión
  digitalWrite(WaterLevel_trigger, LOW);

  tiempo_espera = pulseIn(WaterLevel_echo, HIGH);
  gotWaterLevel = (tiempo_espera / 2.0) / 58.2; //Distancia
  Serial.println(gotWaterLevel);
  delay(100);

  gotLightLevel = digitalRead(LightLevel);
  Serial.println(gotLightLevel);

  sendSensorData();
  delay(3000);
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
  //Set pins nivel de agua
  pinMode(WaterLevel_echo, INPUT);
  pinMode(WaterLevel_trigger, OUTPUT);
  digitalWrite(WaterLevel_trigger, LOW);

  //Set pins nivel de luz
  pinMode(LightLevel, INPUT);


}

void sendSensorData(){
  HTTPClient http;
  http.begin(server_url);
  http.addHeader("Content-Type", "application/json");


  String requestData = "{\"WaterLevel\": " + String(gotWaterLevel) + ", \"LightLevel\": " + String(gotLightLevel)+"}";

  int httpCode = http.POST(requestData);
  String payload = http.getString(); //Guarda la respuesta del servidor (sirve para depurar el servidor o verificar)

  Serial.println(httpCode);
  http.end();
  Serial.println("Sent POST URLencoded request to server.");
  Serial.println();
}