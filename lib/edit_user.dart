import 'dart:ffi';

import 'package:auth_flutter/dto/user.dart';
import 'package:auth_flutter/login.dart';
import 'package:auth_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key, this.userId});

  final int? userId;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _userService = UserService();

  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void alert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Future<User?> fetchUser() async {
    if (widget.userId != null && widget.userId! > 0) {
      return await _userService.get(widget.userId!);
    }
    return null;
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.userId == null || widget.userId! < 1) {
        final User newUser =
            User(0, _nameCtrl.text, _usernameCtrl.text, _passwordCtrl.text);

        final User? saved = await _userService.create(newUser);
        if (saved == null) {
          alert('Login já cadastrado');
          return;
        }
      } else {
        final User editUser =
            User(widget.userId!, _nameCtrl.text, _usernameCtrl.text, null);

        await _userService.update(editUser);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.userId == null
            ? const Text('Novo Usuário')
            : const Text('Editar Usuário'),
      ),
      body: FutureBuilder(
        future: fetchUser(),
        builder: (context, snapshot) {
          final User user = snapshot.data ?? User(0, '', '', null);
          _nameCtrl.text = user.name;
          _usernameCtrl.text = user.username;

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Nome',
                    ),
                    controller: _nameCtrl,
                    onChanged: (value) => _formKey.currentState!.validate(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O Nome é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Login',
                    ),
                    enabled: user.id <= 0,
                    controller: _usernameCtrl,
                    onChanged: (value) => _formKey.currentState!.validate(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O login é obrigatório';
                      }
                      return null;
                    },
                  ),
                  user.id > 0
                      ? const SizedBox.shrink()
                      : TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Senha',
                          ),
                          controller: _passwordCtrl,
                          onChanged: (value) =>
                              _formKey.currentState!.validate(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A senha é obrigatória';
                            }
                            return null;
                          },
                        ),
                  user.id > 0
                      ? const SizedBox.shrink()
                      : TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Confirmar Senha',
                          ),
                          enabled: user.id <= 0,
                          controller: _confirmPassCtrl,
                          onChanged: (value) =>
                              _formKey.currentState!.validate(),
                          validator: (value) {
                            if (value != _passwordCtrl.text) {
                              return 'A senha não confere';
                            }
                            return null;
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar'),
                        onPressed: save,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
