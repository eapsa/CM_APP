import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/feed/bloc/feed_bloc.dart';
import 'package:oart/profile/profile_navigator_cubit.dart';
import 'package:oart/session_cubic.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data_types/all.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _profileView(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Friends Feed"),
      actions: [
        IconButton(
          onPressed: () {
            BlocProvider.of<SessionCubit>(context).signOut();
          },
          icon: const Icon(Icons.logout),
        )
      ],
    );
  }

  Widget _profileView() {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return Container(
          child:
              (state is FeedLoadSucessState && _getWorkouts(state).isNotEmpty)
                  ? RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView(children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: deviceWidth(context) * 0.05,
                                top: deviceHeight(context) * 0.02,
                                bottom: deviceHeight(context) * 0.005),
                            child: const Text(
                              "Statistics",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        _total(_getWorkouts(state)),
                        _chart(_getWorkouts(state)
                            .getRange(
                                0,
                                _getWorkouts(state).length < 7
                                    ? _getWorkouts(state).length
                                    : 7)
                            .toList()),
                        _chartBar(_getWorkouts(state)
                            .getRange(
                                0,
                                _getWorkouts(state).length < 7
                                    ? _getWorkouts(state).length
                                    : 7)
                            .toList()),
                        Padding(
                            padding: EdgeInsets.only(
                                left: deviceWidth(context) * 0.05,
                                top: deviceHeight(context) * 0.02,
                                bottom: deviceHeight(context) * 0.005),
                            child: const Text(
                              "Personal records",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        _record(_getWorkouts(state), state),
                      ]),
                    )
                  : const Center(child: CircularProgressIndicator()));
    });
  }

  Widget _record(List<Workout> workouts, FeedLoadSucessState state) {
    Workout time = workouts[0];
    Workout distance = workouts[0];
    Workout speed = workouts[0];
    for (Workout w in workouts) {
      if (time.time < w.time) time = w;
      if (distance.distance < w.distance) distance = w;
      if (speed.speed > w.speed) speed = w;
    }
    return Column(
      children: [
        _status(time, "Biggest duration workout", state),
        _status(distance, "Longest distance workout", state),
        _status(speed, "Top average speed workout", state),
      ],
    );
  }

  Widget _status(
    Workout workout,
    String title,
    FeedLoadSucessState state,
  ) {
    return GestureDetector(
        onTap: () {
          BlocProvider.of<ProfileNavigatorCubit>(context).showDetail(
            workout,
            state.imageList[workout.id]!,
            state.coordList[workout.id]!,
            state.userNames[workout.user_id]!,
          );
        },
        child: Container(
            margin: EdgeInsets.all(deviceWidth(context) * 0.02),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                    color: const Color.fromARGB(50, 255, 255, 255),
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: deviceHeight(context) * 0.01),
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 20),
                              ))),
                      Row(
                        children: [
                          Expanded(child: _speed(workout.speed)),
                          Expanded(child: _distance(workout.distance)),
                          Expanded(child: _timeMin(workout.time)),
                        ],
                      ),
                    ])))));
  }

  Widget _timeMin(int time) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${((time / 1000) / 60).round().toString().padLeft(2, '0')}:${((time / 1000) % 60).round().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: FittedBox(fit: BoxFit.scaleDown, child: Text("Duration"))),
      ],
    );
  }

  Widget _speed(double speed) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${speed.floor().toString().padLeft(2, '0')}:${((speed % 1) * 60).floor().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: FittedBox(
                fit: BoxFit.scaleDown, child: Text("Speed (min/km)"))),
      ],
    );
  }

  Widget _total(List<Workout> workouts) {
    int time = 0;
    double distance = 0;
    for (Workout w in workouts) {
      time += w.time;
      distance += w.distance;
    }
    return Container(
        margin: EdgeInsets.all(deviceWidth(context) * 0.02),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: Container(
              color: const Color.fromARGB(50, 255, 255, 255),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _distance(distance),
                    _time(time),
                  ]),
            )));
  }

  Widget _distance(double distance) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (distance / 1000).toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: FittedBox(
                fit: BoxFit.scaleDown, child: Text("Total distance (Km)"))),
      ],
    );
  }

  Widget _time(int time) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${(((time / 1000) / 60) / 60).floor().toString().padLeft(2, '0')}:${((time / 1000) / 60).floor().toString().padLeft(2, '0')}:${((time / 1000) % 60).round().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: FittedBox(
                fit: BoxFit.scaleDown, child: Text("Total duration"))),
      ],
    );
  }

  Widget _chart(List<Workout> workouts) {
    return Container(
        margin: EdgeInsets.all(deviceWidth(context) * 0.02),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: Container(
                color: const Color.fromARGB(50, 255, 255, 255),
                child: SfCartesianChart(
                    palette: [Theme.of(context).colorScheme.secondary],
                    primaryXAxis: CategoryAxis(labelRotation: 50),
                    title: ChartTitle(
                        text: "Last ${workouts.length} workouts distance (km)"),
                    series: <ChartSeries>[
                      LineSeries<Workout, String>(
                          markerSettings: const MarkerSettings(
                            shape: DataMarkerType.circle,
                            isVisible: true,
                          ),
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.auto),
                          dataSource: workouts,
                          xValueMapper: (Workout workout, _) =>
                              "${workout.date.split('T')[0].split('-')[1]}-${workout.date.split('T')[0].split('-')[2]} ${workout.date.split('T')[1].split('.')[0]}",
                          yValueMapper: (Workout workout, _) => double.parse(
                              (workout.distance / 1000).toStringAsFixed(2)))
                    ]))));
  }

  Widget _chartBar(List<Workout> workouts) {
    return Container(
        margin: EdgeInsets.all(deviceWidth(context) * 0.02),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: Container(
                color: const Color.fromARGB(50, 255, 255, 255),
                child: SfCartesianChart(
                    palette: [Theme.of(context).colorScheme.secondary],
                    primaryXAxis: CategoryAxis(labelRotation: 50),
                    title: ChartTitle(
                        text:
                            "Last ${workouts.length} workouts average speed (min/km)"),
                    series: <ChartSeries>[
                      ColumnSeries<Workout, String>(
                          markerSettings: const MarkerSettings(
                            shape: DataMarkerType.circle,
                            isVisible: true,
                          ),
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.auto),
                          dataSource: workouts,
                          xValueMapper: (Workout workout, _) =>
                              "${workout.date.split('T')[0].split('-')[1]}-${workout.date.split('T')[0].split('-')[2]} ${workout.date.split('T')[1].split('.')[0]}",
                          yValueMapper: (Workout workout, _) =>
                              double.parse(workout.speed.toStringAsFixed(2)))
                    ]))));
  }

  Future refresh() async {
    context.read<FeedBloc>().add(FeedPageRequest());
    setState(() {});
  }

  List<Workout> _getWorkouts(FeedLoadSucessState state) {
    final sessionCubit = context.read<SessionCubit>();
    int userId = sessionCubit.currentUser;
    List<Workout> workouts = [];
    for (Workout w in state.workoutsList) {
      if (w.user_id == userId) {
        workouts.add(w);
      }
    }
    return workouts;
  }
}
