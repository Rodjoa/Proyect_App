import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WaterLevel extends StatefulWidget {
  const WaterLevel({super.key});

  @override
  _WaterLevelState createState() => _WaterLevelState();
}

class _WaterLevelState extends State<WaterLevel> {
  Map<String, dynamic>? sensorData;

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.8:5000/sensor-data'),
      );

      if (response.statusCode == 200) {
        setState(() {
          sensorData = jsonDecode(response.body) as Map<String, dynamic>;
        });
      } else {
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  String _getWaterLevelStatus(double waterValue) {
    if (waterValue > 40)
      return "bajo";
    else if (waterValue > 20)
      return "medio";
    else
      return "lleno";
  }

  String _getMessage(String status) {
    switch (status) {
      case "bajo":
        return 'Bajo nivel de agua, por favor llene el estanque';
      case "medio":
        return 'Estanque medio';
      case "lleno":
        return 'Estanque lleno';
      default:
        return 'Error en la medición';
    }
  }

  IconData _getWaterIcon(String status) {
    switch (status) {
      case "bajo":
        return Icons.water_drop_outlined;
      case "medio":
        return Icons.water_drop;
      case "lleno":
        return Icons.water;
      default:
        return Icons.error_outline;
    }
  }

  Color _getWaterColor(String status) {
    switch (status) {
      case "bajo":
        return Colors.red.shade300;
      case "medio":
        return Colors.orange.shade400;
      case "lleno":
        return Colors.blue.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sensorData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final waterValue = sensorData!["WaterLevel"].toDouble();
    final status = _getWaterLevelStatus(waterValue);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getWaterIcon(status),
              size: 120,
              color: _getWaterColor(status),
            ),
            const SizedBox(height: 20),
            Text(
              'Nivel actual de agua',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              waterValue.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getMessage(status),
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
