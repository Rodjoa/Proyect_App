import 'package:flutter/material.dart';
import 'package:tower_garden/screens/home/home.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';

//El boton submit no corresponde a la clase MiBoton, ya que al necesitar validación
//se prefirió implementar aparte, dejando la clase MiBoton para aquellos que no la necesitan

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Iniciar sesión';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(title: const Text(appTitle)),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 238, 189),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Contenedor que limita el ancho del campo de texto
              Container(
                width: 300, // Define el ancho deseado para los campos de texto
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ingrese nombre de usuario',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16), // Espacio entre los campos
              // Contenedor para el campo de contraseña con el mismo ancho limitado
              Container(
                width: 300, // El mismo ancho que el campo de usuario
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ingrese contraseña',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese contraseña';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    //Despues crearemos la condición de validación (Estar registrado en la database)
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EstadoTorre()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Entrada inválida')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor:
                        Colors.white, // Aquí aplicas el color recibido
                  ),
                  child: const Text('Submit'),
                ),
              ),

              //meter boton volver
              const SizedBox(height: 80), // Espacio entre los campos
              // Contenedor para el campo de contraseña con el mismo ancho limitado
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 189, 188, 188),
                    foregroundColor:
                        Colors.white, // Aquí aplicas el color recibido
                  ),
                  child: const Text('Volver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
