import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tower_garden/screens/torre_individual/vistas_torre/estado_torre.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Iniciar sesión';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(appTitle),
        backgroundColor: Color(0xFF1565C0),
        foregroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _validateCredentials(String inputUser, String inputPass) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('username');
    final storedPass = prefs.getString('password');

    return inputUser == storedUser && inputPass == storedPass;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese nombre de usuario',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 300,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Ingrese contraseña',
                  border: OutlineInputBorder(),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    final isValid = await _validateCredentials(
                      _usernameController.text,
                      _passwordController.text,
                    );

                    Navigator.of(context, rootNavigator: true).pop();
                    
                    if (isValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EstadoTorre(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Credenciales incorrectas')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Entrada inválida')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Iniciar sesión'),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
