import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/data_types/all.dart';
import 'package:oart/feed/feed_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final _feedRepository = FeedRepository();
  FeedBloc() : super(FeedInitialState()) {
    attemptLoad();
    on<FeedPageRequest>((event, emit) async {
      emit(FeedLoadingState());
      try {
        List<Workout> workoutList = await _feedRepository.getWorkouts();
        List<int> idList = <int>[];
        for (Workout workout in workoutList) {
          idList.add(workout.id);
        }
        print('Boas1 $idList');
        Map<int, List<Image>> imageList =
            await _feedRepository.getImages(idList);
        List<int> idList2 = <int>[];
        for (int id in idList) {
          for (Image image in imageList[id]!) {
            idList2.add(image.workout_id);
          }
        }
        print('Boas2 $idList2');
        Map<int, List<Coordinate>> coordList =
            await _feedRepository.getCoordinates(idList);
        List<int> idList3 = <int>[];
        for (int id in idList) {
          for (Coordinate coord in coordList[id]!) {
            idList3.add(coord.workout_id);
          }
        }
        print('Boas3 $idList3');
        emit(FeedLoadSucessState(workoutsList: workoutList));
      } on Exception catch (e) {
        emit(FeedLoadErrorState());
      }
    });
  }

  void attemptLoad() async {
    try {
      final workoutList = await _feedRepository.getWorkouts();
      emit(FeedLoadSucessState(workoutsList: workoutList));
    } on Exception {
      emit(FeedLoadErrorState());
    }
  }
}
