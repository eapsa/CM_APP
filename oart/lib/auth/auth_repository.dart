import 'package:flutter/material.dart';

class AuthRepository {
  Future<int> load() async {
    print("LoadLoaddddddddddddddddddddddddddddd");
    await Future.delayed(const Duration(seconds: 10));
    throw Exception("not signed in");
    //return 0;
  }

  Future<int> login({
    required String email,
    required String password,
  }) async {
    print("attempting login");
    await Future.delayed(const Duration(seconds: 3));
    print("logged in");
    return 0;
  }

  Future<int> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    print("attempting signup");
    await Future.delayed(const Duration(seconds: 3));
    print("signup");
    return 0;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}
