import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/data_types/all.dart';

enum FeedNavigatorState { view, qrcode, detail }

class FeedNavigatorCubit extends Cubit<FeedNavigatorState> {
  FeedNavigatorCubit() : super(FeedNavigatorState.view) {
    emit(FeedNavigatorState.view);
  }
  late Workout workout;
  late List<Image> imageList;
  late List<Coordinate> coordList;
  late String userName;

  void showView() => emit(FeedNavigatorState.view);
  void showDetail(
    Workout workout,
    List<Image> imageList,
    List<Coordinate> coordList,
    String userName,
  ) {
    this.workout = workout;
    this.imageList = imageList;
    this.coordList = coordList;
    this.userName = userName;
    emit(FeedNavigatorState.detail);
  }

  void showQrcode() => emit(FeedNavigatorState.qrcode);
}
