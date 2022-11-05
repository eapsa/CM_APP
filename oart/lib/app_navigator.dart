import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/auth/auth_cubit.dart';
import 'package:oart/auth/auth_navigator.dart';
import 'package:oart/bar/bottom_nav_bar_view.dart';
import 'package:oart/loading_view.dart';
import 'package:oart/session_cubic.dart';
import 'package:oart/session_state.dart';
import 'package:oart/session_view.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state is UnknownSessionState)
            const MaterialPage(child: LoadingView()),
          if (state is Unauthenticated)
            const MaterialPage(
              child: AuthNavigator(),
            ),
          if (state is Authenticated)
            const MaterialPage(child: BottomNavBarView()),
        ],
        onPopPage: ((route, result) => route.didPop(result)),
      );
    });
  }
}
