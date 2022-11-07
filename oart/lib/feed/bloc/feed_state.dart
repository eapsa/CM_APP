part of 'feed_bloc.dart';

@mat.immutable
abstract class FeedState {}

class FeedInitialState extends FeedState {}

class FeedLoadingState extends FeedState {}

class FeedLoadSucessState extends FeedState {
  final List<Workout> workoutsList;
  final Map<int, List<Image>> imageList;
  final Map<int, List<Coordinate>> coordList;
  final Map<int, String> userNames;
  FeedLoadSucessState(
      {required this.workoutsList,
      required this.imageList,
      required this.coordList,
      required this.userNames});
}

class FeedLoadErrorState extends FeedState {}
