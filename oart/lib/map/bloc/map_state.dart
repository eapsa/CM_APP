part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MapInitialState extends MapState {}

class MapRunState extends MapState {}

class MapPauseState extends MapState {}
