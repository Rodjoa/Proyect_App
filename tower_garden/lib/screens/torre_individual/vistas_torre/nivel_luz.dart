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

  //Esta parte por ahora considera solo dos casos por sensor digital binario

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
        return Icons.wb_sunny_outlined; // Sol con poca luz
      case "medio":
        return Icons.wb_sunny; // Sol medio
      case "alto":
        return Icons.wb_sunny_rounded; // Sol brillante
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nivel de luz"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body:
          sensorData == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getLightIcon(
                            _getLightLevelStatus(
                              sensorData!["LightLevel"].toDouble(),
                            ),
                          ),
                          size: 120,
                          color: _getIconColor(
                            _getLightLevelStatus(
                              sensorData!["LightLevel"].toDouble(),
                            ),
                          ),
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
                          _getMessage(
                            _getLightLevelStatus(
                              sensorData!["LightLevel"].toDouble(),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
