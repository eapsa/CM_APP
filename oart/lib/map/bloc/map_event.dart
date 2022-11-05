part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class MapInitialEvent extends MapEvent {}

class MapLocationChangedEvent extends MapEvent {
  final LatLng location;
  MapLocationChangedEvent({required this.location});
}

class MapStartEvent extends MapEvent {}

class MapStopEvent extends MapEvent {}

class MapResetEvent extends MapEvent {}

class MapEndEvent extends MapEvent {
  final Workout workout;
  MapEndEvent({required this.workout});
}
