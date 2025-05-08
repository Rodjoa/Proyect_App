import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_luz.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_ph.dart';
import 'package:tower_garden/widgets/botones_home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_agua.dart';

//Aquí se gestionan los datos de los sensores y se envían como props a sus vistas respectivas

// Se evalúa eliminar login por ahora (hasta que se despliegue en servidor firebase)

//Se actualizan los datos al entrar a ESTADO TORRE
class EstadoTorre extends StatelessWidget {
  const EstadoTorre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estado Torre")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botones que navegan a las sub-vistas con los datos actuales
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WaterLevel()),
                  ),
              child: const Text("Nivel de Agua"),
            ),

            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pHLevel()),
                  ),
              child: const Text("Nivel de pH"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LightLevel()),
                  ),
              child: const Text("Nivel de Luz"),
            ),
          ],
        ),
      ),
    );
  }
}
