import 'dart:convert';

import 'package:auth_flutter/dto/user.dart';
import 'package:localstorage/localstorage.dart';

class Session {
  final LocalStorage _storage = LocalStorage('session.json');
  final String _key = 'LOGGED_USER';

  Future<void> setLoggedUser(User user) async {
    bool isReady = await _storage.ready;
    if (isReady) {
      await _storage.setItem(_key, jsonEncode(user.toJson()));
    }
  }

  Future<User?> getLoggedUser() async {
    bool isReady = await _storage.ready;
    if (isReady) {
      dynamic json = await _storage.getItem(_key);
      if (json != null) {
        return User.fromJson(jsonDecode(json));
      }
    }
    return null;
  }

  Future<void> removeLoggedUser() async {
    bool isReady = await _storage.ready;
    if (isReady) {
      _storage.setItem(_key, null);
    }
  }
}
