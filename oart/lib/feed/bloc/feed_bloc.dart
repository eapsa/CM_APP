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
        await _feedRepository.synchronize();
        List<Workout> workoutList = await _feedRepository.getWorkouts();
        List<int> idList = <int>[];
        Set<int> userList = {};
        for (Workout workout in workoutList) {
          idList.add(workout.id);
          userList.add(workout.user_id);
        }
        Map<int, List<Image>> imageList =
            await _feedRepository.getImages(idList);
        Map<int, List<Coordinate>> coordList =
            await _feedRepository.getCoordinates(idList);
        Map<int, String> userNames =
            await _feedRepository.getUserNames(userList);
        emit(FeedLoadSucessState(
          workoutsList: workoutList,
          imageList: imageList,
          coordList: coordList,
          userNames: userNames,
        ));
      } on Exception {
        emit(FeedLoadErrorState());
      }
    });
  }

  void attemptLoad() async {
    try {
      await _feedRepository.synchronize();
      List<Workout> workoutList = await _feedRepository.getWorkouts();
      List<int> idList = <int>[];
      Set<int> userList = {};
      for (Workout workout in workoutList) {
        idList.add(workout.id);
        userList.add(workout.user_id);
      }
      Map<int, List<Image>> imageList = await _feedRepository.getImages(idList);
      Map<int, List<Coordinate>> coordList =
          await _feedRepository.getCoordinates(idList);
      Map<int, String> userNames = await _feedRepository.getUserNames(userList);
      emit(FeedLoadSucessState(
        workoutsList: workoutList,
        imageList: imageList,
        coordList: coordList,
        userNames: userNames,
      ));
    } on Exception {
      emit(FeedLoadErrorState());
    }
  }
}
