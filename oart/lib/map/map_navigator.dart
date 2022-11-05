import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/loading_view.dart';
import 'package:oart/map/map_navigator_cubit.dart';
import 'package:oart/map/map_view.dart';
import 'package:oart/map/settings_view.dart';
import 'package:oart/map/workout_view.dart';

class MapNavigator extends StatelessWidget {
  const MapNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapNavigatorCubit, MapNavigatorState>(
        builder: (context, state) {
      return Navigator(
        pages: [
          MaterialPage(child: MapView()),
          if (state == MapNavigatorState.photo)
            MaterialPage(child: SettingsView()),
          if (state == MapNavigatorState.workout)
            MaterialPage(child: WorkoutView()),
        ],
        onPopPage: (route, result) {
          context.read<MapNavigatorCubit>().showMap();
          return route.didPop(result);
        },
      );
    });
  }
}
