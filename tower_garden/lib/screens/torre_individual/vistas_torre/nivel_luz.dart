import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class LightLevel extends StatefulWidget {
  const LightLevel({super.key});

  @override
  _LightLevelState createState() => _LightLevelState();
}

class _LightLevelState extends State<LightLevel> {
  Map<String, dynamic>? SensorData;

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.147:5000/sensor-data'),
      );

      if (response.statusCode == 200) {
        setState(() {
          print("Response 200: OK");
          SensorData = jsonDecode(response.body) as Map<String, dynamic>;
          print("SensorData recibido: $SensorData");
        });
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  initState() {
    super.initState();
    print("initState Called ***********");
    fetchSensorData();
  }

  String _getLightLevelStatus(double lightValue) {
    // Aquí definimos rangos arbitrarios para la luz, puedes ajustarlos
    if (lightValue < 50)
      return "bajo";
    else if (lightValue < 200)
      return "medio";
    else
      return "alto";
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

  String _getImagePath(String status) {
    switch (status) {
      case "bajo":
        return 'images/lowlight.jpeg';
      case "medio":
        return 'images/mediumlight.jpeg';
      case "alto":
        return 'images/highlight.jpeg';
      default:
        return 'images/errorlight.jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (SensorData == null) {
      print("Valor de luz nulo");
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final lightValue = (SensorData!["LightLevel"] ?? 0).toDouble();
    final status = _getLightLevelStatus(lightValue);
    final imagePath = _getImagePath(status);
    final message = _getMessage(status);

    print("Status: $status");
    print("Image path: $imagePath");
    print("Nivel de luz: $SensorData");

    return Scaffold(
      appBar: AppBar(title: Text("Nivel de luz")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),
            Text('Nivel de luz: $lightValue'),
            Text(message),
          ],
        ),
      ),
    );
  }
}
