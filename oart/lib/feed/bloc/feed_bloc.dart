import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:oart/feed/feed_cubit.dart';
import 'package:oart/feed/feed_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepo;
  final FeedCubit feedCubit;

  FeedBloc(this.feedRepo, this.feedCubit) : super(FeedState()) {}
}
