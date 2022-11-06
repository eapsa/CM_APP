part of 'feed_bloc.dart';

@mat.immutable
abstract class FeedState {}

class FeedInitialState extends FeedState {}

class FeedLoadingState extends FeedState {}

class FeedLoadSucessState extends FeedState {
  final List<Workout> workoutsList;
  FeedLoadSucessState({required this.workoutsList});
}

class FeedLoadErrorState extends FeedState {}
