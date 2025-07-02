import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tower_garden/main.dart';
import 'nivel_agua.dart';
import 'nivel_ph.dart';
import 'nivel_luz.dart';
import 'nivel_bateria.dart';
import 'ph_graph.dart';
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
  //List<Map<String, dynamic>>? historical_data;  //declaramos que puede ser nulo (Al usarla deberemos verificar que no sea nula)
  List<Map<String, dynamic>> historical_data = [];
  bool _hasError = false; // Bandera para errores al pedir datos
  bool _isLoading = false; //ultimo frag
  bool _hasError_hist = false; //variable para el fetch historico
  bool _isLoading_hist = false; //......           fetch historico

  Timer? _timer;

  //Funcion para el ultimo dato
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
          .get(Uri.parse('http://192.168.0.18:5000/sensor-data'))
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

  //FUNCION PARA DATOS HISTORICA

  Future<void> fetchSensorData_Historical() async {
    if (!mounted) return;

    setState(() {
      _isLoading_hist = true;
      _hasError_hist = false;
    });

    bool error = false;
    List<Map<String, dynamic>> new_historical_data =
        []; //Lista que recibe el array JSON decodificado desde el ENDPOINT HISTORICO (cada elemento es un map<String, dynamic>) (punto)
    try {
      final response = await http
          .get(
            Uri.parse('http://192.168.0.18:5000/sensor-data/historical'),
          ) //AUN DEBEMOS CREAR ESE ENDPOINT PARA QUE ENTREGUE LOS ULTIMOS 60 VALORES DE LA DB
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(
          response.body,
        ); //jsonDecode nunca retorna null (por eso no hay '?')
        new_historical_data = List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Error al cargar historial');
      }
    } catch (e) {
      error = true;
      print("Error: $e");
    }

    if (!mounted) return;

    setState(() {
      //historical_data = error ? [] : new_historical_data;  //Si hay errror le asigna una lista vacia en vez de null, sino le asigna los datos correspondientes
      historical_data =
          error
              ? []
              : new_historical_data; //Al intentar asignar una variable nullable a una no nullable se genera error (ya se corrigio)
      _hasError_hist = error; //Captura el error si es que hay (al cargar)
      _isLoading_hist =
          false; //indica que termino de cargar los datos (con o sin exito) ->termina el circular progress
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
      print("Claves disponibles en sensorData: ${sensorData!.keys}");
      content = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          WaterLevel(sensorData: sensorData!),
          const SizedBox(height: 20),
          PhLevel(sensorData: sensorData!),
          const SizedBox(
            height: 5,
          ), //Aqui vamos a poner el boton de datos historicos para ir a la vista ph_graph

          ElevatedButton(
            onPressed: () async {
              // Traemos los datos históricos y esperamos que termine
              await fetchSensorData_Historical();

              print("Datos históricos: $historical_data"); // ← Debug clave
              if (historical_data.isNotEmpty) {
                // Navegamos y le pasamos los datos a la pantalla del gráfico
                print("DEBUGEANDO0000000000000O");
                print(historical_data);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PhGraphScreen(dataPoints: historical_data),
                  ),
                );
              } else {
                // Si no hay datos, mostramos un mensaje de error
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No se pudo cargar datos históricos'),
                  ),
                );
              }
            },
            child: const Text('Ver datos históricos'),
          ),

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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                );
              }
            },
          ),
        ],
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
