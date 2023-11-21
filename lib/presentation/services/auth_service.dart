// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app_provider/config/global/environments.dart';
import 'package:chat_app_provider/presentation/models/models.dart';

class AuthService with ChangeNotifier {
  User? usuario;
  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  // ** Login
  Future login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Environments.apiUrl}/login');
    final response = await http.post(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    print(response.body);
    autenticando = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);

      usuario = loginResponse.usuario;

      await _saveToken(loginResponse.token);

      return true;
    } else {
      final responseBody = jsonDecode(response.body);
      return responseBody['msg'] ?? 'error desconocido';
    }
  }
  // **

  // - Register
  Future resgister(String nombre, String email, String password) async {
    autenticando = true;

    final data = {'nombre': nombre, 'email': email, 'password': password};

    final uri = Uri.parse('${Environments.apiUrl}/login/new');
    final response = await http.post(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    print(response.body);
    autenticando = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      usuario = loginResponse.usuario;
      await _saveToken(loginResponse.token);

      return true;
    } else {
      final responseBody = jsonDecode(response.body);
      return responseBody['msg'] ?? 'error desconocido';
    }
  }
  // -

  // * isLoggedIn
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      final uri = Uri.parse('${Environments.apiUrl}/login/renew');

      try {
        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'x-token': token,
          },
        );

        if (response.statusCode == 200) {
          final loginResponse = loginResponseFromJson(response.body);
          usuario = loginResponse.usuario;
          await _saveToken(loginResponse.token);
          return true;
        } else {
          logOut();
          return false;
        }
      } catch (e) {
        return false;
      }
    }

    return false;
  }
  // *

  // SaveToken
  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }
  //

  // LogOut
  Future logOut() async {
    await _storage.delete(key: 'token');
  }
  //
}
