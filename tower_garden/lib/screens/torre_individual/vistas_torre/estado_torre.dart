import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_luz.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_ph.dart';
import 'package:tower_garden/widgets/botones_home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/nivel_agua.dart';

//Aquí se gestionan los datos de los sensores y se envían como props a sus vistas respectivas

// Se evalúa eliminar login por ahora (hasta que se despliegue en servidor firebase)

//Se actualizan los datos al entrar a ESTADO TORRE
class EstadoTorre extends StatefulWidget {
  const EstadoTorre({super.key});

  @override
  _EstadoTorreState createState() => _EstadoTorreState();
}

class _EstadoTorreState extends State<EstadoTorre> {
  // Datos de los sensores (estado interno)
  int _aguaValue = 10;
  int _phValue = 7;
  int _luzValue = 50;

  @override
  void initState() {
    super.initState();
    _cargarDatosSensores(); // Simulación: carga datos al iniciar
    //Reemplazar _cargarDatosSensores() por una llamada al servidor
  }

  // Simula la obtención de datos (en un caso real, sería una API o hardware)
  //Dentro de esta función tendría que implementar la recolección de los datos pidiéndolos al servidor local (por ahora)
  void _cargarDatosSensores() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _aguaValue = 25; // Ejemplo: valor de agua
        _phValue = 9; // Ejemplo: valor de pH
        _luzValue = 70; // Ejemplo: valor de luz
      });
    });
  }

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
                    MaterialPageRoute(
                      builder: (context) => WaterLevel(data: _aguaValue),
                    ),
                  ),
              child: const Text("Nivel de Agua"),
            ),

            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => pHLevel(pHValue: _phValue),
                    ),
                  ),
              child: const Text("Nivel de pH"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LightLevel(lightValue: _luzValue),
                    ),
                  ),
              child: const Text("Nivel de Luz"),
            ),
          ],
        ),
      ),
      // Botón para simular actualización
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _cargarDatosSensores,
        child: const Icon(Icons.refresh),
      ),
      */
    );
  }
}
