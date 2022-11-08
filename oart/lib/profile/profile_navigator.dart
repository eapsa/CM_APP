import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/feed/feed_navigator_cubit.dart';
import 'package:oart/feed/feed_detail_view.dart';
import 'package:oart/feed/feed_qrcode_view.dart';
import 'package:oart/feed/feed_view.dart';
import 'package:oart/profile/profile_detail_view.dart';
import 'package:oart/profile/profile_navigator_cubit.dart';
import 'package:oart/profile/profile_view.dart';

class ProfileNavigator extends StatelessWidget {
  const ProfileNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileNavigatorCubit, ProfileNavigatorState>(
        builder: (context, state) {
      return Navigator(
        pages: [
          const MaterialPage(child: ProfileView()),
          if (state == ProfileNavigatorState.detail)
            const MaterialPage(child: ProfileDetailView()),
        ],
        onPopPage: (route, result) {
          context.read<ProfileNavigatorCubit>().showView();
          return route.didPop(result);
        },
      );
    });
  }
}
