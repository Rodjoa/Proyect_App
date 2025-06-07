import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BatteryLevel extends StatefulWidget {
  const BatteryLevel({super.key});

  @override
  _BatteryLevelState createState() => _BatteryLevelState();
}

class _BatteryLevelState extends State<BatteryLevel> {
  Map<String, dynamic>? sensorData;
  bool _hasError = false; // para controlar error en la carga

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.8:5000/sensor-data'),
      );

      if (response.statusCode == 200) {
        setState(() {
          sensorData = jsonDecode(response.body) as Map<String, dynamic>;
          print("Parsed sensorData: $sensorData"); //hacemos debug
          _hasError = false;
        });
      } else {
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("initState Called Battery");
    fetchSensorData();
  }

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

  @override
  Widget build(BuildContext context) {
    // Manejo de error y carga
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No se pudo obtener los datos'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                });
                fetchSensorData();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (sensorData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final double batteryValue = sensorData!["BatteryLevel"]?.toDouble() ?? 0;
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
