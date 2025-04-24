import 'package:flutter/material.dart';
import 'package:tower_garden/screens/authenticate/login.dart';
import 'package:tower_garden/screens/authenticate/registro.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';

class MiBoton extends StatelessWidget {
  //Definimos variables que tendrá de argumento
  final Color color; //Variable que  almacena el color del boton
  final String botonTexto; //Variable que  almacena el texto del boton
  final Widget
  destino; //Variable que  almacena la 'dirección' de destino al presionar (navegación entre páginas)

  const MiBoton({
    //Registramos los parámetros de argumento que requerirá al invocar la clase
    super.key,
    required this.botonTexto,
    required this.color,
    required this.destino,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              //Al presionarse irá hacia el Widget que entregamos de parámetro, almacenado en la variable destino
              context,
              MaterialPageRoute(builder: (context) => destino),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white, // Aquí aplicamos el color recibido
          ),
          child: Text(botonTexto),
        ),
      ],
    );
  }
}





//replicar lo primero y cambiar contenido del boton
/*
class Boton2 extends StatefulWidget {
  const Boton2({super.key});

  @override
  _Boton2State createState() => _Boton2State();
}

class _Boton2State extends State<Boton2> {
  int cont2 = 0;

  @override
  Widget build(BuildContext context) {
    String textoBoton2 = cont2 == 0 ? "Registrarse" : "Muy amable";

    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            cont2++;
          });
        },
        child: Text(textoBoton2),
      ),
    );
  }
}
*/













/*
Ejemplo de botones con estado

class Boton2 extends StatefulWidget {
  const Boton2({super.key});

  @override
  _Boton2State createState() => _Boton2State();
}

class _Boton2State extends State<Boton2> {
  int cont2 = 0;

  @override
  Widget build(BuildContext context) {
    String textoBoton2 = cont2 == 0 ? "Registrarse" : "Muy amable";

    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            cont2++;
          });
        },
        child: Text(textoBoton2),
      ),
    );
  }
}
*/
