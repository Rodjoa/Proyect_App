import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhLevel extends StatefulWidget {
  const PhLevel({super.key});

  @override
  _PhLevelState createState() => _PhLevelState();
}

class _PhLevelState extends State<PhLevel> {
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

  String _getPhStatus(double phValue) {
    if (phValue < 6.5) return "bajo";
    if (phValue > 8.5) return "alto";
    return "normal";
  }

  String _getMessage(String status) {
    switch (status) {
      case "bajo":
        return 'El pH está bajo. Agua ácida.';
      case "alto":
        return 'El pH está alto. Agua alcalina.';
      case "normal":
        return 'pH dentro de los niveles normales.';
      default:
        return 'Error al leer el pH.';
    }
  }

  IconData _getPhIcon(String status) {
    switch (status) {
      case "bajo":
        return Icons.science_outlined;
      case "alto":
        return Icons.science;
      case "normal":
        return Icons.check_circle_outline;
      default:
        return Icons.error_outline;
    }
  }

  Color _getPhColor(String status) {
    switch (status) {
      case "bajo":
        return Colors.redAccent;
      case "alto":
        return Colors.orangeAccent;
      case "normal":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sensorData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final phValue = sensorData!["pH_Level"].toDouble();
    final status = _getPhStatus(phValue);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getPhIcon(status), size: 120, color: _getPhColor(status)),
            const SizedBox(height: 20),
            Text(
              'Nivel de pH',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              phValue.toStringAsFixed(2),
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
