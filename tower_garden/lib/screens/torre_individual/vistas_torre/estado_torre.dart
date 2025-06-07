import 'package:flutter/material.dart';
import 'nivel_agua.dart';
import 'nivel_ph.dart';
import 'nivel_luz.dart';
import 'nivel_bateria.dart';
import 'nivel_ph.dart';

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
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SizedBox(height: 20),

            // Cada uno debe ser un widget que muestre la tarjeta, no el scaffold completo.
            WaterLevel(), // Cambia el nombre para que no tenga scaffold
            SizedBox(height: 20),

            PhLevel(), // Igual, solo tarjeta sin scaffold
            SizedBox(height: 20),

            LightLevel(),
            SizedBox(height: 20),

            BatteryLevel(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
