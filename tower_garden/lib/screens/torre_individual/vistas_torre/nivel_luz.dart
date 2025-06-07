import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LightLevel extends StatefulWidget {
  const LightLevel({super.key});

  @override
  _LightLevelState createState() => _LightLevelState();
}

class _LightLevelState extends State<LightLevel> {
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

  String _getLightLevelStatus(double lightValue) {
    if (lightValue == 1)
      return "bajo";
    else if (lightValue == 0)
      return "alto";
    return "medio";
  }

  String _getMessage(String status) {
    switch (status) {
      case "bajo":
        return 'Nivel de luz bajo';
      case "medio":
        return 'Nivel de luz intermedio';
      case "alto":
        return 'Nivel de luz alto';
      default:
        return 'Error en la medición';
    }
  }

  IconData _getLightIcon(String status) {
    switch (status) {
      case "bajo":
        return Icons.wb_sunny_outlined;
      case "medio":
        return Icons.wb_sunny;
      case "alto":
        return Icons.wb_sunny_rounded;
      default:
        return Icons.error_outline;
    }
  }

  Color _getIconColor(String status) {
    switch (status) {
      case "bajo":
        return Colors.orange.shade200;
      case "medio":
        return Colors.orange.shade400;
      case "alto":
        return Colors.orange.shade700;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sensorData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final status = _getLightLevelStatus(sensorData!["LightLevel"].toDouble());

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
              Icon(
                _getLightIcon(status),
                size: 120,
                color: _getIconColor(status),
              ),
              const SizedBox(height: 20),
              Text(
                'Nivel actual de luz',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sensorData!["LightLevel"].toStringAsFixed(2),
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
      ),
    );
  }
}
