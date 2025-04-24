import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
//Parece que el directorio lib se omite en la ruta

//import 'package:tower_garden/images/tower.webp';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(), //aqui debo llamar al widget home
    );
  }
}
 //Se introdujo una linea en pubspec.yaml  para
 //intentar introducir la imagen
 //Image.asset('images/tower.webp'),  comando simple sin ajuste 