import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/data_types/all.dart';

enum FeedNavigatorState { view, qrcode, detail }

class FeedNavigatorCubit extends Cubit<FeedNavigatorState> {
  FeedNavigatorCubit() : super(FeedNavigatorState.view) {
    emit(FeedNavigatorState.view);
  }
  late Workout workout;

  void showView() => emit(FeedNavigatorState.view);
  void showDetail(Workout workout) {
    this.workout = workout;
    emit(FeedNavigatorState.detail);
  }

  void showQrcode() => emit(FeedNavigatorState.qrcode);
}
