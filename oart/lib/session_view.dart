import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/session_cubic.dart';

class SessionView extends StatelessWidget {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Session View"),
          TextButton(
              onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
              child: const Text("sign out")),
        ],
      )),
    );
  }
}
