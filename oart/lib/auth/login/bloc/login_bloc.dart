import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:oart/auth/auth_credentials.dart';
import 'package:oart/auth/auth_cubit.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/auth/form_submission_status.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  LoginBloc(this.authRepo, this.authCubit) : super(const LoginState()) {
    print("esdfada");
    on<LoginEmailChanged>((event, emit) async {
      print("user");
      emit(state.copyWith(email: event.email));
    });
    on<LoginPasswordChanged>((event, emit) async {
      print("password");
      emit(state.copyWith(password: event.password));
    });
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        int userId =
            await authRepo.login(email: state.email, password: state.password);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
        authCubit.lauchSession(AuthCredentials(
            email: state.email, userId: userId, password: state.password));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
      }
    });
  }

  // Stream<LoginState> mapEventToState(LoginEvent event) async* {
  //   if (event is LoginemailChanged) {
  //     yield state.copyWith(email: event.email);
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
