import 'package:flutter/material.dart';

class AuthRepository {
  Future<int> load() async {
    // get user from local db
    // return id
    await Future.delayed(const Duration(seconds: 10));
    throw Exception("not signed in");
    //return 0;
  }

  Future<int> login({
    required String email,
    required String password,
  }) async {
    // get user from api
    // write user to local db
    // return id
    await Future.delayed(const Duration(seconds: 3));
    return 0;
  }

  Future<int> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    // post user top api
    // write user to local db
    // return id
    await Future.delayed(const Duration(seconds: 3));
    return 0;
  }

  Future<void> signOut() async {
    // remove db local
    await Future.delayed(const Duration(seconds: 3));
  }
}
