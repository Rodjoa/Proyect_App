import 'package:flutter/material.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_luz.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_ph.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_agua.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_bateria.dart';

class EstadoTorre extends StatelessWidget {
  const EstadoTorre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estado de la Torre"),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)], // Blanco a celeste claro
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Seleccione una opción",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 30),

            // Botón - Nivel de Agua
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WaterLevel()),
                  ),
              icon: const Icon(Icons.water_drop),
              label: const Text("Nivel de Agua"),
              style: _botonEstilo(),
            ),
            const SizedBox(height: 20),

            // Botón - Nivel de pH
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const pHLevel()),
                  ),
              icon: const Icon(Icons.science),
              label: const Text("Nivel de pH"),
              style: _botonEstilo(),
            ),
            const SizedBox(height: 20),

            // Botón - Nivel de Luz
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LightLevel()),
                  ),
              icon: const Icon(Icons.wb_sunny),
              label: const Text("Nivel de Luz"),
              style: _botonEstilo(),
            ),
            const SizedBox(height: 20),

            // Botón - Nivel de Batería
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BatteryLevel(),
                    ),
                  ),
              icon: const Icon(Icons.battery_1_bar_outlined),
              label: const Text("Nivel de Batería"),
              style: _botonEstilo(),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _botonEstilo() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF43A047), // Verde
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }
}
