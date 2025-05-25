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
  bool _hasError =
      false; // NUEVO: Bandera para saber si ocurrió un error al pedir los datos

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
        Uri.parse('http://192.168.0.8:5000/sensor-data'), //parametro de red
        //para emuladores android usar ip (OJO por si funciona no mas)
        //Uri.parse('http://10.0.2.2:5000/sensor-data'),
      );

      if (response.statusCode == 200) {
        // Si la respuesta es 200 OK, parseamos los datos
        setState(() {
          print(" Response 200: OK");
          SensorData = jsonDecode(response.body) as Map<String, dynamic>;
          print("SensorData recibido: $SensorData");
          _hasError =
              false; // NUEVO: aseguramos que no hay error si llegan datos
        });
      } else {
        // Si el servidor no retorna un 200, mostramos un error
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      // Manejo de errores si ocurre algún problema al hacer la solicitud
      print("Error: $e");
      setState(() {
        _hasError = true; // NUEVO: señalamos que hubo un error
      });
    }
  }

  @override
  initState() {
    // ignore: avoid_print
    super.initState();
    print("initState Called");
    fetchSensorData();
  }

  //variable en base a valor agua que diga status (bajo, medio , lleno)
  //variable en base a status que diga qué path de imagen mostrar
  //Definimos funciones que retornan String y que reciben un parámetro
  String _getWaterLevelStatus(double waterValue) {
    //el sensor cuenta 0 max agua y 255 sin agua (mala precisión)
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
        return 'Error en la medición'; // Opción segura
    }
  }

  // NUEVO: función que devuelve un icono según el estado
  IconData _getWaterIcon(String status) {
    switch (status) {
      case "bajo":
        return Icons.water_drop_outlined;
      case "medio":
        return Icons.water_drop;
      case "lleno":
        return Icons.water;
      default:
        return Icons.error_outline; // Icono por defecto si hay error
    }
  }

  // NUEVO: función que devuelve color según el estado
  Color _getWaterColor(String status) {
    switch (status) {
      case "bajo":
        return Colors.red;
      case "medio":
        return Colors.orange;
      case "lleno":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // NUEVO: Si aún no llegan los datos mostramos un loading/error con AppBar y botón de regreso
    if (SensorData == null) {
      print("Valor de agua nulo");

      return Scaffold(
        appBar: AppBar(
          title: Text("Nivel de agua"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Regresa a la pantalla anterior
            },
          ),
        ),
        body: Center(
          child:
              _hasError
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No se pudo obtener los datos'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _hasError = false;
                          });
                          fetchSensorData(); // Reintentar obtener datos
                        },
                        child: Text('Reintentar'),
                      ),
                    ],
                  )
                  : CircularProgressIndicator(), // Indicador de carga mientras esperamos
        ),
      );
    }

    //final waterValue = SensorData!["humedad"] as int; //Op. de afirmación nula
    final waterValue = (SensorData!["WaterLevel"] ?? 0).toDouble();
    //Nos aseguramos que waterValue sea double sin importar si el JSON lo envía como int o algun valor raro

    final status = _getWaterLevelStatus(waterValue);

    final message = _getMessage(status);

    //PROBLEMA: NO PRINTEA
    print("Status: $status"); // Debe ser "bajo", "medio" o "lleno"
    print("Nivel de agua: $SensorData");

    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel de agua"), // No cambia con el estado

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getWaterIcon(status),
              size: 100,
              color: _getWaterColor(status),
            ),

            Text('Nivel de agua: $waterValue'),
            Text(message),
          ],
        ),
      ),
    );
  }
}
