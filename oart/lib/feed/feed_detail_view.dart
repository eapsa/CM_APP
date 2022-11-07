import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oart/data_types/all.dart' as data;
import 'package:oart/feed/feed_navigator_cubit.dart';

class FeedDetailView extends StatefulWidget {
  const FeedDetailView({super.key});
  @override
  State<FeedDetailView> createState() => _FeedDetailView();
}

class _FeedDetailView extends State<FeedDetailView> {
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

  @override
  Widget build(BuildContext context) {
    final workout = context.read<FeedNavigatorCubit>().workout;
    final imageList = context.read<FeedNavigatorCubit>().imageList;
    final coordList = context.read<FeedNavigatorCubit>().coordList;
    imageSliders = imageList != null
        ? imageList
            .map((item) => Container(
                  child: Container(
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
                  ),
                ))
            .toList()
        : imgList
            .map((item) => Container(
                    child: Container(
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
                )))
            .toList();
    for (data.Coordinate coord in coordList) {
      latLen.add(LatLng(coord.latitude, coord.longitude));
    }

    for (int i = 0; i < latLen.length; i++) {
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.green,
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
            _name(workout),
            Padding(
                padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
            Text(workout.description),
            _status(workout),
            Padding(
                padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
            _carousel(imageSliders),
          ]))
    ]);
  }

  Widget _name(data.Workout workout) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: deviceWidth(context) * 0.05)),
        Expanded(
            child: Text(
          workout.date.split('.')[0],
          textAlign: TextAlign.left,
          style: TextStyle(
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
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget _carousel(List<Widget> imageSliders) {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        height: deviceHeight(context) * 0.4,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        pageViewKey: const PageStorageKey<String>('carousel_slider'),
      ),
      items: imageSliders,
    ));
  }
}

final List<String> imgList = [
  'run.png',
];
