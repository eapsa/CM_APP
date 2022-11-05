import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitialState()) {
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
    on<MapResetEvent>((event, emit) {});
    on<MapEndEvent>((event, emit) {});
  }
}
