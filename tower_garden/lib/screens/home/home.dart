import 'package:flutter/material.dart';
import 'package:tower_garden/screens/authenticate/login.dart';
import 'package:tower_garden/screens/authenticate/registro.dart';
import 'package:tower_garden/widgets/botones_home.dart';

class Home extends StatefulWidget {
  //Esta clase declara que existe un Widget con estado (1° clase: Qué es el widget)
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState(); //En esta clase va la lógica del Widget: lo que se muestra (build), varaiables, control de estado. (2° clase: cómo se comporta el widget stateful)
} //Cierre clase Home o clase "contenedora"

class _HomeState extends State<Home> {
  //Lógica de estado
  String? formToShow; // "login", "registro", o null

  void toggleForm(String form) {
    setState(() {
      formToShow = (formToShow == form) ? null : form;
      //Si ya está mostrado el formulario que recibimos (formToShow == form), lo cerramos (null).
      //Si no, lo mostramos (formToShow = form).
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tower Garden App'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/tower.webp',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 250), //60
                  ElevatedButton(
                    onPressed: () => toggleForm("login"),
                    child: const Text("Iniciar sesión"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => toggleForm("registro"),
                    child: const Text("Registrarse"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Mostrar formulario según lo que se seleccione
                  if (formToShow == "login")
                    const MyCustomForm(), // reusamos el widget del login
                  if (formToShow == "registro") const RegistroForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
