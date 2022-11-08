import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oart/map/map_repository.dart';
import 'package:oart/map/workout.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository mapRepo;

  MapBloc(this.mapRepo) : super(MapInitialState()) {
    on<MapInitialEvent>((event, emit) {
      emit(MapInitialState());
    });
    on<MapLocationChangedEvent>((event, emit) {});
    on<MapStartEvent>((event, emit) {
      emit(MapRunState());
    });
    on<MapStopEvent>((event, emit) {
      emit(MapPauseState());
    });
    on<MapEndEvent>((event, emit) async {
      try {
        await mapRepo.saveWorkout(event.workout);
        emit(MapInitialState());
      } on Exception {
        emit(MapInitialState());
      }
    });
  }
}
