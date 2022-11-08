import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_credentials.dart';
import 'package:oart/auth/auth_cubit.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/auth/form_submission_status.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  SignUpBloc(this.authRepo, this.authCubit) : super(const SignUpState()) {
    on<SignUpUsernameChanged>((event, emit) async {
      emit(state.copyWith(username: event.username));
    });
    on<SignUpEmailChanged>((event, emit) async {
      emit(state.copyWith(email: event.email));
    });
    on<SignUpPasswordChanged>((event, emit) async {
      emit(state.copyWith(password: event.password));
    });
    on<SignUpSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        int userId = await authRepo.signUp(
            username: state.username,
            email: state.email,
            password: state.password);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
        authCubit.lauchSession(AuthCredentials(
          password: state.password,
          userId: userId,
          username: state.username,
          email: state.email,
        ));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
      }
    });
  }
}
