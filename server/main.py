from flask import Flask, jsonify, request
from supabase import create_client, Client
import json
from typing import Dict, Any

app = Flask(__name__)

# Configura Supabase
SUPABASE_URL: str = "https://dvooslnwoiunvxezieht.supabase.co"
SUPABASE_KEY: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2b29zbG53b2l1bnZ4ZXppZWh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzODk0MDEsImV4cCI6MjA2Njk2NTQwMX0.NVjdejGHo0uUpVxec6E6la3jBXXRxakOz90ZW2tzELM"

try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("Conexión a Supabase establecida correctamente")
except Exception as e:
    print(f"Error al conectar con Supabase: {str(e)}")
    supabase = None

TABLE_NAME = "sensor_data"  # Asegúrate que sea EXACTAMENTE el nombre de tu tabla en Supabase

@app.route('/sensor-data', methods=['POST'])
def receive_sensor_data():
    if supabase is None:
        return jsonify({"error": "Error de conexión con la base de datos"}), 500

    if not request.data:
        return jsonify({"error": "No se recibieron datos"}), 400

    try:
        print("Datos raw recibidos:", request.data)
        raw_text = request.data.decode('utf-8', errors='replace')
        print("Datos decodificados:", raw_text)

        try:
            data: Dict[str, Any] = request.get_json(force=True)
        except Exception as e:
            return jsonify({
                "error": "JSON inválido",
                "details": str(e),
                "received": raw_text
            }), 400

        required_fields = {
            'water_level': (int, float),
            'light_level': (int, float),
            'battery_level': (int, float),
            'ph_level': (int, float)
        }

        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return jsonify({
                "error": f"Campos faltantes: {', '.join(missing_fields)}",
                "required_fields": list(required_fields.keys())
            }), 400

        type_errors = []
        for field, valid_types in required_fields.items():
            if not isinstance(data[field], valid_types):
                # Intentar convertir a float si no es numérico
                try:
                    data[field] = float(data[field])
                except Exception:
                    type_errors.append(f"El campo {field} debe ser numérico")

        if type_errors:
            return jsonify({
                "error": "Error de tipo en los datos",
                "details": type_errors
            }), 400

        insert_data = {
            "water_level": float(data['water_level']),
            "light_level": int(data['light_level']),
            "battery_level": float(data['battery_level']),
            "ph_level": float(data['ph_level']),
            #"client_ip": request.remote_addr or "unknown"
        }

        try:
            response = supabase.table(TABLE_NAME).insert(insert_data).execute()
            print("Respuesta Supabase:", response)

            if hasattr(response, 'data') and response.data:
                return jsonify({
                    "status": "Datos almacenados",
                    "id": response.data[0].get('id')
                }), 200
            else:
                return jsonify({
                    "error": "Respuesta inesperada de Supabase",
                    "response": str(response)
                }), 500

        except Exception as e:
            print(f"Error al insertar en Supabase: {str(e)}")
            return jsonify({
                "error": "Error al guardar datos",
                "details": str(e)
            }), 500

    except Exception as e:
        print(f"Error interno del servidor: {str(e)}")
        return jsonify({
            "error": "Error interno del servidor",
            "details": str(e)
        }), 500

@app.route('/sensor-data', methods=['GET'])
def get_sensor_data():
    if supabase is None:
        return jsonify({"error": "Error de conexión con la base de datos"}), 500

    try:
        response = supabase.table(TABLE_NAME) \
                        .select("*") \
                        .order("created_at", desc=True) \
                        .limit(1) \
                        .execute() 

        if not response.data:
            return jsonify({
                "error": "No hay datos disponibles",
                "suggestion": f"Verifique que la tabla '{TABLE_NAME}' existe y contiene registros"
            }), 404
            
        return jsonify(response.data[0]), 200
    
    except Exception as e:
        print(f"Error al recuperar datos: {str(e)}")
        return jsonify({
            "error": "Error al recuperar datos",
            "details": str(e)
        }), 500
    

#ENDPOINT DATOS HISTORICOS (60)

@app.route('/sensor-data/historical', methods=['GET'])
def get_sensor_data_hist():
    if supabase is None:
        return jsonify({"error": "Error de conexión con la base de datos"}), 500

    try:
        response = supabase.table(TABLE_NAME) \
                        .select("ph_level, created_at") \
                        .order("created_at", desc=True) \
                        .limit(60) \
                        .execute()

        if not response.data:
            return jsonify({
                "error": "No hay datos disponibles",
                "suggestion": f"Verifique que la tabla '{TABLE_NAME}' existe y contiene registros"
            }), 404
            
        return jsonify(response.data), 200
    
    except Exception as e:
        print(f"Error al recuperar datos: {str(e)}")
        return jsonify({
            "error": "Error al recuperar datos",
            "details": str(e)
        }), 500







if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
