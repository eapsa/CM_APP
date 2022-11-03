import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/auth/form_submission_status.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc(this.authRepo) : super(const LoginState()) {
    print("esdfada");
    on<LoginUsernameChanged>((event, emit) async {
      print("user");
      emit(state.copyWith(username: event.username));
    });
    on<LoginPasswordChanged>((event, emit) async {
      print("password");
      emit(state.copyWith(password: event.password));
    });
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await authRepo.login();
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
      }
    });
  }

  // Stream<LoginState> mapEventToState(LoginEvent event) async* {
  //   if (event is LoginUsernameChanged) {
  //     yield state.copyWith(username: event.username);
  //   } else if (event is LoginPasswordChanged) {
  //     yield state.copyWith(password: event.password);
  //   } else if (event is LoginSubmitted) {
  //     yield state.copyWith(formStatus: FormSubmitting());
  //     try {
  //       await authRepo.login();
  //       yield state.copyWith(formStatus: SubmissionSuccess());
  //     } on Exception catch (e) {
  //       yield state.copyWith(formStatus: SubmissionFailed(e));
  //     }
  //   }
  // }
}
