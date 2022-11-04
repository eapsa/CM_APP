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

  Future<User> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse('$url/login?user_id=$userId'),
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

  Future<Workout> postWorkout(
      int userId,
      int time,
      double distance,
      double speed,
      String date,
      String description,
      List<Map<String, String>> images,
      List<Map<String, double>> coords) async {
    final response = await http.post(
      Uri.parse('$url/workouts?user_id=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'time': time,
        'distance': distance,
        'speed': speed,
        'date': date,
        'description': description,
        'images': images,
        'coords': coords
      }),
    );

    if (response.statusCode == 200) {
      return Workout.fromMapAPI(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register workout.');
    }
  }

  Future<List<Workout>> getWorkouts(int userId) async {
    final response = await http.get(
      Uri.parse('$url/workouts?user_id=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    List<Map<String, dynamic>> maps = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return List.generate(maps.length, (i) {
        return Workout.fromMapLocal(maps[i]);
      });
    } else {
      throw Exception('Failed to get workout list.');
    }
  }
}
