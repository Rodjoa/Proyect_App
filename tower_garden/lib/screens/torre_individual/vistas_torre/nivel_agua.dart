import 'package:flutter/material.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/noti_service.dart';

class WaterLevel extends StatelessWidget {
  final Map<String, dynamic> sensorData; // Recibe datos desde el padre

  const WaterLevel({required this.sensorData, super.key});

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
    final waterValue = sensorData["WaterLevel"].toDouble();
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
            const SizedBox(height: 15),
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
