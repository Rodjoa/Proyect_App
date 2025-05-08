from flask import Flask, jsonify, request



app = Flask(__name__)
sensor_data = {}

#Endpoint para recibir (POST) datos del esp32 en el servidor
@app.route('/sensor-data', methods=['POST'])
def receive_sensor_data():
    global sensor_data
    data = request.get_json()
    print("Datos recibidos:", data)
    sensor_data = data
    return jsonify({"status": "ok"}), 200

#Endpoint para solicitar (GET) datos al server mediante la app movil
@app.route('/sensor-data', methods=['GET'])
def get_sensor_data():
    return jsonify(sensor_data), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)