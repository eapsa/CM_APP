import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/session_cubic.dart';

enum FeedState { refresh, view }

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedState.view);

  void showView() => emit(FeedState.view);
  void showRefresh() => emit(FeedState.refresh);
}
