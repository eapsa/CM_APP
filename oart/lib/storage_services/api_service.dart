import 'dart:convert';

import 'package:network_info_plus/network_info_plus.dart';

import '../data_types/all.dart';
import 'package:http/http.dart' as http;

class APIService {
  final String url = "http://192.168.1.85:8000";

  Future<User> postUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$url/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromMapAPI(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user.');
    }
  }

  Future<User> getUserByCredentials(String email, String password) async {
    final response = await http.get(
      Uri.parse('$url/login?email=$email&password=$password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return User.fromMapAPI(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user.');
    }
  }
}
