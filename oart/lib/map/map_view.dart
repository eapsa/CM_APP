import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:oart/map/bloc/map_bloc.dart';
import 'package:oart/map/map_navigator_cubit.dart';
import 'package:oart/map/shared_preferences.dart';
import 'package:oart/map/workout.dart';
import 'package:oart/session_cubic.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:vector_math/vector_math.dart' as math;

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final LatLng _center = const LatLng(40.633290886836754, -8.65956720631656);
  late GoogleMapController mapController;
  Location location = Location();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  final _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  bool mapRun = false;
  Workout workout = Workout();
  FlutterTts flutterTts = FlutterTts();
  int targetDist = 50;

  Map<String, String> traductions = {
    "en": "",
    "pt": "",
    "fr": "",
    "es": "",
    "de": "",
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    location.onLocationChanged.listen((l) async {
      location.enableBackgroundMode(enable: true);
      print(l);
      if (mapRun) {
        polylineCoordinates.add(LatLng(l.latitude!, l.longitude!));
        _addPolyLine();
        print("distance");
        if (polylineCoordinates.length > 1) {
          LatLng last =
              polylineCoordinates.elementAt(polylineCoordinates.length - 2);

          workout.distance += calculateDistance(
              last.latitude, last.longitude, l.latitude!, l.longitude!);
          print("viva");
          if (workout.distance > targetDist) {
            await flutterTts
                .setLanguage(await SharedPreferencesHelper.getLanguage());
            await flutterTts.speak("Target: $targetDist");
            targetDist += 50;
          }
        }
        Future.delayed(const Duration(seconds: 3));
      }
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 18),
        ),
      );
    });
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    workout.userId = sessionCubit.currentUser;
    print("workout  ${workout.userId}");
    return Scaffold(
      appBar: _appBar(),
      body: _mapPage(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Map"),
      actions: [
        IconButton(
          onPressed: () {
            BlocProvider.of<MapNavigatorCubit>(context).showPhoto();
          },
          icon: const Icon(Icons.settings),
        )
      ],
    );
  }

  Widget _mapPage(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        _map(),
        _boxTracker(context),
      ],
    ));
  }

  Widget _map() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _center, zoom: 16.0),
      zoomControlsEnabled: false,
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      polylines: Set<Polyline>.of(polylines.values),
    );
  }

  Widget _boxTracker(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      return Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (state is MapPauseState) ? _photoButton() : Container(),
              const Padding(
                padding: EdgeInsets.all(8),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: deviceHeight(context) * 0.22,
                width: deviceWidth(context) * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          _distTracker(),
                          _timeTracker(),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                      ),
                      _buttom(context),
                    ]),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
              ),
            ],
          ));
    });
  }

  Widget _distTracker() {
    return Expanded(
        child: Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "${double.parse((workout.distance / 1000).toStringAsFixed(2))}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )),
        const Text("Distance (Km)"),
      ],
    ));
  }

  Widget _timeTracker() {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data;
        final minuteDisplayTime = StopWatchTimer.getDisplayTimeMinute(value!);
        final secondDisplayTime = StopWatchTimer.getDisplayTimeSecond(value);
        workout.time = value;
        return Expanded(
            child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "$minuteDisplayTime:$secondDisplayTime",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                )),
            const Text("Duration"),
          ],
        ));
      },
    );
  }

  Widget _buttom(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: deviceHeight(context) * 0.01,
                top: deviceHeight(context) * 0.01),
            child: (state is MapInitialState)
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        maximumSize: Size(deviceWidth(context) * 0.5,
                            deviceHeight(context) * 0.06),
                        minimumSize: Size(deviceWidth(context) * 0.5,
                            deviceHeight(context) * 0.06),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      _stopWatchTimer.onStartTimer();
                      mapRun = true;
                      context.read<MapBloc>().add(MapStartEvent());
                    },
                    child: const Text(
                      "Start",
                      style: TextStyle(fontSize: 25),
                    ),
                  )
                : (state is MapPauseState)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            _continueButtom(),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: deviceWidth(context) * 0.06)),
                            _terminateButtom(),
                          ])
                    : _stopButton());
      },
    );
  }

  Widget _continueButtom() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          maximumSize:
              Size(deviceWidth(context) * 0.30, deviceHeight(context) * 0.06),
          minimumSize:
              Size(deviceWidth(context) * 0.30, deviceHeight(context) * 0.06),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      onPressed: () {
        _stopWatchTimer.onStartTimer();
        mapRun = true;
        context.read<MapBloc>().add(MapStartEvent());
      },
      child: const Text("Continue"),
    );
  }

  Widget _terminateButtom() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          maximumSize:
              Size(deviceWidth(context) * 0.30, deviceHeight(context) * 0.06),
          minimumSize:
              Size(deviceWidth(context) * 0.30, deviceHeight(context) * 0.06),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      onPressed: () {
        print(workout.time);
        _stopWatchTimer.onResetTimer();
        mapRun = false;
        context.read<MapBloc>().add(MapInitialEvent());
        polylineCoordinates.clear();
        _addPolyLine();
        workout = Workout();
      },
      child: const Text("Terminate"),
    );
  }

  Widget _photoButton() {
    return FloatingActionButton(
      child: const Icon(Icons.camera_alt_outlined),

      // style: ElevatedButton.styleFrom(
      //     maximumSize:
      //         Size(deviceWidth(context) * 0.50, deviceHeight(context) * 0.06),
      //     minimumSize:
      //         Size(deviceWidth(context) * 0.50, deviceHeight(context) * 0.06),
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      onPressed: () {
        pickImage();
      },
    );
  }

  Widget _stopButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          maximumSize:
              Size(deviceWidth(context) * 0.5, deviceHeight(context) * 0.06),
          minimumSize:
              Size(deviceWidth(context) * 0.5, deviceHeight(context) * 0.06),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      onPressed: () {
        _stopWatchTimer.onStopTimer();
        mapRun = false;
        context.read<MapBloc>().add(MapStopEvent());
      },
      child: const Text("Pause"),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);
      final bytes = await imageTemp.readAsBytes();
      String base64encode = base64Encode(bytes);

      if (workout.images == null) {
        workout.images = <String>[base64encode];
      } else {
        workout.images?.add(base64encode);
      }
      print('photo ${workout.images!.length}');
      // setState(() {
      //   this.image = imageTemp;
      // });
    } on PlatformException catch (e) {
      print('Failed to select image: $e');
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    lat1 = math.radians(lat1);
    lon1 = math.radians(lon1);
    lat2 = math.radians(lat2);
    lon2 = math.radians(lon2);

    var earthRadius = 6378137.0; // WGS84 major axis
    double distance = 2 *
        earthRadius *
        asin(sqrt(pow(sin(lat2 - lat1) / 2, 2) +
            cos(lat1) * cos(lat2) * pow(sin(lon2 - lon1) / 2, 2)));

    return distance;
  }
}