import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/feed/feed_navigator_cubit.dart';
import 'package:oart/feed/feed_detail_view.dart';
import 'package:oart/feed/feed_qrcode_view.dart';
import 'package:oart/feed/feed_view.dart';

class FeedNavigator extends StatelessWidget {
  const FeedNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedNavigatorCubit, FeedNavigatorState>(
        builder: (context, state) {
      return Navigator(
        pages: [
          const MaterialPage(child: FeedView()),
          if (state == FeedNavigatorState.detail)
            const MaterialPage(child: FeedDetailView()),
          if (state == FeedNavigatorState.qrcode)
            const MaterialPage(child: QrCodeView()),
        ],
        onPopPage: (route, result) {
          context.read<FeedNavigatorCubit>().showView();
          return route.didPop(result);
        },
      );
    });
  }
}
