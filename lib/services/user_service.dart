import 'dart:convert';
import 'dart:io';

import 'package:auth_flutter/dto/user.dart';
import 'package:auth_flutter/services/session_repository.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'http://192.168.0.7:3000/users';
  final Session _session = Session();

  Future<List<User>> getList() async {
    User? user = await _session.getLoggedUser();

    if (user == null || user.token == null) {
      throw Exception('Sessão expirada');
    }

    final Uri uri = Uri.parse(_baseUrl);

    final response = await http.get(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = List.from(jsonDecode(response.body));
      List<User> users = list.map((e) => User.fromJson(e)).toList();
      return users;
    }

    throw HttpException(response.body, uri: uri);
  }

  Future<User?> get(int userId) async {
    User? logged = await _session.getLoggedUser();

    if (logged == null || logged.token == null) {
      throw Exception('Sessão expirada');
    }

    final Uri uri = Uri.parse("$_baseUrl/$userId");

    final response = await http.get(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${logged.token}'
      },
    );

    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      if (json == null) return null;
      return User.fromJson(json);
    } else if (response.statusCode == 401) {
      throw HttpException(response.body, uri: uri);
    }

    return null;
  }

  Future<User?> create(User user) async {
    User? logged = await _session.getLoggedUser();

    if (logged == null || logged.token == null) {
      throw Exception('Sessão expirada');
    }

    final Uri uri = Uri.parse(_baseUrl);

    final response = await http.post(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${logged.token}'
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      dynamic json = jsonDecode(response.body);
      if (json == null) return null;
      return User.fromJson(json);
    } else if (response.statusCode == 401) {
      throw HttpException(response.body, uri: uri);
    }

    return null;
  }

  Future<User?> update(User user) async {
    User? logged = await _session.getLoggedUser();

    if (logged == null || logged.token == null) {
      throw Exception('Sessão expirada');
    }

    final Uri uri = Uri.parse("$_baseUrl/${user.id}");

    final response = await http.put(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${logged.token}'
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      if (json == null) return null;
      return User.fromJson(json);
    } else if (response.statusCode == 401) {
      throw HttpException(response.body, uri: uri);
    }

    return null;
  }

  Future<bool> delete(int userId) async {
    User? logged = await _session.getLoggedUser();

    if (logged == null || logged.token == null) {
      throw Exception('Sessão expirada');
    }

    final Uri uri = Uri.parse("$_baseUrl/$userId");

    final response = await http.delete(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${logged.token}'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw HttpException(response.body, uri: uri);
    }

    return false;
  }
}
