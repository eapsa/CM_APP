import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_credentials.dart';
import 'package:oart/session_cubic.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;
  AuthCubit(this.sessionCubit) : super(AuthState.login);

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);

  void lauchSession(AuthCredentials credentials) =>
      sessionCubit.showSession(credentials);
}
