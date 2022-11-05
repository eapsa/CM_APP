import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/feed/feed_cubit.dart';
import 'package:oart/feed/feed_view.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state == FeedState.view) const MaterialPage(child: FeedView()),
        ],
        onPopPage: ((route, result) => route.didPop(result)),
      );
    });
  }
}
