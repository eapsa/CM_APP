import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_cubit.dart';
import 'package:oart/auth/login/login_view.dart';
import 'package:oart/auth/sign_up/sign_up_view.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state == AuthState.login) MaterialPage(child: LoginView()),
          if (state == AuthState.signUp) MaterialPage(child: SignUpView()),
        ],
        onPopPage: ((route, result) => route.didPop(result)),
      );
    });
  }
}
