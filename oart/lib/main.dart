import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/auth/login/bloc/login_bloc.dart';
import 'package:oart/auth/login/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
          create: (context) => LoginBloc(
                RepositoryProvider.of<AuthRepository>(context),
              ),
          child: MaterialApp(home: LoginView())),
    );
  }
}
