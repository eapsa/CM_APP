part of 'sign_up_bloc.dart';

@immutable
class SignUpState {
  final String username;
  bool get isValidUsername => username.length > 3;
  final String email;
  bool get isValidEmail => email.length > 3;
  final String password;
  bool get isValidPassword => password.length > 3;

  final FormSubmissionStatus formStatus;

  const SignUpState({
    this.username = "",
    this.email = "",
    this.password = "",
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
