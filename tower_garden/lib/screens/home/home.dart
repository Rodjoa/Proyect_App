import 'package:flutter/material.dart';
import 'package:tower_garden/screens/authenticate/login.dart';
import 'package:tower_garden/screens/authenticate/registro.dart';
import 'package:tower_garden/widgets/botones_home.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tower Garden App'),
        backgroundColor: const Color(0xFF1565C0), // Azul definido
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            'images/tower.webp',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Columna para los botones, alineados en el centro
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                MiBoton(
                  botonTexto: 'Iniciar sesión',
                  color: Color(0xFF1565C0),
                  destino: Login(),
                ),
                MiBoton(
                  botonTexto: 'Registrarse',
                  color: Color(0xFF43A047),
                  destino: Registro(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
