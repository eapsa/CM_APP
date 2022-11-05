part of 'feed_bloc.dart';

@immutable
abstract class FeedEvent {}

class FeedRefresh extends FeedEvent {}

class FeedDisplay extends FeedEvent {}
