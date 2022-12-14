import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/bar/bottom_nav_bar_cubit.dart';
import 'package:oart/feed/feed_navigator.dart';
import 'package:oart/map/map_navigator.dart';
import 'package:oart/profile/profile_navigator.dart';

class BottomNavBarView extends StatelessWidget {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, int>(builder: (context, state) {
      return Scaffold(
        body: IndexedStack(
          index: state,
          children: const [
            MapNavigator(),
            FeedNavigator(),
            ProfileNavigator(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: state,
          onTap: (index) => context.read<BottomNavBarCubit>().selectTab(index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.timer_outlined), label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined), label: "Feed"),
            BottomNavigationBarItem(
                icon: Icon(Icons.task_outlined), label: "Profile"),
          ],
        ),
      );
    });
  }
}
