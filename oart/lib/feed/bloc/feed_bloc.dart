import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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
        final workoutList = await _feedRepository.getPage();
        emit(FeedLoadSucessState(workoutsList: workoutList));
      } on Exception catch (e) {
        emit(FeedLoadErrorState());
      }
    });
  }

  void attemptLoad() async {
    try {
      final workoutList = await _feedRepository.getPage();
      emit(FeedLoadSucessState(workoutsList: workoutList));
    } on Exception {
      emit(FeedLoadErrorState());
    }
  }
}
