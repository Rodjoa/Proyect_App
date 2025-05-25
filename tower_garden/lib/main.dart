import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/noti_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notiService = NotiService();
  await notiService.initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tower Garden',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // Azul base
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF43A047), // Verde
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const Home(),
    );
  }
}

 //Se introdujo una linea en pubspec.yaml  para
 //intentar introducir la imagen
 //Image.asset('images/tower.webp'),  comando simple sin ajuste 