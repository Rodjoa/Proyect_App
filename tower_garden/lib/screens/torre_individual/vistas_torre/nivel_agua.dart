import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';

class WaterLevel extends StatefulWidget {
  final int data; //Dato recibido por el sensor o simulado

  const WaterLevel({Key? key, required this.data}) : super(key: key);

  @override
  _WaterLevelState createState() => _WaterLevelState();
}

class _WaterLevelState extends State<WaterLevel> {
  //variable en base a valor agua que diga status (bajo, medio , lleno)
  //variable en base a status que diga qué path de imagen mostrar
  //Definimos funciones que retornan String y que reciben un parámetro
  String _getWaterLevelStatus(int waterValue) {
    if (waterValue < 30)
      return "bajo";
    else if (waterValue < 70)
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
        return 'Error en la medición'; // Opción segura
    }
  }

  String _getImagePath(String status) {
    switch (status) {
      case "bajo":
        return 'images/LowLevelWater.jpeg';
      case "medio":
        return 'images/MediumLevelWater.jpeg';
      case "lleno":
        return 'images/HighLevelWater.jpeg';
      default:
        return 'images/ErrorLeveWater.png'; // Opción segura
    }
  }

  @override
  Widget build(BuildContext context) {
    //En el build las variables de arriba se ponen como tipo final
    final status = _getWaterLevelStatus(widget.data);
    final imagePath = _getImagePath(status);
    final message = _getMessage(status);

    //PROBLEMA: NO PRINTEA
    print("Status: $status"); // Debe ser "bajo", "medio" o "lleno"
    print("Image path: $imagePath"); // Debe mostrar una ruta válida

    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel de agua"), // No cambia con el estado
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),

            Text('Nivel de agua: ${widget.data}'),
            Text(message),
            /*)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _contador++;
                });
              },
              child: Text("Actualizar"),
            ),
            */
          ],
        ),
      ),
    );
  }
}
