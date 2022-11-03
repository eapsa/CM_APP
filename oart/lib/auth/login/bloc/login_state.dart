part of 'login_bloc.dart';

@immutable
class LoginState {
  final String username;
  bool get isValidUsername => username.length > 3;
  final String password;
  bool get isValidPassword => password.length > 3;

  final FormSubmissionStatus formStatus;

  const LoginState({
    this.username = "",
    this.password = "",
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? username,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    print(username.toString());
    return LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
