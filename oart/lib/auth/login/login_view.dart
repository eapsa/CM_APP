import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/auth/form_submission_status.dart';
import 'package:oart/auth/login/bloc/login_bloc.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginForm(),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _userNameField(),
                    _passwordField(),
                    _loginButton(),
                  ],
                ))));
  }

  Widget _userNameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          hintText: "Email",
        ),
        validator: ((value) => state.isValidUsername ? null : "Invalid Email"),
        onChanged: ((value) => context
            .read<LoginBloc>()
            .add(LoginUsernameChanged(username: value))),
      );
    }));
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          hintText: "Password",
        ),
        validator: ((value) =>
            state.isValidPassword ? null : "Invalid Password"),
        onChanged: ((value) => context
            .read<LoginBloc>()
            .add(LoginPasswordChanged(password: value))),
      );
    }));
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              child: const Text("Login"));
    }));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
