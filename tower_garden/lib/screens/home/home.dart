import 'package:flutter/material.dart';
import 'package:tower_garden/screens/authenticate/login.dart';
import 'package:tower_garden/screens/authenticate/registro.dart';
import 'package:tower_garden/widgets/botones_home.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tower Garden App')),
      body: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            'images/tower.webp',
            fit: BoxFit.cover, // Esto asegura que la imagen cubra la pantalla
            width: double.infinity, // Asegura que la imagen ocupe todo el ancho
            height:
                double.infinity, // Asegura que la imagen ocupe toda la altura
          ),

          // Columna para los botones, alineados en el centro
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                //Llamamos a la instancia entregándole sus 3 parámetros
                MiBoton(
                  botonTexto: 'Iniciar sesión',
                  color: Colors.blue,
                  destino: Login(),
                ),
                //Llamamos a la instancia entregándole sus 3 parámetros
                MiBoton(
                  botonTexto: 'Registrarse',
                  color: Colors.blue,
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
