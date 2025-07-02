import 'package:flutter/material.dart';

class LightLevel extends StatelessWidget {
  final Map<String, dynamic> sensorData; // Recibe datos desde el padre

  const LightLevel({super.key, required this.sensorData});

  String _getLightLevelStatus(double value) {
    if (value == 1) return "bajo";
    if (value == 0) return "alto";
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
    //final lightLevel = sensorData["light_level"].toDouble();
    final lightLevel = safeDouble(sensorData["light_level"]); //trato de null
    final status = _getLightLevelStatus(lightLevel);

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
                lightLevel.toStringAsFixed(2),
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
