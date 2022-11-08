import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/data_types/all.dart';

enum ProfileNavigatorState { view, detail }

class ProfileNavigatorCubit extends Cubit<ProfileNavigatorState> {
  ProfileNavigatorCubit() : super(ProfileNavigatorState.view) {
    emit(ProfileNavigatorState.view);
  }
  late Workout workout;
  late List<Image> imageList;
  late List<Coordinate> coordList;
  late String userName;

  void showView() => emit(ProfileNavigatorState.view);
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
    emit(ProfileNavigatorState.detail);
  }
}
