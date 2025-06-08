import 'package:flutter/material.dart';
import 'nivel_agua.dart';
import 'nivel_ph.dart';
import 'nivel_luz.dart';
import 'nivel_bateria.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class EstadoTorre extends StatefulWidget {
  const EstadoTorre({super.key});

  @override
  _EstadoTorreState createState() => _EstadoTorreState();
}

class _EstadoTorreState extends State<EstadoTorre> {
  Map<String, dynamic>? sensorData;
  bool _hasError = false; // Bandera para errores al pedir datos
  bool _isLoading = false; //ultimo frag
  Timer? _timer;

  Future<void> fetchSensorData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    Map<String, dynamic>? newSensorData;
    bool error = false;

    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.8:5000/sensor-data'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        newSensorData = jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      error = true;
      print("Error: $e");
    }

    if (!mounted) return;

    setState(() {
      sensorData = error ? null : newSensorData;
      _hasError =
          error; //Así se usa el setState para evitar hacer set en donde se capta el valor (catch)
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Realizamos la peticion de datos una vez que haya sido renderizado el primer frame (no trabar la renderizacion)
      fetchSensorData();
    });

    //Guardamos el timer para poder cancelarlo despues
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      fetchSensorData();
      print("Se ha realizado una nueva peticion http $sensorData");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //haremos que la llamada a fetch se postergue hasta que el primer frame haya sido renderizado

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error al cargar datos'),
            ElevatedButton(
              onPressed: fetchSensorData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (sensorData == null) {
      content = const Center(child: Text('No hay datos disponibles'));
    } else {
      content = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          WaterLevel(sensorData: sensorData!),
          const SizedBox(height: 20),
          PhLevel(sensorData: sensorData!),
          const SizedBox(height: 20),
          LightLevel(sensorData: sensorData!),
          const SizedBox(height: 20),
          BatteryLevel(sensorData: sensorData!),
          const SizedBox(height: 20),
        ],
      );
    }

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
        child: content,
      ),
    );
  }
}
