import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oart/data_types/all.dart' as data;
import 'package:oart/profile/profile_navigator_cubit.dart';

class ProfileDetailView extends StatefulWidget {
  const ProfileDetailView({super.key});
  @override
  State<ProfileDetailView> createState() => _ProfileDetailView();
}

class _ProfileDetailView extends State<ProfileDetailView> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  // created controller to display Google Maps
  late GoogleMapController _controller;
  //on below line we have set the camera position
  final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(40.636839, -8.657503),
    zoom: 17,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  List<Widget> imageSliders = [];
  // list of locations to display polylines
  List<LatLng> latLen = [];

  late String _darkMapStyle;

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map.json');
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  @override
  Widget build(BuildContext context) {
    final workout = context.read<ProfileNavigatorCubit>().workout;
    final imageList = context.read<ProfileNavigatorCubit>().imageList;
    final coordList = context.read<ProfileNavigatorCubit>().coordList;
    imageSliders = imageList.isNotEmpty
        ? imageList
            .map((item) => Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.memory(
                            base64.decode(item.image),
                            fit: BoxFit.cover,
                            width: 1000.0,
                          ),
                        ],
                      )),
                ))
            .toList()
        : imgList
            .map((item) => Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 11, 2, 45),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              item,
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ],
                        )),
                  ),
                ))
            .toList();
    for (data.Coordinate coord in coordList) {
      latLen.add(LatLng(coord.latitude, coord.longitude));
    }

    for (int i = 0; i < latLen.length; i++) {
      _polyline.add(Polyline(
        polylineId: const PolylineId('1'),
        points: latLen,
        color: Colors.red,
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout ${workout.id}"),
      ),
      body: _feedDetail(workout, imageSliders),
    );
  }

  Widget _feedDetail(data.Workout workout, List<Widget> imageSliders) {
    return Column(children: [
      _map(workout),
      Expanded(
          child: ListView(
              //color: Colors.amber,
              children: [
            Padding(
                padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
            _status(workout),
            Padding(
                padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
            Center(child: Text(workout.description)),
            Padding(
                padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
            _carousel(imageSliders),
            Padding(
                padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
            _name(workout),
            Padding(
                padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
          ]))
    ]);
  }

  Widget _name(data.Workout workout) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: deviceWidth(context) * 0.05)),
        Expanded(
            child: Text(
          "${workout.date.split('T')[0]} ${workout.date.split('T')[1].split('.')[0]}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )),
        Padding(padding: EdgeInsets.only(right: deviceWidth(context) * 0.05)),
      ],
    );
  }

  Widget _status(data.Workout workout) {
    return Row(
      children: [
        Expanded(child: _speed(workout)),
        Expanded(child: _distance(workout)),
        Expanded(child: _time(workout)),
      ],
    );
  }

  Widget _speed(data.Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${workout.speed.floor().toString().padLeft(2, '0')}:${((workout.speed % 1) * 60).floor().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Speed (min/km)")),
      ],
    );
  }

  Widget _distance(data.Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (workout.distance / 1000).toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Distance (Km)")),
      ],
    );
  }

  Widget _time(data.Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${((workout.time / 1000) / 60).round().toString().padLeft(2, '0')}:${((workout.time / 1000) % 60).round().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Duration")),
      ],
    );
  }

  Widget _map(data.Workout workout) {
    return SizedBox(
      width: deviceWidth(context), // or use fixed size like 200
      height: deviceHeight(context) * 0.35,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: _kGoogle,
                  mapType: MapType.normal,
                  markers: _markers,
                  polylines: _polyline,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    _controller.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: latLen[0], zoom: 18),
                      ),
                    );
                    _controller.setMapStyle(_darkMapStyle);
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget _carousel(List<Widget> imageSliders) {
    return CarouselSlider(
      options: CarouselOptions(
        height: deviceHeight(context) * 0.4,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        pageViewKey: const PageStorageKey<String>('carousel_slider'),
      ),
      items: imageSliders,
    );
  }
}

final List<String> imgList = [
  'run.png',
];
