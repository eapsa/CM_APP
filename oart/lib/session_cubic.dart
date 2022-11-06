import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:oart/auth/auth_credentials.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  SessionCubit(this.authRepo) : super(UnknownSessionState()) {
    emit(UnknownSessionState());
    attemptLoad();
  }

  int get currentUser => (state as Authenticated).user;

  void attemptLoad() async {
    try {
      final userId = await authRepo.load();
      NetworkInfo net = NetworkInfo();
      String? ip = await net.getWifiIP();
      print('Boas $ip');
      if (ip != null) {
        print('Boas Dentro');
        await authRepo.synchronize();
      }
      emit(Authenticated(user: userId));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(AuthCredentials credentials) {
    final user = credentials.userId;
    emit(Authenticated(user: user));
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
