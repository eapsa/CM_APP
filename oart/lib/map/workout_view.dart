import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/map/bloc/map_bloc.dart';
import 'package:oart/map/map_navigator_cubit.dart';
import 'package:oart/map/workout.dart';

class WorkoutView extends StatelessWidget {
  WorkoutView({super.key});

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final workout = context.read<MapNavigatorCubit>().workout;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save Workout"),
      ),
      body: _workout(context, workout),
    );
  }

  Widget _workout(BuildContext context, Workout workout) {
    return SingleChildScrollView(
        child: Column(children: [
      _time(workout),
      _distance(workout),
      _speed(workout),
      _forms(context, workout),
      const Padding(padding: EdgeInsets.all(8)),
      _saveButton(context, workout),
    ]));
  }

  Widget _forms(BuildContext context, Workout workout) {
    return Padding(
        padding: EdgeInsets.only(
            left: deviceWidth(context) * 0.1,
            right: deviceWidth(context) * 0.1),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _nameText(workout),
                _descriptionText(workout),
              ],
            )));
  }

  Widget _nameText(Workout workout) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Workout name",
      ),
      validator: ((value) => value!.isNotEmpty ? null : "Invalid name"),
      onChanged: (value) => workout.name = value,
    );
  }

  Widget _descriptionText(Workout workout) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: "Workout description",
      ),
      validator: ((value) => value!.isNotEmpty ? null : "Invalid description"),
      onChanged: (value) => workout.description = value,
    );
  }

  Widget _saveButton(BuildContext context, Workout workout) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          maximumSize:
              Size(deviceWidth(context) * 0.5, deviceHeight(context) * 0.06),
          minimumSize:
              Size(deviceWidth(context) * 0.5, deviceHeight(context) * 0.06),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.read<MapBloc>().add(MapEndEvent(workout: workout));
        }
      },
      child: const Text("Save workout"),
    );
  }

  Widget _speed(Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "${workout.speed.floor()}:${((workout.speed % 1) * 60).floor()}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )),
        const Text("Speed (min/km)"),
      ],
    );
  }

  Widget _distance(Workout workout) {
    print(workout.time);
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              (workout.distance / 1000).toStringAsFixed(2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )),
        const Text("Distance (Km)"),
      ],
    );
  }

  Widget _time(Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "${((workout.time! / 1000) / 60).round().toString().padLeft(2, '0')}:${((workout.time! / 1000) % 60).round().toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )),
        const Text("Duration"),
      ],
    );
  }
}
