import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';

class pHLevel extends StatefulWidget {
  final pHValue = 5; //Dato recibido por el sensor o simulado

  /*Creamos un constructor donde data es requerido
  En este caso debe ser explicito para recibir parametros en el (datos de sensor)
  Si no se espera recibir y solo se maneja un estado interno, puede dejarse implícito*/

  const pHLevel({super.key});

  @override
  _pHLevelState createState() => _pHLevelState();
}

class _pHLevelState extends State<pHLevel> {
  int cont = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel de pH"), // No cambia con el estado
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(' Nivel de pH: ${widget.pHValue}'),
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
