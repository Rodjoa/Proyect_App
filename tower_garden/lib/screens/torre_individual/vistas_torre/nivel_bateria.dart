import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class BatteryLevel extends StatefulWidget {
  const BatteryLevel({super.key});

  @override
  _BatteryLevelState createState() => _BatteryLevelState();
}

class _BatteryLevelState extends State<BatteryLevel> {
  Map<String, dynamic>? SensorData;
  bool _hasError = false;

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
  initState() {
    super.initState();
    print("initState Called");
    fetchSensorData();
  }

  String _getBatteryLevelStatus(double batteryValue) {
    if (batteryValue < 1.0)
      return "bajo";
    else if (batteryValue < 1.4)
      return "medio";
    else
      return "lleno";
  }

  String _getMessage(String status) {
    switch (status) {
      case "bajo":
        return 'Batería baja, conecte a fuente de energía';
      case "medio":
        return 'Nivel medio de batería';
      case "lleno":
        return 'Batería llena';
      default:
        return 'Error en la medición';
    }
  }

  IconData _getBatteryIcon(String status) {
    switch (status) {
      case "bajo":
        return Icons.battery_alert;
      case "medio":
        return Icons.battery_4_bar;
      case "lleno":
        return Icons.battery_full;
      default:
        return Icons.error_outline;
    }
  }

  Color _getBatteryColor(String status) {
    switch (status) {
      case "bajo":
        return Colors.red;
      case "medio":
        return Colors.orange;
      case "lleno":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (SensorData == null) {
      print("Valor de batería nulo");

      return Scaffold(
        appBar: AppBar(
          title: Text("Nivel de batería"),
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

    final batteryValue = (SensorData!["BatteryLevel"] ?? 0).toDouble();
    final percent = ((batteryValue / 1.6) * 100).clamp(0, 100).round();
    final status = _getBatteryLevelStatus(batteryValue);
    final message = _getMessage(status);

    print("Status: $status");
    print("Nivel de batería: $SensorData");

    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel de batería"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getBatteryIcon(status),
              size: 100,
              color: _getBatteryColor(status),
            ),
            Text('Nivel de batería: $percent%'),
            Text(message),
          ],
        ),
      ),
    );
  }
}
