import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class WaterLevel extends StatefulWidget {
  const WaterLevel({super.key});

  @override
  _WaterLevelState createState() => _WaterLevelState();
}

class _WaterLevelState extends State<WaterLevel> {
  //Implementamos initState() para pedir los datos al ingresar

  Map<String, dynamic>? SensorData;
  /*Sobre la variable SensorData:

La función jsonDecode() toma esta cadena JSON y la convierte en un objeto 
de tipo Map<String, dynamic>. Es decir, convierte los datos de JSON en un 
Map de Dart donde las claves son de tipo String y los valores pueden ser 
de cualquier tipo (dynamic).
*/

  // Método para pedir los datos al servidor
  //Future: Se usa cuando el valor llega más adelante
  //<void>: Función fetchSensorData no retorna nada
  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.10:5000/sensor-data'),
        //para emuladores android usar ip (OJO por si funciona no mas)
        //Uri.parse('http://10.0.2.2:5000/sensor-data'),
      );

      if (response.statusCode == 200) {
        // Si la respuesta es 200 OK, parseamos los datos
        setState(() {
          print(" Response 200: OK");
          SensorData = jsonDecode(response.body) as Map<String, dynamic>;
          print("SensorData recibido: $SensorData");
        });
      } else {
        // Si el servidor no retorna un 200, mostramos un error
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      // Manejo de errores si ocurre algún problema al hacer la solicitud
      print("Error: $e");
    }
  }

  @override
  initState() {
    // ignore: avoid_print
    super.initState();
    print("initState Called ***********");
    fetchSensorData();
  }

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
    //final status = _getWaterLevelStatus(widget.data);
    if (SensorData == null) {
      print("Valor de agua nulo");
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    //final waterValue = SensorData!["humedad"] as int; //Op. de afirmación nula
    final waterValue = (SensorData!["humedad"] ?? 0).toDouble();
    final status = _getWaterLevelStatus(waterValue);
    final imagePath = _getImagePath(status);
    final message = _getMessage(status);

    //PROBLEMA: NO PRINTEA
    print("Status: $status"); // Debe ser "bajo", "medio" o "lleno"
    print("Image path: $imagePath"); // Debe mostrar una ruta válida
    print("Humedad: $SensorData");

    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel de agua"), // No cambia con el estado
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),
            Text('Nivel de agua: $waterValue'),
            Text(message),
          ],
        ),
      ),
    );
  }
}
