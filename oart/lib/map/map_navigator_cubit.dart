import 'package:flutter_bloc/flutter_bloc.dart';

enum MapNavigatorState { map, photo }

class MapNavigatorCubit extends Cubit<MapNavigatorState> {
  MapNavigatorCubit() : super(MapNavigatorState.map);
  void showMap() => emit(MapNavigatorState.map);
  void showPhoto() => emit(MapNavigatorState.photo);
}
