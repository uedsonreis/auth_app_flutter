import 'package:auth_flutter/home.dart';
import 'package:auth_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  String _username = '';
  String _password = '';

  void alert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void signIn() {
    try {
      authService.login(_username, _password).then((logged) {
        if (logged == null) {
          alert('Login/senha inválido');
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      });
    } catch (error) {
      alert('Servidor indisponível');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acesso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Login',
              ),
              onChanged: (value) => setState(() => _username = value),
            ),
            TextFormField(
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Senha',
              ),
              onChanged: (value) => setState(() => _password = value),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar'),
                  onPressed: () => signIn(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
