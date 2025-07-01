import 'package:flutter/material.dart';

// Ahora BatteryLevel es Stateless, porque ya no hace fetch por sí misma.
class BatteryLevel extends StatelessWidget {
  final Map<String, dynamic>? sensorData; // Datos que vienen desde el padre

  const BatteryLevel({super.key, required this.sensorData});

  // Función para obtener el icono según el nivel de batería
  IconData _getBatteryIcon(double batteryValue) {
    if (batteryValue > 80) {
      return Icons.battery_full;
    } else if (batteryValue > 50) {
      return Icons.battery_6_bar;
    } else if (batteryValue > 20) {
      return Icons.battery_3_bar;
    } else {
      return Icons.battery_alert;
    }
  }

  // Función para obtener el color según el nivel de batería
  Color _getBatteryColor(double batteryValue) {
    if (batteryValue > 80) {
      return Colors.green;
    } else if (batteryValue > 50) {
      return Colors.yellow.shade700;
    } else if (batteryValue > 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Función para obtener un mensaje de estado (opcional)
  String _getBatteryMessage(double batteryValue) {
    if (batteryValue > 80) {
      return "Batería alta";
    } else if (batteryValue > 50) {
      return "Batería media";
    } else if (batteryValue > 20) {
      return "Batería baja";
    } else {
      return "Batería crítica";
    }
  }

  //Funcion añadida para asegurar el null
  double safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0; // por si llega otro tipo inesperado
  }
  //fin funcion

  @override
  Widget build(BuildContext context) {
    // Manejo de error y carga
    /*
    if (sensorData == null) {    //Funcion para progress con valores nulos
      return const Center(child: CircularProgressIndicator());
    }
    */

    //Capturamos los nulos y dejamos con las mismas minusculas que el server
    /*
    final batteryValue =
        sensorData?["battery_level"] != null
            ? sensorData!["battery_level"].toDouble()
            : 0.0;

    final icon = _getBatteryIcon(batteryValue);
    final color = _getBatteryColor(batteryValue);
    final message = _getBatteryMessage(batteryValue);
    */
    //intento arreglo

    final batteryValue = safeDouble(sensorData?["battery_level"] ?? 0.0);

    final icon = _getBatteryIcon(batteryValue);
    final color = _getBatteryColor(batteryValue);
    final message = _getBatteryMessage(batteryValue);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 120, color: color),
              const SizedBox(height: 20),
              Text(
                'Nivel actual de batería',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${batteryValue.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
