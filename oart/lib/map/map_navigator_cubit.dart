import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/map/workout.dart';

enum MapNavigatorState { map, photo, workout }

class MapNavigatorCubit extends Cubit<MapNavigatorState> {
  MapNavigatorCubit() : super(MapNavigatorState.map);

  Workout workout = Workout();
  void showMap() => emit(MapNavigatorState.map);
  void showPhoto() => emit(MapNavigatorState.photo);
  void showWorkout(Workout workout) {
    this.workout = workout;
    emit(MapNavigatorState.workout);
  }
}
