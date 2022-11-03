import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_cubit.dart';
import 'package:oart/auth/form_submission_status.dart';
import 'package:oart/auth/sign_up/bloc/sign_up_bloc.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _signForm(context),
        _showSignUpButton(context),
      ],
    ));
  }

  Widget _signForm(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _usernameField(context),
                    _emailField(context),
                    _passwordField(context),
                    _signButton(context),
                  ],
                ))));
  }

  Widget _usernameField(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: ((context, state) {
      return Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) * 0.02),
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: "Username",
            ),
            validator: ((value) =>
                state.isValidEmail ? null : "Invalid Username"),
            onChanged: ((value) => context
                .read<SignUpBloc>()
                .add(SignUpUsernameChanged(username: value))),
          ));
    }));
  }

  Widget _emailField(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: ((context, state) {
      return Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) * 0.02),
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: "Email",
            ),
            validator: ((value) => state.isValidEmail ? null : "Invalid Email"),
            onChanged: ((value) => context
                .read<SignUpBloc>()
                .add(SignUpEmailChanged(email: value))),
          ));
    }));
  }

  Widget _passwordField(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: ((context, state) {
      return Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) * 0.02),
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: "Password",
            ),
            validator: ((value) =>
                state.isValidPassword ? null : "Invalid Password"),
            onChanged: ((value) => context
                .read<SignUpBloc>()
                .add(SignUpPasswordChanged(password: value))),
          ));
    }));
  }

  Widget _signButton(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: ((context, state) {
      return Padding(
          padding: EdgeInsets.only(
              bottom: deviceHeight(context) * 0.1,
              top: deviceHeight(context) * 0.05),
          child: state.formStatus is FormSubmitting
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<SignUpBloc>().add(SignUpSubmitted());
                    }
                  },
                  child: const Text("SignUp")));
    }));
  }

  Widget _showSignUpButton(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(bottom: deviceHeight(context) * 0.05),
      child: TextButton(
        child: const Text("Already have an account? Sign in."),
        onPressed: () => context.read<AuthCubit>().showLogin(),
      ),
    ));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
