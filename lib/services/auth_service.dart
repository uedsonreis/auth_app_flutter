import 'dart:convert';
import 'dart:io';

import 'package:auth_flutter/dto/user.dart';
import 'package:auth_flutter/services/session_repository.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://192.168.0.7:3000/auth/login';

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'username': username, 'password': password},
      ),
    );

    if (response.statusCode == 201) {
      dynamic json = jsonDecode(response.body);
      User user = User.fromJson(json);

      Session session = Session();
      await session.setLoggedUser(user);

      return user;
    }

    return null;
  }
}
