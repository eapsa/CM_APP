import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_cubit.dart';
import 'package:oart/auth/form_submission_status.dart';
import 'package:oart/auth/login/bloc/login_bloc.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Padding(
            padding: EdgeInsets.only(
                left: deviceWidth(context) * 0.1,
                right: deviceWidth(context) * 0.1),
            child: Form(
                key: _formKey,
                child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: deviceHeight(context) * 0.05),
                            child: Image.asset(
                              'run.png',
                              width: 200,
                            )),
                        _emailField(context),
                        _passwordField(context),
                        _loginButton(context),
                        _showSignUpButton(context),
                      ],
                    ))))));
  }

  Widget _emailField(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return TextFormField(
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary)),
          hintText: "Email",
        ),
        validator: ((value) => state.isValidEmail ? null : "Invalid Email"),
        onChanged: ((value) =>
            context.read<LoginBloc>().add(LoginEmailChanged(email: value))),
      );
    }));
  }

  Widget _passwordField(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) * 0.02),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary)),
              hintText: "Password",
            ),
            validator: ((value) =>
                state.isValidPassword ? null : "Invalid Password"),
            onChanged: ((value) => context
                .read<LoginBloc>()
                .add(LoginPasswordChanged(password: value))),
          ));
    }));
  }

  Widget _loginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return Padding(
          padding: EdgeInsets.only(
              bottom: deviceHeight(context) * 0.1,
              top: deviceHeight(context) * 0.05),
          child: state.formStatus is FormSubmitting
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(LoginSubmitted());
                    }
                  },
                  child: const Text("Login")));
    }));
  }

  Widget _showSignUpButton(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(bottom: deviceHeight(context) * 0.05),
      child: TextButton(
        child: const Text("Don't have an account? Sign up."),
        onPressed: () => context.read<AuthCubit>().showSignUp(),
      ),
    ));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
