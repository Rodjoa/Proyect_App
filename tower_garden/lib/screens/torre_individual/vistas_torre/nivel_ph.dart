import 'package:flutter/material.dart';

class PhLevel extends StatelessWidget {
  final Map<String, dynamic> sensorData; // Recibe datos desde el padre

  const PhLevel({super.key, required this.sensorData});

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
    final phLevel = sensorData["pH_Level"].toDouble();
    final status = _getPhStatus(phLevel);

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
              phLevel.toStringAsFixed(2),
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
