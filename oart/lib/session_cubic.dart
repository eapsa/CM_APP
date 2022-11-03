import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_credentials.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  SessionCubit(this.authRepo) : super(UnknownSessionState()) {
    emit(UnknownSessionState());
    attemptLoad();
  }

  void attemptLoad() async {
    try {
      final userId = await authRepo.load();
      emit(Authenticated(user: userId));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(AuthCredentials credentials) {
    final user = credentials.email;
    emit(Authenticated(user: user));
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
