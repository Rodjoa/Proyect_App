import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/noti_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:tower_garden/screens/torre_individual/vistas_torre/noti_service.dart';

class WaterLevel extends StatefulWidget {
  const WaterLevel({super.key});

  @override
  _WaterLevelState createState() => _WaterLevelState();
}

class _WaterLevelState extends State<WaterLevel> {
  Map<String, dynamic>? SensorData;
  bool _hasError = false; // Bandera para errores al pedir datos

  Future<String>?
  _statusFuture; // NUEVO: almacenamos el estado del agua una sola vez

  // Método para pedir los datos al servidor
  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.8:5000/sensor-data'),
      );

      if (response.statusCode == 200) {
        setState(() {
          print(" Response 200: OK");
          SensorData = jsonDecode(response.body) as Map<String, dynamic>;
          print("SensorData recibido: $SensorData");
          _hasError = false;
        });
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("initState Called");

    // NUEVO: Pedimos los datos y preparamos el futuro del estado del agua
    fetchSensorData().then((_) {
      final waterValue = (SensorData?["WaterLevel"] ?? 0).toDouble();
      _statusFuture = _getWaterLevelStatus(
        waterValue,
      ); // Solo se calcula una vez
      setState(
        () {},
      ); // Para que se reconstruya el widget con el nuevo _statusFuture
    });
  }

  // Función que devuelve "bajo", "medio" o "lleno"
  //Se define Future<String> porque incluye una llamada asincrónica:para las notificaciones (async/await)
  Future<String> _getWaterLevelStatus(double waterValue) async {
    if (waterValue > 40) {
      try {
        await NotiService().showNotification(
          title: "Alerta de agua",
          body: "Por favor, rellene el estanque",
        );
        return "bajo";
      } catch (e) {
        print('Error al mostrar notificación: $e');
        return "bajo";
      }
    } else if (waterValue > 20) {
      return "medio";
    } else {
      return "lleno";
    }
  }

  // Devuelve el mensaje a mostrar en pantalla
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

  // Devuelve el ícono según el estado
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

  // Devuelve color según el estado
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
    // Si no llegaron aún los datos del sensor, mostramos loading o error
    if (SensorData == null || _statusFuture == null) {
      print("SensorData o statusFuture aún no listos");
      return Scaffold(
        appBar: AppBar(
          title: Text("Nivel de agua"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
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
                          fetchSensorData();
                        },
                        child: Text('Reintentar'),
                      ),
                    ],
                  )
                  : CircularProgressIndicator(),
        ),
      );
    }

    final waterValue = (SensorData!["WaterLevel"] ?? 0).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel de agua"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: _statusFuture, // Usamos el estado ya guardado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Error al calcular estado del agua"));
          }

          final status = snapshot.data!;
          final message = _getMessage(status);

          // Confirmación por consola
          print("Status: $status");
          print("Nivel de agua: $SensorData");

          return Center(
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
          );
        },
      ),
    );
  }
}
